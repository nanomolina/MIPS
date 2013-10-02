library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;

entity datapath_tb is
end entity;



architecture TB of datapath_tb is
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

	signal MemToReg, MemWrite, Branch, AluSrc, RegDst, RegWrite, Jump,
			 dump, reset, clk : std_logic;
	signal AluControl : std_logic_vector(2 downto 0);
	signal pc, instr: std_logic_vector(31 downto 0);

	begin
	dut : datapath port map (
						MemToReg => MemToReg,
						MemWrite => MemWrite,
						Branch => Branch,
						AluSrc => AluSrc,
						RegDst => RegDst,
						RegWrite => RegWrite,
						Jump => Jump,
						AluControl => AluControl,
						dump => dump,
						pc => pc,
						instr => instr,
						reset => reset,
						clk => clk
					);

	process begin
		clk <= '1';
		wait for 5 ns;
		clk <= '0';
		wait for 5 ns;
	end process;

	process begin
		
		--ADD--
		reset <= '1';
		wait for 2 ns;
		reset <= '0';
		
		MemToReg <= '0';
		MemWrite <= '0';
		Branch <= '0'; --??
		AluSrc <= '1';
		RegDst <= '0'; --??
		RegWrite <= '1';
		Jump <= '1';	
		AluControl <= "010";
		
		dump <= '1';
		wait for 20 ns;
		dump <= '0';
	
	end process;
	

end TB;
