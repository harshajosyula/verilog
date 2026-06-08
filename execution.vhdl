library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Execute_unit is
    Port (
        -- Inputs from OPR/EX pipeline register
        Rs1 : in STD_LOGIC_VECTOR(15 downto 0); -- Operand 1
        Rs2 : in STD_LOGIC_VECTOR(15 downto 0); -- Operand 2
        Imm_extended_6 : in STD_LOGIC_VECTOR(15 downto 0); -- Sign Extended immediate(6-bit) value 
        Imm_extended_9 : in STD_LOGIC_VECTOR(15 downto 0); -- Sign Extended immediate(9-bit) value 
        PC : in STD_LOGIC_VECTOR(15 downto 0); 

        -- write_dest_reg: in STD_LOGIC(2 downto 0); (no need as it need to be bypassed)

        -- inputs from condition code register
        cc_prev: in STD_LOGIC_VECTOR(1 downto 0);
        
        -- forwarded inputs 
        Forw_Alu_result: in STD_LOGIC_VECTOR(15 downto 0); 
        Forw_wb_result: in STD_LOGIC_VECTOR(15 downto 0); 

        -- Control signals as inputs
        ALU_Src : in STD_LOGIC;  -- Select immediate or B
        ALU_ctrl : in  STD_LOGIC_VECTOR(4 downto 0);  -- ALU operation select
        Forw_AE: in  STD_LOGIC_VECTOR(1 downto 0);
        Forw_BE: in  STD_LOGIC_VECTOR(1 downto 0);
        Ctrl_JRI: in STD_LOGIC;
        Ctrl_JLR: in STD_LOGIC;
        Ctrl_JAL: in STD_LOGIC;
        Branch_E: in STD_LOGIC;

        -- BUffer the condition code registers (also useful in generating control signals)
        cc_next: buffer STD_LOGIC_VECTOR(1 downto 0);

        -- Outputs on Branch and Jump address targets calculation
        PC_BAT: out STD_LOGIC_VECTOR(15 downto 0);
        PC_JAT: out STD_LOGIC_VECTOR(15 downto 0);

        -- Outputs to EX/MEM pipeline register
        ALU_Result : out STD_LOGIC_VECTOR(15 downto 0);
        constructed_lli: out STD_LOGIC_VECTOR(15 downto 0); 
        store_data: out STD_LOGIC_VECTOR(15 downto 0);
        PC_sel_E: out std_logic
        -- Write_dest_reg: out STD_LOGIC(2 downto 0); -- w_dest to be bypassede
    );
end Execute_unit;

architecture Behavioral of Execute_Unit is
    
    signal alu_op1 : STD_LOGIC_VECTOR(15 downto 0);
    signal alu_op2 : STD_LOGIC_VECTOR(15 downto 0);
    signal read_data_op2 : STD_LOGIC_VECTOR(15 downto 0); 
    signal sign_ext_alu_op1:signed (16 downto 0);
    signal sign_ext_alu_op2: signed (16 downto 0);

    signal shifted_imm_6: STD_LOGIC_VECTOR(15 downto 0);
    signal shifted_imm_9: STD_LOGIC_VECTOR(15 downto 0);
    signal so_jri_jal_sel: STD_LOGIC;
    signal so_jri_jal_mux: STD_LOGIC_VECTOR(15 downto 0);
    signal so_JAT_adder: STD_LOGIC_VECTOR(15 downto 0);
    -- signal s_constructed_lli: STD_LOGIC_VECTOR(15 downto 0);

    -- signal s_pc_BAT: STD_LOGIC_VECTOR(15 downto 0); 
    signal artm_result : STD_LOGIC_VECTOR(16 downto 0); --MSB for carry, on arthmetic operation
    signal result: STD_LOGIC_VECTOR(15 downto 0); -- logical and comparison operations result
	 signal zero_E: STD_LOGIC;
    -- signal s_new_pc: STD_LOGIC_VECTOR(15 downto 0);
    -- signal s_wd_3: STD_LOGIC_VECTOR(15 downto 0);
    
    signal ctrl_JLR_delayed : std_logic := '0';
    
    signal branch_taken : std_logic;

