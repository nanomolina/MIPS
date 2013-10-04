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

    --CLOCKS
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

            MemToReg_in:	in std_logic;
		    MemWrite_in:	in std_logic;
		    Branch_in:		in std_logic;
		    AluSrc_in:		in std_logic;
		    RegDst_in:		in std_logic;
		    RegWrite_in:	in std_logic;
		    Jump_in:		in std_logic;
		    alucontrol_in: in std_logic_vector (2 downto 0);

            clk : in std_logic;

            PCPlus4_out : out std_logic_vector(31 downto 0);

		    MemToReg_out:	out std_logic;
		    MemWrite_out:	out std_logic;
		    Branch_out:		out std_logic;
		    AluSrc_out:		out std_logic;
		    RegDst_out:		out std_logic;
		    RegWrite_out:	out std_logic;
		    Jump_out:		out std_logic;
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
    --FIN CLOCKS

--signal CLOCKS
signal InstrC_s, PCPlus4C_s, RD1DC_s, RD2DC_s, SignImmC_s, AluOutC_s,
        WriteDataC_s, PCBranchC_s, AluOut2C_s, ReadDataC_s, PCPlus4F_s, PCPlus4D_s : std_logic_vector(31 downto 0);
signal RtDC_s, RdDC_s, WriteRegC_s, WriteReg2C_s , WriteRegM_s: std_logic_vector(4 downto 0);
signal ZeroC_s, RegWriteE_s, MemToRegE_s, MemWriteE_s, JumpE_s, BranchE_s,
        RegWriteM_s, MemToRegM_s, BranchM_s, MemWriteM_s, AluSrcE_s, RegDstE_s,
        JumpM_s, RegWriteW_s, MemToRegW_s , WriteRegW_s : std_logic;
signal AluControlE_s : std_logic_vector(2 downto 0);



signal PcBranchM_s, InstrF_s, PCF_s,
       InstrD_s,RD2E_s, RD1E_s, SignImmE_s, 
       AluOutM_s, WriteDataM_s, ReadDataW_s,
       ResultW_s : std_logic_vector(31 downto 0);

signal ZeroM_s, PcSrcM_s : std_logic;

signal A3_s, RtE_s, RdE_s : std_logic_vector(4 downto 0);

