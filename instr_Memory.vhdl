library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity instr_Memory is port(
	clk: in std_logic;
	Addr : in std_logic_vector(15 downto 0);
	instr : out std_logic_vector(15 downto 0)
);
end instr_memory;


architecture behave_instr_memory of instr_Memory is 

--memory size 64kb 
type mem_type is array(0 to 65535) of STD_LOGIC_VECTOR(7 downto 0);

--hardcoding few instruction by initialising memory
signal memory : mem_type := (
         0=>  "01000011",
         1=>  "10000001",
       2=>  "01000101",
       3=>  "10000001",
       4=>  "10000010",
       5=>  "10001010",
       24 =>"10011110",
       25=>"01001011",
       
      
       46 =>"00100111",
      47 =>"00101000",
        others => "00000000"
    );

begin
	
                     instr <= memory(to_integer(unsigned(Addr))) & memory(to_integer(unsigned(Addr)) + 1)   ;
	


end behave_instr_memory;


