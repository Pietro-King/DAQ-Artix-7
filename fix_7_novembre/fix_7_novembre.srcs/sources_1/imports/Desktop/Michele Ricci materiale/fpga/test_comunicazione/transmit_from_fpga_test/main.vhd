---------------------------
----remind per Settembre ----- il codice serve per leggere un singolo dato convertito dall adc sull evaluation module
------------------------------ mando la dc in input all adc da convertire e quindi scrivo con COMMANDA che il segnale i_read (che ho scritto nel blocco dell adc che deve attendere circa 70 nanosecondi misurati in colpi di clk come funziona sul chip di giovanni)
------------------------------- quindi dopo quel delay l adc converte...l'output adc data valid che va alto al termine della conversione si attacca al tx valid che abilita la connessione rimandandomi il dato al pc che leggo su qt
------------------------------- come prima misura usiamo solo 8 dei bit convertiti dall adc (l ftdi è a soli 8 bit) successivamente sarà necessario scrivere un codice che spezza tutte le parole da 12 in due da 8 (8bit + ( 4bit+UUUU ))
------------------------------ per i constraint apparte quelli gia scritti bisogna aggiungere 3 pin: sclk(fpga to adc ), cs(fpga to adc), serial_adc_output(adc to fpga)  
------------------------------ IN SEGUITO ANDRA AGGIUNTO COME INPUT ALL FPGA IL TRIGGER DEL CHIP DI GIO CHE USERO PER LA CONVERSIONE 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.NUMERIC_STD.ALL;  


entity ADC_BRIDGE is

GENERIC(fifo_port_w:integer:=16;
		  fifo_port_r:integer:=8);
		  
PORT(--FTDI SIDE (towards world)
     --receiver part
	  ftdi_rxfN: IN std_logic;
	  ftdi_oeN: OUT std_logic;
	  ftdi_rdN: OUT std_logic;	
     --transmitter part
     ftdi_txeN: IN std_logic;
	  ftdi_wrN: OUT std_logic;
     ftdi_SIWU: OUT std_logic;
	  --COMMON DATA BUS
     ftdi_dq: INOUT std_logic_vector(7 downto 0);
     --ftdi clock signal
     ftdi_clk: IN std_logic;
     --END OF FTDI side-------------
	  --------------------------------------------------------------
	  --BOARD SIDE--------------------------------------------------
	  --OSCILLATOR IN
	 
	  CLK_IN1_P           : in     std_logic;
	  LOCKED_FTDI         : OUT     std_logic; 
	  lock_clk_out        : OUT     std_logic; 
	  
	  serial_adc_output   : in std_logic;--------------------- ;--------------questo out lo dovo connettere ad un capable pin di Mars Eb1 che poi collego con un cavetto al sdo(serial data out) dell adc....è IL dato seriale convertito dall adc che poi deserializzo in un bus parallelo da mandare a tx_data appena va alto tx_valid=adc_data_valid....questo mi arriva direttamente dalla board con l adc
	  
	  sclk :out std_logic; ----------------------questo clk deve andare ad un pin di Eb1 (deve essere capable pin o basta un IO ? penso dipenda da quanto è veloce il clk)e quindi al pin sclk dell adc sulla eval. board
	  cs: out std_logic;  ----------------questo è il chip select che attraverso un pin di MArs Eb1 mando al pin cs dell adc
	  o_trigger:out std_logic:='1';
	  
	  LED_1: OUT std_logic:= '1';--------------------------------led che si accendono appena scrivo command seguito da @ oppure x
	  LED_2: OUT std_logic:='1';
	  
	  i_read_button: in std_logic
	
	---------command_out: out std_logic_vector(7 downto 0)                   ----------------------------------------   OUTPUT  ------ SWITCHING LED
	  );
end ADC_BRIDGE ;


architecture Behavioral of ADC_BRIDGE is
--component declaration

component usb_fpga_bridge is
generic(port_width_transmit:integer:=16;
		  port_width_receive:integer:=8);		  
