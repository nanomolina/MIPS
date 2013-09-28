library ieee;
use ieee.std_logic_1164.all;

entity sign is
    port(a: in std_logic_vector(15 downto 0);
          y: out std_logic_vector(31 downto 0));
end entity;

architecture behavior of sign is
begin
    process (a) 
        variable v : std_logic_vector(15 downto 0);
        begin
       
        if (a(0)='1') then
            v := (others => '1');
            y <= (a & v);
        elsif (a(0)='0') then
            v := (others => '0');
            y <= (a & v);
        end if;

    end process;
end architecture;
