library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;
--use IEEE.NUMERIC_STD.ALL;
entity usb_fpga_bridge is
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
	  
	  ftdi_clk_X : out std_logic;-------------------------NOTA
	  --FPGA SIDE 
     --receive part
     rx_ready: IN std_logic;
     rx_valid: OUT std_logic;
	  rx_data: OUT std_logic_vector(port_width_receive-1 downto 0);
     --transmit part 
     tx_ready: OUT std_logic;
	  tx_valid: IN std_logic;
	  tx_data: IN std_logic_vector(port_width_transmit-1 downto 0);
     --clock of the internal system
	  CLK: IN std_logic;
     --syncronous reset of the main logic
	  RST: IN std_logic;
     --utilty bridge logic (when locked deassert you MUST put a reset on RESETBRIDGE )
	  RST_BRIDGE: IN std_logic;
     LOCKED_BRIDGE: OUT std_logic
	 );
end usb_fpga_bridge;



architecture Behavioral of usb_fpga_bridge is
-- component declaration

-------------------------------- 
component utility is
port(--to ftdi
     --RECEIVER SIDE
	  ftdi_rxfN_out: IN std_logic;
	  ftdi_oeN_out: OUT std_logic;
	  ftdi_rdN_out: OUT std_logic;	
     --TRANSMITTER SIDE
     ftdi_txeN_out: IN std_logic;
	  ftdi_wrN_out: OUT std_logic;
     --COMMON DATA BUS
     ftdi_dq: INOUT std_logic_vector(7 downto 0);
     --ftdi clock signal
     ftdi_clk_out: IN std_logic;
     --end of ftdi side
	  -----------------------------
	  -- fpga side
     --RECEIVER SIDE
	  ftdi_rxfN_i: OUT std_logic;
	  ftdi_oeN_i: IN std_logic;
	  ftdi_rdN_i: IN std_logic;	
     --TRANSMITTER SIDE
     ftdi_txeN_i: OUT std_logic;
	  ftdi_wrN_i: IN std_logic;
     ftdi_dq_oe: IN std_logic; 
	  ftdi_dq_en: IN std_logic;
	  --COMMON DATA BUSES
     ftdi_dq_in: OUT std_logic_vector(7 downto 0);
     ftdi_dq_out: IN std_logic_vector(7 downto 0);
	  --ftdi clock signal
     ftdi_clk_i: OUT std_logic;
	  --LOCKED PLL( means that the eeprom is correctly setted in fifo 245 mode)
	  LOCKED_BRIDGE: OUT std_logic;
	  RST_BRIDGE: IN std_logic
	  );
end component;
signal ftdi_dq_en:std_logic;
component transmitter_fsm is
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
end component;

component receiver_fsm is
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
end component;

component arbiter is
    Port ( ftdi_clk : in  STD_LOGIC;
           ftdi_rx_req : in  STD_LOGIC;
           ftdi_tx_req : in  STD_LOGIC;
           ftdi_rx_gnt : out  STD_LOGIC;
           ftdi_tx_gnt : out  STD_LOGIC);
end component;
---FIFOS DECLARATION


COMPONENT transmitter_fifo
  PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full : OUT STD_LOGIC;
    almost_full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
	------------ valid : OUT STD_LOGIC
  );
END COMPONENT;

COMPONENT receiver_fifo
  PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    full : OUT STD_LOGIC;
    almost_full : OUT STD_LOGIC;
    empty : OUT STD_LOGIC
  );
