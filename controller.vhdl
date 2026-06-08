library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controller is port(
	opcode : in STD_LOGIC_VECTOR(3 downto 0);
	func_field: in STD_LOGIC_VECTOR (2 downto 0);
	--outputs
	
	RegDst : out STD_LOGIC;
	Reg_WE : out STD_LOGIC;
	Alu_src: out std_logic;
	Alu_op : out std_logic_vector(4 downto 0);
	LLI : out std_logic;
	ctrl_JLR: out STD_LOGIC;
	ctrl_JAL: out STD_LOGIC;
	ctrl_JRI: out STD_LOGIC;
	branch: out STD_LOGIC;
	DataMem_WE:out STD_LOGIC;
	memToReg: out STD_LOGIC_VECTOR(1 downto 0)
);
end controller;

architecture behave of controller is 

begin
 process(opcode, func_field)
 
 begin
	RegDst <='0';
	Reg_WE <='0';
	Alu_src <= '0';
	Alu_op<="10011"; --no operation
	LLI<='0';
	ctrl_JLR<='0';
	ctrl_JAL<='0';
	ctrl_JRI<='0';
	branch<='0';
	DataMem_WE<='0';
	memToReg<="00";
	
	
	case opcode is

    when "0000" =>  -- ADI
        RegDst      <= '0';
        Reg_WE      <= '1';
        Alu_src     <= '0';
        Alu_op      <= "00000";
        LLI         <= '0';
        ctrl_JLR    <= '0';
        ctrl_JAL    <= '0';
        ctrl_JRI    <= '0';
        branch      <= '0';
        DataMem_WE  <= '0';
        memToReg    <= "00";

    when "0001" =>  -- all kinds of add
        if func_field = "000" then --ada
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "00000";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";

        elsif func_field = "001" then --adz
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "00001";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";

        elsif func_field = "010" then --adc
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "00010";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";

        elsif func_field = "011" then --awc
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "00011";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";

        elsif func_field = "100" then --aca
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "00100";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";

        elsif func_field = "101" then --acc
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "00101";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";

        elsif func_field = "110" then --acz
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "00110";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";

        elsif func_field = "111" then --acw
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "00111";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";

        end if;   
        
        when "0010" => -- all kinds of nands
        
        if func_field = "000" then --ndu
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "01000";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";
            
        elsif func_field = "001" then --ndz
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "01001";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";
            
         elsif func_field = "010" then --ndc
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "01010";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";
            
          elsif func_field = "100" then --ncu
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "01100";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';
            memToReg    <= "00";
           
           elsif func_field = "110" then --ncc
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "01110";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0'; 
            memToReg    <= "00";
            
           elsif func_field = "101" then --ncz
            RegDst      <= '1';
            Reg_WE      <= '1';
            Alu_src     <= '1';
            Alu_op      <= "01101";
            LLI         <= '0';
            ctrl_JLR    <= '0';
            ctrl_JAL    <= '0';
            ctrl_JRI    <= '0';
            branch      <= '0';
            DataMem_WE  <= '0';	
            memToReg    <= "00";
         end if;   
         
         
     when "0100" =>  -- LW
        RegDst      <= '0';
        Reg_WE      <= '1';
        Alu_src     <= '0';
        Alu_op      <= "01111";
        LLI         <= '0';
        ctrl_JLR    <= '0';
        ctrl_JAL    <= '0';
        ctrl_JRI    <= '0';
        branch      <= '0';
        DataMem_WE  <= '0';
        memToReg    <= "01";  
        
      when "0101" =>  -- SW
        RegDst      <= '0';
        Reg_WE      <= '0';
        Alu_src     <= '0';
        Alu_op      <= "11111";
        LLI         <= '0';
        ctrl_JLR    <= '0';
        ctrl_JAL    <= '0';
        ctrl_JRI    <= '0';
        branch      <= '0';
        DataMem_WE  <= '1';
        memToReg    <= "00"; --dontcare
        
       when "1000" =>  -- BEQ
        RegDst      <= '1';
        Reg_WE      <= '0';
        Alu_src     <= '1';
        Alu_op      <= "10000";
        LLI         <= '0';
        ctrl_JLR    <= '0';
        ctrl_JAL    <= '0';
        ctrl_JRI    <= '0';
        branch      <= '1';
        DataMem_WE  <= '0';
        memToReg    <= "00"; --dontcare
        
        when "1001" =>  -- BLT
        RegDst      <= '1';
        Reg_WE      <= '0';
        Alu_src     <= '1';
        Alu_op      <= "10001";
        LLI         <= '0';
        ctrl_JLR    <= '0';
        ctrl_JAL    <= '0';
        ctrl_JRI    <= '0';
        branch      <= '1';
        DataMem_WE  <= '0';
        memToReg    <= "00"; --dontcare
        
        
        when "1010" =>  -- BLE
        RegDst      <= '1';
        Reg_WE      <= '0';
        Alu_src     <= '1';
        Alu_op      <= "10010";
        LLI         <= '0';
        ctrl_JLR    <= '0';
        ctrl_JAL    <= '0';
        ctrl_JRI    <= '0';
        branch      <= '1';
        DataMem_WE  <= '0';
        memToReg    <= "00";
        
        when "0011" =>  -- LLI
        RegDst      <= '0';
        Reg_WE      <= '1';
        Alu_src     <= '1'; --dontcare
        Alu_op      <= "10011";
        LLI         <= '1';
        ctrl_JLR    <= '0';
        ctrl_JAL    <= '0';
        ctrl_JRI    <= '0';
        branch      <= '0';
        DataMem_WE  <= '0';
        memToReg    <= "11";   
        
        when "1100" =>  -- JAL
        RegDst      <= '0';
        Reg_WE      <= '1';
        Alu_src     <= '1'; --dontcare
        Alu_op      <= "10101";
        LLI         <= '0';
        ctrl_JLR    <= '0';
        ctrl_JAL    <= '1';
        ctrl_JRI    <= '0';
        branch      <= '0';
        DataMem_WE  <= '0';
        memToReg    <= "00"; --dontcare
        
        when "1101" =>  -- JLR
        RegDst      <= '0';
        Reg_WE      <= '1';
        Alu_src     <= '1'; --dontcare
        Alu_op      <= "11110";
        LLI         <= '0';
        ctrl_JLR    <= '1';
        ctrl_JAL    <= '0';
        ctrl_JRI    <= '0';
        branch      <= '0';
        DataMem_WE  <= '0';
        memToReg    <= "00"; --dontcare   
        
        when "1111" =>  -- JRI
        RegDst      <= '0';
        Reg_WE      <= '0';
        Alu_src     <= '1'; --dontcare
        Alu_op      <= "10011";
        LLI         <= '0';
        ctrl_JLR    <= '0';
        ctrl_JAL    <= '0';
        ctrl_JRI    <= '1';
        branch      <= '0';
        DataMem_WE  <= '0';
        memToReg    <= "10"; --dontcare        

    when others =>
        null;

end case;
		
		
end process;	
		
end behave;
