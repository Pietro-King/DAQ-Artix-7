
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity led_blink is
 Port ( 
 button_1: in std_logic;
 button_2: in std_logic;
 led_1 : out std_logic;
 led_2 : out std_logic );
 
end led_blink;

architecture Behavioral of led_blink is

begin

led_1 <= button_1;
led_2 <= button_2;

end Behavioral;
