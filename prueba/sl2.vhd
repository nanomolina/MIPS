library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

entity sl2 is
    port(
        a: in std_logic_vector (31 downto 0);
        y: out std_logic_vector (31 downto 0)
    );
end entity;

architecture bh of sl2 is
begin
	process(a)
	begin
		y <= a(29 downto 0) & "00";
	end process;
end bh;
