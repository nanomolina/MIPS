library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
port(   a,b : in std_logic_vector(31 downto 0);
        alucontrol : in std_logic_vector(2 downto 0);
        result : out std_logic_vector(31 downto 0);
        zero: out std_logic
        );
end alu;

architecture Behavioral of alu is

--signal result : std_logic_vector(31 downto 0);

begin

process(alucontrol, a, b)
begin
    case alucontrol is
        when "000" => 
            result <= a and b;  --AND gate
        when "001" => 
            result <= a or b; --OR gate
        when "010" => 
            result <= a + b;  --addition
        when "100" => 
            result <= a nand b; --NAND gate               
        when "101" => 
            result <= a nor b;  --NOR gate
        when "110" => 
            result <= a - b;  --substraction   
        when "111" =>
            if a < b then 
                result <= (others => '1');
            else
                result <= (others => '0'); --SLT
            end if;
        when others =>
            result <= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
    end case;
--    if (result = x"00000000") then
--        zero <= '1';
--    elsif (result = x"FFFFFFFF") then
--        zero <= '0';
--    end if;
end process;

end Behavioral;
