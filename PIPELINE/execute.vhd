library ieee;
use ieee.std_logic_1164.all;

entity execute is
    port(
        RD1E, RD2E, PCPlus4E, SignImmE: in std_logic_vector(31 downto 0);
        RtE, RdE: in std_logic_vector(4 downto 0);
        RegDst, AluSrc, AluControl: in std_logic;
        WriteRegE: out std_logic_vector(4 downto 0);
        ZeroE: out std_logic;
        AluOutE, WriteDataE, PCBranchE: out std_logic_vector(31 downto 0));
end entity;

architecture e_arq of execute is
    component adder
        port (
            a : in std_logic_vector(31 downto 0);
            b : in std_logic_vector(31 downto 0);
            y : out std_logic_vector(31 downto 0));
    end component;
    component mux2
        generic (MAX : integer := 32);
        port (
            d0, d1: in std_logic_vector((MAX-1) downto 0);
            s:   in std_logic;     
            y: out std_logic_vector((MAX-1) downto 0));
    end component;
    component sl2
        port (
            a: in std_logic_vector (31 downto 0);
            y: out std_logic_vector (31 downto 0));
    end component;
    component alu
        port (
            a, b: in std_logic_vector(31 downto 0);
            alucontrol: in std_logic_vector(2 downto 0);
            result: out std_logic_vector(31 downto 0);
            zero: out std_logic);
    end component;

    signal sl2_out: std_logic_vector(31 downto 0);
    signal SrcBE: std_logic_vector(31 downto 0);
begin
    mux2_1: mux2 generic map(
                    MAX := 5)
                port map(
                    d0 => RtE,
                    d1 => RdE,
                    s  => RegDst,
                    y  => WriteRegE);‪ --salida
    sl2: sl2 port map(
                a => SignImmE,
                y => sl2_out);
    adder: adder port map(
                a => sl2_out,
                b => PCPlus4E,
                y => PCBranchE); --salida
    mux2_2: mux2 port map(
                d0 => RD2E,
                d1 => SignImmE,
                s  => AluSrc,
                y  => SrcBE);
    WriteDataE <= RD2E; --salida
    Alu: alu port map(
                a => RD1E,
                b => SrcBE,
                alucontrol => AluControl,
                result => AluOutE, --salida
                zero => ZeroE); --salida
end architecture;
