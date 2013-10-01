library ieee;
use ieee.std_logic_1164.all;

entity maindec is
    port (Op: in std_logic_vector(5 downto 0);
          MemToReg, MemWrite, Branch, AluSrc, RegDst, RegWrite,
          Jump: out std_logic;
          AluOp: out std_logic_vector(1 downto 0));
end entity;

architecture arq_maindec of maindec is
    signal parcial_result: std_logic_vector(8 downto 0);
begin
    parcial_result <= ("110000010") when (Op = "000000") else
                      ("101001000") when (Op = "100011") else
                      ("001010000") when (Op = "101011") else
                      ("000100001") when (Op = "000100") else
                      ("101000000") when (Op = "001000") else
                      ("000000100") when (Op = "000010") else
                      ("---------");

    RegWrite <= parcial_result(8);
    RegDst <= parcial_result(7);
    AluSrc <= parcial_result(6);
    Branch <= parcial_result(5);
    MemWrite <= parcial_result(4);
    MemToReg <= parcial_result(3);
    Jump <= parcial_result(2);
    AluOp <= parcial_result(1 downto 0);

end architecture;
