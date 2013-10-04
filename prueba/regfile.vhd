library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;

entity regfile is
	port (
		--revisar las imputs son 5 BITS para MIPS??
		ra1, ra2, wa3: in std_logic_vector(4 downto 0);
		wd3: in std_logic_vector(31 downto 0);
		we3, clk: in std_logic;
		rd1, rd2: out std_logic_vector(31 downto 0)
	);
end entity;

architecture BH of regfile is
constant ZERO : std_logic_vector (4 downto 0) := "00000";
--memoria: 64 palabras de 32 bits--
type mem_reg is array (63 downto 0) of std_logic_vector(31 downto 0);
signal mem_r : mem_reg := (OTHERS => x"00000000");
--signal 

begin
	process (ra1, ra2, clk, mem_r)
--	variable temp1, temp2, temp3 : integer;
--	variable mem_r : mem_reg := (OTHERS => x"00000000");
	begin
		if (clk'event and clk='1'and we3='1') then 
			mem_r(conv_integer(wa3)) <= wd3;
		end if;

		if (ra1 = ZERO ) then rd1 <= x"00000000";
		else rd1 <= mem_r(conv_integer(ra1));
		end if;

		if (ra2 = ZERO) then rd2 <= x"00000000";
		else rd2 <= mem_r(conv_integer(ra2));
		end if;
	end process;
end BH;
		
	

