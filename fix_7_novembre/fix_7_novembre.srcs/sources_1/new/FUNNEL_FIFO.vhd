------------------------------------------------------------
--this module implements a circular buffer for each adc
--it works with a 100MHZ clock
--whenever the adc finish a conversion the data are written in the buffer
--whenever there are data and the funnel is ready they are sent forward in the chain with the funnel_ready signal(1clk period)
--
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;


entity funnel_fifo is
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
end funnel_fifo;

architecture Behavioral of funnel_fifo is
------circular buffer------
component circular_buffer is
	generic(
		fifo_length	: integer:=16;
		data_width	: integer:=16);

	port(
		clk_w		: in std_logic;
        clk_r        : in std_logic;
		rst			: in std_logic;
		ren			: in std_logic;
		wen			: in std_logic;
		dataout		: out std_logic_vector(data_width-1 downto 0);
		datain		: in  std_logic_vector(data_width-1 downto 0);
		empty		: out std_logic;
		full		: out std_logic);
	end component;
----------------------------------------------------
----signals-----------------------------------
signal EoC_adc: std_logic:='0';
signal empty_fifo_vector: std_logic_vector(0 to 15) ;
signal full_fifo_vector: std_logic_vector(0 to 15) ;
--signal busy: std_logic:='0';
signal rst_0: std_logic:='0';
--signal dummy_o: std_logic:='0';

signal funnel_0 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_1 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_2 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_3 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_4 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_5 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_6 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_7 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_8 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_9 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_10 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_11 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_12 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_13 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_14 : STD_LOGIC_VECTOR (15 downto 0);
signal funnel_15 : STD_LOGIC_VECTOR (15 downto 0);


begin
    empty_fifos<=empty_fifo_vector;
    --EoC_adc<=(EoC_adc_0 AND EoC_adc_1 AND EoC_adc_2 AND EoC_adc_3 AND EoC_adc_4 AND EoC_adc_5 AND EoC_adc_6 AND EoC_adc_7 AND EoC_adc_8 AND EoC_adc_9 AND EoC_adc_10 AND EoC_adc_11 AND EoC_adc_12 AND EoC_adc_13 AND EoC_adc_14 AND EoC_adc_15);
    i_funnel_0 <="0000" & funnel_0(13 downto 2);
    i_funnel_1 <="0001" & funnel_1(13 downto 2);
    i_funnel_2 <="0010" & funnel_2(13 downto 2);
    i_funnel_3 <="0011" & funnel_3(13 downto 2);
    i_funnel_4 <="0100" & funnel_4(13 downto 2);
    i_funnel_5 <="0101" & funnel_5(13 downto 2);
    i_funnel_6 <="0110" & funnel_6(13 downto 2);
    i_funnel_7 <="0111" & funnel_7(13 downto 2);
    i_funnel_8 <="1000" & funnel_8(13 downto 2);
    i_funnel_9 <="1001" & funnel_9(13 downto 2);
    i_funnel_10 <="1010" & funnel_10(13 downto 2);
    i_funnel_11 <="1011" & funnel_11(13 downto 2);
    i_funnel_12 <="1100" & funnel_12(13 downto 2);
    i_funnel_13 <="1101" & funnel_13(13 downto 2);
    i_funnel_14 <="1110" & funnel_14(13 downto 2);
    i_funnel_15 <="1111" & funnel_15(13 downto 2);
    
    
    fifo0: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_0,
                                    dataout=>funnel_0,
                                    datain=>o_adc_0,
                                    empty=>empty_fifo_vector(0),
                                    full=>full_fifo_vector(0)
                                    );
    fifo1: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_1,
                                    dataout=>funnel_1,
                                    datain=>o_adc_1,
                                    empty=>empty_fifo_vector(1),
                                    full=>full_fifo_vector(1)
                                    );
    fifo2: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_2,
                                    dataout=>funnel_2,
                                    datain=>o_adc_2,
                                    empty=>empty_fifo_vector(2),
                                    full=>full_fifo_vector(2)
                                    );
    fifo3: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_3,
                                    dataout=>funnel_3,
                                    datain=>o_adc_3,
                                    empty=>empty_fifo_vector(3),
                                    full=>full_fifo_vector(3)
                                    );
    fifo4: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_4,
                                    dataout=>funnel_4,
                                    datain=>o_adc_4,
                                    empty=>empty_fifo_vector(4),
                                    full=>full_fifo_vector(4)
                                    );
    fifo5: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_5,
                                    dataout=>funnel_5,
                                    datain=>o_adc_5,
                                    empty=>empty_fifo_vector(5),
                                    full=>full_fifo_vector(5)
                                    );
    fifo6: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_6,
                                    dataout=>funnel_6,
                                    datain=>o_adc_6,
                                    empty=>empty_fifo_vector(6),
                                    full=>full_fifo_vector(6)
                                    );
    fifo7: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_7,
                                    dataout=>funnel_7,
                                    datain=>o_adc_7,
                                    empty=>empty_fifo_vector(7),
                                    full=>full_fifo_vector(7)
                                    );
    fifo8: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_8,
                                    dataout=>funnel_8,
                                    datain=>o_adc_8,
                                    empty=>empty_fifo_vector(8),
                                    full=>full_fifo_vector(8)
                                    );
    fifo9: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_9,
                                    dataout=>funnel_9,
                                    datain=>o_adc_9,
                                    empty=>empty_fifo_vector(9),
                                    full=>full_fifo_vector(9)
                                    );
    fifo10: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_10,
                                    dataout=>funnel_10,
                                    datain=>o_adc_10,
                                    empty=>empty_fifo_vector(10),
                                    full=>full_fifo_vector(10)
                                    );
    fifo11: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_11,
                                    dataout=>funnel_11,
                                    datain=>o_adc_11,
                                    empty=>empty_fifo_vector(11),
                                    full=>full_fifo_vector(11)
                                    );
    fifo12: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_12,
                                    dataout=>funnel_12,
                                    datain=>o_adc_12,
                                    empty=>empty_fifo_vector(12),
                                    full=>full_fifo_vector(12)
                                    );
    fifo13: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_13,
                                    dataout=>funnel_13,
                                    datain=>o_adc_13,
                                    empty=>empty_fifo_vector(13),
                                    full=>full_fifo_vector(13)
                                    );
    fifo14: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_14,
                                    dataout=>funnel_14,
                                    datain=>o_adc_14,
                                    empty=>empty_fifo_vector(14),
                                    full=>full_fifo_vector(14)
                                    );
    fifo15: circular_buffer port map(clk_w=>clk_w,
                                    clk_r=>clk_r,
                                    rst=>rst_0,
                                    ren=>funnel_ready,
                                    wen=>EoC_adc_15,
                                    dataout=>funnel_15,
                                    datain=>o_adc_15,
                                    empty=>empty_fifo_vector(15),
                                    full=>full_fifo_vector(15)
                                    );
end Behavioral;
