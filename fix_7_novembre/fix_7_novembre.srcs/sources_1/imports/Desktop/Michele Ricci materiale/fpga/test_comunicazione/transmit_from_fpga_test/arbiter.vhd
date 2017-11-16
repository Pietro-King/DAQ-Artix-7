 -- controllare questo codice che la logica vada bene
 --l'alternativa potrebbe essere quella che quando c'è un conflitto di req nessuno dei 2 gnt si alza
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity arbiter is
    Port ( ftdi_clk : in  STD_LOGIC;
           ftdi_rx_req : in  STD_LOGIC;
           ftdi_tx_req : in  STD_LOGIC;
           ftdi_rx_gnt : out  STD_LOGIC;
           ftdi_tx_gnt : out  STD_LOGIC);
end arbiter;

architecture Behavioral of arbiter is           
signal ftdi_tx_gnt_int, ftdi_rx_gnt_int: std_logic;                                                
begin
arbiter_process: process(ftdi_clk,ftdi_rx_gnt_int,ftdi_tx_gnt_int)
begin
	if rising_edge(ftdi_clk) then 
		if (ftdi_rx_req='1' and ftdi_tx_req='0')  then 
			ftdi_rx_gnt_int<='1';					
			ftdi_tx_gnt_int<='0';
		elsif (ftdi_rx_req='1' and ftdi_tx_gnt_int='1')	then 
			ftdi_rx_gnt_int<='0';
		   ftdi_tx_gnt_int<='1';
		end if;	
	   if (ftdi_tx_req='1' and ftdi_rx_req='0')  then 
			ftdi_tx_gnt_int<='1';					
			ftdi_rx_gnt_int<='0';
		elsif (ftdi_tx_req='1' and ftdi_rx_gnt_int='1')	then
			ftdi_tx_gnt_int<='0';
		   ftdi_rx_gnt_int<='1';
		end if;	
	   if (ftdi_rx_req='0' and ftdi_tx_req='0') then
			ftdi_tx_gnt_int<='0';					
			ftdi_rx_gnt_int<='0';
	   end if;
	end if;
-- assignement of internal signals
ftdi_rx_gnt<=ftdi_rx_gnt_int;
ftdi_tx_gnt<=ftdi_tx_gnt_int;
end process;
end Behavioral;

