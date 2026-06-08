library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Operand_read_unit is
    Port (
        -- general inputs
        clk, WE: in STD_LOGIC;                         
        A1, A2, A3: in STD_LOGIC_VECTOR(2 downto 0);
        WD3, R0_write: in STD_LOGIC_VECTOR(15 downto 0);
	reset : in std_logic;
	write_Reg_End : in STD_LOGIC_VECTOR(2 downto 0);
        -- inputs for the sign extender
        imm_6: in STD_LOGIC_VECTOR(5 downto 0);
        imm_9: in STD_LOGIC_VECTOR(8 downto 0);

        -- outputs
        R_data1, R_data2, R0_read: out STD_LOGIC_VECTOR(15 downto 0);  
        ext_imm_6, ext_imm_9: out STD_LOGIC_VECTOR(15 downto 0)        
    );
end Operand_read_unit;
architecture Behavioral_OPR of Operand_read_unit is
    type Reg_file_type is array(0 to 7) of STD_LOGIC_VECTOR(15 downto 0);
    signal R_file: Reg_file_type;
        signal PC_reg : std_logic_vector(15 downto 0) ; -- dedicated PC
begin
    process(clk)
    
    begin
        if rising_edge(clk) then

            if reset = '1' then
                -- initializing all registers to 0 on reset
                R_file(0) <= x"0000";   -- R0 (PC) starts at 0
                R_file(1) <= x"0001";
                R_file(2) <= x"0002";
                R_file(3) <= x"0003";
                R_file(4) <= x"0004";
                R_file(5) <= x"0005";
                R_file(6) <= x"0006";
                R_file(7) <= x"0007";
		 PC_reg    <= x"0000";
            else
                -- normal operation
               -- R_data1 <= R_file(to_integer(unsigned(A1))) when A1 /="000";
                --R_data2 <= R_file(to_integer(unsigned(A2))) when A2 /="000";

 		PC_reg  <= R0_write;
                if WE = '1' and write_Reg_End /= "000" then
                    R_file(to_integer(unsigned(write_Reg_End))) <= WD3;
                   
                end if;

            end if;
        end if;
    end process;
	
	   R_data1 <= R_file(to_integer(unsigned(A1))) when A1 /="000";
                R_data2 <= R_file(to_integer(unsigned(A2))) when A2 /="000";
	    R0_read <= PC_reg;	
    -- immediate sign extenders (outside process, combinational)
    ext_imm_6 <= STD_LOGIC_VECTOR(resize(signed(imm_6), 16));
    ext_imm_9 <= STD_LOGIC_VECTOR(resize(signed(imm_9), 16));

end Behavioral_OPR;
