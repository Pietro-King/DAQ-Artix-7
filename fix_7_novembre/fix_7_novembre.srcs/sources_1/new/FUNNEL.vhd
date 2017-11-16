------------------
--this module feeds the data from the fifo circuit to the bridge
--whenever is not busy, it will start its routine and send the data to the bridge (16bit at a time)
--the busy signal also works as valid for the bridge module
-- bridge and funnel MUST HAVE THE SAME CLOCK
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;


entity funnel is
  Port
( 
    clk: in std_logic;
    empty_fifos :in std_logic_vector(0 to 15);
    i_funnel_0 : in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_1 : in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_2 : in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_3 : in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_4 : in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_5 : in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_6 : in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_7 : in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_8 : in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_9 : in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_10 :in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_11 :in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_12 :in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_13 :in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_14 :in   STD_LOGIC_VECTOR (15 downto 0);
    i_funnel_15 :in   STD_LOGIC_VECTOR (15 downto 0);


    funnel_ready:  out std_logic;
    o_funnel_data: out std_logic_vector(15 downto 0);-------------16 bit
    busy_funnel:   out std_logic

);
end funnel;

architecture Behavioral of funnel is

shared variable counter:integer :=0;
signal zeroes:std_logic_vector(0 to 15):="0000000000000000";
signal busy:std_logic:='0';
signal start_counter:std_logic:='0';
signal funnel_ready_signal:std_logic:='0';

begin

busy_funnel<=busy;
read_from_fifos:process(clk)
    begin
    if(rising_edge(clk)) then
        if( empty_fifos = zeroes and busy='0' and funnel_ready_signal='0') then
            funnel_ready<='1';
            funnel_ready_signal<='1';
        else
            funnel_ready<='0';
            funnel_ready_signal<='0';
        end if;
    end if;
    end process;
    
starter:process(funnel_ready_signal,clk)
        begin
            if( funnel_ready_signal='1') then
                start_counter<='1';
            elsif(rising_edge(clk)) then
                if (counter>=16) then
                    start_counter<='0';
                end if;
            end if;
       
        end process;
    
busy_idle:process(clk)
        begin
        if(rising_edge(clk)) then
            if( start_counter='1' and counter < 16) then
                busy<='1';
            else
                busy<='0';
            end if;
        end if;
        end process;
    
counter_prcs:process(clk)
    begin
        if(rising_edge(clk)) then
            if(start_counter='1') then
                counter:=counter+1;
             else
                counter:=0;
            end if;
        end if;
    end process;
    
funneling:process(clk)
    begin
        if(rising_edge(clk)) then
            
                case counter is
            
                when 0 => o_funnel_data <=i_funnel_0;
                when 1 => o_funnel_data <=i_funnel_1;
                when 2 => o_funnel_data <=i_funnel_2;
                when 3 => o_funnel_data <=i_funnel_3;
                when 4 => o_funnel_data <=i_funnel_4;
                when 5 => o_funnel_data <=i_funnel_5;
                when 6 => o_funnel_data <=i_funnel_6;
                when 7 => o_funnel_data <=i_funnel_7;
                when 8 => o_funnel_data <=i_funnel_8;
                when 9 => o_funnel_data <=i_funnel_9;
                when 10 => o_funnel_data <=i_funnel_10;
                when 11 => o_funnel_data <=i_funnel_11;
                when 12 => o_funnel_data <=i_funnel_12;
                when 13 => o_funnel_data <=i_funnel_13;
                when 14 => o_funnel_data <=i_funnel_14;
                when 15 => o_funnel_data <=i_funnel_15;
                --when others => NULL;   ------------------------------------ NULL means no action  
                when others => o_funnel_data <="0000000000000000"; --to find errors
                end case; 
        
        end if;
    end process;
    
end Behavioral;
