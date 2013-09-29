library ieee;
use ieee.std_logic_1164.all;

entity fetch is
    port( 
        jumpM, PcSrcM, clk, reset: in std_logic;
        PcBranchM: in std_logic_vector(31 downto 0);
        InstrF, PCF, PCPlus4F: out std_logic_vector(31 downto 0)
    );
end entity;

architecture f_arq of fetch is
    component mux2
		generic (MAX : integer := 32);
		port (
			d0, d1: in std_logic_vector((MAX-1) downto 0);
        	s:   in std_logic;     
        	y: out std_logic_vector((MAX-1) downto 0)
		);
	end component;
	component flopr
		port (
			d: in std_logic_vector(31 downto 0);
        	rst, clk:   in std_logic;     
        	q: out std_logic_vector(31 downto 0)
		);
	end component;
	component imem
		port (
    	    a: in std_logic_vector (5 downto 0);
	        rd: out std_logic_vector (31 downto 0)	
		);
	end component;
	component adder
		port (
			a : in std_logic_vector(31 downto 0);
			b : in std_logic_vector(31 downto 0);
			y : out std_logic_vector(31 downto 0)
		);
	end component;
    signal PCNext, PCPlus4F, PCJump, PC1: std_logic_vector(31 downto 0);
    signal Instrf
begin
    mux2_1: mux2 port map(
                    d0 => PCPlus4F,
                    d1 => PcBranchM,
                    s => PCSrcM,
                    y => PCNext
                );
    PCJump <= PCPlus4F(31 downto 28) & Instrf(25 downto 0) & "00";
    mux2_2: mux2 port map(
                    d0 => PCNext,
                    d1 => PCJump,
                    s => jumpM,
                    y => PC1
                );
    flopr: flopr port map(
                    d => PC1,
                    clk => clk,
                    rst => reset,
                    q => PCF
                );
                                        
