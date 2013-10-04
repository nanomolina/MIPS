library ieee;
use ieee.std_logic_1164.all;

entity memory is
    port(
        AluOutM, WriteDataM: in std_logic_vector(31 downto 0);
        ZeroM, MemWrite, Branch, clk, dump: in std_logic;
        ReadDataM: out std_logic_vector(31 downto 0);
        PCSrcM: out std_logic);
end entity;

architecture e_arq of memory is
    component dmem
        port (
            a, wd:	in std_logic_vector (31 downto 0);
            clk,we:	in std_logic;
            rd:		out std_logic_vector (31 downto 0);
            dump: 	in std_logic);
    end component;
    signal temp1: std_logic_vector(31 downto 0);
    signal temp2: std_logic_vector(31 downto 0);
begin
    temp1 <=  "0000000000000000" & AluOutM(31 downto 16);
    temp2 <=  "0000000000000000" & WriteDataM(31 downto 16);
    dmem1: dmem port map(
                    a    => temp1,
                    wd   => temp2,
                    clk  => clk,
                    we   => MemWrite,
                    rd   => ReadDataM, --salida
                    dump => dump);
    PCSrcM <= ZeroM and Branch; --salida
end architecture;
