--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity receiver_fsm is
port(
	  ftdi_rxfN: IN std_logic;              
	  ftdi_oeN: OUT std_logic;                    -- mettere degli IDDR e dei ODDR (GLOBALI PER TUTTO L'OGGETTO! )
	  ftdi_rdN: OUT std_logic;
     -- segnali che non devono uscire dai PADS ma che toccanoi solo altri oggetti
	  ftdi_rx_req_s,rx_fifo_wrreq_ff_s : OUT std_logic;   --outputs             
     ftdi_rx_gnt_s,rx_fifo_afull_s :  IN std_logic;      --inputs   
	  --plus the clock signal and the RST that forces the state into the IDLE state	  
	  ftdi_clk: IN std_logic;        
	  RST: IN std_logic
	  );
end receiver_fsm;

architecture Behavioral of receiver_fsm is
--SEGNALI DELLA MACCHINA A STATI 
type STATUS is ( IDLE , START , READD , ENDD) ;
signal PS, NS : STATUS;
--copia di alcuni segnali da usare come SEGNALI INTERNI
signal ftdi_rx_req,rx_fifo_wrreq_ff : std_logic;   --outputs             
signal ftdi_rx_gnt,rx_fifo_afull : std_logic;      --inputs               
-- SEGNALI DI UTILITY(PER IL FLIP FLOP) 
signal rx_fifo_wrreq : std_logic;            --questo è il wrreq non sincrono(può essere eliminato,      si può togliere il ff anche
                                             --c'è ridondanza fra rx_fifo_wrreq_ff_s e rx_fifo_wrreq_ff;)   
begin
--assegno i segnali interni ai segnali esterni
ftdi_rx_req_s<=ftdi_rx_req;
rx_fifo_wrreq_ff_s<=rx_fifo_wrreq_ff;             
ftdi_rx_gnt<=ftdi_rx_gnt_s;
rx_fifo_afull<=rx_fifo_afull_s;

-- registro che clocca il next state 
state_reg: process(ftdi_clk)
begin
	if rising_edge (ftdi_clk) then 
		if (RST='1') then 
			PS<=IDLE;
		else
			PS<=NS;
		end if;
	end if; 
end process;

-- processo per dare in modo sincrono wrreq
wrreq_reg: process(ftdi_clk)
begin
	if rising_edge (ftdi_clk) then 
		rx_fifo_wrreq_ff<=rx_fifo_wrreq;
	end if; 
end process;

-- processo che calcola il next state 
next_state_decode: process (PS,rx_fifo_afull,ftdi_rx_gnt,ftdi_rxfN)
begin		
	case PS is
		when IDLE =>
			if ftdi_rx_gnt='1' then 
				NS<=START;
			else
				NS<=PS;
			end if;
		when START =>
			NS<=READD;
		when READD =>
		   if rx_fifo_afull='1' or ftdi_rxfN ='1' then 
				NS<=ENDD;
			else
				NS<=PS;
			end if;
		when ENDD =>
			NS<=IDLE;
	   when others =>      --exception case (è IL CASO DI PARTENZA) 
			NS <= IDLE;	
	end case;
end process;
-- processo che calcola gli outputs e li da in modo asincrono (quelli che poi vorremo sincroni saranno dati in out con un ddr 
--                                                             e il wrreq ha già un flip flop)
output_decode : process (PS,rx_fifo_afull,ftdi_rx_gnt,ftdi_rxfN)
begin	case PS is
		when IDLE =>
		-- nell' idel state questi 2 segnali sono sempre così	
			rx_fifo_wrreq<='0';           
			ftdi_rdN<='1';
		--	
			if ftdi_rxfN='0' and rx_fifo_afull='0' then 
				ftdi_rx_req<='1';                               -- send the request at the arbiter
				else 
				ftdi_rx_req<='0';
			end if;	
			if ftdi_rx_gnt='1' then
				ftdi_oeN<='0';
			else 
				ftdi_oeN<='1';
			end if;
		when START =>
			ftdi_rdN<='0';
			ftdi_oeN<='0';
			ftdi_rx_req<='1';
			rx_fifo_wrreq<='0';
		when READD =>
			ftdi_rx_req<='1';          --segnale che ha sempre quel valor in questo stato     
			if ftdi_rxfN='0' then          
				rx_fifo_wrreq<='1';
			else
				rx_fifo_wrreq<='0';
			end if;
		   if ftdi_rxfN='0' and rx_fifo_afull='0' then   
				ftdi_oeN<='0';
			   ftdi_rdN<='0';
			else
				ftdi_oeN<='1';
			   ftdi_rdN<='1';	
		   end if;
		when ENDD =>
			ftdi_oeN<='1';
			ftdi_rdN<='1';
	      rx_fifo_wrreq<='0';
		   ftdi_rx_req<='0';
	end case;
end process;
end Behavioral;

