library ieee;
    use ieee.std_logic_1164.all;

entity datapath is
    port (
        MemToReg : in std_logic;
        MemWrite : in std_logic;
        Branch : in std_logic;
        AluSrc : in std_logic;
        RegDst : in std_logic;
        RegWrite : in std_logic;
        Jump : in std_logic;
        AluControl : in std_logic_vector(2 downto 0);
        dump : in std_logic;
        pc : out std_logic_vector(31 downto 0);
        instr : out std_logic_vector(31 downto 0);
        reset : in std_logic;
        clk : in std_logic);
end entity;

architecture arq_datapath of datapath is
    entity fetch is
        port( 
            jumpM, PcSrc, clk, reset: in std_logic;
            PcBranchF: in std_logic_vector(31 downto 0);
            InstrF, PCF, PCPlus4F: out std_logic_vector(31 downto 0));
    end entity;
    entity decode is
        port(
            A3: in std_logic_vector(4 downto 0);
            InstrD, Wd3: in std_logic_vector(31 downto 0);
            RegWrite, clk: in std_logic;
            Rtd, RdD: out std_logic_vector(4 downto 0);
            SignImmD, RD1D, RD2D: out std_logic_vector(31 downto 0));
    end entity;
    entity execute is
        port(
            RD1E, RD2E, PCPlus4E, SignImmE: in std_logic_vector(31 downto 0);
            RtE, RdE: in std_logic_vector(4 downto 0);
            RegDst, AluSrc, AluControl: in std_logic;
            WriteRegE: out std_logic_vector(4 downto 0);
            ZeroE: out std_logic;
            AluOutE, WriteDataE, PCBranchE: out std_logic_vector(31 downto 0));
    end entity;
    entity memory is
        port(
            AluOutM, WriteDataM: in std_logic_vector(31 downto 0);
            ZeroM, MemWrite, Branch, clk, dump: in std_logic;
            ReadDataM: out std_logic_vector(31 downto 0);
            PCSrcM: out std_logic);
    end entity;
    entity writeback is
        port(
            AluOutW, ReadDataW: in std_logic_vector(31 downto 0);
            MemToReg: in std_logic;
            ResultW: out std_logic_vector(31 downto 0));
    end entity;

begin
    Fetch: fetch port map(
                    jumpM     => Jump,
                    PcSrc     => PCSrcM,
                    clk       => clk,
                    reset     => reset,
                    PcBranchF => PCBranchE,
                    InstrF    =>
                    PCF       =>
                    PCPlus4F  =>
                );
    Decode: decode port map(
                        A3       =>
                        InstrD   =>
                        Wd3      =>
                        RegWrite =>
                        clk      =>
                        Rtd      =>
                        RdD      =>
                        SignImmD =>
                        RD1D     =>
                        RD2D     =>
                    );
    Execute: execute port map(
                        RD1E       =>
                        RD2E       =>
                        PCPlus4E   =>
                        SignImmE   =>
                        RtE        =>
                        RdE        =>
                        RegDst     =>
                        AluSrc     =>
                        AluControl =>
                        WriteRegE  =>
                        ZeroE      =>
                        AluOutE    =>
                        WriteDataE =>
                        PCBranchE  =>
                    );
    Memory: memory port map(
                        AluOutM    =>
                        WriteDataM =>
                        ZeroM      =>
                        MemWrite   =>
                        Branch     =>
                        clk        =>
                        dump       =>
                        ReadDataM  =>
                        PCSrcM     =>
                    );
    WriteBack: writeback port map(
                            AluOutW   =>
                            ReadDataW =>
                            MemToReg  =>
                            ResultW   =>
                        );
