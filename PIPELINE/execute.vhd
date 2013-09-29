library ieee;
use ieee.std_logic_1164.all;

entity execute is
    port(
        RD1E, RD2E, PCPlus4E, SignImmE: in std_logic_vector(31 downto 0);
        RtE, RdE: in std_logic_vector(4 downto 0);
        RegDst, AluSrc, AluControl: in std_logic;
        WriteRegE: out std_logic_vector(4 downto 0);
        ZeroE: out std_logic;
        AluOutE, WriteDataE, PCBranchE: out std_logic_vector(31 downto 0)
    );
end entity;
