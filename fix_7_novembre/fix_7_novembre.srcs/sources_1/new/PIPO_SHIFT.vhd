library ieee;
use ieee.std_logic_1164.all;



entity PIPO_shift is
    generic (
    
        OUTPUT_STRING_WIDTH: INTEGER := 56 ;
        VECTOR_WIDTH: INTEGER := 8;
        DEPTH: INTEGER   := 8
    );
    
    port (
    
        clk: in std_logic;
        reset: in std_logic;
        input_vector: in std_logic_vector(VECTOR_WIDTH-1 downto 0);
        output_string: out std_logic_vector(OUTPUT_STRING_WIDTH-1 downto 0);--------------segnale di valid del comando inviato dal pc
        output_command: out std_logic_vector(VECTOR_WIDTH-1 downto 0);---------------------segnale che contiene l'istruzione da effettuare
        valid: in std_logic
        
--          Dout_0: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
--          Dout_1: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
--          Dout_2: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
--          Dout_3: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
--          Dout_4: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
--          Dout_5: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
--          Dout_6: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
--          Dout_7: out std_logic_vector(VECTOR_WIDTH-1 downto 0)
 
  );
end;
---------------------------------------------------------
architecture Behavioral of PIPO_shift is

    -------------------------------------------------------------------useful signals
    shared variable counter : integer := 0 ;
    
    type matrix is array (0 to DEPTH-1) of std_logic_vector(VECTOR_WIDTH-1 downto 0);    ------------------------------------array of standard logic vector
    signal code : matrix;    ----- (0 to DEPTH-1)(VECTOR_WIDTH-1 downto 0);---???        ------------------------------------segnale array
    
    signal FLAG : std_logic:='1';
   -------------------------------------------------------------- output parallel data   
       signal  Dout_0: std_logic_vector(VECTOR_WIDTH-1 downto 0);
       signal  Dout_1: std_logic_vector(VECTOR_WIDTH-1 downto 0);
       signal  Dout_2: std_logic_vector(VECTOR_WIDTH-1 downto 0);
       signal  Dout_3: std_logic_vector(VECTOR_WIDTH-1 downto 0);
       signal  Dout_4: std_logic_vector(VECTOR_WIDTH-1 downto 0);
       signal  Dout_5: std_logic_vector(VECTOR_WIDTH-1 downto 0);
       signal  Dout_6: std_logic_vector(VECTOR_WIDTH-1 downto 0);
       signal  Dout_7: std_logic_vector(VECTOR_WIDTH-1 downto 0);
  
   -------------------------------------------------   
   
begin
--------------------------------------------------

       
    process(clk)
    begin
       if rising_edge( clk ) then ----------------------------------- NOTA LO SHIFT DEI VETTORI NEL REGISTRO è SINCORNA CON IL VALID => tx_valid
       
           if reset='0' then
           code <= input_vector & code (0 to DEPTH-2);
                      
                Dout_0 <= code (0);
                Dout_1 <= code (1);
                Dout_2 <= code (2);
                Dout_3 <= code (3);
                Dout_4 <= code (4);
                Dout_5 <= code (5);
                Dout_6 <= code (6);
                Dout_7 <= code (7);
         
           else  code <= (others => (others => '0'));
                
       end if;   
       end if;
       end process;
       
       --output_string <=Dout_7 & Dout_6 & Dout_5 & Dout_4 & Dout_3 & Dout_2  & Dout_1 ;
       
       output_string <= Dout_6 & Dout_5 & Dout_4 & Dout_3 & Dout_2  & Dout_1 & Dout_0 ;
     
     
      output_command <= Dout_0;  
           
       end Behavioral;






























--library ieee;
--use ieee.std_logic_1164.all;



--entity PIPO_shift is
--    generic (
    
--        OUTPUT_STRING_WIDTH: INTEGER := 56 ;
--        VECTOR_WIDTH: INTEGER := 8;
--        DEPTH: INTEGER   := 8
--    );
    
--    port (
    
--        clk: in std_logic;
--       -- reset: in std_logic;
--        input_vector: in std_logic_vector(VECTOR_WIDTH-1 downto 0);
--        output_string: out std_logic_vector(OUTPUT_STRING_WIDTH-1 downto 0);--------------segnale di valid del comando inviato dal pc
--        output_command: out std_logic_vector(VECTOR_WIDTH-1 downto 0)---------------------segnale che contiene l'istruzione da effettuare
        
----          Dout_0: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
----          Dout_1: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
----          Dout_2: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
----          Dout_3: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
----          Dout_4: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
----          Dout_5: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
----          Dout_6: out std_logic_vector(VECTOR_WIDTH-1 downto 0);
----          Dout_7: out std_logic_vector(VECTOR_WIDTH-1 downto 0)
 
--  );
--end;
-----------------------------------------------------------
--architecture Behavioral of PIPO_shift is

