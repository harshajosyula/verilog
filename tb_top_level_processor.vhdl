library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top_level_processor is
end tb_top_level_processor;

architecture sim of tb_top_level_processor is

    signal clk            : std_logic := '0';
    signal enable_low_regs: std_logic := '1';
    signal clr            : std_logic := '0';
    signal reset          : std_logic := '1';
    signal reset_reg_file : std_logic := '1';

    constant CLK_PERIOD : time := 20 ns;

begin

    -- Instantiate processor
    DUT: entity work.top_level_processor
        port map (
            clk             => clk,
            enable_low_regs => enable_low_regs,
            clr             => clr,
            reset           => reset,
            reset_reg_file  => reset_reg_file
        );

    -- Clock: toggles every 5ns forever
    clk <= not clk after CLK_PERIOD / 2;

    -- Stimulus
    process
    begin
       
       wait for CLK_PERIOD;
        -- Step 2: Release reset
        reset          <= '0';
        reset_reg_file <= '0';
        enable_low_regs <= '0';
        wait for CLK_PERIOD;

        -- Step 3: Start the processor (active low enable)
        

        -- Step 4: Let it run for 30 cycles and observe
        wait for CLK_PERIOD * 70;

        wait; -- end simulation
    end process;

end sim;