PORT(--FTDI SIDE (towards world)
     --receiver part
        ftdi_rxfN: IN std_logic;
        ftdi_oeN: OUT std_logic;
        ftdi_rdN: OUT std_logic;	
        --transmitter part
        ftdi_txeN: IN std_logic;
        ftdi_wrN: OUT std_logic;
        ftdi_SIWU: OUT std_logic;
        --COMMON DATA BUS
        ftdi_dq: INOUT std_logic_vector(7 downto 0);
        --ftdi clock signal
        ftdi_clk: IN std_logic;
        --END OF FTDI side-------------
        ftdi_clk_X: OUT std_logic;-------------------AGGIUNTO
        
        --FPGA SIDE 
        --receive part
        rx_ready: IN std_logic;
        rx_valid: OUT std_logic;
        rx_data: OUT std_logic_vector(fifo_port_r-1 downto 0);
        --transmit part 
        tx_ready: OUT std_logic;
        tx_valid: IN std_logic;
        tx_data: IN std_logic_vector(fifo_port_w-1 downto 0);
       --clock of the internal system
        CLK: IN std_logic;
        --syncronous reset of the main logic
         RST: IN std_logic;
       --utilty bridge logic (when locked deassert you MUST put a reset on RESETBRIDGE )
        RST_BRIDGE: IN std_logic;
        LOCKED_BRIDGE: OUT std_logic
	  );
end component;

---------------------------------COMPONENT SIGNALS
signal RST_BRIDGE_LOGIC: std_logic:='0';

signal rx_data : std_logic_vector(fifo_port_r-1 downto 0);   
signal rx_ready,rx_valid: std_logic;                         
signal tx_data : std_logic_vector(fifo_port_w-1 downto 0);
signal tx_ready,tx_valid: std_logic;

-------COUNTER SIGNALS
signal RST_COUNT_1: std_logic:='1';
signal DISABLE_1: std_logic:='0';
signal COUNT_1: std_logic_vector(31 downto 0):=(others=>'0');
---------------------------------
signal ftdi_clk_X :std_logic;----------------- aggiunto
--------------------------------

constant wait_time: INTEGER:=2000;            --500000000;      -- corrisponede a 5 secondi di attesa prima di abilitare la trasmissione
signal  command_out: std_logic_vector(7 downto 0); 
------------------------------------------------------------------  COMPONENTI
--CLOCK GENERATOR
component clock_generator
port
 (-- Clock in ports
   CLK_IN1          : in   std_logic;
  --CLK_IN1_P         : in     std_logic;
  -- CLK_IN1_N         : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  CLK_OUT2          : out    std_logic;
  CLK_OUT3          : out    std_logic;-----------------questo è il clk per l adc!!!
  CLK_OUT4          : out    std_logic;
  CLK_OUT5          : out    std_logic;     ----CLK 5 è a 200 MHZ per il debug-- ora settato a 5 per la program
  -- Status and control signals
  RESET             : in     std_logic;
  LOCKED            : out    std_logic
 );
end component;

-------------------------------------------------------------------

component ADC_ARRAY is

    Port (
       clk_adc:                in std_logic;
       
       trigger_adc :           in STD_LOGIC;
       serial_data_in_adc_0 :  in STD_LOGIC;   
       serial_data_in_adc_1 :  in STD_LOGIC;   
       serial_data_in_adc_2 :  in STD_LOGIC;   
       serial_data_in_adc_3 :  in STD_LOGIC;   
       serial_data_in_adc_4 :  in STD_LOGIC;   
       serial_data_in_adc_5 :  in STD_LOGIC;   
       serial_data_in_adc_6 :  in STD_LOGIC;   
       serial_data_in_adc_7 :  in STD_LOGIC;   
       serial_data_in_adc_8 :  in STD_LOGIC;   
       serial_data_in_adc_9 :  in STD_LOGIC;   
       serial_data_in_adc_10 : in STD_LOGIC;   
       serial_data_in_adc_11 : in STD_LOGIC;   
       serial_data_in_adc_12 : in STD_LOGIC;   
       serial_data_in_adc_13 : in STD_LOGIC;   
       serial_data_in_adc_14 : in STD_LOGIC;   
       serial_data_in_adc_15 : in STD_LOGIC;   
        
       o_sclk:      out STD_LOGIC;
       o_cs:        out STD_LOGIC; 
       o_adc_0 :    out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_1 :    out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_2 :    out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_3 :    out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_4 :    out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_5 :    out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_6 :    out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_7 :    out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_8 :    out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_9 :    out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_10 :   out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_11 :   out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_12 :   out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_13 :   out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_14 :   out STD_LOGIC_VECTOR (15 downto 0);
       o_adc_15 :   out STD_LOGIC_VECTOR (15 downto 0);
       ---read signal
       EoC_adc_0 : out STD_LOGIC;  
       EoC_adc_1 : out STD_LOGIC;  
       EoC_adc_2 : out STD_LOGIC;  
       EoC_adc_3 : out STD_LOGIC;  
       EoC_adc_4 : out STD_LOGIC;  
       EoC_adc_5 : out STD_LOGIC;  
       EoC_adc_6 : out STD_LOGIC;  
       EoC_adc_7 : out STD_LOGIC;  
       EoC_adc_8 : out STD_LOGIC;  
       EoC_adc_9 : out STD_LOGIC;  
       EoC_adc_10 :out STD_LOGIC;  
       EoC_adc_11 :out STD_LOGIC;  
       EoC_adc_12 :out STD_LOGIC;  
       EoC_adc_13 :out STD_LOGIC;  
       EoC_adc_14 :out STD_LOGIC;  
       EoC_adc_15 :out STD_LOGIC

       );
 end component;
