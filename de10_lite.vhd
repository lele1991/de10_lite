-------------------------------------------------------------------
-- Name        : de0_lite.vhd
-- Author      : 
-- Version     : 0.1
-- Copyright   : Departamento de Eletrônica, Florianópolis, IFSC
-- Description : Projeto base DE10-Lite
-------------------------------------------------------------------
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.all;

entity de10_lite is 
	port (
		---------- CLOCK ----------
		ADC_CLK_10:	in std_logic;
		MAX10_CLK1_50: in std_logic;
		MAX10_CLK2_50: in std_logic;
		
		----------- SDRAM ------------
		DRAM_ADDR: out std_logic_vector (12 downto 0);
		DRAM_BA: out std_logic_vector (1 downto 0);
		DRAM_CAS_N: out std_logic;
		DRAM_CKE: out std_logic;
		DRAM_CLK: out std_logic;
		DRAM_CS_N: out std_logic;		
		DRAM_DQ: inout std_logic_vector(15 downto 0);
		DRAM_LDQM: out std_logic;
		DRAM_RAS_N: out std_logic;
		DRAM_UDQM: out std_logic;
		DRAM_WE_N: out std_logic;
		
		----------- SEG7 ------------
		HEX0: out std_logic_vector(7 downto 0);
		HEX1: out std_logic_vector(7 downto 0);
		HEX2: out std_logic_vector(7 downto 0);
		HEX3: out std_logic_vector(7 downto 0);
		HEX4: out std_logic_vector(7 downto 0);
		HEX5: out std_logic_vector(7 downto 0);

		----------- KEY ------------
		KEY: in std_logic_vector(1 downto 0);

		----------- LED ------------
		LEDR: out std_logic_vector(9 downto 0);

		----------- SW ------------
		SW: in std_logic_vector(9 downto 0);

		----------- VGA ------------
		VGA_B: out std_logic_vector(3 downto 0);
		VGA_G: out std_logic_vector(3 downto 0);
		VGA_HS: out std_logic;
		VGA_R: out std_logic_vector(3 downto 0);
		VGA_VS: out std_logic;
	
		----------- Accelerometer ------------
		GSENSOR_CS_N: out std_logic;
		GSENSOR_INT: in std_logic_vector(2 downto 1);
		GSENSOR_SCLK: out std_logic;
		GSENSOR_SDI: inout std_logic;
		GSENSOR_SDO: inout std_logic;
	
		----------- Arduino ------------
		ARDUINO_IO: inout std_logic_vector(15 downto 0);
		ARDUINO_RESET_N: inout std_logic
	);
end entity;

architecture rtl of de10_lite is
	
	-- ipcatalog->library-> basic-> simul-> debug-> intel = 16 
	-- declaração implicita
	component s_probe is
		port (
			source : out std_logic_vector(31 downto 0);                    -- source
			probe  : in  std_logic_vector(31 downto 0) := (others => 'X')  -- probe
		);
	end component s_probe;
	
	 signal probe: 	std_logic_vector(31 downto 0);
    signal source: 	std_logic_vector(31 downto 0);
	 
	 signal done_flag : std_logic;
	 signal dataa : unsigned(7 downto 0);
	 signal datab : unsigned(7 downto 0);
	 signal product : unsigned (15 downto 0);
	 signal clk: std_logic;
	 signal state_out : unsigned(2 downto 0);

begin
    
		u0 : component s_probe
		port map (
			source => source, -- sources.source
			probe  => probe   --  probes.probe
		);

    dut: entity work.mult8x8
       generic map(
            SIZE_2   => 2,
            SIZE_4   => 4,
            SIZE_16  => 16
        )
        port map(
                       
            reset_a         => SW(0),
            clk             => source(16),
            start           => SW(2),
            
            dataa           => unsigned(source(7 downto 0)),
            datab           => unsigned(source(15 downto 8)),
            unsigned(product8x8_out)  => probe(15 downto 0),
				done_flag       => LEDR(0),				
            seg_a           => HEX0(6),
            seg_b           => HEX0(5),
            seg_c           => HEX0(4),
            seg_d           => HEX0(3),
            seg_e           => HEX0(2),
            seg_f           => HEX0(1),
            seg_g           => HEX0(0)
        ); 
		 
		  probe(17) <= done_flag;
		  probe(20 downto 18) <= std_logic_vector(state_out);	
		  
	--signal probe (permite alterar em tempo de execução)

end;