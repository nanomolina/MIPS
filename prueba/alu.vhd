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

    signal Reg : std_logic_vector(31 downto 0);

begin

process(alucontrol, a, b, Reg)
begin
    case alucontrol is
        when "000" => Reg <= a and b;  --AND gate
        when "001" => Reg <= a or b; --OR gate
        when "010" => Reg <= a + b;  --addition
        when "100" => Reg <= a nand b; --NAND gate               
        when "101" => Reg <= a nor b;  --NOR gate
        when "110" => Reg <= a - b;  --substraction   
        when "111" => if a < b then Reg <= (others => '1');
                      else Reg <= (others => '0'); --SLT
                      end if;
        when others => Reg <= "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
    end case;
    result <= Reg;
    if (Reg = x"00000000") then
        zero <= '1';
    elsif (Reg = x"FFFFFFFF") then
        zero <= '0';
    end if;
end process;

end Behavioral;