-----------------------------------------

 signal i_clk_adc :  std_logic :='0';              
 signal o_adc_data_valid :  std_logic :='0';
 signal o_adc_data :  std_logic_vector(15 downto 0);---:="ZZZZZZZZZZZZ";
 signal o_sclk :  std_logic :='1';
 signal o_cs    :   std_logic :='1';

 signal i_miso:   std_logic;

-------------------------------------


component command_block
port
 (    ---------------------------------------------------------------------------------rx part
      ----&&&----out_adc_data : in std_logic_vector;----------NOTA-----------------------------------(QUESTA COSA è UNA MERDA PER ME...)lo mando come input a command block e poi lo collego a tx_data che esce dal blocco
      rx_ready: OUT std_logic;
      rx_valid: IN std_logic;
	  rx_data: IN std_logic_vector (fifo_port_r-1 downto 0);
 ----------------------------------------------------------------------------------tx part
      tx_ready: IN std_logic;
      ftdi_clk: IN std_logic;  
      CLK: IN std_logic;
      wait_star: IN std_logic;
      command_out: out std_logic_vector
      
 );
end component;

--clock signals
-----100 MHZ CLOCK PLL
signal CLK,LOCK_CLK: std_logic;                

-----FTDI CLOCK PLL
--signal RST_BRIDGE: std_logic:='0';
signal LOCKED_BRIDGE: std_logic;
----
signal LOCK_START: std_logic:='0';

--shift register signal 
signal RST_SHIFT: std_logic_vector(7 downto 0):=(others=>'0');
signal FLAG : std_logic:='0';


signal trans_signal : std_logic_vector(fifo_port_r-1 downto 0);
-----------------------------------------------------

signal command_out_signal: std_logic_vector(7 downto 0); ---------------segnale per fare il case in output

shared variable counter_tx_valid :integer := 1;   
shared variable counter_trigger :integer := 0; 
signal SoC : std_logic:='0';   


component funnel_fifo 
    Port (
           clk_w:                 in std_logic;--adc clk 
           clk_r:                 in std_logic;--fpga clk
           rst:                 in std_logic;   
           funnel_ready:        in std_logic;
           o_adc_0 :    in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_1 :    in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_2 :    in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_3 :    in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_4 :    in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_5 :    in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_6 :    in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_7 :    in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_8 :    in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_9 :    in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_10 :   in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_11 :   in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_12 :   in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_13 :   in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_14 :   in STD_LOGIC_VECTOR (15 downto 0);
           o_adc_15 :   in STD_LOGIC_VECTOR (15 downto 0);
           ---read signal
           EoC_adc_0 :  in STD_LOGIC;
           EoC_adc_1 :  in STD_LOGIC;
           EoC_adc_2 :  in STD_LOGIC;
           EoC_adc_3 :  in STD_LOGIC;
           EoC_adc_4 :  in STD_LOGIC;
           EoC_adc_5 :  in STD_LOGIC;
           EoC_adc_6 :  in STD_LOGIC;
           EoC_adc_7 :  in STD_LOGIC;
           EoC_adc_8 :  in STD_LOGIC;
           EoC_adc_9 :  in STD_LOGIC;
           EoC_adc_10 : in STD_LOGIC;
           EoC_adc_11 : in STD_LOGIC;
           EoC_adc_12 : in STD_LOGIC;
           EoC_adc_13 : in STD_LOGIC;
           EoC_adc_14 : in STD_LOGIC;
           EoC_adc_15 : in STD_LOGIC;
    ---outputs
           empty_fifos:     out STD_LOGIC_VECTOR (0 to 15);
           i_funnel_0 :     out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_1 :     out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_2 :     out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_3 :     out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_4 :     out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_5 :     out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_6 :     out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_7 :     out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_8 :     out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_9 :     out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_10 :    out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_11 :    out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_12 :    out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_13 :    out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_14 :    out STD_LOGIC_VECTOR (15 downto 0);
           i_funnel_15 :    out STD_LOGIC_VECTOR (15 downto 0)

           );
