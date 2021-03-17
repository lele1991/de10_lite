library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench is

end entity testbench;

architecture RTL of testbench is
    
    constant SIZE_2:    integer := 2;
    constant SIZE_4:    integer := 4;
    constant SIZE_16:   integer := 16;
                    
    signal dataa:       unsigned(7 downto 0);
    signal datab:       unsigned(7 downto 0);
    signal start:       std_logic;
    signal reset_a:     std_logic;
    signal clk:         std_logic;
    
    signal done_flag:   std_logic;
    signal product8x8_out:  unsigned(15 downto 0);
    signal seg_a:       std_logic;
    signal seg_b:       std_logic;
    signal seg_c:       std_logic;
    signal seg_d:       std_logic;
    signal seg_e:       std_logic;
    signal seg_f:       std_logic;
    signal seg_g:       std_logic;

begin
    
    dut: entity work.mult8x8
       generic map(
            SIZE_2   => SIZE_2,
            SIZE_4   => SIZE_4,
            SIZE_16  => SIZE_16
        )
        port map(
            dataa           => dataa,
            datab           => datab,
            start           => start,
            reset_a         => reset_a,
            clk             => clk,
            done_flag       => done_flag,
            product8x8_out  => product8x8_out,
            seg_a           => seg_a,
            seg_b           => seg_b,
            seg_c           => seg_c,
            seg_d           => seg_d,
            seg_e           => seg_e,
            seg_f           => seg_f,
            seg_g           => seg_g
        );        

    clock_driver : process
        constant period : time := 8 ns;
        begin
            clk <= '0';
            wait for period / 2;
            clk <= '1';
            wait for period / 2;
    end process clock_driver;
        
    inputs: process
    begin
        
        dataa <= "00000011";
        datab <= "00000111";
        reset_a <= '0';
        start <= '0';
        
        wait for 4 ns;
        start <= '1';
        wait for 1 ns;
        start <= '0';
        wait for 15 ns;

        wait;
    end process;       
                    
end architecture RTL;