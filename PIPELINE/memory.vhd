library ieee;
use ieee.std_logic_1164.all;

entity memory is
    port(
        AluOutM, WriteDataM: in std_logic_vector(31 downto 0);
        ZeroM, MemWrite, Branch, clk, dump: in std_logic;
        ReadDataM: out std_logic_vector(31 downto 0);
        PCSrcM: out std_logic
    );
end entity;