--    -------------------------------------------------------------------useful signals
--    shared variable counter : integer := 0 ;
    
--    type matrix is array (0 to DEPTH-1) of std_logic_vector(VECTOR_WIDTH-1 downto 0);    ------------------------------------array of standard logic vector
--    signal code : matrix;    ----- (0 to DEPTH-1)(VECTOR_WIDTH-1 downto 0);---???        ------------------------------------segnale array
    
--    signal FLAG : std_logic:='1';
--   -------------------------------------------------------------- output parallel data   
--       signal  Dout_0: std_logic_vector(VECTOR_WIDTH-1 downto 0);
--       signal  Dout_1: std_logic_vector(VECTOR_WIDTH-1 downto 0);
--       signal  Dout_2: std_logic_vector(VECTOR_WIDTH-1 downto 0);
--       signal  Dout_3: std_logic_vector(VECTOR_WIDTH-1 downto 0);
--       signal  Dout_4: std_logic_vector(VECTOR_WIDTH-1 downto 0);
--       signal  Dout_5: std_logic_vector(VECTOR_WIDTH-1 downto 0);
--       signal  Dout_6: std_logic_vector(VECTOR_WIDTH-1 downto 0);
--       signal  Dout_7: std_logic_vector(VECTOR_WIDTH-1 downto 0);
       
----    signal output_string:  std_logic_vector(OUTPUT_STRING_WIDTH-1 downto 0);
----    constant OUTPUT_STRING_WIDTH: INTEGER := 64;        
-- -------------------------------------------------   
--begin
----------------------------------------------------

-- process (clk)
--    begin
--    if flag='1' then
--        if rising_edge(clk) then
--            counter := counter+1 ;
            
--        else counter:=0;
        
----            if counter <= 7 then
----            code <= input_vector & code (0 to DEPTH-2);
            
----            else code <= (others => (others => '0'));
----            end if;
--         end if;
--    end if;    
--    end process;
   
    
--    process(clk)
--    begin
--       if rising_edge(clk) then
       
--            if counter <= 7 then
--            code <= input_vector & code (0 to DEPTH-2);
           
--            elsif counter = 7 then
                   
--                Dout_0 <= code (0);
--                Dout_1 <= code (1);
--                Dout_2 <= code (2);
--                Dout_3 <= code (3);
--                Dout_4 <= code (4);
--                Dout_5 <= code (5);
--                Dout_6 <= code (6);
--                Dout_7 <= code (7);
         
--            elsif counter = 8  then
--            code <= (others => (others => '0'));
--            counter := 0;
--            flag <= '0'; 
       
           
                                  
                
--           end if;
--       end if;
--       end process;
       
       
       
--      output_string <= Dout_0 & Dout_1 & Dout_2 & Dout_3 & Dout_4 & Dout_5 & Dout_5 & Dout_6 ;  
     
--      output_command <= Dout_7;  
           
--       end Behavioral;

--    process (clk)
--    begin
    
--        if rising_edge(clk) then
--        code <= input_vector & code (0 to DEPTH-2);
--        counter := counter+1 ;
--        end if;
        
--    end process;
   
    
--    process(clk)
--    begin
--       if rising_edge(clk) then
          
--           if counter = 8  then
--                code <= (others => (others => '0'));
--                counter := 0; 
           
--           elsif counter = 7 then
       
--                Dout_0 <= code (0);
--                Dout_1 <= code (1);
--                Dout_2 <= code (2);
--                Dout_3 <= code (3);
--                Dout_4 <= code (4);
--                Dout_5 <= code (5);
--                Dout_6 <= code (6);
--                Dout_7 <= code (7);
                                  
                
--           end if;
--       end if;
--       end process;


  
















--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

--entity PIPO_SHIFT is

--     port (
--     clk : in std_logic;
--        data_in : in std_logic_vector( 7 downto 0 );
--          reset: in std_logic;
--          Dout_0: out std_logic_vector(7 downto 0);
--          Dout_1: out std_logic_vector(7 downto 0);
--          Dout_2: out std_logic_vector(7 downto 0);
--          Dout_3: out std_logic_vector(7 downto 0);
--          Dout_4: out std_logic_vector(7 downto 0);
--          Dout_5: out std_logic_vector(7 downto 0);
--          Dout_6: out std_logic_vector(7 downto 0);
--          Dout_7: out std_logic_vector(7 downto 0)

--           );
     
--  end PIPO_SHIFT;


-- architecture Behavioral of PIPO_SHIFT is
 
-- type array_data is array (0 to 7) of std_logic_vector(7 downto 0);
-- signal code : array_data (0 to 7)(7 downto 0);

-- shared variable counter : integer := 0; 
 
