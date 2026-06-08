library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OPR_EX_Pipeline_reg is
    Port (
        -- general inputs
        clk : in  std_logic;
        reset : in  std_logic; 
        en: in std_logic; -- low enable

        -- from Operand stage
        R_data1_opr, R_data2_opr, R0_read_opr: in STD_LOGIC_VECTOR(15 downto 0);  
        ext_imm_6_opr, ext_imm_9_opr: in STD_LOGIC_VECTOR(15 downto 0);
        
        -- Bypassed inputs
        PC_opr : in  std_logic_vector(15 downto 0);
        RS1_opr : in  std_logic_vector(2 downto 0);  -- Source reg 1 address
        RS2_opr : in  std_logic_vector(2 downto 0);  -- Source reg 2 address
        RD_opr : in  std_logic_vector(2 downto 0);  -- Destination reg address
        PC_plus2_opr : in std_logic_vector(15 downto 0); 

        -- Control signals from control unit
        Reg_WE_opr : in STD_LOGIC;
        Alu_src_opr: in std_logic;
        Alu_op_opr : in std_logic_vector(4 downto 0);
        LLI_opr : in std_logic;
        ctrl_JLR_opr: in STD_LOGIC;
        ctrl_JAL_opr: in STD_LOGIC;
        ctrl_JRI_opr: in STD_LOGIC;
        branch_opr: in STD_LOGIC;
        DataMem_WE_opr: in STD_LOGIC;
        memToReg_opr: in STD_LOGIC_VECTOR(1 downto 0);

        -- Outputs
        R_data1_ex, R_data2_ex, R0_read_ex: out STD_LOGIC_VECTOR(15 downto 0);  
        ext_imm_6_ex, ext_imm_9_ex : out STD_LOGIC_VECTOR(15 downto 0);
        
        PC_ex : out std_logic_vector(15 downto 0);
        RS1_ex : out std_logic_vector(2 downto 0);  -- Source reg 1 address
        RS2_ex : out std_logic_vector(2 downto 0);  -- Source reg 2 address
        RD_ex : out std_logic_vector(2 downto 0);  -- Destination reg address
        PC_plus2_ex : out std_logic_vector(15 downto 0); 

        Reg_WE_ex : out STD_LOGIC;
        Alu_src_ex: out std_logic;
        Alu_op_ex : out std_logic_vector(4 downto 0);
        LLI_ex : out std_logic;
        ctrl_JLR_ex: out STD_LOGIC;
        ctrl_JAL_ex: out STD_LOGIC;
        ctrl_JRI_ex: out STD_LOGIC;
        branch_ex: out STD_LOGIC;
        DataMem_WE_ex: out STD_LOGIC;
        memToReg_ex: out STD_LOGIC_VECTOR(1 downto 0)
    );
end OPR_EX_Pipeline_reg;

architecture Behavioral of OPR_EX_Pipeline_reg is
begin
 
    process(clk, reset)
    begin
        if reset = '1' then -- synchronous reset
            -- Data signals
            R_data1_ex   <= (others => '0');
            R_data2_ex   <= (others => '0');
            R0_read_ex   <= (others => '0');
            ext_imm_6_ex  <= (others => '0');
            ext_imm_9_ex  <= (others => '0');
 
            -- Bypassed signals
            PC_ex        <= (others => '0');
            RS1_ex       <= (others => '0');
            RS2_ex       <= (others => '0');
            RD_ex        <= (others => '0');
            PC_plus2_ex  <= (others => '0');
 
            -- Control signals
            Reg_WE_ex     <= '0';
            Alu_src_ex    <= '0';
            Alu_op_ex     <= (others => '0');
            LLI_ex        <= '0';
            ctrl_JLR_ex   <= '0';
            ctrl_JAL_ex   <= '0';
            ctrl_JRI_ex   <= '0';
            branch_ex     <= '0';
            DataMem_WE_ex <= '0';
            memToReg_ex   <= (others => '0');
 
        elsif rising_edge(clk) then
            if en = '0' then  -- low enable: latch when en is low
                -- Data signals
                R_data1_ex   <= R_data1_opr;
                R_data2_ex   <= R_data2_opr;
                R0_read_ex   <= R0_read_opr;
                ext_imm_6_ex  <= ext_imm_6_opr;
                ext_imm_9_ex  <= ext_imm_9_opr;
 
                -- Bypassed signals
                PC_ex        <= PC_opr;
                RS1_ex       <= RS1_opr;
                RS2_ex       <= RS2_opr;
                RD_ex        <= RD_opr;
                PC_plus2_ex  <= PC_plus2_opr;
 
                -- Control signals
                Reg_WE_ex     <= Reg_WE_opr;
                Alu_src_ex    <= Alu_src_opr;
                Alu_op_ex     <= Alu_op_opr;
                LLI_ex        <= LLI_opr;
                ctrl_JLR_ex   <= ctrl_JLR_opr;
                ctrl_JAL_ex   <= ctrl_JAL_opr;
                ctrl_JRI_ex   <= ctrl_JRI_opr;
                branch_ex     <= branch_opr;
                DataMem_WE_ex <= DataMem_WE_opr;
                memToReg_ex   <= memToReg_opr;
            end if;
            -- When en = '1': outputs hold their current values (pipeline stall)
        end if;
    end process;
 
end Behavioral;
