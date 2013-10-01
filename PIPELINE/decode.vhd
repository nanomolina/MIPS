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

architecture d_arq of decode is
    component regfile
    port (
        ra1, ra2, wa3: in std_logic_vector(4 downto 0);
        wd3: in std_logic_vector(31 downto 0);
        we3, clk: in std_logic;
        rd1, rd2: out std_logic_vector(31 downto 0)
    );
    component sign
        port (
            a: in std_logic_vector(15 downto 0);
            y: out std_logic_vector(31 downto 0)
        );
    end component;
begin
    regfile: regfile port map(
                        ra1 => InstrD(25 downto 21),
                        ra2 => InstrD(20 downto 16),
                        wa3 => A3,
                        wd3 => Wd3,
                        we3 => RegWrite,
                        clk => clk,
                        rd1 => RD1D, --salida
                        rd2 => RD2D  --salida
                    );
    sign: sign port map(
                    a => InstrD(15 downto 0),
                    y => SignImmD  --salida
                );
    Rtd <= InstrD(20 downto 16); --salida
    RdD <= InstrD(15 downto 11); --salida

end architecture;
