library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_level_processor is port (
-- Primary output for overall processor
clk : in std_logic;
--enable_inst_mem : in std_logic; --to get the instructions
enable_low_regs : in std_logic; --to start normal run of the processor
clr : in std_logic ;
reset_reg_file: in std_logic; -- on reset, it initialize all the regs to zero in reg file 
reset: in std_logic
);

end top_level_processor;

architecture behave of top_level_processor is 

--signals for fetch stage
signal pc_out_fetch : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal instr_out_fetch : STD_LOGIC_VECTOR(15 DOWNTO 0);

--signals for fetch register
signal pc_out_fetch_register : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal instr_out_fetch_register : STD_LOGIC_VECTOR(15 DOWNTO 0);

--signals for decode stage
signal A1_decode : std_logic_vector (2 downto 0);
signal A2_decode : std_logic_vector (2 downto 0);
signal A3_decode : std_logic_vector (2 downto 0);
signal sign_extension_6bit_decode : std_logic_vector(5 downto 0);
signal sign_extension_9bit_decode : std_logic_vector(8 downto 0);
signal pc_out_decode : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal opcode_control : STD_LOGIC_VECTOR(3 DOWNTO 0);
signal func_field_control : STD_LOGIC_VECTOR (2 DOWNTO 0);
signal R0_write_decode :  STD_LOGIC_VECTOR (15 DOWNTO 0);

--signals for decode register
signal A1_decode_register : std_logic_vector (2 downto 0);
signal A2_decode_register : std_logic_vector (2 downto 0);
signal A3_decode_register : std_logic_vector (2 downto 0);
signal sign_extension_6bit_decode_register : std_logic_vector(5 downto 0);
signal sign_extension_9bit_decode_register : std_logic_vector(8 downto 0);
signal pc_out_decode_register : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal R0_write_OR : STD_LOGIC_VECTOR(15 DOWNTO 0);

signal RegDst_dec_reg : STD_LOGIC;
signal	Reg_WE_dec_reg :STD_LOGIC;
signal	Alu_src_dec_reg:STD_LOGIC;
signal	Alu_op_dec_reg : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal	LLI_dec_reg:STD_LOGIC;
signal	ctrl_JLR_dec_reg:STD_LOGIC;
signal	ctrl_JAL_dec_reg:STD_LOGIC;
signal	ctrl_JRI_dec_reg : STD_LOGIC;
signal	branch_dec_reg :STD_LOGIC;
signal	DataMem_dec_reg : STD_LOGIC;
signal	memToReg_dec_reg : STD_LOGIC_VECTOR(1 DOWNTO 0);


--signals for controller
signal	RegDst_out :  STD_LOGIC;
signal	Reg_WE_out:  STD_LOGIC;
signal	Alu_src_out: std_logic;
signal	Alu_op_out : std_logic_vector(4 downto 0);
signal	LLI_out : std_logic;
signal	ctrl_JLR_out:  STD_LOGIC;
signal	ctrl_JAL_out:  STD_LOGIC;
signal	ctrl_JRI_out:  STD_LOGIC;
signal	branch_out:  STD_LOGIC;
signal	DataMem_WE_out: STD_LOGIC;
signal	memToReg_out:  STD_LOGIC_VECTOR(1 downto 0);

--signals for hazard unit
signal StallF        : std_logic := '0';
signal StallD        : std_logic := '0';
signal FlushF        : std_logic := '0';
signal FlushD        : std_logic := '0';
signal FlushOPR      : std_logic := '0';
signal PC_write_hz   : std_logic := '0';
signal Forward_AE_out: std_logic_vector(1 downto 0) := "00";
signal Forward_BE_out: std_logic_vector(1 downto 0) := "00";
signal branch_ex_out : std_logic := '0';

--signals for operand read
signal  R_data1_opr, R_data2_opr, R0_read_opr:  STD_LOGIC_VECTOR(15 downto 0);  
 signal ext_imm_6_opr, ext_imm_9_opr:  STD_LOGIC_VECTOR(15 downto 0);
 
