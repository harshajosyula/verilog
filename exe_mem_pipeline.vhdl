library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ex_mem_pipe is
	port(
		clk: in std_logic;
		reset:in std_logic;
		
		--inputs to pipeline register
		RegWriteE:in std_logic;
		MemtoRegE:in std_logic_vector(1 downto 0);
		MemWriteE:in std_logic;
		
		ALUOutE:in std_logic_vector(15 downto 0);
		WriteDataE:in std_logic_vector(15 downto 0);

		-- bypassed inputs 
		WriteRegE:in std_logic_vector(2 downto 0);
		PC_plus2E: in std_logic_vector(15 downto 0);
		constructed_lli_in : in std_logic_vector(15 downto 0);
		--outputs to mem stage
		RegWriteM:out std_logic;
		MemtoRegM:out std_logic_vector(1 downto 0);
		MemWriteM:out std_logic;
		
		ALUOutM:out std_logic_vector(15 downto 0);
		WriteDataM:out std_logic_vector(15 downto 0);
		WriteRegM:out std_logic_vector(2 downto 0);
		PC_plus2M:out std_logic_vector(15 downto 0);
		constructed_lli_out: out std_logic_vector(15 downto 0)
	);
end ex_mem_pipe;

architecture Behavioral of ex_mem_pipe is
begin
	process(clk,reset)
	begin
		if reset='1' then
			RegWriteM<='0';
			MemtoRegM<=(others=>'0');
			MemWriteM<='0';
			
			ALUOutM<=(others=>'0');
			WriteDataM<=(others=>'0');
			WriteRegM<=(others=>'0');
			PC_plus2M<=(others=>'0');
		
		elsif rising_edge(clk) then
			RegWriteM<=RegWriteE;
			MemtoRegM<=MemtoRegE;
			MemWriteM<=MemWriteE;
			
			ALUOutM<=ALUOutE;
			WriteDataM<=WriteDataE;
			WriteRegM<=WriteRegE;
			PC_plus2M<=PC_plus2E;
			constructed_lli_out <= constructed_lli_in;
		end if;
	end process;
end Behavioral;
			
			
