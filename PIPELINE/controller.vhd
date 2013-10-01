library ieee;
use ieee.std_logic_1164.all;
library work;
use work.components.all;

entity controller is
    port (Op, Funct: in std_logic_vector(5 downto 0);
          MemToReg, MemWrite, Branch, AluSrc, RegDst, RegWrite,
          Jump: out std_logic;
          AluControl: out std_logic_vector(2 downto 0));
end entity;


architecture arq_controller of controller is
    component aludec
        port (funct: in std_logic_vector(5 downto 0);
              aluop: in std_logic_vector(1 downto 0);
              alucontrol: out std_logic_vector(2 downto 0));
    end component;
    component maindec
        port (Op: in std_logic_vector(5 downto 0);
              MemToReg, MemWrite, Branch, AluSrc, RegDst, RegWrite,
              Jump: out std_logic;
              AluOp: out std_logic_vector(1 downto 0));
    end component;
    signal AluOp: std_logic_vector(1 downto 0);

begin
    p0: maindec port map (Op, MemToReg, MemWrite, Branch, AluSrc, RegDst, RegWrite,
                        Jump, AluOp);
    p1: aludec port map(aluop => AluOp, Funct => funct, AluControl => alucontrol);
end architecture;
