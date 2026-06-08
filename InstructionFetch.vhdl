library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IFstage is port (
	
	clk: in std_logic;
	Addr : in std_logic_vector(15 downto 0);
	BTA: in std_logic_vector(15 downto 0);
	JTA: in std_logic_vector(15 downto 0);
	PC_sel_E : in std_logic;
	ctrl_branch: in std_logic;
	flush_in : in std_logic;
	--enable   :  in std_logic; 
	instr_out:  out std_logic_vector(15 downto 0); -- output of pipeline Fetch reg
	pc_out:  out std_logic_vector(15 downto 0);
	R0_write_fetch: out std_logic_vector(15 downto 0)
);
end IFstage;

architecture behave of IFstage is 
    signal instr_wire : std_logic_vector(15 downto 0);
    signal pc : std_logic_vector(15 downto 0);
    signal pc_plus2 : std_logic_vector(15 downto 0);

begin

		    pc_plus2 <= std_logic_vector(unsigned(Addr) + x"0002");

		    			
	instr_mem: entity work.instr_Memory 
		port map(
			clk  => clk,
			Addr =>Addr,
			instr =>instr_wire
		);
	
	
	  instr_out <= instr_wire;
    	  pc_out <= Addr;
	
	
	
	
	R0_write_fetch <=   JTA    when PC_sel_E = '1'   else
        	    	    BTA    when ctrl_branch = '1' else
        	    	    pc_plus2;  -- DEFAULT: PC+2		

	
end behave;
