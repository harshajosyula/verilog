library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
	port(
		clk:in std_logic;
		ALUOutM:in std_logic_vector(15 downto 0);
		WriteDataM:in std_logic_vector(15 downto 0);		
		MemWriteM:in std_logic;
		
		ReadDataM:out std_logic_vector(15 downto 0)
	);
end data_memory;


architecture behave_data_memory of data_memory is
	-- Data memory size= 64KB
	type mem_type is array(0 to 65535) of std_logic_vector(7 downto 0);
	
	signal memory : mem_type := (
    0  => x"00",
    1  => x"01",
    2  => x"02",
    3  => x"03",
    4  => x"04",
    5  => x"05",
    6  => x"06",
    7  => x"07",
    8  => x"08",
    9  => x"09",
    others => x"00"
);
	
begin
	process(clk)
	begin
		if rising_edge(clk) then
			--WriteData
			if MemWriteM='1' then
				memory(to_integer(unsigned(ALUOutM)))<=WriteDataM(15 downto 8);
				memory(to_integer(unsigned(ALUOutM))+1)<=WriteDataM(7 downto 0);
			end if;
			
			--read Data
		--	ReadDataM<=memory(to_integer(unsigned(ALUOutM))) & memory(to_integer(unsigned(ALUOutM))+1);
		
				-- Use a temporary variable or signal to handle the wrap-around logic
				ReadDataM <= memory(to_integer(unsigned(ALUOutM))) & 
           			  memory((to_integer(unsigned(ALUOutM)) + 1) mod 65536);
		end if;
		
	end process;
end behave_data_memory;
	