end component;

signal i_funnel_0 : STD_LOGIC_VECTOR (15 downto 0);    
signal i_funnel_1 : STD_LOGIC_VECTOR (15 downto 0);    
signal i_funnel_2 : STD_LOGIC_VECTOR (15 downto 0);    
signal i_funnel_3 : STD_LOGIC_VECTOR (15 downto 0);    
signal i_funnel_4 : STD_LOGIC_VECTOR (15 downto 0);    
signal i_funnel_5 : STD_LOGIC_VECTOR (15 downto 0);    
signal i_funnel_6 : STD_LOGIC_VECTOR (15 downto 0);    
signal i_funnel_7 : STD_LOGIC_VECTOR (15 downto 0);    
signal i_funnel_8 : STD_LOGIC_VECTOR (15 downto 0);    
signal i_funnel_9 : STD_LOGIC_VECTOR (15 downto 0);    
signal i_funnel_10: STD_LOGIC_VECTOR (15 downto 0);   
signal i_funnel_11: STD_LOGIC_VECTOR (15 downto 0);   
signal i_funnel_12: STD_LOGIC_VECTOR (15 downto 0);   
signal i_funnel_13: STD_LOGIC_VECTOR (15 downto 0);   
signal i_funnel_14: STD_LOGIC_VECTOR (15 downto 0);   
signal i_funnel_15: STD_LOGIC_VECTOR (15 downto 0);  

signal o_adc_0: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_1: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_2: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_3: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_4: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_5: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_6: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_7: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_8: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_9: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_10: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_11: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_12: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_13: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_14: STD_LOGIC_VECTOR (15 downto 0);
signal o_adc_15: STD_LOGIC_VECTOR (15 downto 0); 

signal o_funnel_data: STD_LOGIC_VECTOR (15 downto 0); 

signal empty_fifos: STD_LOGIC_VECTOR (0 to 15);  
signal rst_funnel: std_logic:='0';
signal funnel_ready: std_logic:='0';
signal busy_funnel: std_logic:='0';

signal EoC_adc_0: STD_LOGIC;
signal EoC_adc_1: STD_LOGIC;
signal EoC_adc_2: STD_LOGIC;
signal EoC_adc_3: STD_LOGIC;
signal EoC_adc_4: STD_LOGIC;
signal EoC_adc_5: STD_LOGIC;
signal EoC_adc_6: STD_LOGIC;
signal EoC_adc_7: STD_LOGIC;
signal EoC_adc_8: STD_LOGIC;
signal EoC_adc_9: STD_LOGIC;
signal EoC_adc_10: STD_LOGIC;
signal EoC_adc_11: STD_LOGIC;
signal EoC_adc_12: STD_LOGIC;
signal EoC_adc_13: STD_LOGIC;
signal EoC_adc_14: STD_LOGIC;
signal EoC_adc_15: STD_LOGIC;


component funnel is
  Port
( 
        clk: in std_logic;
        empty_fifos :in std_logic_vector(0 to 15);
        i_funnel_0 : in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_1 : in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_2 : in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_3 : in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_4 : in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_5 : in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_6 : in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_7 : in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_8 : in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_9 : in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_10 :in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_11 :in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_12 :in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_13 :in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_14 :in   STD_LOGIC_VECTOR (15 downto 0);
        i_funnel_15 :in   STD_LOGIC_VECTOR (15 downto 0);
        
        funnel_ready:  out std_logic;
        o_funnel_data: out std_logic_vector(15 downto 0);-------------16 bit
        busy_funnel:   out std_logic

);
end component;

