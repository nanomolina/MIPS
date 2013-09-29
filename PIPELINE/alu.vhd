library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity alu is
    port(
        a, b: in std_logic_vector(31 downto 0);
        alucontrol: in std_logic_vector(2 downto 0);
        result: out std_logic_vector(31 downto 0);
        zero: out std_logic
    );
end entity;

architecture behavior of alu is
begin
process(a,b,alucontrol)
    variable temp: std_logic_vector(31 downto 0);
    begin
    case alucontrol is
        when "000" =>
            temp := a and b;
        when "001" =>
            temp := a or b;
        when "010" =>
            temp := a + b;
        when "011" =>
            temp := x"00000000"; --preguntar
        when "100" =>
            temp := a and not(b);
        when "101" =>
            temp := a or not(b);
        when "110" =>
            temp := a - b;
        when "111" =>
            if (a < b) then
                temp := (others => '1');
            elsif (a > b) then
                temp := (others => '0');
            end if;
        when others =>
            temp := x"00000000";
    end case;
    if (temp = x"00000000") then
        zero <= '1';
    else
        zero <= '0';
    end if;

    result <= temp;


end process;
end behavior;
                



