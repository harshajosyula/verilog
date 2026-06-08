library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Instr_decode_stage is port (


	instr_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	pc_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	ctrl_Reg_dst: in STD_LOGIC;
	--enable: in std_logic;
	PC_sel_E : in std_logic;
	ctrl_branch: in std_logic;
	BTA: in std_logic_vector(15 downto 0);
	JTA: in std_logic_vector(15 downto 0);
	
	
		--outputs
     RF_A1 : out std_logic_vector(2 downto 0);
     RF_A2 : out std_logic_vector(2 downto 0);
     RF_A3 : out std_logic_vector(2 downto 0);
     sign_extension_6bit: out STD_LOGIC_VECTOR(5 DOWNTO 0);	
     sign_extension_9bit: out STD_LOGIC_VECTOR(8 downto 0);
     pc_out   : out STD_LOGIC_VECTOR(15 DOWNTO 0);
     opcode : out STD_LOGIC_VECTOR(3 DOWNTO 0);
     func_field: out STD_LOGIC_VECTOR(2 DOWNTO 0)
    
 );
end Instr_decode_stage;
architecture behave of Instr_decode_stage is 

begin
	-- instr_out <= instr_in;
	pc_out <= pc_in;
	RF_A1 <= instr_in(8 downto 6);
	RF_A3<= instr_in(11 downto 9);
	RF_A2<= instr_in(5 downto 3) when ctrl_Reg_dst = '1' else
		instr_in(11 downto 9);
		
	sign_extension_6bit <= instr_in(5 downto 0);
	sign_extension_9bit <= instr_in (8 downto 0);
	opcode <= instr_in(15 downto 12);
	func_field <= instr_in(2 downto 0);
			
	
	
end behave;