begin

    -- all required muxes implementation
    alu_op1 <= Forw_Alu_result when Forw_AE = "10" else
                Forw_wb_result when Forw_AE = "01" 
                else Rs1; --forwading mux
    read_data_op2 <= Forw_Alu_result when Forw_BE = "10" else
                        Forw_wb_result when Forw_BE = "01" 
                        else Rs2; --forwading mux
    alu_op2 <= read_data_op2 when ALU_Src='1' else Imm_extended_6; 
    sign_ext_alu_op1 <= resize(signed(alu_op1), 17);
    sign_ext_alu_op2 <= resize(signed(alu_op2), 17);

    shifted_imm_6 <= std_logic_vector(shift_left(signed(Imm_extended_6), 1));
    shifted_imm_9 <= std_logic_vector(shift_left(signed(Imm_extended_9), 1));

--    so_jri_jal_sel <= Ctrl_JAL or (not Ctrl_JRI);

	so_jri_jal_sel <= Ctrl_JAL or Ctrl_JRI;

    so_jri_jal_mux <= PC when Ctrl_JAL='1' else read_data_op2; -- when JAL inst. then PC+imm_9*2 o.w. rA+imm_9*2
    
   so_JAT_adder <= std_logic_vector( signed(so_jri_jal_mux) - to_signed(6, so_jri_jal_mux'length) + signed(shifted_imm_9) ) when Ctrl_JAL ='1' else
    		   std_logic_vector(signed(read_data_op2) + signed(shifted_imm_9) -x"0002" );

    

    
    -- ALU Process
    process(alu_op1, alu_op2, sign_ext_alu_op1, sign_ext_alu_op2, ALU_ctrl, cc_prev,PC)
	begin
		 result <= (others => '0');
		 artm_result <= (others => '0');
		 case ALU_ctrl is
			  when "00000" =>  -- ADA
					artm_result <= std_logic_vector(sign_ext_alu_op1 + sign_ext_alu_op2);

			  when "00010" =>  -- ADC
					if cc_prev(1) = '1' then
						 artm_result <= std_logic_vector(sign_ext_alu_op1 + sign_ext_alu_op2);
					else
						 artm_result <= std_logic_vector(sign_ext_alu_op1);
					end if;

			  when "00001" =>  -- ADZ
					if cc_prev(0) = '1' then
						 artm_result <= std_logic_vector(sign_ext_alu_op1 + sign_ext_alu_op2);
					else
						 artm_result <= std_logic_vector(sign_ext_alu_op1);
					end if;

			  when "00011" =>  -- AWC
					if cc_prev(1) = '1' then
						 artm_result <= std_logic_vector(sign_ext_alu_op1 + sign_ext_alu_op2 + to_signed(1, 17));
					else
						 artm_result <= std_logic_vector(sign_ext_alu_op1 + sign_ext_alu_op2);
					end if;

			  when "00100" =>  -- ACA
					artm_result <= std_logic_vector(sign_ext_alu_op1 + resize(signed(not alu_op2), 17) + to_signed(1, 17));

			  when "00110" =>  -- ACC
					if cc_prev(1) = '1' then
						 artm_result <= std_logic_vector(sign_ext_alu_op1 + resize(signed(not alu_op2), 17) + to_signed(1, 17));
					else
						 artm_result <= std_logic_vector(sign_ext_alu_op1);
					end if;

			  when "00101" =>  -- ACZ
					if cc_prev(0) = '1' then
						 artm_result <= std_logic_vector(sign_ext_alu_op1 + resize(signed(not alu_op2), 17) + to_signed(1, 17));
					else
						 artm_result <= std_logic_vector(sign_ext_alu_op1);
					end if;

			  when "00111" =>  -- ACW
					if cc_prev(1) = '1' then
						 artm_result <= std_logic_vector(sign_ext_alu_op1 + resize(signed(not alu_op2), 17) + to_signed(1, 17));
					else
						 artm_result <= std_logic_vector(sign_ext_alu_op1 + resize(signed(not alu_op2), 17));
					end if;

			  when "01000" => -- NDU
					result <= alu_op1 nand alu_op2;

			  when "01010" => -- NDC
					if cc_prev(1) = '1' then
						 result <= alu_op1 nand alu_op2;
					else
						 result <= alu_op1;
					end if;

			  when "01001" => -- NDZ
					if cc_prev(0) = '1' then
						 result <= alu_op1 nand alu_op2;
					else
						 result <= alu_op1;
					end if;

			  when "01100" => -- NCU
					result <= alu_op1 nand (not alu_op2);

			  when "01110" => -- NCC
					if cc_prev(1) = '1' then
						 result <= alu_op1 nand (not alu_op2);
					else
						 result <= alu_op1;
					end if;

			  when "01101" => -- NCZ
					if cc_prev(0) = '1' then
						 result <= alu_op1 nand (not alu_op2);
					else
						 result <= alu_op1;
					end if;

			  when "10000" =>  -- BEQ
					if signed(alu_op1) = signed(alu_op2) then
						 result <= (others => '1');
					else
						 result <= (others => '0');
					end if;

			  when "10001" =>  -- BLT
					if signed(alu_op1) < signed(alu_op2) then
						 result <= (others => '1');
					else
						 result <= (others => '0');
					end if;

			  when "10010" =>  -- BLE
					if signed(alu_op1) <= signed(alu_op2) then
						 result <= (others => '1');
					else
						 result <= (others => '0');
					end if;

			  when "01111" =>  -- LW
					artm_result <= std_logic_vector(resize(signed(alu_op1), 17) + resize(signed(alu_op2), 17));

			  when "11111" => -- SW
					artm_result <= std_logic_vector(resize(signed(alu_op1), 17) + resize(signed(alu_op2), 17));
			 
			  when "10101" => --JAL
					artm_result <= '0' & std_logic_vector(unsigned(PC) - 2);

			  when  "11110" => --JLR
			  		if PC /= x"UUUU" then  -- guard against metavalue
       					 artm_result <= '0' &  std_logic_vector(unsigned(PC));
    					else
       					 artm_result <= (others => '0');
   					 end if;
			  when others =>
					result <= (others => '0');
					artm_result <= (others => '0');
		 end case;
	end process;

    -- Output assignments
   process(result, artm_result, ALU_ctrl, cc_prev)
begin
    if (ALU_ctrl = "01111" or ALU_ctrl = "11111" or ALU_ctrl = "10101" or ALU_ctrl ="11110" ) then
        -- LW / SW: use arithmetic result
        ALU_Result <= artm_result(15 downto 0);
        cc_next <= cc_prev;

    elsif (ALU_ctrl(4 downto 3) = "01" or ALU_ctrl(4 downto 3) = "10") then
        ALU_Result <= result;
        if result = x"0000" then
            cc_next <= cc_prev or "01";
        else
            cc_next <= cc_prev and "10";
        end if;

    elsif (ALU_ctrl(4 downto 3) = "00") then
        ALU_Result <= artm_result(15 downto 0);
        if artm_result(15 downto 0) = x"0000" then
            cc_next <= "01";
        else
            cc_next <= artm_result(artm_result'high) & '0';
        end if;

    else
        ALU_Result <= result;
        cc_next <= cc_prev;
    end if;
end process;

    PC_BAT <= std_logic_vector(unsigned(shifted_imm_6) + unsigned(PC)  - x"0006"); -- Branch target calculation
    PC_JAT <= std_logic_vector(unsigned(alu_op1) - x"0002") when Ctrl_JLR='1' else so_JAT_adder; -- for jal/jri and jlr

    
    constructed_lli <= "0000000"  & Imm_extended_9(8 downto 0) ; -- least significant 9 bits are imm. and others zero
    store_data <= read_data_op2; -- Store value from reg A into memory
	 
    -- control signal generating
	-- zero_E <= '1' when cc_next(0) = '1' else '0';
    --PC_sel_E <= (Branch_E and zero_E) or Ctrl_JLR or Ctrl_JAL or Ctrl_JRI; 
    
    
branch_taken <= '1' when result = x"FFFF" else '0';
PC_sel_E <= (Branch_E and branch_taken) or Ctrl_JLR or Ctrl_JAL or Ctrl_JRI;

end Behavioral;

