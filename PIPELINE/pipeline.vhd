library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;

entity pipeline is
	port (
		pc : out std_logic_vector(31 downto 0);
		instr : out std_logic_vector(31 downto 0);

		dump : in std_logic;
		reset : in std_logic;
		clk : in std_logic
	);
end entity;

architecture BH of pipeline is
	--DECLARACION DE COMPONENTES--
	component datapath
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
			clk : in std_logic
		);
	end component;

	component controller
		port (
			Op: in std_logic_vector(5 downto 0);
			Funct: in std_logic_vector(5 downto 0);
			MemToReg:	out std_logic;
			MemWrite:	out std_logic;
			Branch:		out std_logic;
			AluSrc:		out std_logic;
			RegDst:		out std_logic;
			RegWrite:	out std_logic;
			Jump:		out std_logic;
			alucontrol: out std_logic_vector (2 downto 0)
		);
	end component;


--DECLARACION DE SEniALES--
	signal MemToReg_s, MemWrite_s, Branch_s, AluSrc_s, RegDst_s, RegWrite_s, Jump_s : std_logic;
	signal AluControl_s : std_logic_vector(2 downto 0);
	signal Instr_s : std_logic_vector(31 downto 0);


	begin

	CONTROLLER1: controller port map(
							Op => Instr_s(31 downto 26),
							Funct => Instr_s(5 downto 0),
							MemToReg => MemToReg_s,
							MemWrite => MemWrite_s,
							Branch => Branch_s,
							AluSrc => AluSrc_s,
							RegDst => RegDst_s,
							RegWrite => RegWrite_s,
							Jump => Jump_s,
							alucontrol => AluControl_s
							);
	DATAPATH1: datapath port map(
							MemToReg => MemToReg_s,
							MemWrite => MemWrite_s,
							Branch => Branch_s,
							AluSrc => AluSrc_s,
							RegDst => RegDst_s,
							RegWrite => RegWrite_s,
							Jump => Jump_s,
							AluControl => AluControl_s,
							dump => dump,

							pc => pc,
							instr => Instr_s,

							reset => reset,
							clk => clk
							);
	instr <= Instr_s; -- IMPORTANTE !!!
end BH;
