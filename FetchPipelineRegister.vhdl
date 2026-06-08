library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity pipeline_fetch is port (
    clk      : in  std_logic;
    clr      : in  std_logic;  -- active high flush
    enable   : in  std_logic;  -- active low enable (stall when '1')
    instr_in : in  std_logic_vector(15 downto 0);
    pc_in    : in  std_logic_vector(15 downto 0);
    flush_in : in std_logic;
    pc_out   : out std_logic_vector(15 downto 0);
    instr_out: out std_logic_vector(15 downto 0)
    
);
end pipeline_fetch;

architecture behave of pipeline_fetch is 
 signal pc_plus2 : std_logic_vector(15 downto 0);
  signal flushcount : unsigned(1 downto 0) := "00";
begin

	    pc_plus2 <= std_logic_vector(unsigned(pc_in) + x"0002");
		

    process(clk)
    	
    begin
    

 
        if rising_edge(clk) then
         	 if clr = '1' or flush_in= '1' then
                instr_out  <= x"0000";
                pc_out     <= x"0000";
                flushcount <= "10"; -- This handles the next 2 cycles
          
            elsif   flushcount > "00" then
            	
            	instr_out <= x"0000";
                pc_out    <= x"0000";
                
                flushcount <= flushcount - 1;
                
            	
            elsif enable = '0' then     -- normal latch (active low)
                instr_out <= instr_in;
                pc_out    <= pc_plus2;

            end if;
        end if;
    end process;
end behave;
