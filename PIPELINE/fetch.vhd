library ieee;
use ieee.std_logic_1164.all;

entity fetch is
    port( 
        jump, PcSrcM, clk, reset: in std_logic;
        PcBranchM: in std_logic_vector(31 downto 0);
        InstrF, PCF, PCPlus4F: out std_logic_vector(31 downto 0)
    );
end entity;
