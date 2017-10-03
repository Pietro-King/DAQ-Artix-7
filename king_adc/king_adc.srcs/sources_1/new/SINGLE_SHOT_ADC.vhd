
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity axel_adc is
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
end axel_adc;

architecture Behavioral of axel_adc is

shared variable counter :integer := 1;

signal conv_flag :std_logic :='0';

signal r_sclk :std_logic;
signal r_cs :std_logic:='1';
signal led :std_logic;
signal r_read_button: std_logic;
signal clk_x :std_logic;
signal LOCK_CLK :std_logic;
SIGNAL TIMER :std_logic;   ------DEBOUNUCE SIGNAL
SIGNAL debounce_flag :std_logic:= '1';
shared variable DEBOUNCE_TIMER: integer:=1000;
shared variable debounce_delay : integer:=1;------------per il debounce del bottone
signal x : std_logic :='0';
begin

process( clk_x )
begin
if rising_edge (clk_x) then

  if debounce_flag='0' and debounce_delay <=DEBOUNCE_TIMER then
  debounce_delay := debounce_delay +1;
  else debounce_delay := 1;
  end if;
   
--  if debounce_delay = 1000 then
--  debounce_delay :=1;
--  x<='1';--------------------segnale per vedere delay sul testbench
--  end if;

end if;
end process;

process( clk_x )
begin
if rising_edge (clk_x)  then

    if r_read_button ='0'and debounce_flag='1' then
        conv_flag <='1';
        debounce_flag<='0';
        
    elsif debounce_delay =DEBOUNCE_TIMER then
        debounce_flag<='1';  
   
        
    elsif counter>21 then ---r_sclk<='1';
        conv_flag <= '0';
        
    else 
        conv_flag <= conv_flag;
       
    end if;
-------------------------------------------------------altro if nello stesso processo del clk
    if counter <=19 and counter >3 then
        ---r_sclk <=i_clk ;
        r_cs<='0';
    else
        r_cs<='1';
    end if;
---------------------------------------------------------       
--    if debounce_delay = 1000 then
--    debounce_flag<='1';

--    end if;

end if;
end process;
----------------------------------------

process(clk_x,conv_flag)
begin
if rising_edge (clk_x) then
if  conv_flag ='1' then
counter := counter + 1;
else counter:=1 ;
end if;
end if;
end process;


process(clk_x,r_cs)
begin

if r_cs ='0'  then

r_sclk <= clk_x;

else r_sclk <= '1';


end if;
end process;

adc_data_valid_process: process(clk_x)
begin
if counter =21 then
o_adc_data_valid <='1';
else
o_adc_data_valid <='0';

end if;
end process;


o_cs<=r_cs;
o_sclk<=r_sclk;
--LED_i_read<=led;
r_read_button<=i_read_button;
clk_x<=i_clk_adc;


data_process: process(clk_x)
begin

if(falling_edge(clk_x)) then

   case counter is-----------------------miso è in pratica il singolo bit convertito dall adc che quindi esce dallo slave e va al master

     when  5  => o_adc_data(15)   <= i_miso;
     when  6  => o_adc_data(14)   <= i_miso;
     when  7  => o_adc_data( 13)  <= i_miso;
     when  8  => o_adc_data( 12)  <= i_miso;
     when  9 => o_adc_data( 11)   <= i_miso;
     when  10 => o_adc_data( 10)   <= i_miso;
     when  11 => o_adc_data( 9)  <= i_miso;
     when  12 => o_adc_data( 8)  <= i_miso;
     when  13 => o_adc_data( 7)  <= i_miso;
     when  14 => o_adc_data( 6)  <= i_miso;
     when  15 => o_adc_data( 5)  <= i_miso;
     when  16 => o_adc_data( 4)  <= i_miso;
     when  17 => o_adc_data( 3)  <= i_miso;
     when  18 => o_adc_data( 2)  <= i_miso;
     when  19 => o_adc_data( 1)  <= i_miso;
     when  20 => o_adc_data( 0)  <= i_miso;
     
--     when 11  => o_adc_data( 3)  <= i_miso;
--     when 12  => o_adc_data( 2)  <= i_miso;
--     when 13  => o_adc_data( 1)  <= i_miso;
--     when 14  => o_adc_data( 0)  <= i_miso;
 
     when others => NULL;   ------------------------------------ NULL means no action  
      
   end case;  

end if;
end process;


end Behavioral;