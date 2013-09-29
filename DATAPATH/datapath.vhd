library ieee;
	use ieee.std_logic_1164.all;
library work;
    use work.components.all;

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
		clk : in std_logic
	);
end entity;

architecture BH of datapath is
	signal DUMPS, PCSrc, ZEROs : std_logic;
	signal PC1, PCNext, PC_T, PCOut, INSTRUCTION,
		PCPlus4, SrcA, PCJump, QUATRO,
		PCBranch, SignImm, SrcB, Result,
		RD1, RD2, AD1, AD2, ReadData, WriteData, ALUResult : std_logic_vector(31 downto 0);
	signal SIGNIN : std_logic_vector(15 downto 0);
	signal A1, A2, A3, IMEMIN : std_logic_vector(5 downto 0);
	signal instr5_1, instr5_2, instr5_3, instr5_4, WriteReg : std_logic_vector(4 downto 0);

	begin
	ADDER1: adder port map(
					a => PCOut, 
					b => QUATRO,
					y => PCPlus4 
					);
	ADDER2: adder port map(
					a => AD1 ,
					b => PCPlus4,
					y => PCBranch
					);
	FLOPR1: flopr port map(
					d => PC1 ,
		        	rst => reset,
					clk => clk,
        			q => PCOut
					);
	MUX2_1: mux2 port map(
					d0 => PCPlus4,
					d1 => PCBranch,
	        		s => PCSrc,
	        		y => PCNext
					);
	MUX2_2: mux2 port map(
					d0 => PCNext,
					d1 => PCJump,
	        		s => Jump,
	        		y => PC1
					);
	MUX2_3: mux2 port map(
					d0 => WriteData,
					d1 => SignImm,
	        		s => AluSrc,
	        		y => SrcB
					);
	MUX2_4: mux2 port map(
					d0 => ALUResult,
					d1 => ReadData,
	        		s => MemToReg,
	        		y => Result
					);

	MUX2_5: mux2 	generic map( 
						MAX => 5
					)
					port map(
						d0 => instr5_1,
						d1 => instr5_2,	
						s => RegDst,
	        			y => WriteReg
					);
	IMEM1: imem port map(
					a => IMEMIN,
					rd => INSTRUCTION
					);
	REGFILE1: regfile port map(
						ra1 => instr5_3,
						ra2 => instr5_4,
						wa3 => WriteReg,
						wd3 => Result,
						we3 => RegWrite,
						clk => clk,
						rd1 => SrcA,
						rd2 => WriteData
						);
	SIGNEXT: sign port map(
					a => SIGNIN,
       				y => SignImm
					);
	ALU1: alu port map(
				a => SrcA,
				b => SrcB,
    	    	alucontrol => AluControl,
	    	    result => ALUResult,
    		    zero => ZEROs
				);
	SL2a: sl2 port map(
				a => SignImm,
		        y => AD1
				);
	DMEM1: dmem port map(
					a => ALUResult, 
					wd => WriteData,
					clk => clk,
					we => MemWrite,
					rd => ReadData,
					dump => DUMPS
					);

	QUATRO <= x"00000004"; --REVISAR!!!
	PCJump <= PCPlus4(31 downto 28) & INSTRUCTION(25 downto 0) & "00";
	PCSrc <= Branch and ZEROs;
	IMEMIN <= PCOut(7 downto 2); 

	instr5_1 <= INSTRUCTION(20 downto 16);
	instr5_2 <= INSTRUCTION(15 downto 11);
	instr5_3 <= INSTRUCTION(25 downto 21);
	instr5_4 <= INSTRUCTION(20 downto 16);
	SIGNIN <= INSTRUCTION(15 downto 0);

	instr <= INSTRUCTION;
	pc <= PCOut;

end architecture;


