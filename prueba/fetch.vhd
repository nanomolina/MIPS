library ieee;
use ieee.std_logic_1164.all;

entity fetch is
    port( 
        jumpM, PcSrcM, clk, reset: in std_logic;
        PcBranchM: in std_logic_vector(31 downto 0);
        InstrF, PCF, PCPlus4F: out std_logic_vector(31 downto 0));
end entity;

architecture f_arq of fetch is
    component mux2
        generic (MAX : integer := 32);
        port (
            d0, d1: in std_logic_vector((MAX-1) downto 0);
            s:   in std_logic;     
            y: out std_logic_vector((MAX-1) downto 0));
    end component;
    component flopr
        port (
            d: in std_logic_vector(31 downto 0);
            rst, clk:   in std_logic;     
            q: out std_logic_vector(31 downto 0));
    end component;
    component imem
        port (
        a: in std_logic_vector (5 downto 0);
        rd: out std_logic_vector (31 downto 0));
    end component;
    component adder
        port (
            a : in std_logic_vector(31 downto 0);
            b : in std_logic_vector(31 downto 0);
            y : out std_logic_vector(31 downto 0));
    end component;

    signal PCNext, PCPlus4F1, PCJump, PC1, PCF_s, 
            Instrf_s: std_logic_vector(31 downto 0);
    signal QUATRO: std_logic_vector(31 downto 0) := x"00000004";
    signal IMEMIN: std_logic_vector(5 downto 0);

begin 

    mux2_1: mux2 port map(
                    d0 => PCPlus4F1,
                    d1 => PcBranchM,
                    s => PCSrcM,
                    y => PCNext);
    mux2_2: mux2 port map(
                    d0 => PCNext,
                    d1 => PCJump,
                    s => jumpM,
                    y => PC1);
    flopr1: flopr port map(
                    d => PC1,
                    clk => clk,
                    rst => reset,
                    q => PCF_s);
    adder1: adder port map(
                    a => PCF_s,
                    b => QUATRO,
                    y => PCPlus4F1);
    imem1: imem port map(
                    a  => IMEMIN,
                    rd => Instrf_s);

    PCJump <= PCPlus4F1(31 downto 28) & Instrf_s(25 downto 0) & "00";
    IMEMIN <= PCF_s(7 downto 2); 
    InstrF <= Instrf_s;
    PCF <= PCF_s;
    PCPlus4F <= PCPlus4F1;

end architecture;