component program_spi is
port(
        
        rx_data:            in std_logic_vector(0 to 7);--program string to write; must be connected to rx_data
        retransmitted_prog: in std_logic; --the string sent back
        clk:                in std_logic; --clk
        program:            in std_logic; --programming signal
        
        program_written:    out std_logic;
        finish_program:     out std_logic; --finish programming signal
        spi_write_en:       out std_logic; -- goes  to the pin for the write en
        asic_load:          out std_logic; --load signal
        rom_en:             out std_logic; --rom enable
        spi_write_data:     out std_logic --delivers the serial data to the asic
);
end component;
signal clk_program:std_logic;
signal retransmitted_prog_signal:std_logic;
signal program_signal:std_logic;
signal finish_program_signal:std_logic;
signal spi_write_en_signal:std_logic;
signal asic_load_signal:std_logic;
signal rom_en_signal:std_logic;
signal spi_write_data_signal:std_logic;
signal program_flag:std_logic:='0';
signal program_reset:std_logic:='1';
signal program_written_signal:std_logic;

      
-------------------------------------ARCHITECTURE begin  ----------
begin

program_sfera: program_spi
    port map
    (
        rx_data             =>rx_data,
        clk                 =>clk_program,
        retransmitted_prog  =>retransmitted_prog_signal,
        program             =>program_signal,
        program_written     =>program_written_signal,
        finish_program      =>finish_program_signal,--useful?
        spi_write_en        =>spi_write_en_signal, --to pin
        asic_load           =>asic_load_signal,    --to pin
        rom_en              =>rom_en_signal,        --to pin
        spi_write_data      =>spi_write_data_signal --to pin
   
    );

--------------------------------------------------------
MAIN_CLOCK : clock_generator     ---fa il clock a 100 mhz
  port map
   (-- Clock in ports
    CLK_IN1 => CLK_IN1_P,
    
    -- Clock out ports
    CLK_OUT1 => CLK,-------------- 100 MHz
    CLK_OUT2 => open,
    CLK_OUT3 => i_clk_adc,-----------------questo è il clock che invio al blocco dell adc  ADC...e che quindi appena converto e cs va low diventa o_sclk !!! 
    CLK_OUT4 => open,
    CLK_OUT5 => clk_program,      --5mhz       
   
    -- Status and control signals
    RESET  =>'0',
    LOCKED => LOCK_CLK
	 );
	 
----end of clock 
----PROBE PART
--CLK_OUT_10N<=CLK_OUT1;                 -- assegno il clock out al pin esterno
LOCKED_FTDI<=LOCKED_BRIDGE;             -- ASSEGNO IL LOCKED DELL'FTDI AL PIN ESTERNO
lock_clk_out<=lock_clk;                  --vedo se si è lockato il pll riferito all'internal clock gen



COMMAND : command_block

port map
     (---------------------------------------------------------------------------rx_part
      ----&&&----out_adc_data=>o_adc_data,
      rx_ready=>rx_ready,
      rx_valid=>rx_valid,
	  rx_data=>rx_data,
 ----------------------------------------------------------------------------------tx part
      tx_ready=>tx_ready,
	  --tx_valid=>tx_valid,
	 -----&&&----- tx_data=>tx_data,
      clk=>clk,--------------------------------
      ftdi_clk=>ftdi_clk_X,------------------------------------nota!
      wait_star => flag,---------------------> ho attaccato la flag che gestisce l' attesa al pin wait star del blocco command
      command_out=> command_out
	  );


BRIDGE:usb_fpga_bridge
generic map(port_width_transmit=>fifo_port_w,
		      port_width_receive=>fifo_port_r)
