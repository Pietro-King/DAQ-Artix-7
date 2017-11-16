library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity utility is
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
end utility;
--------------------------------------------------------
architecture Behavioral of utility is
------------------------------------------------------
-- segnali di utility per i buffer di uscita dei registri 
signal ftdi_oeN_buf,ftdi_rdN_buf,ftdi_wrN_buf: std_logic;
 
--INPUT_OUTPUT_component
signal ftdi_dq_out_buf,ftdi_dq_in_buf: std_logic_vector(7 downto 0);
signal tristate: std_logic;

--PLL CLOCK FROM FTDI
component ftdi_clock_gen
port
 (-- Clock in ports
  CLK_IN1           : in     std_logic;
  -- Clock out ports
  CLK_OUT1          : out    std_logic;
  CLK_OUT2          : out    std_logic;
  -- Status and control signals
  RESET             : in     std_logic;
  LOCKED            : out    std_logic
 ------------------------------------------------------****** CLK_VALID         : out    std_logic -------------- QUESTO C ERA NEL VECCHIO IPCORE DI ISE, ADESSO NON C è PIU IL PIN CLK_VALID
 );
end component;
--segnale interno di lock del pll_ftdi
signal CLK_IN: std_logic;
signal CLK0: std_logic;    ------ è uguale all'  ftdi_clk_i   ! *********  ----NOTA----  **********
signal CLK180: std_logic;
signal LOCKED_INT: std_logic;
------------------------------------------
begin
----------------------------------------------------------------
-- assegno il clock interno generato dal pll al clock all'interno del bridge
ftdi_clk_i<=CLK0;
LOCKED_BRIDGE<=LOCKED_INT;
------------------------------------------------------------------------------
ftdi_clock_generator : ftdi_clock_gen
  port map
   (-- Clock in ports
    CLK_IN1 => ftdi_clk_out,
    -- Clock out ports
    CLK_OUT1 => CLK0,
    CLK_OUT2 =>open,
    -- Status and control signals
    RESET  => RST_BRIDGE,
    LOCKED => LOCKED_INT);                       ---------------------------********* 
    ----------------------------- +*+*+*+*+*+*+*+* --------CLK_VALID => open);-----------------------------********* il nuovo ipcore di vivado non ha il pin clk_valid quindi ho assegnato quello che prima era valid a LOCKED
--------------------------------------------------------------------------
-- buffer dei pin senza registro(su cui devo metter i constraint di tempo ) 
 IBUF_rxfN : IBUF
   generic map (
      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "DEFAULT")
   port map (
      O => ftdi_rxfN_i,     -- Buffer output
      I => ftdi_rxfN_out      -- Buffer input (connect directly to top-level port)
   );
 IBUF_txeN : IBUF
   generic map (
      IBUF_LOW_PWR => TRUE, -- Low power (TRUE) vs. performance (FALSE) setting for referenced I/O standards
      IOSTANDARD => "DEFAULT")
   port map (
      O => ftdi_txeN_i,     -- Buffer output
      I => ftdi_txeN_out      -- Buffer input (connect directly to top-level port)
   );
--------------------------------------------------------------------------------------
--uscite sincrone 
--flip flop per i 3 dati sincroni
pins_out:process(CLK0)
begin
if rising_edge(CLK0) then 
ftdi_oeN_buf<=ftdi_oeN_i;
ftdi_rdN_buf<=ftdi_rdN_i;
ftdi_wrN_buf<=ftdi_wrN_i;
end if;
end process;

OBUF_oeN : OBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (
      O => ftdi_oeN_out,     -- Buffer output (connect directly to top-level port)
      I => ftdi_oeN_buf      -- Buffer input 
   );	

OBUF_rdN : OBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (
      O => ftdi_rdN_out,     -- Buffer output (connect directly to top-level port)
      I => ftdi_rdN_buf      -- Buffer input 
   );	

OBUF_wrN : OBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "DEFAULT",
      SLEW => "SLOW")
   port map (
      O => ftdi_wrN_out,     -- Buffer output (connect directly to top-level port)
      I => ftdi_wrN_buf      -- Buffer input 
   );		
