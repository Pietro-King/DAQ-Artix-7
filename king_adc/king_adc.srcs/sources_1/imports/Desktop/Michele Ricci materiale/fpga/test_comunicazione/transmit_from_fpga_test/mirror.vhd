----ciaooo
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

GENERIC(fifo_port_w:integer:=8;
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
	 adc_trigger : in std_logic;----------------- trigger esterno che arriva al blocco adc....per adesso non lo sto usando e per effettuare una prima conversione utilizzo come i_read un segnale generato grazie al blocco command che scrivo da qt COMMANDA
	  
	LED_1: OUT std_logic:= '1';--------------------------------led che si accendono appena scrivo command seguito da @ oppure x
	LED_2: OUT std_logic:='1';
	i_read_pin :OUT std_logic:='1';
	
	i_read_button: in std_logic
	
	---------command_out: out std_logic_vector(7 downto 0)                   ----------------------------------------   OUTPUT  ------ SWITCHING LED
	  );
end ADC_BRIDGE ;


architecture Behavioral of ADC_BRIDGE is
--component declaration

----------------------------------------------BRIDGE COMPONENT
component usb_fpga_bridge is

generic(port_width_transmit:integer:=8;
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
  CLK_OUT5          : out    std_logic;                                     ----CLK 5 è a 200 MHZ per il debug
  -- Status and control signals
  RESET             : in     std_logic;
  LOCKED            : out    std_logic
 );
end component;

-------------------------------------------------------------------
component axel_adc is
 
port

 (
 
 
 i_clk_adc: in std_logic;                       
 i_read_button : in std_logic;                  
 o_sclk: out std_logic;                         
 o_cs: out std_logic;                           
 i_miso: in std_logic;                          
 o_adc_data: out std_logic_vector(15 downto 0);  
 o_adc_data_valid: out std_logic                
                                                
--  i_clk                       : in  std_logic;
--  i_rst                       : in  std_logic;
--  i_read                      : in  std_logic;
--  i_conv_ena                  : in  std_logic;  -- enable ADC convesion-------------------ancora non lo sto utilizzando 
--  o_adc_data_valid            : out std_logic;  -- conversion valid pulse
--  o_adc_data                  : out std_logic_vector(7 downto 0); -- adc parallel data 
   
---- ADC serial interface
--  o_sclk                      : out std_logic;----------ADC CLOCK
--  o_cs                          : out std_logic;--------- CHIP SELECT CHE VA AL PIN DELL ADC
--  o_mosi                      : out std_logic;--------- MOSI " master out - serial in "
--  i_miso                      : in  std_logic --------- MISO " master in - serial out "
  
  );

end component;
-----------------------------------------

 signal i_clk_adc :  std_logic :='0';
 ---signal i_read_button:  std_logic :='0';                
 signal i_rst :  std_logic :='0';
 signal i_conv_ena :  std_logic :='0';
 signal o_adc_data_valid :  std_logic :='0';
 signal o_adc_data :  std_logic_vector(15 downto 0);---:="ZZZZZZZZZZZZ";
 signal o_sclk :  std_logic :='1';
 signal o_cs    :   std_logic :='1';
 signal o_mosi:   std_logic :='1';
 signal i_miso:   std_logic;
 
 
 signal trigger: std_logic:='0'; -------trigger che per test scrivo attraverso pc con command
-------------------------------------
--serial_adc_output <=i_miso;

component command_block
port
 (    ---------------------------------------------------------------------------------rx part
      ----&&&----out_adc_data : in std_logic_vector;----------NOTA-----------------------------------(QUESTA COSA è UNA MERDA PER ME...)lo mando come input a command block e poi lo collego a tx_data che esce dal blocco
      rx_ready: OUT std_logic;
      rx_valid: IN std_logic;
	  rx_data: IN std_logic_vector (fifo_port_r-1 downto 0);
 ----------------------------------------------------------------------------------tx part
      tx_ready: IN std_logic;
	 -- tx_valid: OUT std_logic;-----------------levato, lo faccio arrivare dal blocco generale
	  ----&&&----tx_data: OUT std_logic_vector(fifo_port_w-1 downto 0);

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
      
      
-------------------------------------arch begin     ----*****----BEGIN----*****----
begin

--------------------------------------------------------
MAIN_CLOCK : clock_generator     ---fa il clock a 100 mhz
  port map
   (-- Clock in ports
    CLK_IN1 => CLK_IN1_P,
    
    -- Clock out ports
    CLK_OUT1 => CLK,-------------- 100 MHz
    CLK_OUT2 => open,
    CLK_OUT3 => i_clk_adc,-----------------questo è il clock che invio al blocco dell adc  ADC...e che quindi appena converto e cs va low diventa o_sclk !!! 
    CLK_OUT4 => OPEN,
    CLK_OUT5 => open,             
   
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
	  
ADC: axel_adc 

port map
      
         (
         
           i_clk_adc            => i_clk_adc,      
         
           i_read_button           => i_read_button,
           --i_rst            => i_rst,         
           --i_conv_ena       => i_conv_ena,    
           o_adc_data_valid => o_adc_data_valid,
           o_adc_data       => o_adc_data,
           
           -- ADC serial int=>-- ADC serial int
           
           o_sclk           => o_sclk,       
           o_cs             => o_cs,            
        --   o_mosi           => o_mosi,         
           i_miso           => i_miso           
                       
      );
-----------------------------------------------------------------------------------




 i_miso <= serial_adc_output;----------------i_miso è l output seriale dell adc input dell intero codice !!!!
 --i_read <= adc_trigger;-----------------!!!!!!!!!DA AGGIUNGERE SUCCESSIVAMENTE ..VERRA DAL CHIP DI GIO
 
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


process(command_out)
begin
   
  case  command_out is
      when "01000000" =>  led_1<='1' ;led_2<='0'; ----------------------------scrivendo @ dopo COMMAND si accende il primo led
--     -- when "01011000" =>  led_2<='1' ;led_1<='0'; ----------------------------scrivendo X dopo COMMAND si accende il secondo led
  -----  when "01000001" =>  i_read  <='1';  led_2<='1' ;led_1<='0';       ----------------------------scrivendo A da pc mando alto il triggerr che si connette ad i_read del blocco adc
      
      when others =>  led_1<='0'; led_2<= '0';
        
  end case;
 
end process;



---------------------------------------------------------------------------------------------
adc_data_acquisition: process(CLK)
begin
if rising_edge(CLK) then

if  tx_ready='1' and o_adc_data_valid ='1' then  --------(ricorda nel blocco bridge è scritto che tx ready <= not(almost full receive fifo))start transmission of digital adc out to pc....mando il tx valid alto assieme al data_valid output dell adc
   tx_valid <='1'; 

--elsif tx_valid ='1' and rx_data = "11111111"  then                  ---------STOP TRANSMISSION DATA TO PC scrivendo da qt 
--      tx_valid <='0';
       
else 
      tx_valid<='0';
	
end if;
end if;
end process;


process(CLK)
begin

if rising_edge(CLK) then
  
    if tx_ready ='1' and tx_valid ='1' then
  
    tx_data <= o_adc_data(15 downto 8) ;  ------"01000000";     ------------------------------- trasferisco al pc il dato digitale convertito
  
    end if;
    
end if;

end process;



---i_read_pin<=i_read;-------------AGGIUNTO PER TEST
---------------------------------------------

end  Behavioral ;



