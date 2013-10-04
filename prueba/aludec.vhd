library ieee;
use ieee.std_logic_1164.all;

entity aludec is
    port (funct: in std_logic_vector(5 downto 0);
          aluop: in std_logic_vector(1 downto 0);
          alucontrol: out std_logic_vector(2 downto 0));
end entity;

architecture arq_aludec of aludec is
begin
    alucontrol <= "010" when aluop = "00" else
                  "110" when aluop = "01" else
                  "010" when aluop(0) = '1' and funct = "100000" else
                  "110" when aluop(0) = '1' and funct = "100010" else
                  "000" when aluop(0) = '1' and funct = "100100" else
                  "001" when aluop(0) = '1' and funct = "100101" else
                  "111" when aluop(0) = '1' and funct = "101010" else
                  unaffected;
end architecture;