port map(--FTDI SIDE (towards world)
     --receiver part
	  ftdi_rxfN=>ftdi_rxfN,
	  ftdi_oeN=>ftdi_oeN,
	  ftdi_rdN=>ftdi_rdN,
     --transmitter part
     ftdi_txeN=>ftdi_txeN,
	  ftdi_wrN=>ftdi_wrN,
     ftdi_SIWU=>ftdi_SIWU,
	  --COMMON DATA BUS
     ftdi_dq=>ftdi_dq,
     --ftdi clock signal
     ftdi_clk=>ftdi_clk,
     --END OF FTDI side-------------
	 ftdi_clk_X=>ftdi_clk_X,
	  
	 --FPGA SIDE 
     --receive part
     rx_ready=>rx_ready,
     rx_valid=>rx_valid,
	 rx_data=>rx_data,
     --transmit part 
      tx_ready=>tx_ready,----------------------
	  tx_valid=>tx_valid,      ------------------------
	  tx_data=>tx_data,         ------------------------
     --clock of the internal system
	  CLK=>CLK,
     --syncronous reset of the main logic
	  RST=>RST_BRIDGE_LOGIC,
     --utilty bridge logic (when locked deassert you MUST put a reset on RESETBRIDGE )
	  RST_BRIDGE=>'0',
     LOCKED_BRIDGE=>LOCKED_BRIDGE
	  );
	  
--ADC: axel_adc 
--port map
--      (         
--       i_clk_adc            => i_clk_adc,      
--       i_read_button           => i_read_button,
--       o_adc_data_valid => o_adc_data_valid,
--       o_adc_data       => o_adc_data,     
--       o_sclk           => o_sclk,       
--       o_cs             => o_cs,                    
--       i_miso           => i_miso           
                   
--      );
ADC: ADC_ARRAY
PORT MAP
        (
           clk_adc=>i_clk_adc,
           trigger_adc=>i_read_button,
           serial_data_in_adc_0 =>i_miso,
           serial_data_in_adc_1 =>i_miso,
           serial_data_in_adc_2 =>i_miso,
           serial_data_in_adc_3 =>i_miso,
           serial_data_in_adc_4 =>i_miso,
           serial_data_in_adc_5 =>i_miso,
           serial_data_in_adc_6 =>i_miso,
           serial_data_in_adc_7 =>i_miso,
           serial_data_in_adc_8 =>i_miso,
           serial_data_in_adc_9 =>i_miso,
           serial_data_in_adc_10=>i_miso,
           serial_data_in_adc_11=>i_miso,
           serial_data_in_adc_12=>i_miso,
           serial_data_in_adc_13=>i_miso,
           serial_data_in_adc_14=>i_miso,
           serial_data_in_adc_15=>i_miso,
            
           o_cs    => o_cs,
           o_sclk  => o_sclk,                    
           o_adc_0 => o_adc_0, 
           o_adc_1 => o_adc_1,
           o_adc_2 => o_adc_2,
           o_adc_3 => o_adc_3,
           o_adc_4 => o_adc_4,
           o_adc_5 => o_adc_5,
           o_adc_6 => o_adc_6,
           o_adc_7 => o_adc_7,
           o_adc_8 => o_adc_8,
           o_adc_9 => o_adc_9,
           o_adc_10 => o_adc_10,
           o_adc_11 => o_adc_11,
           o_adc_12 => o_adc_12,
           o_adc_13 => o_adc_13,
           o_adc_14 => o_adc_14,
           o_adc_15 => o_adc_15,
           EoC_adc_0 => EoC_adc_0, 
           EoC_adc_1 => EoC_adc_1,
           EoC_adc_2 => EoC_adc_2,
           EoC_adc_3 => EoC_adc_3,
           EoC_adc_4 => EoC_adc_4,
           EoC_adc_5 => EoC_adc_5,
           EoC_adc_6 => EoC_adc_6,
           EoC_adc_7 => EoC_adc_7,
           EoC_adc_8 => EoC_adc_8,
           EoC_adc_9 => EoC_adc_9,
           EoC_adc_10 => EoC_adc_10,
           EoC_adc_11 => EoC_adc_11,
           EoC_adc_12 => EoC_adc_12,
           EoC_adc_13 => EoC_adc_13,
           EoC_adc_14 => EoC_adc_14,
           EoC_adc_15 => EoC_adc_15   
        );
          
