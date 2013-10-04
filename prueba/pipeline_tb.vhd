library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;


entity pipeline_tb is
end entity;

architecture TB of pipeline_tb is
	component pipeline
	port(
		dump : in std_logic;

		pc : out std_logic_vector(31 downto 0);
		instr : out std_logic_vector(31 downto 0);

		reset : in std_logic;
		clk : in std_logic
	);
	end component;


	signal pc, instr: std_logic_vector(31 downto 0);
	signal dump, reset, clk: std_logic;

	begin
	dut: pipeline port map(
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
		--01094020  (add $t0 $t0 $t1)

		--en binario:
		--0000 0001 0000 1001 0100 0000 0010 0000
		dump <= '0';
		reset <= '1';
        wait for 20 ns;
        reset <= '0';
		wait for 170 ns;
		dump <= '1';
		wait for 30 ns;
		dump <= '0';
	end process;

--	process begin
--		wait for 170 ns;
--		dump <= '1';
--		wait for  ns;
--		dump <= '0';
--	end process;
end TB;
