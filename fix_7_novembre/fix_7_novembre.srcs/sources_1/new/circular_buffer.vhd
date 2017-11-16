library	ieee;
use		ieee.std_logic_1164.all;
use		ieee.numeric_std.all;

entity circular_buffer is
	generic(
		fifo_length	: integer:=16;
		data_width	: integer:=16);

	port(
		clk_w		: in std_logic;
		clk_r		: in std_logic;
		rst			: in std_logic;
		ren			: in std_logic;
		wen			: in std_logic;
		dataout		: out std_logic_vector(data_width-1 downto 0);
		datain		: in  std_logic_vector(data_width-1 downto 0);
		empty		: out std_logic;
		full		: out std_logic);
	end circular_buffer;

architecture Behav of circular_buffer is

	type memory_type is array (0 to fifo_length-1) of std_logic_vector(data_width-1 downto 0);
	signal memory	: memory_type := (others => (others => '0'));
	signal readptr,writeptr	: integer range 0 to fifo_length-1 := 0;
	signal empty_o,full_o: std_logic:='0';


begin
    full<=full_o;
    empty<=empty_o;
    full_o <= '1' when ((writeptr + 1 = readptr)) or ((writeptr=fifo_length-1) and (readptr=0)) else '0';
    empty_o <= '1' when (readptr = writeptr) else '0' ;
		
fifo_w: process(clk_w,rst)
	begin
		if rst='1' then
			
			writeptr <= 0;

		elsif rising_edge(clk_w) then
			if (wen='1' and full_o='0') then 
				memory(writeptr) <= datain ;
				if (writeptr=fifo_length-1) then
					writeptr <= 0;
				else
					writeptr <= writeptr+1;
				end if;
			end if;

					
		end if; 
	end process;
	
fifo_r: process(clk_r,rst)
    begin
    	if rst='1' then
            readptr <= 0;
            
        elsif rising_edge(clk_r) then
            if (ren='1' and empty_o='0') then 
                dataout <= memory(readptr);
                if (readptr=fifo_length-1) then
                    readptr <= 0;
                else
                    readptr <= readptr+1;
                end if;
            end if ;
                    
        end if; 
    end process;
end Behav;