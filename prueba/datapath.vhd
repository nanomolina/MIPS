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

    signal PCBranchE_out_s, InstrF_out_s, InstrIFID_out_s , PCF_s, PCPlus4F_out_s,
       PCPlus4IFID_out_s, RD2D_out_s,RD2IDEX_out_s, RD1D_out_s,RD1IDEX_out_s, 
        SignImmD_out_s,SignImmIDEX_out_s, 
       AluOutE_out_s,AluOutEXMEM_out_s, WriteDataE_out_s,WriteDataEXMEM_out_s, ReadDataM_out_s,
        ReadDataMEMWB_out_s,PCPlus4IDEX_out_s,
       ResultW_s, PCBranchEXMEM_out_s, AluOutMEMWB_out_s: std_logic_vector(31 downto 0);

    signal ZeroE_out_s,ZeroEXMEM_out_s, PcSrcM_s,MemToRegIDEX_out_s, MemToRegEXMEM_out_s,
            MemToRegMEMWB_out_s,MemWriteIDEX_out_s,BranchIDEX_out_s,BranchEXMEM_out_s,
            AluSrcIDEX_out_s,RegDstIDEX_out_s,RegWriteIDEX_out_s,RegWriteEXMEM_out_s,
            RegWriteMEMEB_out_s,JumpIDEX_out_s, JumpEXMEM_out_s,MemWriteEXMEM_out_s: std_logic;

    signal A3E_out_s,A3EXMEM_out_s,A3MEMWB_out_s, RtD_out_s, RtIDEX_out_s, RdD_out_s, RdIDEX_out_s: std_logic_vector(4 downto 0);
    signal AluControlIDEX_out_s: std_logic_vector(2 downto 0);

