------------------------------------------
--This module groups togerther all the ADC handlers
--the trigger signal is single
--can be modeled to choose singolar channels.
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ADC_ARRAY is

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
end ADC_ARRAY;

architecture Behavioral of ADC_ARRAY is
component axel_adc is
  Port
 ( 
    i_clk_adc: in std_logic;
    i_read_button : in std_logic;
    o_sclk: out std_logic;
    o_cs: out std_logic;
    i_miso: in std_logic;
    o_adc_data: out std_logic_vector(15 downto 0);-------------16 bit
    o_adc_data_valid: out std_logic
  );
end component;

signal o_sclk_0 : STD_LOGIC;  
signal o_sclk_1 : STD_LOGIC;  
signal o_sclk_2 : STD_LOGIC;  
signal o_sclk_3 : STD_LOGIC;  
signal o_sclk_4 : STD_LOGIC;  
signal o_sclk_5 : STD_LOGIC;  
signal o_sclk_6 : STD_LOGIC;  
signal o_sclk_7 : STD_LOGIC;  
signal o_sclk_8 : STD_LOGIC;  
signal o_sclk_9 : STD_LOGIC;  
signal o_sclk_10 : STD_LOGIC; 
signal o_sclk_11 : STD_LOGIC; 
signal o_sclk_12 : STD_LOGIC; 
signal o_sclk_13 : STD_LOGIC; 
signal o_sclk_14 : STD_LOGIC; 
signal o_sclk_15 : STD_LOGIC; 

signal o_cs_0 : STD_LOGIC;  
signal o_cs_1 : STD_LOGIC;  
signal o_cs_2 : STD_LOGIC;  
signal o_cs_3 : STD_LOGIC;  
signal o_cs_4 : STD_LOGIC;  
signal o_cs_5 : STD_LOGIC;  
signal o_cs_6 : STD_LOGIC;  
signal o_cs_7 : STD_LOGIC;  
signal o_cs_8 : STD_LOGIC;  
signal o_cs_9 : STD_LOGIC;  
signal o_cs_10 : STD_LOGIC; 
signal o_cs_11 : STD_LOGIC; 
signal o_cs_12 : STD_LOGIC; 
signal o_cs_13 : STD_LOGIC; 
signal o_cs_14 : STD_LOGIC; 
signal o_cs_15 : STD_LOGIC; 


begin
o_cs<=o_cs_0 AND o_cs_1 AND o_cs_1 AND o_cs_2 AND o_cs_3 AND o_cs_4 AND o_cs_5 AND o_cs_6 AND o_cs_7 AND o_cs_8 AND o_cs_9 AND o_cs_10 AND o_cs_11 AND o_cs_12 AND o_cs_13 AND o_cs_14 AND o_cs_15;
o_sclk<=o_sclk_0 AND o_sclk_1 AND o_sclk_1 AND o_sclk_2 AND o_sclk_3 AND o_sclk_4 AND o_sclk_5 AND o_sclk_6 AND o_sclk_7 AND o_sclk_8 AND o_sclk_9 AND o_sclk_10 AND o_sclk_11 AND o_sclk_12 AND o_sclk_13 AND o_sclk_14 AND o_sclk_15;

adc0: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_0,
                        o_cs=>o_cs_0,
                        i_miso=>serial_data_in_adc_0,
                        o_adc_data=>o_adc_0,
                        o_adc_data_valid=>EoC_adc_0
                        );
adc1: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_1,
                        o_cs=>o_cs_1,
                        i_miso=>serial_data_in_adc_1,
                        o_adc_data=>o_adc_1,
                        o_adc_data_valid=>EoC_adc_1
                        );
adc2: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_2,
                        o_cs=>o_cs_2,
                        i_miso=>serial_data_in_adc_2,
                        o_adc_data=>o_adc_2,
                        o_adc_data_valid=>EoC_adc_2
                        );
adc3: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_3,
                        o_cs=>o_cs_3,
                        i_miso=>serial_data_in_adc_3,
                        o_adc_data=>o_adc_3,
                        o_adc_data_valid=>EoC_adc_3
                        );
adc4: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_4,
                        o_cs=>o_cs_4,
                        i_miso=>serial_data_in_adc_4,
                        o_adc_data=>o_adc_4,
                        o_adc_data_valid=>EoC_adc_4
                        );
adc5: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_5,
                        o_cs=>o_cs_5,
                        i_miso=>serial_data_in_adc_5,
                        o_adc_data=>o_adc_5,
                        o_adc_data_valid=>EoC_adc_5
                        );
adc6: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_6,
                        o_cs=>o_cs_6,
                        i_miso=>serial_data_in_adc_6,
                        o_adc_data=>o_adc_6,
                        o_adc_data_valid=>EoC_adc_6
                        );
adc7: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_7,
                        o_cs=>o_cs_7,
                        i_miso=>serial_data_in_adc_7,
                        o_adc_data=>o_adc_7,
                        o_adc_data_valid=>EoC_adc_7
                        );
adc8: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_8,
                        o_cs=>o_cs_8,
                        i_miso=>serial_data_in_adc_8,
                        o_adc_data=>o_adc_8,
                        o_adc_data_valid=>EoC_adc_8
                        );
adc9: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_9,
                        o_cs=>o_cs_9,
                        i_miso=>serial_data_in_adc_9,
                        o_adc_data=>o_adc_9,
                        o_adc_data_valid=>EoC_adc_9
                        );
adc10: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_10,
                        o_cs=>o_cs_10,
                        i_miso=>serial_data_in_adc_10,
                        o_adc_data=>o_adc_10,
                        o_adc_data_valid=>EoC_adc_10
                        );
adc11: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_11,
                        o_cs=>o_cs_11,
                        i_miso=>serial_data_in_adc_11,
                        o_adc_data=>o_adc_11,
                        o_adc_data_valid=>EoC_adc_11
                        );
adc12: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_12,
                        o_cs=>o_cs_12,
                        i_miso=>serial_data_in_adc_12,
                        o_adc_data=>o_adc_12,
                        o_adc_data_valid=>EoC_adc_12
                        );
adc13: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_13,
                        o_cs=>o_cs_13,
                        i_miso=>serial_data_in_adc_13,
                        o_adc_data=>o_adc_13,
                        o_adc_data_valid=>EoC_adc_13
                        );
adc14: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_14,
                        o_cs=>o_cs_14,
                        i_miso=>serial_data_in_adc_14,
                        o_adc_data=>o_adc_14,
                        o_adc_data_valid=>EoC_adc_14
                        );
adc15: axel_adc port map
                       (i_clk_adc=>clk_adc,
                        i_read_button=>trigger_adc,
                        o_sclk=>o_sclk_15,
                        o_cs=>o_cs_15,
                        i_miso=>serial_data_in_adc_15,
                        o_adc_data=>o_adc_15,
                        o_adc_data_valid=>EoC_adc_15
                        );

end Behavioral;
