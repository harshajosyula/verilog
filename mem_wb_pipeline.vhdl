library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem_wb_pipeline_reg is
	port(
		clk:in std_logic;
		-- inputs from mem stage
		ReadDataM:in std_logic_vector(15 downto 0);

		-- bypassed inputs from ex_mem_pipeline reg
		WriteRegM:in std_logic_vector(2 downto 0); -- destination reg
		ALUOutM:in std_logic_vector(15 downto 0);
		PC_plus2M:in std_logic_vector(15 downto 0);
		constructed_lli_in_wb :in std_logic_vector(15 downto 0);
		--contorl signals as bypassed inputs
		RegWrite_en_M: in std_logic;
		Result_sel_M: in std_logic_vector(1 downto 0);

		-- outputs
		ReadDataW:out std_logic_vector(15 downto 0);
		ALUOutW:out std_logic_vector(15 downto 0);
		WriteRegW:out std_logic_vector(2 downto 0);
		PC_plus2W:out std_logic_vector(15 downto 0);
		RegWrite_en_W: out std_logic;
		Result_sel_W: out std_logic_vector(1 downto 0);
		constructed_lli_out_wb : out std_logic_vector(15 downto 0)
	);
end mem_wb_pipeline_reg;

architecture Behavioral of mem_wb_pipeline_reg is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			ALUOutW<=ALUOutM;
			ReadDataW<=ReadDataM;
			WriteRegW<=WriteRegM;
			PC_plus2W <= PC_plus2M;
			RegWrite_en_W <= RegWrite_en_M;
			Result_sel_W <= Result_sel_M;
			constructed_lli_out_wb <= constructed_lli_in_wb;
		end if;
	end process;
end Behavioral;
