library ieee;
use ieee.std_logic_1164.all;

entity flopr is
    port (
        d: in std_logic_vector(31 downto 0);
        rst, clk:   in std_logic;     
        q: out std_logic_vector(31 downto 0));
end entity;

architecture behavior of flopr is
begin
process (clk, rst) begin
    if (rst = '1') then
        q <= (others => '0');
    elsif (clk'event and clk = '1') then
        q <= d;
    end if;
end process;
end architecture;
    
