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
    component fetch
        port( 
            jumpM, PcSrcM, clk, reset: in std_logic;
            PcBranchM: in std_logic_vector(31 downto 0);
            InstrF, PCF, PCPlus4F: out std_logic_vector(31 downto 0));
    end component;
    component decode
        port(
            A3: in std_logic_vector(4 downto 0);
            InstrD, Wd3: in std_logic_vector(31 downto 0);
            RegWrite, clk: in std_logic;
            RtD, RdD: out std_logic_vector(4 downto 0);
            SignImmD, RD1D, RD2D: out std_logic_vector(31 downto 0));
    end component;
    component execute
        port(
            RD1E, RD2E, PCPlus4E, SignImmE: in std_logic_vector(31 downto 0);
            RtE, RdE: in std_logic_vector(4 downto 0);
            RegDst, AluSrc : in std_logic;
            AluControl: in std_logic_vector(2 downto 0);
            WriteRegE: out std_logic_vector(4 downto 0);
            ZeroE: out std_logic;
            AluOutE, WriteDataE, PCBranchE: out std_logic_vector(31 downto 0));
    end component;
    component memory
        port(
            AluOutM, WriteDataM: in std_logic_vector(31 downto 0);
            ZeroM, MemWrite, Branch, clk, dump: in std_logic;
            ReadDataM: out std_logic_vector(31 downto 0);
            PCSrcM: out std_logic);
    end component;
    component writeback
        port(
            AluOutW, ReadDataW: in std_logic_vector(31 downto 0);
            MemToReg: in std_logic;
            ResultW: out std_logic_vector(31 downto 0));
    end component;


signal PcBranchM_s, InstrF_s, PCF_s, PCPlus4F_s,
       InstrD_s,RD2E_s, RD1E_s, SignImmE_s, 
       AluOutM_s, WriteDataM_s, ReadDataW_s,
       ResultW_s : std_logic_vector(31 downto 0);

signal ZeroM_s, PcSrcM_s : std_logic;

signal A3_s, RtE_s, RdE_s : std_logic_vector(4 downto 0);

begin
    Fetch1: fetch port map(
                    jumpM     => Jump,
                    PcSrcM    => PCSrcM_s, --changing
                    clk       => clk,
                    reset     => reset,
                    PcBranchM => PCBranchM_s,
                    InstrF    => InstrD_s, --changing
                    PCF       => pc,
                    PCPlus4F  => PCPlus4F_s --changing
                );
    Decode1: decode port map(
                        A3       => A3_s, --changing
                        InstrD   => InstrD_s, --changing
                        Wd3      => ResultW_s,
                        RegWrite => RegWrite,
                        clk      => clk,
                        RtD      => RtE_s,
                        RdD      => RdE_s,
                        SignImmD => SignImmE_s,
                        RD1D     => RD1E_s,
                        RD2D     => RD2E_s
                    );
    Execute1: execute port map(
                        RD1E       => RD1E_s, --changing
                        RD2E       => RD2E_s,
                        PCPlus4E   => PCPlus4F_s,
                        SignImmE   => SignImmE_s, --changing
                        RtE        => RtE_s, --changing
                        RdE        => RdE_s,
                        RegDst     => RegDst,
                        AluSrc     => AluSrc,
                        AluControl => AluControl,
                        WriteRegE  => A3_s,
                        ZeroE      => ZeroM_s,
                        AluOutE    => AluOutM_s,
                        WriteDataE => WriteDataM_s,
                        PCBranchE  => PCBranchM_s
                    );
    Memory1: memory port map(
                        AluOutM    => AluOutM_s, --changing
                        WriteDataM => WriteDataM_s, --changing
                        ZeroM      => ZeroM_s, --changing
                        MemWrite   => MemWrite,
                        Branch     => Branch,
                        clk        => clk,
                        dump       => dump,
                        ReadDataM  => ReadDataW_s,
                        PCSrcM     => PCSrcM_s --Posee el mismo nombre (posible conflicto futuro) illak:Para nada!
                    );
    WriteBack1: writeback port map(
                            AluOutW   => AluOutM_s, --changing
                            ReadDataW => ReadDataW_s, --changing
                            MemToReg  => MemToReg,
                            ResultW   => ResultW_s --changing
                        );


instr <= instrD_s;
end arq_datapath;