--signals for opr_exe register
signal R_data1_ex_out, R_data2_ex_out, R0_read_ex_out     : std_logic_vector(15 downto 0);
signal ext_imm_6_ex_out, ext_imm_9_ex_out                 : std_logic_vector(15 downto 0);
signal PC_ex_out                                           : std_logic_vector(15 downto 0);
signal RS1_ex_out                                          : std_logic_vector(2 downto 0);
signal RS2_ex_out                                          : std_logic_vector(2 downto 0);
signal RD_ex_out                                           : std_logic_vector(2 downto 0);
signal PC_plus2_ex_out                                     : std_logic_vector(15 downto 0);
signal Alu_op_ex_out                                       : std_logic_vector(4 downto 0);
signal memToReg_ex_out                                     : std_logic_vector(1 downto 0);  
signal Reg_WE_ex_out, Alu_src_ex_out, LLI_ex_out,
       ctrl_JLR_ex_out, ctrl_JAL_ex_out, ctrl_JRI_ex_out,
       DataMem_WE_ex_out                    : std_logic; 
       
-- signals for execution 

signal cc_next_wire  : std_logic_vector(1 downto 0) := "00";
signal cc_prev_wire  : std_logic_vector(1 downto 0) := "00";
signal PC_BAT_exe   : std_logic_vector(15 downto 0) := x"0000";
signal PC_JAT_exe   : std_logic_vector(15 downto 0) := x"0000";
signal PC_sel_E_exe : std_logic := '0';
signal  ALU_Result_exe :  STD_LOGIC_VECTOR(15 downto 0);
signal  constructed_lli_exe:  STD_LOGIC_VECTOR(15 downto 0); 
signal  store_data_exe:  STD_LOGIC_VECTOR(15 downto 0);

 
--signals for exe_mem_pipeline
signal		RegWriteM_exe_mem : std_logic;
signal		MemtoRegM_exe_mem: std_logic_vector(1 downto 0);
signal		MemWriteM_exe_mem: std_logic;
		
signal		ALUOutM_exe_mem: std_logic_vector(15 downto 0);
signal		WriteDataM_exe_mem:  std_logic_vector(15 downto 0);
signal		WriteRegM_exe_mem: std_logic_vector(2 downto 0);
signal 		PC_plus2M_exe_mem: std_logic_vector(15 downto 0);
              
--signals for datamemeory

signal ReadDataM_out : std_logic_vector(15 downto 0);    

--signals for mem_wb_pipeline
signal      	ReadDataW_out : std_logic_vector(15 downto 0);
signal		ALUOutW_out : std_logic_vector(15 downto 0);
signal		WriteRegW_out : std_logic_vector(2 downto 0);
signal		PC_plus2W_out : std_logic_vector(15 downto 0);
signal		RegWrite_en_W_out : std_logic;
signal 		Result_sel_W_out : std_logic_vector(1 downto 0);  

--signals for writeback
signal Result_to_reg_file_W_Out: std_logic_vector(15 downto 0);

signal constructed_lli_exe_mem_out: std_logic_vector(15 downto 0);
signal constructed_lli_mem_wb_out: std_logic_vector(15 downto 0);

begin 
	
	
	-- Fix 3: registered cc_prev
process(clk)
begin
    if rising_edge(clk) then
        if reset = '1' then
            cc_prev_wire <= "00";
        else
            cc_prev_wire <= cc_next_wire;
        end if;
    end if;
