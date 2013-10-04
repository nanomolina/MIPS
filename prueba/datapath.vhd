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

    component IF_ID
        port(
            clk : in std_logic;
            instr_in : in std_logic_vector(31 downto 0);
            pcplus4_in : in std_logic_vector(31 downto 0);
            instr_out : out std_logic_vector(31 downto 0);
            pcplus4_out : out std_logic_vector(31 downto 0)
            );
    end component;

    component ID_EX
        port(
            RtD_in : in std_logic_vector(4 downto 0);
            RdD_in : in std_logic_vector(4 downto 0);
            SignImm_in : in std_logic_vector(31 downto 0);
            RD1_in : in std_logic_vector(31 downto 0);
            RD2_in : in std_logic_vector(31 downto 0);

            PCPlus4_in : in std_logic_vector(31 downto 0);

            MemToReg_in:in std_logic;
            MemWrite_in:in std_logic;
            Branch_in:in std_logic;
            AluSrc_in:in std_logic;
            RegDst_in:in std_logic;
            RegWrite_in:in std_logic;
            Jump_in:in std_logic;
            alucontrol_in: in std_logic_vector (2 downto 0);

            clk : in std_logic;

            PCPlus4_out : out std_logic_vector(31 downto 0);

            MemToReg_out:out std_logic;
            MemWrite_out:out std_logic;
            Branch_out:out std_logic;
            AluSrc_out:out std_logic;
            RegDst_out:out std_logic;
            RegWrite_out:out std_logic;
            Jump_out:out std_logic;
            alucontrol_out: out std_logic_vector (2 downto 0);

            RtD_out : out std_logic_vector(4 downto 0);
            RdD_out : out std_logic_vector(4 downto 0);
            SignImm_out : out std_logic_vector(31 downto 0);
            RD1_out : out std_logic_vector(31 downto 0);
            RD2_out : out std_logic_vector(31 downto 0)
        );
    end component;

    component EX_MEM
        port(
            Zero_in : in std_logic;
            AluOut_in : in std_logic_vector(31 downto 0);
            WriteData_in : in std_logic_vector(31 downto 0);
            WriteReg_in : in std_logic_vector(4 downto 0);
            PCBranch_in : in std_logic_vector(31 downto 0);

            RegWrite_in: in std_logic;
            MemToReg_in: in std_logic;
            MemWrite_in: in std_logic;
            Jump_in: in std_logic;
            Branch_in: in std_logic;


            clk : in std_logic;

            RegWrite_out: out std_logic;
            MemToReg_out: out std_logic;
            MemWrite_out: out std_logic;
            Jump_out: out std_logic;
            Branch_out: out std_logic;

            Zero_out : out std_logic;
            AluOut_out : out std_logic_vector(31 downto 0);
            WriteData_out : out std_logic_vector(31 downto 0);
            WriteReg_out : out std_logic_vector(4 downto 0);
            PCBranch_out : out std_logic_vector(31 downto 0)
        );
    end component;

    component MEM_WB
        port(
            AluOut_in : in std_logic_vector(31 downto 0);
            ReadData_in : in std_logic_vector(31 downto 0);
            WriteReg_in : in std_logic_vector(4 downto 0);

            RegWrite_in: in std_logic;
            MemToReg_in: in std_logic;

            clk : in std_logic;

            RegWrite_out: out std_logic;
            MemToReg_out: out std_logic;

            AluOut_out : out std_logic_vector(31 downto 0);
            ReadData_out : out std_logic_vector(31 downto 0);
            WriteReg_out : out std_logic_vector(4 downto 0)
        );
    end component;

    signal PcBranchE_s, InstrF_s, PCF_s, PCPlus4F_s,
       Instr987_s,RD2D_s, RD1D_s, SignImmD_s, 
       AluOutE_s, WriteDataE_s, ReadDataM_s,
       ResultW_s : std_logic_vector(31 downto 0);

    signal ZeroE_s, PcSrcM_s : std_logic;

    signal A3E_s, RtD_s, RdD_s : std_logic_vector(4 downto 0);

begin
    Fetch1: fetch port map(
                    jumpM     => Jump,
                    PcSrcM    => PcSrcM_s,
                    clk       => clk,
                    reset     => reset,
                    PcBranchM => PcBranchE_s,
                    InstrF    => InstrF_s,
                    PCF       => pc,
                    PCPlus4F  => PCPlus4F_s
                );
    
    Decode1: decode port map(
                        A3       => A3E_s,
                        InstrD   => InstrF_s,
                        Wd3      => ResultW_s,
                        RegWrite => RegWrite,
                        clk      => clk,
                        RtD      => RtD_s,
                        RdD      => RdD_s,
                        SignImmD => SignImmD_s,
                        RD1D     => RD1D_s,
                        RD2D     => RD2D_s
                    );
    Execute1: execute port map(
                        RD1E       => RD1D_s,
                        RD2E       => RD2D_s,
                        PCPlus4E   => PCPlus4F_s,
                        SignImmE   => SignImmD_s,
                        RtE        => RtD_s,
                        RdE        => RdD_s,
                        RegDst     => RegDst,
                        AluSrc     => AluSrc,
                        AluControl => AluControl,
                        WriteRegE  => A3E_s,
                        ZeroE      => ZeroE_s,
                        AluOutE    => AluOutE_s,
                        WriteDataE => WriteDataE_s,
                        PCBranchE  => PCBranchE_s
                    );
    Memory1: memory port map(
                        AluOutM    => AluOutE_s,
                        WriteDataM => WriteDataE_s,
                        ZeroM      => ZeroE_s,
                        MemWrite   => MemWrite,
                        Branch     => Branch,
                        clk        => clk,
                        dump       => dump,
                        ReadDataM  => ReadDataM_s,
                        PCSrcM     => PCSrcM_s
                    );
    WriteBack1: writeback port map(
                            AluOutW   => AluOutE_s,
                            ReadDataW => ReadDataM_s,
                            MemToReg  => MemToReg,
                            ResultW   => ResultW_s --changing
                        );
instr <= instrF_s;
end architecture;


