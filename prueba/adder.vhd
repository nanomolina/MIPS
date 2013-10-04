library ieee;
	use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use ieee.numeric_std.all;

entity adder is
    port(
        a : in std_logic_vector(31 downto 0);
        b : in std_logic_vector(31 downto 0);
		y : out std_logic_vector(31 downto 0) 
	);
end entity;

architecture BH of adder is
begin
	process(a, b) begin
	y <=  a + b;
	end process;
end BH;