end process;	
	
	--instruction fetch
	FetchStage : entity work.IFstage  
		port map(
			clk=> clk,
			Addr => R0_read_opr,        --Ro will come and act as PC
			--enable => enable_low_regs,  
			BTA =>PC_BAT_exe,
			JTA =>PC_JAT_exe,
			PC_sel_E =>PC_sel_E_exe,
			ctrl_branch =>branch_ex_out,
			flush_in => FlushF,
			--outputs
			instr_out => instr_out_fetch,
			pc_out => pc_out_fetch,
			R0_write_fetch => R0_write_decode
	);
	
	--instruction fetch register
	fetch_reg: entity work.pipeline_fetch
		port map(
			clk  => clk,
			clr => clr ,
			flush_in => FlushF,
			enable => enable_low_regs or StallF,
			instr_in => instr_out_fetch,
			--outputs
			pc_in => pc_out_fetch,
			pc_out => pc_out_fetch_register,
			instr_out => instr_out_fetch_register
		);
		
	-- instruction decode stage
	  Decode_stage: entity work.Instr_decode_stage
	  	port map(
		instr_in => instr_out_fetch_register,
		pc_in => pc_out_fetch_register,
		ctrl_Reg_dst=> RegDst_out,
		PC_sel_E =>PC_sel_E_exe,
		ctrl_branch =>branch_ex_out,
		BTA =>PC_BAT_exe,
		JTA =>PC_JAT_exe,

		--outputs
     		RF_A1 =>A1_decode,
    		RF_A2 =>A2_decode,
     		RF_A3 =>A3_decode,
     		sign_extension_6bit =>sign_extension_6bit_decode,
     		sign_extension_9bit =>sign_extension_9bit_decode,
     		pc_out =>pc_out_decode,
     		opcode => opcode_control,
     		func_field => func_field_control
     		
	  	);
	  	
	  -- instruction decode pipeline register
	  piplineRegister: entity work.pipeline_decode 
	  	port map(
		clk => clk,
		--R0_write_in =>R0_write_decode,
		pc_in=>pc_out_decode,
		A1=> A1_decode,
		A2=> A2_decode,
		A3=> A3_decode,
		clr => clr ,
		enable => enable_low_regs or StallD,
		sign_extension_6bit =>sign_extension_6bit_decode,
		sign_extension_9bit =>sign_extension_9bit_decode,
		
		--control inputs
		RegDst_in =>RegDst_out,
		Reg_WE_in => Reg_WE_out,
		Alu_src_in=> Alu_src_out,
		Alu_op_in => Alu_op_out,
		LLI_in => LLI_out,
		ctrl_JLR_in => ctrl_JLR_out,
		ctrl_JAL_in=> ctrl_JAL_out,
		ctrl_JRI_in=> ctrl_JRI_out,
		branch_in => branch_out,
		DataMem_in => DataMem_WE_out,
		memToReg_in=> memToReg_out,
		
		--outputs
		RF_A1    => A1_decode_register,
   	   	 RF_A2    => A2_decode_register,
   		RF_A3    => A3_decode_register,
		sign_extension_6bit_out =>sign_extension_6bit_decode_register,
		sign_extension_9bit_out => sign_extension_9bit_decode_register,
   		pc_out   => pc_out_decode_register,
   		--R0_write_out => R0_write_OR
   		
   		RegDst_dec =>RegDst_dec_reg,
   		Reg_WE_dec =>Reg_WE_dec_reg,
		Alu_src_dec=>Alu_src_dec_reg,
		Alu_op_dec => Alu_op_dec_reg,
		LLI_dec=>LLI_dec_reg,
		ctrl_JLR_dec=> ctrl_JLR_dec_reg,
		ctrl_JAL_dec=> ctrl_JAL_dec_reg,
		ctrl_JRI_dec => ctrl_JRI_dec_reg,
		branch_dec => branch_dec_reg,
		DataMem_dec => DataMem_dec_reg,
		memToReg_dec =>memToReg_dec_reg
	
	);
	
	--Controller
	controller : entity work.controller 
		port map(
		
		opcode => opcode_control,
		func_field => func_field_control,
		
		--outputs
		RegDst =>RegDst_out,
		Reg_WE => Reg_WE_out,
		Alu_src=> Alu_src_out,
		Alu_op => Alu_op_out,
		LLI => LLI_out,
		ctrl_JLR => ctrl_JLR_out,
		ctrl_JAL=> ctrl_JAL_out,
		ctrl_JRI=> ctrl_JRI_out,
		branch => branch_out,
		DataMem_WE => DataMem_WE_out,
		memToReg=> memToReg_out
		);

	-- Hazard Unit
	hazard_unit: entity work.Hazard_unit
		port map(
			rs1_OPR => A1_decode_register,
			rs2_OPR => A2_decode_register,
			rs1_E => RS1_ex_out,
			rs2_E => RS2_ex_out,
			rd_E => RD_ex_out,
			rd_M => WriteRegM_exe_mem,
			rd_W => WriteRegW_out,
			result_src_E => memToReg_ex_out,
			RegWrite_M => RegWriteM_exe_mem,
			RegWrite_W => RegWrite_en_W_out,
			PC_src_E => PC_sel_E_exe,
			opcode =>opcode_control,
			
			PC_write_dis => PC_write_hz,
			Stall_IF_ID => StallF,
			Stall_ID_OPR => StallD,
			Flush_IF_ID => FlushF,
			Flush_ID_OPR=> FlushD,
			Flush_OPR_EX => FlushOPR,
			Forward_AE => Forward_AE_out,
			Forward_BE => Forward_BE_out
		);

	-- operand read
	opr_read : entity work.Operand_read_unit
		port map(
		clk => clk,
		WE =>   RegWrite_en_W_out or PC_write_hz,                      
        	A1 =>  A1_decode_register,
        	A2 =>  A2_decode_register,
        	A3 =>  A3_decode_register,
        	WD3 => Result_to_reg_file_W_Out,
         	--R0_write => R0_write_OR,
            	R0_write => R0_write_decode,
            imm_6 => sign_extension_6bit_decode_register,
        	imm_9 => sign_extension_9bit_decode_register,
			reset => reset_reg_file,
			write_Reg_End => WriteRegW_out,
        	--outputs
            R_data1 => R_data1_opr,
        	R_data2 => R_data2_opr,
        	R0_read => R0_read_opr, 
        	ext_imm_6 => ext_imm_6_opr,
         	ext_imm_9 => ext_imm_9_opr

		);
	
	--operand and execute pipeline register	
	opr_exe_pipleine: entity work.OPR_EX_Pipeline_reg 
		port map (
			clk => clk,
        	reset => clr ,
        	en=> enable_low_regs, -- low enable

        -- from Operand stage
       	 	R_data1_opr=>R_data1_opr,
       	 	R_data2_opr =>R_data2_opr, 
       	  	R0_read_opr=> R0_read_opr,  
        	ext_imm_6_opr=>ext_imm_6_opr,
        	ext_imm_9_opr=>ext_imm_9_opr,
        
        -- Bypassed inputs
       		PC_opr => R0_read_opr, -- present pc is always R0_READ
        	RS1_opr =>A1_decode_register,  -- Source reg 1 address
        	RS2_opr => A2_decode_register,  -- Source reg 2 address
        	RD_opr => A3_decode_register, -- Destination reg address
        	PC_plus2_opr =>pc_out_decode_register,
        -- control inputs
        	Reg_WE_opr => Reg_WE_dec_reg,
      		Alu_src_opr=> Alu_src_dec_reg,
        	Alu_op_opr => Alu_op_dec_reg,
        	LLI_opr => LLI_dec_reg,
        	ctrl_JLR_opr=> ctrl_JLR_dec_reg,
        	ctrl_JAL_opr=>ctrl_JAL_dec_reg ,
        	ctrl_JRI_opr=> ctrl_JRI_dec_reg,
        	branch_opr=>branch_dec_reg ,
        	DataMem_WE_opr=>DataMem_dec_reg,
        	memToReg_opr=>memToReg_dec_reg ,
        --outputs
        	R_data1_ex => R_data1_ex_out,
        	R_data2_ex =>R_data2_ex_out , 
        	R0_read_ex => R0_read_ex_out,  
        	ext_imm_6_ex => ext_imm_6_ex_out,
        	ext_imm_9_ex =>ext_imm_9_ex_out,
        
        	PC_ex =>PC_ex_out ,
        	RS1_ex => RS1_ex_out,  -- Source reg 1 address
        	RS2_ex => RS2_ex_out,  -- Source reg 2 address
        	RD_ex =>RD_ex_out ,  -- Destination reg address
        	PC_plus2_ex => PC_plus2_ex_out, 

        	Reg_WE_ex =>Reg_WE_ex_out ,
        	Alu_src_ex=> Alu_src_ex_out,
       		Alu_op_ex => Alu_op_ex_out,
       		LLI_ex =>LLI_ex_out ,
        	ctrl_JLR_ex=>ctrl_JLR_ex_out,
        	ctrl_JAL_ex=>ctrl_JAL_ex_out,
        	ctrl_JRI_ex=>ctrl_JRI_ex_out,
        	branch_ex=>branch_ex_out,
        	DataMem_WE_ex=>DataMem_WE_ex_out,
       		memToReg_ex=>memToReg_ex_out
		
		);
		
		
	-- execution stage
	exe : entity work.Execute_unit
		port map (
		--clk => clk,
		Rs1  => R_data1_ex_out, 
        	Rs2  => R_data2_ex_out,
        	Imm_extended_6  => ext_imm_6_ex_out, 
       		Imm_extended_9  => ext_imm_9_ex_out, 
        	PC  => PC_ex_out, 
        -- inputs from condition code register
       		cc_prev => cc_prev_wire,
        
        -- forwarded inputs 
       		Forw_Alu_result => ALUOutM_exe_mem,
        	Forw_wb_result => Result_to_reg_file_W_Out, 

        -- Control signals as inputs
        	ALU_Src => Alu_src_ex_out,
        	ALU_ctrl  =>Alu_op_ex_out,
        	Forw_AE => Forward_AE_out,
        	Forw_BE  => Forward_BE_out,
        	Ctrl_JRI =>ctrl_JRI_ex_out,
        	Ctrl_JLR =>ctrl_JLR_ex_out,
        	Ctrl_JAL =>ctrl_JAL_ex_out,
        	Branch_E =>branch_ex_out,
        	cc_next  =>cc_next_wire,
		-- outputs
			PC_BAT =>PC_BAT_exe,
			PC_JAT =>PC_JAT_exe,
          	ALU_Result=>ALU_Result_exe,
          	constructed_lli=> constructed_lli_exe,
			store_data=>store_data_exe,
			PC_sel_E=>PC_sel_E_exe
	
		);
		
	-- exe_mem pipeline reg
	exe_mem: entity work.ex_mem_pipe 
		port map(
		
		clk => clk,
		reset=> reset, 
		--inputs to pipeline register
		RegWriteE => Reg_WE_ex_out,
		MemtoRegE => memToReg_ex_out,
		MemWriteE =>DataMem_WE_ex_out,
		
		ALUOutE => ALU_Result_exe,
		WriteDataE => store_data_exe,

		-- bypassed inputs 
		WriteRegE => RD_ex_out,
		PC_plus2E => PC_plus2_ex_out,
		constructed_lli_in => constructed_lli_exe,
		
		--outputs
		RegWriteM  =>RegWriteM_exe_mem ,
		MemtoRegM =>MemtoRegM_exe_mem,
		MemWriteM =>MemWriteM_exe_mem,
		ALUOutM => ALUOutM_exe_mem,
		WriteDataM  => WriteDataM_exe_mem,
		WriteRegM =>WriteRegM_exe_mem,
 		PC_plus2M =>PC_plus2M_exe_mem,
 		constructed_lli_out => constructed_lli_exe_mem_out	
		);
		
	--datamemory
	
	datamem: entity work.data_memory
		port map(
		
		clk => clk,
		ALUOutM =>ALUOutM_exe_mem,
		WriteDataM =>	WriteDataM_exe_mem,
		MemWriteM =>MemWriteM_exe_mem,
		--outputs
		ReadDataM => ReadDataM_out
		);
		
	--mem_wb_pipeline
	mem_wb_pipeline_reg : entity work.mem_wb_pipeline_reg
		port map(
		clk => clk,
		-- inputs from mem stage
		ReadDataM=> ReadDataM_out,
		-- bypassed inputs from ex_mem_pipeline reg
		WriteRegM => WriteRegM_exe_mem,
		ALUOutM => ALUOutM_exe_mem,
		PC_plus2M=>PC_plus2M_exe_mem,
		
		--contorl signals as bypassed inputs
		RegWrite_en_M => RegWriteM_exe_mem ,
		Result_sel_M => MemtoRegM_exe_mem,
		constructed_lli_in_wb =>constructed_lli_exe_mem_out,
		-- outputs
		ReadDataW => ReadDataW_out,
		ALUOutW => ALUOutW_out,
		WriteRegW => WriteRegW_out,
		PC_plus2W => PC_plus2W_out,
		RegWrite_en_W => RegWrite_en_W_out,
		Result_sel_W => Result_sel_W_out,
		constructed_lli_out_wb => constructed_lli_mem_wb_out
		);
		
	-- writeback stage
	writeback : entity work.write_back
		port map(
		Result_sel_W_in =>Result_sel_W_out,

		--inputs to mux
		ReadDataW => ReadDataM_out,
		ALUOutW => ALUOutW_out,
		PC_plus2W_in => PC_plus2W_out,
		constructed_lli_final =>constructed_lli_mem_wb_out,
		-- output
		Result_to_reg_file_W => Result_to_reg_file_W_Out
		);
end behave;