--begin

  
--   process (clk)
--   begin
--    if rising_edge(CLK, reset) then
--        if reset then
--                 array_data    <= (others => (others => '0'));
--        elsif rising_edge(clk) then
--         array_data <= data_in  & array_data(0 to 6);
         
--   end if;
--   end process;
   














--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

--entity PIPO_SHIFT is

--     port (
--     clk : in std_logic;
--        data_in : in std_logic_vector( 7 downto 0 );
         
--          Dout_0: out std_logic_vector(7 downto 0);
--          Dout_1: out std_logic_vector(7 downto 0);
--          Dout_2: out std_logic_vector(7 downto 0);
--          Dout_3: out std_logic_vector(7 downto 0);
--          Dout_4: out std_logic_vector(7 downto 0);
--          Dout_5: out std_logic_vector(7 downto 0);
--          Dout_6: out std_logic_vector(7 downto 0);
--          Dout_7: out std_logic_vector(7 downto 0)

--           );
     
--  end PIPO_SHIFT;


-- architecture Behavioral of PIPO_SHIFT is
 
 
-- shared variable counter : integer := 0; 
-- signal data_out :std_logic_vector( 7 downto 0 );
-- signal data_out_0 :std_logic_vector( 7 downto 0 );
-- signal data_out_1 :std_logic_vector( 7 downto 0 );
-- signal data_out_2 :std_logic_vector( 7 downto 0 );
-- signal data_out_3 :std_logic_vector( 7 downto 0 );
-- signal data_out_4 :std_logic_vector( 7 downto 0 );
-- signal data_out_5 :std_logic_vector( 7 downto 0 );
-- signal data_out_6 :std_logic_vector( 7 downto 0 );
-- signal data_out_7 :std_logic_vector( 7 downto 0 );

 
--  signal data_in_0 :std_logic_vector( 7 downto 0 );
--  signal data_in_1 :std_logic_vector( 7 downto 0 );
--  signal data_in_2 :std_logic_vector( 7 downto 0 );
--  signal data_in_3 :std_logic_vector( 7 downto 0 );
--  signal data_in_4 :std_logic_vector( 7 downto 0 );
--  signal data_in_5 :std_logic_vector( 7 downto 0 );
--  signal data_in_6 :std_logic_vector( 7 downto 0 );
--  signal data_in_7 :std_logic_vector( 7 downto 0 );
 
-- signal data_x :std_logic_vector( 7 downto 0 );

--begin

  
--   process (clk)
--   begin
--    if rising_edge(CLK) then
--     data_out <= data_in; 
--     counter := counter+1; 
     
--   end if;
--   end process;
   
   
--  process(clk)
--   begin
--   if rising_edge(CLK) then
      
--        case counter is
            
--              when '1' =>  
--              data_out_1 <= data_out ;
                                                
--              when '2' =>  
--              data_out_2 <= data_out  ;              
            
            
--               when '3' =>  
--               data_out_3 <= data_out;
            
            
              
           
--           end case;
  
   
--       end if;
--   end if;
--   end process;





--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

--entity PIPO_SHIFT is

--     port(
--     clk : in std_logic;
--        data_in : in std_logic_vector(63 downto 0);
    
----          Dout_0: out std_logic_vector(7 downto 0);
----          Dout_1: out std_logic_vector(7 downto 0);
----          Dout_2: out std_logic_vector(7 downto 0);
----          Dout_3: out std_logic_vector(7 downto 0);
----          Dout_4: out std_logic_vector(7 downto 0);
----          Dout_5: out std_logic_vector(7 downto 0);
----          Dout_6: out std_logic_vector(7 downto 0);
----          Dout_7: out std_logic_vector(7 downto 0)
       
--     );
     
--  end PIPO_SHIFT;
  
--architecture Behavioral of PIPO_SHIFT is

--     shared variable counter : integer := 0; 
--     signal code :  std_logic_vector(63 downto 0);  
--     signal Dout_0:  std_logic_vector(7 downto 0);
--     signal Dout_1:  std_logic_vector(7 downto 0);
--     signal Dout_2:  std_logic_vector(7 downto 0);
--     signal Dout_3:  std_logic_vector(7 downto 0);
--     signal Dout_4:  std_logic_vector(7 downto 0);
--     signal Dout_5:  std_logic_vector(7 downto 0);
--     signal Dout_6:  std_logic_vector(7 downto 0);
--     signal Dout_7:  std_logic_vector(7 downto 0);
     
     
--begin

  
--   process (clk)
--   begin
--    if rising_edge(CLK) then
--     data_out <= data_in; 
--     counter := counter+1; 
--     end if;
--   end process;
 
--code  <= Dout_0 & Dout_1 & Dout_2 & Dout_3 & Dout_4 & Dout_5 & Dout_5 & Dout_6 & Dout_7; 


-- end Behavioral;