--end of single ended outputs
--------------------------------------------------------------
--input flip flop
ftdi_dq_input:process(CLK0)
begin
if rising_edge(CLK0) then
ftdi_dq_in<=ftdi_dq_in_buf;
end if;
end process;
----output flip flop with enable
ftdi_dq_output:process(CLK0)
begin
if rising_edge(CLK0) then---------------------------------!!!!!!  vedi schema a pagina 49
	if ftdi_dq_en='1' then---------------------------!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!oe-en
		ftdi_dq_out_buf<=ftdi_dq_out;
		--ftdi_dq_out_scope<=ftdi_dq_out;           --chipscope
	else
		ftdi_dq_out_buf<=ftdi_dq_out_buf;
		--ftdi_dq_out_scope<=ftdi_dq_out_scope;     --chipscope
 	end if;
end if;
end process;
--tristate buffer out for dq and control declaration 
tristate<=not(ftdi_dq_oe);

   IOBUF_0 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "LVCMOS33",
      SLEW => "SLOW")
   port map (
      O => ftdi_dq_in_buf(0),     -- Buffer output
      IO => ftdi_dq(0),   -- Buffer inout port (connect directly to top-level port)
      I => ftdi_dq_out_buf(0),     -- Buffer input
      T => tristate      -- 3-state enable input, high=input, low=output 
   );
    IOBUF_1 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "LVCMOS33",
      SLEW => "SLOW")
   port map (
      O => ftdi_dq_in_buf(1),     -- Buffer output
      IO => ftdi_dq(1),   -- Buffer inout port (connect directly to top-level port)
      I =>ftdi_dq_out_buf(1),     -- Buffer input
      T => tristate      -- 3-state enable input, high=input, low=output 
   );
     IOBUF_2 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "LVCMOS33",
      SLEW => "SLOW")
   port map (
      O => ftdi_dq_in_buf(2),     -- Buffer output
      IO => ftdi_dq(2),   -- Buffer inout port (connect directly to top-level port)
      I => ftdi_dq_out_buf(2),     -- Buffer input
      T => tristate      -- 3-state enable input, high=input, low=output 
   );
     IOBUF_3 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "LVCMOS33",
      SLEW => "SLOW")
   port map (
      O => ftdi_dq_in_buf(3),     -- Buffer output
      IO => ftdi_dq(3),   -- Buffer inout port (connect directly to top-level port)
      I => ftdi_dq_out_buf(3),     -- Buffer input
      T => tristate      -- 3-state enable input, high=input, low=output 
   );
     IOBUF_4 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "LVCMOS33",
      SLEW => "SLOW")
   port map (
      O => ftdi_dq_in_buf(4),     -- Buffer output
      IO => ftdi_dq(4),   -- Buffer inout port (connect directly to top-level port)
      I => ftdi_dq_out_buf(4),     -- Buffer input
      T => tristate      -- 3-state enable input, high=input, low=output 
   );
     IOBUF_5 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "LVCMOS33",
      SLEW => "SLOW")
   port map (
      O => ftdi_dq_in_buf(5),     -- Buffer output
      IO => ftdi_dq(5),   -- Buffer inout port (connect directly to top-level port)
      I => ftdi_dq_out_buf(5),     -- Buffer input
      T => tristate      -- 3-state enable input, high=input, low=output 
   );
     IOBUF_6 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "LVCMOS33",
      SLEW => "SLOW")
   port map (
      O => ftdi_dq_in_buf(6),     -- Buffer output
      IO => ftdi_dq(6),   -- Buffer inout port (connect directly to top-level port)
      I => ftdi_dq_out_buf(6),     -- Buffer input
      T => tristate      -- 3-state enable input, high=input, low=output 
   );
     IOBUF_7 : IOBUF
   generic map (
      DRIVE => 12,
      IOSTANDARD => "LVCMOS33",
      SLEW => "SLOW")
   port map (
      O => ftdi_dq_in_buf(7),     -- Buffer output
      IO => ftdi_dq(7),   -- Buffer inout port (connect directly to top-level port)
      I => ftdi_dq_out_buf(7),     -- Buffer input
      T => tristate      -- 3-state enable input, high=input, low=output 
   );
--------------------------------------------------
end Behavioral;  