funnel_queue: funnel_fifo 
PORT MAP
        (
        clk_w=>i_clk_adc,       
        clk_r=> clk,
        rst=>rst_funnel,
        funnel_ready=>funnel_ready,
        empty_fifos =>empty_fifos,
        o_adc_0 => o_adc_0, 
        o_adc_1 => o_adc_1,
        o_adc_2 => o_adc_2,
        o_adc_3 => o_adc_3,
        o_adc_4 => o_adc_4,
        o_adc_5 => o_adc_5,
        o_adc_6 => o_adc_6,
        o_adc_7 => o_adc_7,
        o_adc_8 => o_adc_8,
        o_adc_9 => o_adc_9,
        o_adc_10 => o_adc_10,
        o_adc_11 => o_adc_11,
        o_adc_12 => o_adc_12,
        o_adc_13 => o_adc_13,
        o_adc_14 => o_adc_14,
        o_adc_15 => o_adc_15,
        EoC_adc_0 => EoC_adc_0, 
        EoC_adc_1 => EoC_adc_1,
        EoC_adc_2 => EoC_adc_2,
        EoC_adc_3 => EoC_adc_3,
        EoC_adc_4 => EoC_adc_4,
        EoC_adc_5 => EoC_adc_5,
        EoC_adc_6 => EoC_adc_6,
        EoC_adc_7 => EoC_adc_7,
        EoC_adc_8 => EoC_adc_8,
        EoC_adc_9 => EoC_adc_9,
        EoC_adc_10 => EoC_adc_10,
        EoC_adc_11 => EoC_adc_11,
        EoC_adc_12 => EoC_adc_12,
        EoC_adc_13 => EoC_adc_13,
        EoC_adc_14 => EoC_adc_14,
        EoC_adc_15 => EoC_adc_15,
        i_funnel_0 =>i_funnel_0, 
        i_funnel_1 =>i_funnel_1, 
        i_funnel_2 =>i_funnel_2, 
        i_funnel_3 =>i_funnel_3, 
        i_funnel_4 =>i_funnel_4, 
        i_funnel_5 =>i_funnel_5, 
        i_funnel_6 =>i_funnel_6, 
        i_funnel_7 =>i_funnel_7, 
        i_funnel_8 =>i_funnel_8, 
        i_funnel_9 =>i_funnel_9, 
        i_funnel_10=>i_funnel_10,
        i_funnel_11=>i_funnel_11,
        i_funnel_12=>i_funnel_12,
        i_funnel_13=>i_funnel_13,
        i_funnel_14=>i_funnel_14,
        i_funnel_15=>i_funnel_15   
               
);
                
multiplexer: funnel 
       port map
        (
          clk=> clk,
          empty_fifos =>empty_fifos,
          funnel_ready=>funnel_ready,
          i_funnel_0 =>i_funnel_0, 
          i_funnel_1 =>i_funnel_1,
          i_funnel_2 =>i_funnel_2, 
          i_funnel_3 =>i_funnel_3, 
          i_funnel_4 =>i_funnel_4, 
          i_funnel_5 =>i_funnel_5, 
          i_funnel_6 =>i_funnel_6, 
          i_funnel_7 =>i_funnel_7, 
          i_funnel_8 =>i_funnel_8, 
          i_funnel_9 =>i_funnel_9, 
          i_funnel_10=>i_funnel_10,
          i_funnel_11=>i_funnel_11,
          i_funnel_12=>i_funnel_12,
          i_funnel_13=>i_funnel_13,
          i_funnel_14=>i_funnel_14,
          i_funnel_15=>i_funnel_15,
          o_funnel_data=>o_funnel_data,
          busy_funnel=>busy_funnel
        );
-----------------------------------------------------------------------------------

 i_miso <= serial_adc_output;----------------i_miso è l output seriale dell adc input dell intero codice !!!! 
 sclk <= o_sclk;------------------!!! sclk è il clk che devo mandare dentro il pin dell adc e lo sto connettendo all output o_sclk del blocco vhdl che controlla l adc
 cs <= o_cs;------------------------------stessa cosa per chip select ... l output del blocco principale cs lo mando ad un io pin di Mars e quindi alla board dell adc
 
----------------------------------------------------
-------MAIN CODE
--contatore a 32 bit con  DISABLE  per il waiting iniziale
counter_1:process(CLK)
	begin
		if rising_edge(CLK) then
			if DISABLE_1='1' then
				COUNT_1<=COUNT_1;
			elsif RST_COUNT_1='1' then
				COUNT_1<=(others=>'0');
			else		 
				COUNT_1<=COUNT_1 + 1;
			end if;
		end if;
	end process;
	