END COMPONENT;
------- SIGNALS
--SIGNAL FOR THE BRIDGE
signal ftdi_rxN_i,ftdi_oeN_i,ftdi_rdN_i,ftdi_clk_i,ftdi_txeN_i,ftdi_wrN_i: std_logic;
signal rx_fifo_data,tx_fifo_data: std_logic_vector(7 downto 0);
--internal signals
signal ftdi_rx_req,ftdi_rx_gnt,rx_fifo_afull,rx_fifo_wrreq,ftdi_tx_req,ftdi_tx_gnt,tx_fifo_empty,tx_fifo_rdreq,ftdi_dq_oe: std_logic;
--------------------
--fifo auxiliary signals
signal almost_full_trans_fifo: std_logic;
signal empty_receive: std_logic;
---------------------------signal fifo_valid :std_logic; --------------------------*******---VALID AGGIUNTO ALLA TRANSMIT FIFO---*******
------
-------------------signal ftdi_dq_OUTFF_en:std_logic;   SEGNALE AGGIUNTO DA ME
begin
------------------------------------------------------
ftdi_SIWU<='1';         --constant value out!
-------------------------------------------------------
register_and_buffer: utility 
port map(--to ftdi
     --RECEIVER SIDE
	  ftdi_rxfN_out=>ftdi_rxfN,
	  ftdi_oeN_out=>ftdi_oeN,
	  ftdi_rdN_out=>ftdi_rdN,	
     --TRANSMITTER SIDE
     ftdi_txeN_out=>ftdi_txeN,
	  ftdi_wrN_out=>ftdi_wrN,
     --COMMON DATA BUS
     ftdi_dq=>ftdi_dq,
     --ftdi clock signal
     ftdi_clk_out=>ftdi_clk,
     --end of ftdi side
	  -----------------------------
	  -- fpga side
     --RECEIVER SIDE
	  ftdi_rxfN_i=>ftdi_rxN_i,
	  ftdi_oeN_i=>ftdi_oeN_i,
	  ftdi_rdN_i=>ftdi_rdN_i,
     --TRANSMITTER SIDE
     ftdi_txeN_i=>ftdi_txeN_i,
	  ftdi_wrN_i=>ftdi_wrN_i,
     ftdi_dq_oe=>ftdi_dq_oe,
	  ftdi_dq_en=> ftdi_dq_en,------------------------------------------------------------------------- ftdi_dq_en=>ftdi_dq_OUTFF_en,
	  --COMMON DATA BUSES
     ftdi_dq_in=>rx_fifo_data,
     ftdi_dq_out=>tx_fifo_data,
	  --ftdi clock signal
     ftdi_clk_i=>ftdi_clk_i,
	  --LOCKED PLL( means that the eeprom is correctly setted in fifo 245 mode)
	  LOCKED_BRIDGE=>LOCKED_BRIDGE,
	  RST_BRIDGE=>RST_BRIDGE
	  );

transmitter_machine: transmitter_fsm
port map (
     -- verso il mondo esterno  
	  ftdi_txeN=>ftdi_txeN_i, 
     ftdi_wrN=>ftdi_wrN_i,
     --verso gli altri blocchi
     ftdi_tx_req=>ftdi_tx_req,
	  tx_fifo_rdreq=>tx_fifo_rdreq,
	  ftdi_dq_en=>ftdi_dq_en,
	  ftdi_dq_oe=>ftdi_dq_oe,       
     ftdi_tx_gnt=>ftdi_tx_gnt,
	  tx_fifo_empty=>tx_fifo_empty,
     -- plus the clock signal and the reset  
     ftdi_clk=>ftdi_clk_i,
     RST=>RST
	  );

receiver_machine:receiver_fsm
PORT MAP(
	  ftdi_rxfN=>ftdi_rxN_i,           
	  ftdi_oeN=>ftdi_oeN_i,         -- mettere degli IDDR e dei ODDR (GLOBALI PER TUTTO L'OGGETTO! )
	  ftdi_rdN=>ftdi_rdN_i,
     -- segnali che non devono uscire dai PADS ma che toccanoi solo altri oggetti
	  ftdi_rx_req_s=>ftdi_rx_req,
	  rx_fifo_wrreq_ff_s=>rx_fifo_wrreq,    --outputs             
     ftdi_rx_gnt_s=>ftdi_rx_gnt,
	  rx_fifo_afull_s=>rx_fifo_afull,       --inputs   
	  --plus the clock signal and the RST that forces the state into the IDLE state	  
	  ftdi_clk=>ftdi_clk_i,      
	  RST=>RST
	  );

arb:arbiter 
PORT MAP ( 
     ftdi_clk=>ftdi_clk_i, 
     ftdi_rx_req=>ftdi_rx_req, 
     ftdi_tx_req=>ftdi_tx_req, 
     ftdi_rx_gnt=>ftdi_rx_gnt, 
     ftdi_tx_gnt=>ftdi_tx_gnt
	  ); 
-------------

 
--RECEIVER FIFO 
receive_fifo: receiver_fifo
  PORT MAP (
    rst => RST,
    wr_clk => ftdi_clk_i,
    rd_clk => CLK,
    din => rx_fifo_data,
    wr_en => rx_fifo_wrreq,
    rd_en => rx_ready,
    dout => rx_data,
    full => open,
    almost_full => rx_fifo_afull,
    empty => empty_receive
  );
rx_valid<=not(empty_receive);

--TRANSMITTER FIFO 
transmit_fifo : transmitter_fifo
  PORT MAP (
    rst => RST,
    wr_clk => CLK,
    rd_clk => ftdi_clk_i,
    din => tx_data,
    wr_en => tx_valid,
    rd_en => tx_fifo_rdreq,
    dout => tx_fifo_data,
    full => open,
    almost_full => almost_full_trans_fifo,
    empty => tx_fifo_empty
	 --------------------valid=> open
  );
tx_ready<=not(almost_full_trans_fifo);

ftdi_clk_X <= ftdi_clk_i;

-------------------------------------------------------------------
end Behavioral;

