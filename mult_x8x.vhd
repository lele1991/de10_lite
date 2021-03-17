library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult8x8 is
    generic(
        SIZE_2:     integer := 2;
        SIZE_4:     integer := 4;
        SIZE_8:     integer := 8;
        SIZE_16:    integer := 16
    );
    port(
        dataa:      in unsigned(7 downto 0);
        datab:      in unsigned(7 downto 0);
        start:      in std_logic;
        reset_a:    in std_logic;
        clk:        in std_logic;
        
        done_flag:      out std_logic;
        product8x8_out: out unsigned(15 downto 0);
        seg_a:          out std_logic;
        seg_b:          out std_logic;
        seg_c:          out std_logic;
        seg_d:          out std_logic;
        seg_e:          out std_logic;
        seg_f:          out std_logic;
        seg_g:          out std_logic
                
    );
end entity mult8x8;

architecture RTL of mult8x8 is
    signal sum:         unsigned(15 downto 0);
    signal product:     unsigned(7 downto 0);
    signal aout:        unsigned(3 downto 0);
    signal bout:        unsigned(3 downto 0);
    signal sel:         unsigned(1 downto 0);
    signal shift:       std_logic_vector(1 downto 0);
    signal shift_out:   unsigned(15 downto 0);
    signal product8x8:  unsigned(15 downto 0);
    signal start_n:     std_logic;
    signal count:       std_logic_vector(1 downto 0);
    signal state_out:   std_logic_vector(2 downto 0);    
    signal clk_ena:     std_logic;    
    signal sclr_n:      std_logic;
   
begin
    mux_when_a: entity work.mux_when
        generic map(
            SIZE => SIZE_4
        )         
        port map(
            mux_in_a => dataa(SIZE_4-1 downto 0),
            mux_in_b => dataa((SIZE_4*2)-1 downto SIZE_4),
            mux_out  => aout(SIZE_4-1 downto 0),
            mux_sel  => sel(1)
        ); 

    mux_when_b: entity work.mux_when
        generic map(
            SIZE => SIZE_4
        ) 
        port map(
            mux_in_a => datab(SIZE_4-1 downto 0),
            mux_in_b => datab((SIZE_4*2)-1 downto SIZE_4),
            mux_out  => bout(SIZE_4-1 downto 0),
            mux_sel  => sel(0)
        );
        
    mult:entity work.mult
        generic map(
            SIZE => SIZE_4
        )        
        port map(
            dataa => aout(SIZE_4-1 downto 0),
            datab => bout(SIZE_4-1 downto 0),
            prod  => product ((SIZE_4*2)-1 downto 0)
        );  

    shifter:entity work.shifter 
        generic map(
            SIZE_2 => SIZE_2,
            SIZE_8 => SIZE_8,
            SIZE_16 => SIZE_16
        )           
        port map(
            input       => product(SIZE_8-1 downto 0),
            shift_cntrl => shift(SIZE_2-1 downto 0),
            shift_out   => shift_out(SIZE_16-1 downto 0)
        );

    registrador:entity work.reg
        generic map(
            SIZE_16 => SIZE_16
        )         
        port map(
            clk     => clk,
            sclr_n  => sclr_n,
            clk_ena => clk_ena,
            datain  => sum(SIZE_16-1 downto 0),
            prod_reg_out => product8x8(SIZE_16-1 downto 0)
        );
    
    adder: entity work.addernbits
        generic map(
            SIZE => SIZE_16
        )
        port map(
            dataa => shift_out(SIZE_16-1 downto 0),
            datab => product8x8(SIZE_16-1 downto 0),
            sum   => sum(SIZE_16-1 downto 0)
        );    

              
       
    fsm:entity work.mult_control
        port map(
            clk       => clk,
            reset_a   => reset_a,
            start     => start,
            count     => count(1 downto 0),
            input_sel => sel(1 downto 0),
            shift_sel => shift(1 downto 0),
            state_out => state_out(2 downto 0),
            done      => done_flag,
            clk_ena   => clk_ena,
            sclr_n    => sclr_n
        );
        
    start_n <= not start;    
    counter:entity work.counter
        port map(
            clk       => clk,
            aclr_n    => start_n,
            counter_out => count
        );              
 
    sevensegments:entity work.seven_segment_cntrl
        port map(
            input (3) => '0',
            input(2 downto 0) => state_out(2 downto 0),
            seg_a => seg_a,
            seg_b => seg_b,
            seg_c => seg_c,
            seg_d => seg_d,
            seg_e => seg_e,
            seg_f => seg_f,
            seg_g => seg_g
        ); 
    product8x8_out <= product8x8;            
end architecture RTL;