library ieee;
use ieee.std_logic_1164.all;

entity writeback is
    port(
        AluOutW, ReadDataW: in std_logic_vector(31 downto 0);
        MemToReg: in std_logic;
        ResultW: out std_logic_vector(31 downto 0)
    );
end entity;
