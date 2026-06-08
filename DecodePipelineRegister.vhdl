library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pipeline_decode is port (
	clk : in std_logic ;
--	R0_write_in : in std_logic_vector(15 downto 0);

	pc_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	A1: in STD_LOGIC_VECTOR(2 DOWNTO 0);
	A2: in STD_LOGIC_VECTOR(2 DOWNTO 0);
	A3: in STD_LOGIC_VECTOR(2 DOWNTO 0);	
	enable : in std_logic; --active low
	clr  : in std_logic ;
	sign_extension_6bit: in std_logic_vector(5 downto 0);
	sign_extension_9bit : in std_logic_vector (8 downto 0);	
	
	RegDst_in : in STD_LOGIC;
	Reg_WE_in :in STD_LOGIC;
	Alu_src_in:in STD_LOGIC;
	Alu_op_in : in STD_LOGIC_VECTOR(4 DOWNTO 0);
	LLI_in: in STD_LOGIC;
	ctrl_JLR_in: in STD_LOGIC;
	ctrl_JAL_in:in STD_LOGIC;
	ctrl_JRI_in : in STD_LOGIC;
	branch_in :in STD_LOGIC;
	DataMem_in :in STD_LOGIC;
	memToReg_in : in STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	--output
	RF_A1: out STD_LOGIC_VECTOR(2 DOWNTO 0);
	RF_A2: out STD_LOGIC_VECTOR(2 DOWNTO 0);
	RF_A3: out STD_LOGIC_VECTOR(2 DOWNTO 0);	
	pc_out   : out STD_LOGIC_VECTOR(15 DOWNTO 0);
	sign_extension_6bit_out : out std_logic_vector(5 downto 0);
	sign_extension_9bit_out : out std_logic_vector (8 downto 0);
	R0_write_out :OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	RegDst_dec : out STD_LOGIC;
	Reg_WE_dec :out STD_LOGIC;
	Alu_src_dec:out STD_LOGIC;
	Alu_op_dec : out STD_LOGIC_VECTOR(4 DOWNTO 0);
	LLI_dec: out STD_LOGIC;
	ctrl_JLR_dec:out STD_LOGIC;
	ctrl_JAL_dec:out STD_LOGIC;
	ctrl_JRI_dec : out STD_LOGIC;
	branch_dec :out STD_LOGIC;
	DataMem_dec : out STD_LOGIC;
	memToReg_dec : out STD_LOGIC_VECTOR(1 DOWNTO 0)
);
end pipeline_decode;

architecture behave of pipeline_decode is 

begin
	process(clk)
	begin
		if rising_edge(clk) then
			if (clr = '1') then
			--instr_out <=x"0000";  --flush / stall for control hazards
			 pc_out <= x"0000";
			 RF_A1     <= "000";   -- zero out on flush
   			 RF_A2     <= "000";
   			 RF_A3     <= "000";
			--R0_write_out <= x"0000";
			sign_extension_6bit_out <= "000000";
			sign_extension_9bit_out <=  "000000000";
			
			elsif (enable = '0') then
			RF_A1 <= A1;
			RF_A2 <=A2;
			RF_A3 <=A3;
			--instr_out <=instr_in;
			pc_out<=pc_in;
			sign_extension_6bit_out <= sign_extension_6bit;
			sign_extension_9bit_out <=  sign_extension_9bit;
			--R0_write_out <=	R0_write_in;	
			
			RegDst_dec   <= RegDst_in;
                Reg_WE_dec   <= Reg_WE_in;
                Alu_src_dec  <= Alu_src_in;
                Alu_op_dec   <= Alu_op_in;
                LLI_dec      <= LLI_in;
                ctrl_JLR_dec <= ctrl_JLR_in;
                ctrl_JAL_dec <= ctrl_JAL_in;
                ctrl_JRI_dec <= ctrl_JRI_in;
                branch_dec   <= branch_in;
                DataMem_dec  <= DataMem_in;
                memToReg_dec <= memToReg_in;
			
				
			end if; 
		end if; 
	end process;
end behave;