begin
    Fetch1: fetch port map(
                    jumpM     => JumpM_s,
                    PcSrcM    => PCSrcM_s, --changing
                    clk       => clk,
                    reset     => reset,
                    PcBranchM => PCBranchC_s,
                    InstrF    => InstrD_s, --changing
                    PCF       => pc,
                    PCPlus4F  => PCPlus4F_s --changing
                );

    IF_ID1: IF_ID port map(
                    clk => clk,
                    instr_in => InstrD_s,
                    pcplus4_in => PCPlus4F_s,
                    instr_out => InstrC_s,--senial de salida
                    pcplus4_out => PCPlus4D_s --senial de salida
                    );

    Decode1: decode port map(
                        A3       => A3_s, --changing
                        InstrD   => InstrC_s, --changing
                        Wd3      => ResultW_s,
                        RegWrite => RegWriteW_s,
                        clk      => clk,
                        RtD      => RtE_s,
                        RdD      => RdE_s,
                        SignImmD => SignImmE_s,
                        RD1D     => RD1E_s,
                        RD2D     => RD2E_s
                    );
    ID_EX1: ID_EX port map(

                    RtD_in => RtE_s,
                    RdD_in => RdE_s,
                    SignImm_in => SignImmE_s,
                    RD1_in => RD1E_s,
                    RD2_in => RD2E_s,
                    PCPlus4_in => PCPlus4D_s,
                    MemToReg_in => MemToReg, --REVISAR! de aca hasta clk
                    MemWrite_in => MemWrite,
                    Branch_in => Branch,
                    AluSrc_in => AluSrc,
                    RegDst_in => RegDst,
                    RegWrite_in => RegWrite,
                    Jump_in => Jump,
                    alucontrol_in => AluControl,
                    clk => clk,
                    MemToReg_out => MemToRegE_s,
                    MemWrite_out => MemWriteE_s,
                    Branch_out => BranchE_s,
                    AluSrc_out => AluSrcE_s,
                    RegDst_out => RegDstE_s,
                    RegWrite_out => RegWriteE_s,
                    Jump_out => JumpE_s,
                    alucontrol_out => AluControlE_s,
                    RtD_out => RtDC_s,
                    RdD_out => RdDC_s,
                    SignImm_out => SignImmC_s,
                    RD1_out => RD1DC_s,
                    RD2_out => RD2DC_s,
                    PCPlus4_out => PCPlus4C_s
                    );

    Execute1: execute port map(
                        RD1E       => RD1DC_s, --changing
                        RD2E       => RD2DC_s,
                        PCPlus4E   => PCPlus4C_s,
                        SignImmE   => SignImmC_s, --changing
                        RtE        => RtDC_s, --changing
                        RdE        => RdDC_s,
                        RegDst     => RegDstE_s,
                        AluSrc     => AluSrcE_s,
                        AluControl => AluControlE_s,
                        WriteRegE  => WriteRegM_s,
                        ZeroE      => ZeroM_s,
                        AluOutE    => AluOutM_s,
                        WriteDataE => WriteDataM_s,
                        PCBranchE  => PCBranchM_s
                    );

    EX_MEM1: EX_MEM port map(
                    Zero_in => ZeroM_s,
                    AluOut_in => AluOutM_s,
                    WriteData_in => WriteDataM_s,
                    WriteReg_in => WriteRegM_s,
                    PCBranch_in => PCBranchM_s,
                    RegWrite_in => RegWriteE_s,
                    MemToReg_in => MemToRegE_s,
                    MemWrite_in => MemWriteE_s,
                    Jump_in => JumpE_s,
                    Branch_in => BranchE_s,
                    clk => clk,
                    RegWrite_out => RegWriteM_s,
                    MemToReg_out => MemToRegM_s,
                    MemWrite_out => MemWriteM_s,
                    Jump_out => JumpM_s,
                    Branch_out => BranchM_s,
                    Zero_out => ZeroC_s,
                    AluOut_out => AluOutC_s,
                    WriteData_out => WriteDataC_s,
                    WriteReg_out => WriteRegC_s,
                    PCBranch_out => PCBranchC_s
                    );

    Memory1: memory port map(
                        AluOutM    => AluOutC_s, --changing
                        WriteDataM => WriteDataC_s, --changing
                        ZeroM      => ZeroC_s, --changing
                        MemWrite   => MemWriteM_s,
                        Branch     => BranchM_s, --PREGUNTAR
                        clk        => clk,
                        dump       => dump,
                        ReadDataM  => ReadDataW_s,
                        PCSrcM     => PCSrcM_s --Posee el mismo nombre (posible conflicto futuro) illak:Para nada!
                    );

    MEM_WB1: MEM_WB port map(
                    AluOut_in => AluOut2C_s,
                    ReadData_in => ReadDataW_s,
                    WriteReg_in => WriteRegC_s,
                    RegWrite_in => RegWriteM_s,
                    MemToReg_in => MemToRegM_s,
                    clk => clk,
                    RegWrite_out => RegWriteW_s,
                    MemToReg_out => MemToRegW_s,
                    AluOut_out => AluOut2C_s,
                    ReadData_out => ReadDataC_s,
                    WriteReg_out => A3_s
                    );

    WriteBack1: writeback port map(
                            AluOutW   => AluOut2C_s, --changing
                            ReadDataW => ReadDataC_s, --changing
                            MemToReg  => MemToRegW_s,
                            ResultW   => ResultW_s --changing
                        );

instr <= instrD_s;
end arq_datapath;
