library ieee;
use ieee.std_logic_1164.all;

entity decode is
    port(
        A3: in std_logic_vector(4 downto 0);
        InstrD, Wd3: in std_logic_vector(31 downto 0);
        RegWrite, clk: in std_logic;
        Rtd, RdD: out std_logic_vector(4 downto 0);
        SignImmD, RD1D, RD2D: out std_logic_vector(31 downto 0)
    );
end entity;
        
