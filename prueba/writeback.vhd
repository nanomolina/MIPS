library ieee;
use ieee.std_logic_1164.all;

entity writeback is
    port(
        AluOutW, ReadDataW: in std_logic_vector(31 downto 0);
        MemToReg: in std_logic;
        ResultW: out std_logic_vector(31 downto 0));
end entity;

architecture wb_arq of writeback is
    component mux2
        generic (MAX : integer := 32);
        port (
            d0, d1: in std_logic_vector((MAX-1) downto 0);
            s:   in std_logic;     
            y: out std_logic_vector((MAX-1) downto 0));
    end component;

begin
    mux2_1: mux2 port map (
                    d0 => AluOutW,
                    d1 => ReadDataW,
                    s  => MemToReg,
                    y  => ResultW);  --salida
end architecture;