---------------------------------------	

-- gestisce l'attesa per il locking

startup: process(LOCK_CLK,LOCKED_BRIDGE)                
begin 
		if LOCK_CLK='1' and LOCKED_BRIDGE='1' then --
			LOCK_START<='1';
		else
			LOCK_START<='0';
		end if;
end process;


---------------------------------------


--gestisce il contatore che tiene tutto fermo per il wait_time
wait_process:process(CLK)
begin
if rising_edge(CLK) then 
	if LOCK_START='1' and COUNT_1<std_logic_vector(to_unsigned(wait_time-1,32)) then
		RST_COUNT_1<='0';
		DISABLE_1<='0';
	else	
		RST_COUNT_1<='0';
		DISABLE_1<='1';
	end if;
end if;
end process;

-------------------------------------------------
flag_generator:process(CLK)
begin
if rising_edge(CLK) then 
	if COUNT_1>=std_logic_vector(to_unsigned(wait_time,32)) then
		flag<='1';
	else
		flag<='0';
	end if;
end if;
end process;
-------------------------------------------------------------------------------------   FLAG SIGNAL <= WAIT_STAR PIN OF COMMAND

-----------
--rst del bridge (dura 16 colpi di clock, la lunghezza dello shift reg) 
shift_reg:process(CLK) 
begin
if rising_edge(CLK) then  
	if COUNT_1=std_logic_vector(to_unsigned(wait_time-30,32)) then
		RST_SHIFT<="11111111";
	else
		RST_SHIFT<='0'&RST_SHIFT(7 downto 1);
	end if;
end if;
end process;
RST_BRIDGE_LOGIC<=RST_SHIFT(0);

------------------------------------------------------------------------- SWITCHING LED CASE 
list_of_commands:process(command_out,program_reset)
begin

  case  command_out is
      when "01000000" =>  led_1<='1' ;led_2<='0'; SoC<='0'; ----scrivendo @ dopo COMMAND si accende il primo led
      when "01011000" =>  SoC<='1'; ----------------------------scrivendo X dopo COMMAND si accende il secondo led
      when "01010000" =>  program_flag<='1';--program_signal<='1';program_flag<='1';--"P"
      when "01010001" =>  program_flag<='0';--program_signal<='1';program_flag<='1';--"Q"
      when others =>  led_1<='0'; led_2<= '0';
        
  end case;

end process;

tx_data <=o_funnel_data;
tx_valid<= tx_ready AND busy_funnel;


--    tx_valid_process:process(CLK)
--    begin
--    if rising_edge(CLK) then
--     -------------------------------------
     
--        if o_adc_data_valid='1' and tx_ready='1' then 
        
--        counter_tx_valid := counter_tx_valid + 1;
        
--        else counter_tx_valid :=1;  
--        end if;
        
--     --------------------------------------   
     
--        if  counter_tx_valid = 2 then  
--        tx_valid<='1';
--        tx_data <= o_adc_data(15 downto 8) ; 
        
--        elsif counter_tx_valid = 3 then
--        tx_valid<='1';
--        tx_data <= o_adc_data(7 downto 0) ;
        
--        else tx_valid<='0';
--        end if ;  
        
--    ---------------------------------------
--    end if;
--    end process;


--SELFTRIGGERING PROCESS
trigger_process_clk:process(CLK)
    begin
    if rising_edge(CLK) then
        if(counter_trigger<100)and (SoC='1') then
            counter_trigger:=counter_trigger+1;        
        else
            counter_trigger:=0;
        end if;
    end if;
end process;

trigger_process:process(CLK)
    begin
    if(counter_trigger = 5) then
        o_trigger <='0';
    elsif(counter_trigger=6) then
        o_trigger<='1';
    end if;
end process;


program_reset_process:process(CLK)
    begin
    if rising_edge(CLK) then
        if program_flag='1' and program_written_signal='0' then --if i'm programmin and i finished reading the string, i set the routine to read something else
            program_signal<='1';
        else
            program_signal<='0';
        end if;
    end if;
end process;
     
end  Behavioral ;
