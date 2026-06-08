library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity write_back is
	port(
		-- select line for mux
		Result_sel_W_in:in std_logic_vector(1 downto 0);

		--inputs to mux
		ReadDataW:in std_logic_vector(15 downto 0);
		ALUOutW:in std_logic_vector(15 downto 0);
		PC_plus2W_in: in std_logic_vector(15 downto 0);
		constructed_lli_final: in std_logic_vector(15 downto 0);
		-- output
		Result_to_reg_file_W:out std_logic_vector(15 downto 0)
	);
end write_back;

architecture Behavioral of write_back is
begin
	Result_to_reg_file_W<=ReadDataW when Result_sel_W_in = "01" else
			  PC_plus2W_in when Result_sel_W_in = "10"  else
			  constructed_lli_final when Result_sel_W_in="11"
			  else ALUOutW;
end Behavioral;
