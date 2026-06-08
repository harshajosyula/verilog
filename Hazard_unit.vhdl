library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Hazard_unit is
    Port (
        -- inputs from various stages
        rs1_OPR, rs2_OPR, rs1_E, rs2_E, rd_E, rd_M, rd_W: in STD_LOGIC_VECTOR(2 downto 0);
        result_src_E: in STD_LOGIC_VECTOR(1 downto 0);  -- to select for write back in reg of reg file
        RegWrite_M, RegWrite_W: in STD_LOGIC; -- to enable the write in reg file 
        PC_src_E: in STD_LOGIC;
	opcode : in std_logic_vector(3 downto 0);
        -- Outputs to various pipeline registers and stages
        PC_write_dis, Stall_IF_ID, Stall_ID_OPR: out STD_LOGIC;
        Flush_IF_ID, Flush_ID_OPR ,Flush_OPR_EX: out STD_LOGIC;
        Forward_AE, Forward_BE: out STD_LOGIC_VECTOR(1 downto 0)
        
    );
end Hazard_unit;

architecture Behavioral_HZ of Hazard_unit is
    -- required signals 
    signal s0_ld_hz: STD_LOGIC;
    
begin
    -- RAW data hazard detection and action
    process(all)
    begin
        -- Forward A
        if (rs1_E = rd_M) and (RegWrite_M = '1') and (rs1_E /= "000") then
            Forward_AE <= "10"; -- forwarding from Meme_stage
        elsif (rs1_E = rd_W) and (RegWrite_W = '1') and (rs1_E /= "000") then 
            Forward_AE <= "01"; -- forwarding from WB_stage
        else Forward_AE <= "00";
        end if;

        -- Forward B
        if (rs2_E = rd_M) and (RegWrite_M = '1') and (rs2_E /= "000") then
            Forward_BE <= "10";
        elsif (rs2_E = rd_W) and (RegWrite_W = '1') and (rs2_E /= "000") then
            Forward_BE <= "01";
        else
            Forward_BE <= "00";
        end if;
    end process;

    -- load-use hazard
    s0_ld_hz <= '1' when (result_src_E = "01") and 
                    ((rs1_OPR = rd_E) or (rs2_OPR = rd_E))
                    else '0';

    -- generating control signals                
    PC_write_dis <= s0_ld_hz;
    Stall_IF_ID <= s0_ld_hz;    
    Stall_ID_OPR <= s0_ld_hz;
    Flush_OPR_EX <= s0_ld_hz;
    
   -- Combine Jump Detection and Branch Detection
Flush_IF_ID  <= '1' when opcode(3 downto 2) = "11"  else
	        '1' when opcode(3 downto 2) = "10" 
	      else '0';
    
    
    -------------important
--Flush_IF_ID  <= PC_src_E;   -- flush fetch register on branch taken
--Flush_ID_OPR <= PC_src_E;   -- flush decode register on branch taken
    
end Behavioral_HZ;
       