begin
    Fetch1: fetch port map(
                    jumpM     => JumpEXMEM_out_s,
                    PcSrcM    => PcSrcM_s,
                    clk       => clk,
                    reset     => reset,
                    PcBranchM => PCBranchEXMEM_out_s,
                    InstrF    => InstrF_out_s,
                    PCF       => pc,
                    PCPlus4F  => PCPlus4F_out_s
                );
    IF_ID1: IF_ID port map(
                    clk         => clk,
                    instr_in    => InstrF_out_s,
                    pcplus4_in  => PCPlus4F_out_s,
                    instr_out   => InstrIFID_out_s,
                    pcplus4_out => PCPlus4IFID_out_s
                );
    Decode1: decode port map(
                        A3       => A3MEMWB_out_s,
                        InstrD   => InstrIFID_out_s,
                        Wd3      => ResultW_s,
                        RegWrite => RegWriteMEMEB_out_s,
                        clk      => clk,
                        RtD      => RtD_out_s,
                        RdD      => RdD_out_s,
                        SignImmD => SignImmD_out_s,
                        RD1D     => RD1D_out_s,
                        RD2D     => RD2D_out_s
                    );
    ID_EX1: ID_EX port map(
                    RtD_in         => RtD_out_s,
                    RdD_in         => RdD_out_s,
                    SignImm_in     => SignImmD_out_s,
                    RD1_in         => RD1D_out_s,
                    RD2_in         => RD2D_out_s,
                    PCPlus4_in     => PCPlus4IFID_out_s,
                    MemToReg_in    => MemToReg,
                    MemWrite_in    => MemWrite,
                    Branch_in      => Branch,
                    AluSrc_in      => AluSrc,
                    RegDst_in      => RegDst,
                    RegWrite_in    => RegWrite,
                    Jump_in        => Jump,
                    alucontrol_in  => AluControl,
                    clk            => clk,
                    PCPlus4_out    => PCPlus4IDEX_out_s,
                    MemToReg_out   => MemToRegIDEX_out_s,
                    MemWrite_out   => MemWriteIDEX_out_s,
                    Branch_out     => BranchIDEX_out_s,
                    AluSrc_out     => AluSrcIDEX_out_s,
                    RegDst_out     => RegDstIDEX_out_s,
                    RegWrite_out   => RegWriteIDEX_out_s,
                    Jump_out       => JumpIDEX_out_s,
                    alucontrol_out => AluControlIDEX_out_s,
                    RtD_out        => RtIDEX_out_s,
                    RdD_out        => RdIDEX_out_s,
                    SignImm_out    => SignImmIDEX_out_s,
                    RD1_out        => RD1IDEX_out_s,
                    RD2_out        => RD2IDEX_out_s
                );
    Execute1: execute port map(
                        RD1E       => RD1IDEX_out_s,
                        RD2E       => RD2IDEX_out_s,
                        PCPlus4E   => PCPlus4IDEX_out_s,
                        SignImmE   => SignImmIDEX_out_s,
                        RtE        => RtIDEX_out_s,
                        RdE        => RdIDEX_out_s,
                        RegDst     => RegDstIDEX_out_s,
                        AluSrc     => AluSrcIDEX_out_s,
                        AluControl => AluControlIDEX_out_s,
                        WriteRegE  => A3E_out_s,
                        ZeroE      => ZeroE_out_s,
                        AluOutE    => AluOutE_out_s,
                        WriteDataE => WriteDataE_out_s,
                        PCBranchE  => PCBranchE_out_s
                    );
    EX_MEM1: EX_MEM port map(
                        Zero_in       => ZeroE_out_s,
                        AluOut_in     => AluOutE_out_s,
                        WriteData_in  => WriteDataE_out_s,
                        WriteReg_in   => A3E_out_s,
                        PCBranch_in   => PCBranchE_out_s,
                        RegWrite_in   => RegWriteIDEX_out_s,
                        MemToReg_in   => MemToRegIDEX_out_s,
                        MemWrite_in   => MemWriteIDEX_out_s,
                        Jump_in       => JumpIDEX_out_s,
                        Branch_in     => BranchIDEX_out_s,
                        clk           => clk,
                        RegWrite_out  => RegWriteEXMEM_out_s,
                        MemToReg_out  => MemToRegEXMEM_out_s,
                        MemWrite_out  => MemWriteEXMEM_out_s,
                        Jump_out      => JumpEXMEM_out_s,
                        Branch_out    => BranchEXMEM_out_s,
                        Zero_out      => ZeroEXMEM_out_s,
                        AluOut_out    => AluOutEXMEM_out_s,
                        WriteData_out => WriteDataEXMEM_out_s,
                        WriteReg_out  => A3EXMEM_out_s,
                        PCBranch_out  => PCBranchEXMEM_out_s
                    );
    Memory1: memory port map(
                        AluOutM    => AluOutEXMEM_out_s,
                        WriteDataM => WriteDataEXMEM_out_s,
                        ZeroM      => ZeroEXMEM_out_s,
                        MemWrite   => MemWriteEXMEM_out_s,
                        Branch     => BranchEXMEM_out_s,
                        clk        => clk,
                        dump       => dump,
                        ReadDataM  => ReadDataM_out_s,
                        PCSrcM     => PCSrcM_s
                    );
    MEM_WB1: MEM_WB port map(
                        AluOut_in    => AluOutEXMEM_out_s,
                        ReadData_in  => ReadDataM_out_s,
                        WriteReg_in  => A3EXMEM_out_s,
                        RegWrite_in  => RegWriteEXMEM_out_s,
                        MemToReg_in  => MemToRegEXMEM_out_s,
                        clk          => clk,
                        RegWrite_out => RegWriteMEMEB_out_s,
                        MemToReg_out => MemToRegMEMWB_out_s,
                        AluOut_out   => AluOutMEMWB_out_s,
                        ReadData_out => ReadDataMEMWB_out_s,
                        WriteReg_out => A3MEMWB_out_s
                    );
    WriteBack1: writeback port map(
                            AluOutW   => AluOutEXMEM_out_s,
                            ReadDataW => ReadDataMEMWB_out_s,
                            MemToReg  => MemToRegMEMWB_out_s,
                            ResultW   => ResultW_s
                        );
    instr <= InstrF_out_s;

end architecture;


