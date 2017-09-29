
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.MATH_REAL.ALL;
use IEEE.NUMERIC_STD.ALL;  



entity simulazioneADC_BRIDGE is
end simulazioneADC_BRIDGE;

 architecture Behavioral of simulazioneADC_BRIDGE is
   
    COMPONENT ADC_BRIDGE
    
    PORT(
         ftdi_rxfN : IN  std_logic;
         ftdi_oeN : OUT  std_logic;
         ftdi_rdN : OUT  std_logic;
         ftdi_txeN : IN  std_logic;
         ftdi_wrN : OUT  std_logic;
         ftdi_dq : INOUT  std_logic_vector(7 downto 0);
         ftdi_clk : IN  std_logic;
         CLK_IN1_P : IN  std_logic;
         LOCKED_FTDI : OUT  std_logic;
         lock_clk_out : OUT std_logic; 
         serial_adc_output   : in std_logic;--------------questo out lo dovo connettere ad un capable pin di Mars Eb1 che poi collego con un cavetto al sdo(serial data out) dell adc
         adc_trigger : in std_logic;
         i_read_button: in std_logic
         ---------------------------------------  A QUANTO PARE NEI COMPONENTI DELLE SIMULAZIONI BASTA METTERE GLI INPUT..INFATTI QUI NON CI SONO I LED E ATRI SEGNALI COME CS E SCLK 
         
         --sclk :out std_logic ----------------------questo clk deve andare ad un pin di Eb1 (deve essere capable pin o basta un IO ? penso dipenda da quanto è veloce il clk)e quindi al pin sclk dell adc sulla eval. board
--         LED_1: OUT std_logic:='0';
--         LED_2: OUT std_logic:='0'
                
		  );
    END COMPONENT;
    
   --Inputs
    signal ftdi_rxfN : std_logic := '1';
    signal ftdi_txeN : std_logic := '1';
    signal ftdi_clk : std_logic := '0';
    signal CLK_IN1_P : std_logic := '0';
    signal i_clk_adc : std_logic := '0';
   -- signal CLK_IN1_N : std_logic := '0';
 
     --BiDirs
    signal ftdi_dq : std_logic_vector(7 downto 0):="ZZZZZZZZ";
 
      --Outputs
    signal ftdi_oeN : std_logic;
    signal ftdi_rdN : std_logic;
    signal ftdi_wrN : std_logic;
    --signal CLK_OUT_10N : std_logic;
    signal LOCKED_FTDI : std_logic;
    signal lock_clk_out : std_logic;
    -- Clock period definitions
    constant ftdi_clk_period : time := 16.6 ns;------------------NOTA! Questo è il clock dell ftdi 60 MHz
    constant CLK_IN1_P_period : time := 20 ns;
    constant i_clk_period : time := 31.25 ns;-------------clock a 30 MHz generato dall ip_core
  --  constant CLK_IN1_N_period : time := 20 ns;
    constant num_cycles: integer:=9999999;
     --signal flag
--     signal LED_1: std_logic;
--     signal LED_2: std_logic;
     signal serial_adc_output:  std_logic; 
     signal adc_trigger :std_logic;
     signal i_read_button :std_logic;

begin
   uut: ADC_BRIDGE PORT MAP 
   (
   
          ftdi_rxfN => ftdi_rxfN,
          ftdi_oeN => ftdi_oeN,
          ftdi_rdN => ftdi_rdN,
          ftdi_txeN => ftdi_txeN,
          ftdi_wrN => ftdi_wrN,
          ftdi_dq => ftdi_dq,
          ftdi_clk => ftdi_clk,
          CLK_IN1_P => CLK_IN1_P,
         
          LOCKED_FTDI => LOCKED_FTDI,
          lock_clk_out => lock_clk_out,
          
          serial_adc_output  =>   serial_adc_output ,
		  adc_trigger =>adc_trigger,
		  i_read_button=>i_read_button
--          LED_1=>LED_1,
--          LED_2=>LED_2
          
          );
                  
   -- ClocLED_2: OUT std_logic:='0            k process definitions
   ftdi_clk_process :process
   begin	
			ftdi_clk <= '0';
			wait for 1000 ns;
			for i in 1 to num_cycles loop
				ftdi_clk <= '0';
				wait for ftdi_clk_period/2;
				ftdi_clk <= '1';
				wait for ftdi_clk_period/2;
			end loop;
	end process;
 
   CLK_IN1_P_process :process
   begin
		CLK_IN1_P <= '1';
		wait for CLK_IN1_P_period/2;
		CLK_IN1_P <= '0';
		wait for CLK_IN1_P_period/2;
   end process;
   
   
      i_clk_adc_process :process
      begin
           i_clk_adc <= '1';
           wait for i_clk_period/2;
           i_clk_adc <= '0';
           wait for i_clk_period/2;
      end process;
 
 
 -- Stimulus process
      stim_proc: process
      begin        
         -- hold reset state for 100 ns.
         
         wait for 100 ns;    
         wait for ftdi_clk_period*10;
         wait for 800 ns;    
         wait for 50000 ns;
         
         -------------------------------------------------------------dato che passa , tutto corretto
         
         ftdi_rxfN<='0';
         wait for ftdi_clk_period*4;
         ftdi_dq<="01000011" ;wait for  ftdi_clk_period;   ----------------------------------  COMMAND on keyboard ---> ASCII ---> binary = 10000011 01001111 01001101 01001101 01000001 01001110 01000100
         ftdi_dq<="01001111" ;wait for  ftdi_clk_period;
         ftdi_dq<="01001101" ;wait for  ftdi_clk_period;
         ftdi_dq<="01001101" ;wait for  ftdi_clk_period;
         ftdi_dq<="01000001" ;wait for  ftdi_clk_period;
         ftdi_dq<="01001110" ;wait for  ftdi_clk_period;
         ftdi_dq<="01000100" ;wait for  ftdi_clk_period;
         
         ftdi_dq<="01000000" ;wait for  ftdi_clk_period;--------------------------------   @ on keyboard ---> ASCII ---> binary = 01000000
         
          ftdi_dq<="ZZZZZZZZ" ;  wait for ftdi_clk_period*3;
          ftdi_rxfN<='1'; wait for ftdi_clk_period;
          ftdi_txeN<='0';
         
         
         wait for 50000 ns;
                
