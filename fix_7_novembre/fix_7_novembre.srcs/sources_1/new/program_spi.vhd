--must add the ! bit
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity program_spi is
port(
        
        rx_data:            in std_logic_vector(0 to 7);--program string to write; must be connected to rx_data
        retransmitted_prog: in std_logic; --the string sent back_ thruought a pin
        clk:                in std_logic; --clk
        program:            in std_logic; --programming signal
        
        program_written:    out std_logic;
        finish_program:     out std_logic; --finish programming signal
        spi_write_en:       out std_logic; -- goes  to the pin for the write en
        asic_load:          out std_logic; --load signal
        rom_en:             out std_logic; --rom enable
        spi_write_data:     out std_logic --delivers the serial data to the asic
);
end program_spi;

architecture Behavioral of program_spi is
constant string_lenght:integer:=112;
constant byte_lenght:integer:=14;
signal program_written_signal: std_logic:='0';
signal spi_string_read: std_logic_vector(0 to 111);
signal spi_string_retransmitted: std_logic_vector(0 to 111);
signal finish_program_signal:std_logic;
begin



program_written<=program_written_signal;

-----------------change program signal
rom_enable:process--ogni volta che si alza program, setto il rom_en
begin
 --if rising_edge(program) then
    if program_written_signal='1' then
        if (spi_string_read(0 to 7)="01001001") then --I
            rom_en<='1';
        else 
            rom_en<='0';
        end if;
    end if;
--end if;    
end process;



read_string:process(clk)
variable count_read:integer:=0;
begin
    if rising_edge(clk) then
        if program='1' then --remember to set the program to 0 after 12 clk cycles
            if count_read<=byte_lenght-1 then
                spi_string_read(count_read*8 to (count_read*8)+7)<=rx_data;
                count_read:=count_read+1;
                if count_read= byte_lenght then
                    program_written_signal<='1';
                end if;         
            end if;
        elsif(finish_program_signal='1') then
            count_read:=0;
            program_written_signal<='0';
        end if;
    end if;
end process;

programming:process(clk)
variable count_1:integer:=0;
variable count_2:integer:=0;
begin
    if rising_edge(clk) then
        if program_written_signal='1' then
       
            if count_1<= string_lenght-1 then
                spi_write_en<='1';
                spi_write_data<=spi_string_read(count_1);
                count_1:=count_1+1;
                finish_program<='0';
                finish_program_signal<='0';
                asic_load<='0';
            
                
            elsif count_1=string_lenght then
                if count_2<= string_lenght-1 then
                            spi_write_en<='1';
                            spi_write_data<=spi_string_read(count_2);
                            spi_string_retransmitted(count_2)<=retransmitted_prog;
                            count_2:=count_2+1;
                            
                end if;
 
                if count_2 = string_lenght then
                    asic_load<='1';
                    count_1:=count_1+1;
                end if;
           
            elsif count_2 = string_lenght then
                --count_1:=0;
                count_2:=0;
                finish_program<='1';
                finish_program_signal<='1';
                spi_write_en<='0';
                asic_load<='0';
                spi_write_data<='Z';
                
             else
                count_1:=0;
                finish_program_signal<='0';
             end if;
        end if;
    end if;

end process;
end Behavioral;
