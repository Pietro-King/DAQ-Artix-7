-- occhio ai glonal oddr per le uscite verso l'esterno
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmitter_fsm is
port(
     -- verso il mondo esterno  
	  ftdi_txeN : IN std_logic;
     ftdi_wrN: OUT std_logic;
     --verso gli altri blocchi
     ftdi_tx_req,tx_fifo_rdreq,ftdi_dq_en,ftdi_dq_oe : OUT std_logic;       
     ftdi_tx_gnt,tx_fifo_empty : IN std_logic;
     -- plus the clock signal and the reset  
     ftdi_clk : IN std_logic; 
     RST: IN std_logic 
	  );
end transmitter_fsm;


architecture Behavioral of transmitter_fsm is
--SEGNALI DELLA MACCHINA A STATI 
type STATUS is ( IDLE , WRITEE , WAITT, ENDD) ;
signal PS, NS : STATUS;
--copia dei segnali all interno in modo da poter leggere e scrivere
signal ftdi_txeN_i,ftdi_tx_gnt_i,tx_fifo_empty_i :  std_logic;                             --inputs
signal ftdi_tx_req_i,tx_fifo_rdreq_i,ftdi_dq_en_i,ftdi_dq_oe_i, ftdi_wrN_i: std_logic;     --outputs
begin
 --    SIGNALS
 --assegno i segnali interni a quelli esterni 
 --outputs
ftdi_tx_req<=ftdi_tx_req_i;          
tx_fifo_rdreq<=tx_fifo_rdreq_i;
ftdi_dq_en<=ftdi_dq_en_i;-----*****
ftdi_wrN<=ftdi_wrN_i;    
-- ci sono 2 segnali che nei fatti sono uguali, assegno il valore a uno dei 2 solo e qui li rendo uguali       
ftdi_dq_en_i<=tx_fifo_rdreq_i;
   ------------------------------------------------------------------*************************
-- process(ftdi_clk)------------------------------TUTTO QUESTO PEZZO L HO AGGIUNTO PER SINCRONIZZARE FTDI_DQ_EN (???)
--	begin
--		if rising_edge (ftdi_clk) then 
--			ftdi_dq_en<=ftdi_dq_en_i;
--		end if; 
--	end process;
	----------------------------------------------------------------------*******************************
	
	-- processo per dare in modo sincrono ftdi_dq_oe    
	wrreq_reg: process(ftdi_clk)
	begin
		if rising_edge (ftdi_clk) then 
			ftdi_dq_oe<=ftdi_dq_oe_i;
		end if; 
	end process;
--inputs
ftdi_txeN_i<=ftdi_txeN; 
ftdi_tx_gnt_i<=ftdi_tx_gnt; 
tx_fifo_empty_i<=tx_fifo_empty;
------------------------------ END SIGNALS
-- registro che clocca il next state in modo sincrono e, nel caso di reset ,porta la macchina nel caso IDLE  
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

-- processo che calcola il next state 
next_state_decode: process (PS,ftdi_txeN_i,tx_fifo_empty_i,ftdi_tx_gnt_i)
begin		
	case PS is
		when IDLE =>
			if ftdi_tx_gnt_i='1' then 
				NS<=WRITEE;
			else
				NS<=PS;
			end if;
		when WRITEE =>
			if ftdi_txeN_i='1' then 
				NS<=WAITT;
			elsif tx_fifo_empty_i='1' then
				NS<=ENDD;
			else 
				NS<=PS;
			end if;
		when WAITT =>
			if (ftdi_txeN_i='0' and ftdi_tx_gnt_i='1')  then 
				NS<=WRITEE;
			else
				NS<=PS;
			end if;
      when ENDD =>
			NS<=IDLE;
		when others =>      --exception case (è IL CASO DI PARTENZA) 
			NS <= IDLE;	
	end case;
end process;

-- processo che calcola gli outputs in modo asincrono
--(poi bisogna valutare dove mettere oddr o registri (se si tratta di segnali interni))

output_decode : process (PS,ftdi_txeN_i,tx_fifo_empty_i,ftdi_tx_gnt_i)
begin	case PS is
		when IDLE =>
			if ftdi_txeN_i='0' and tx_fifo_empty_i='0' then 
				ftdi_tx_req_i<='1';
			else
				ftdi_tx_req_i<='0';
			end if;
		   if ftdi_tx_gnt_i='1' then 
				tx_fifo_rdreq_i<='1';------------------------------------------------------------------------***********
			   ftdi_dq_oe_i<='1';                   --C'è un registro per lui
			   ftdi_wrN_i<='0';
			else
				tx_fifo_rdreq_i<='0';
			   ftdi_dq_oe_i<='0';                   --C'è un registro per lui
			   ftdi_wrN_i<='1';
			end if;
		when WRITEE =>
			ftdi_tx_req_i<='1';                     -- nella questi segnali hanno sempre questi valori
			if ftdi_txeN_i='0' and tx_fifo_empty_i='0' then 
				tx_fifo_rdreq_i<='1';
			   ftdi_wrN_i<='0';
				ftdi_dq_oe_i<='1';                    --C'è un registro per lui
			else            
				tx_fifo_rdreq_i<='0';
			   ftdi_wrN_i<='1';
				ftdi_dq_oe_i<='0'; 
			end if;
		when WAITT =>
			tx_fifo_rdreq_i<='0';      -- valgono sempre questo in questo stato
			if ftdi_txeN_i='0' then 
				ftdi_tx_req_i<='1';
			else
				ftdi_tx_req_i<='0';
			end if;
         if (ftdi_tx_gnt_i='1' and ftdi_txeN_i='0') then 
				ftdi_dq_oe_i<='1';                   --C'è un registro per lui
			   ftdi_wrN_i<='0';
			else
				ftdi_dq_oe_i<='0';                   --C'è un registro per lui
			   ftdi_wrN_i<='1';
			end if;
		when ENDD =>
			   tx_fifo_rdreq_i<='0';
				ftdi_wrN_i<='1';
			   ftdi_dq_oe_i<='0'; 
		      ftdi_tx_req_i<='0'; 
	end case;
end process;	
end Behavioral;