--                -------------------------------------------------------------dato che passa , tutto corretto
                
--                ftdi_rxfN<='0';
--                wait for ftdi_clk_period*5;
--                ftdi_dq<="01000011" ;wait for  ftdi_clk_period;   ----------------------------------  COMMAND on keyboard ---> ASCII ---> binary = 10000011 01001111 01001101 01001101 01000001 01001110 01000100
--                ftdi_dq<="01001111" ;wait for  ftdi_clk_period;
--                ftdi_dq<="01001101" ;wait for  ftdi_clk_period;
--                ftdi_dq<="01001101" ;wait for  ftdi_clk_period;
--                ftdi_dq<="01000001" ;wait for  ftdi_clk_period;
--                ftdi_dq<="01001110" ;wait for  ftdi_clk_period;
--                ftdi_dq<="01000100" ;wait for  ftdi_clk_period;
                
--                ftdi_dq<="01000001" ;wait for  ftdi_clk_period;--prima ne attendevo 3 di clk period--------------------------------  A IN CODICE ASCII ---> binary = 01011000
                 
                ftdi_dq<="ZZZZZZZZ";--------------aggiunto
                i_read_button<='0';              
                wait for i_clk_period*4;
                
                serial_adc_output <='0';
                wait for i_clk_period*2;
                serial_adc_output <='1';
                wait for i_clk_period*2;
                serial_adc_output <='1';
                wait for i_clk_period*2;
                serial_adc_output <='1';
                wait for i_clk_period*2;
                serial_adc_output <='0';
                wait for i_clk_period*2;
                serial_adc_output <='1';
                wait for i_clk_period*2;
                serial_adc_output <='1';
                wait for i_clk_period*2;
                serial_adc_output <='0';
                wait for i_clk_period*2;
                
                serial_adc_output <='U';
                  
                  ftdi_dq<="ZZZZZZZZ" ;---  wait for ftdi_clk_period*3;
                                              ftdi_rxfN<='1'; 
                                              wait for ftdi_clk_period*2;
                                              ftdi_txeN<='0';
                
                wait for 5000 ns;
                 i_read_button<='1'; 
                 
                wait for 100 ns;
                 i_read_button<='0';      
                 
                 wait for 100ns;
                 i_read_button<='1';
                 
                 wait for 100us;
                 i_read_button <='0';
                 
                 wait for 100ns;
                 i_read_button<='1';
                 
                 wait for 150us;
                 i_read_button <='0'; 
                 
                 wait for 100ns;
                 i_read_button<='1';
                 wait for 70us;
                 i_read_button <='0';         
                                wait for i_clk_period*4;
                                
                                serial_adc_output <='0';
                                wait for i_clk_period*2;
                                serial_adc_output <='1';
                                wait for i_clk_period*2;
                                serial_adc_output <='0';
                                wait for i_clk_period*2;
                                serial_adc_output <='0';
                                wait for i_clk_period*2;
                                serial_adc_output <='0';
                                wait for i_clk_period*2;
                                serial_adc_output <='0';
                                wait for i_clk_period*2;
                                serial_adc_output <='1';
                                wait for i_clk_period*2;
                                serial_adc_output <='0';
                                wait for i_clk_period*2;
                                
                                
                                  ftdi_dq<="ZZZZZZZZ" ;---  wait for ftdi_clk_period*3;
                                                              ftdi_rxfN<='1'; 
                                                              wait for ftdi_clk_period*2;
                                                              ftdi_txeN<='0';
                                
                                wait for 5000 ns;
                
         
      wait;   
 
 end process;
 
end ;
