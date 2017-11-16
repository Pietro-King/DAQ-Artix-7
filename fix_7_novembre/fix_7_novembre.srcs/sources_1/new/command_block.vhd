library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;
--use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL; 


---------------------------------------------------------------------
entity command_block is

generic(port_width_transmit:integer:=8;
		port_width_receive:integer:=8);
		  
PORT( -----------------------------------------------------------------------------rx part
     ----&&&--- out_adc_data : in std_logic_vector;-----------aggiunto perche tx data � un input del blocco generale adc_bridge!!
      rx_ready: OUT std_logic;
      rx_valid: IN std_logic;
	  rx_data: IN std_logic_vector(port_width_receive-1 downto 0);
 ----------------------------------------------------------------------------------tx part
      tx_ready: IN std_logic;
	  --tx_valid: OUT std_logic;
	----&&&&-----  tx_data: OUT std_logic_vector(port_width_transmit-1 downto 0);----------------------!!!!! OCCHIO
      ftdi_clk: in std_logic;
      CLK: IN std_logic;
      wait_star: IN std_logic;
      command_out: out std_logic_vector(port_width_receive-1 downto 0)
	 );
	 
end command_block;

architecture Behavioral of command_block is

-----------------------------------------------------------------------------------------  SIGNALS
signal command_x : std_logic_vector( port_width_receive-1 downto 0 );
signal command : std_logic_vector( port_width_receive-1 downto 0 );
signal output_string: std_logic_vector( 55 downto 0 ):=(others=>'0');
signal pipo_rst: std_logic :='1';
signal flag: std_logic :='0';
signal peppe: std_logic:='0';
signal trans_signal : std_logic_vector( port_width_transmit-1 downto 0 );
------------------------------------------------------------
shared variable counter : integer := 1 ;-----------------------------------------------------------contatore per l attesa di qualche ciclo di clock prima di abilitare la lettura della fifo per evitare UNDERFLOW
--signal counter : std_logic_vector( 2 downto 0 ):="000";
-------------------------------------------------------------------
signal tx_valid_signal: std_logic :='0';
signal dato_trasmesso:std_logic_vector( port_width_transmit-1 downto 0 );
--signal rx_data : std_logic_vector(fifo_port_r-1 downto 0);   
--signal rx_ready,rx_valid: std_logic;                         
--signal tx_data : std_logic_vector(fifo_port_w-1 downto 0);
--signal tx_ready,tx_valid: std_logic;

 -------------------------------------------------------------------------------------COMPONENTS
COMPONENT PIPO_SHIFT
  PORT (
          clk: in std_logic;
          reset: in std_logic;
          input_vector: in std_logic_vector;--(VECTOR_WIDTH-1 downto 0);
          output_string: out std_logic_vector;--(OUTPUT_STRING_WIDTH-1 downto 0);--------------segnale di valid del comando inviato dal pc
          output_command: out std_logic_vector;--(VECTOR_WIDTH-1 downto 0)---------------------segnale che contiene l'istruzione da effettuare
          valid: in std_logic
  );
END COMPONENT;
----------------------------------------------------------------------

-----------------------------------------------------------------------------------------


begin

pipo: PIPO_SHIFT
  PORT MAP (
  
  CLK => CLK,
  input_vector => rx_data, 
  output_string => output_string,
  output_command => command,  
  reset => pipo_rst,
  valid => rx_valid
  );
  
---------------------------------------------------------- GESTIONE DEL RX_VALID E DEL RESET DEL PIPO REGISTER

process(clk)
begin

if rising_edge(CLK) then
    if wait_star='1' then
    pipo_rst<='0';
    else pipo_rst<='1';
    end if;
end if;
end process;
---------------------------------------------------------------------   QUESTA PARTE SUL FRONTE DI SALITA DEL CLOCK DELL FTDI SERVE PER EVITARE UNDERFLOW DELL RX FIFO...IN PRATICA ATTENDO 8 COLPI DI FTDI CLOCK DOPO CHE � STATO CARICATO IL PRIMO DATO(OVVERO ASPETTO CHE SIANO STATI CARICATI 8 DATI PRIMA DI LEGGERLI CON UN CLOCK MOLTO PIU VELOCE)

process(ftdi_clk)
begin

if rising_edge(ftdi_clk) then    -------quando non ci sono segnali validi in output alla fifo, il contatore si resetta
    if rx_valid ='1'then
    counter := counter+1;
    else counter:=1;
    end if;
end if;
end process;

process(clk)
begin

if rising_edge(clk) then -----------------abilito la lettura della fifo appena sono staticaricati almeno 8 dati cosi evito underflow della fifo 
    if counter>=8 then
    rx_ready<='1';
    else rx_ready<='0';
    end if;
end if;
end process;

-------------------------------------------------------------------------------

process(clk)
begin
if rising_edge(clk) then

  if  pipo_rst = '0' then
  
     case  output_string  is
          
          when "01000011010011110100110101001101010000010100111001000100" => ----- corrisponde alla parola "COMMAND" convertita in ascii e quindi in binario da 56 bit
          flag<='1';  
                                                                                            
          when others =>  flag <='0' ;
          
     end case;
  
  end if;
end if;
end process;

---------------------------------------------------------qui sto dicendo---> appena ricevi la parola command, aggiorna l'uscita command_out al valore del byte che arriva dopo e tienilo a quel valore finche non arriva nuovamente un altra parola command
process(clk)
begin
if rising_edge(CLK) then

   if flag ='1' then ---------------------  ovvero se � stata riconosciuta la parola command
   command_x <= command ;
   
   else command_x <=command_x;--------------------------------> cosi lo tengo COSTANTE finche non arriva un altra parola COMMAND...quindi si aggiorna
    

    end if;
end if;
end process;
    
command_out <= command_x;

   ----&&&&---- tx_data<=out_adc_data;----------------------QUI HO ATTACCATO L INPUT AL BLOCCO OUT_ADC_DATA ALL OUTPUT DELLO STESSO BLOCCO TX_DATA...QUESTA ROBA PENSO SI POSSA RIVEDERE 
    
   
end Behavioral;
