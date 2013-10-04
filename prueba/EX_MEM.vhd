library ieee;
    use ieee.std_logic_1164.all;

entity EX_MEM is
    port (
        Zero_in : in std_logic;
        AluOut_in : in std_logic_vector(31 downto 0);
        WriteData_in : in std_logic_vector(31 downto 0);
        WriteReg_in : in std_logic_vector(4 downto 0);
        PCBranch_in : in std_logic_vector(31 downto 0);

        RegWrite_in: in std_logic;
        MemToReg_in: in std_logic;
        MemWrite_in: in std_logic;
        Jump_in: in std_logic;
        Branch_in: in std_logic;

        clk : in std_logic;

        RegWrite_out: out std_logic;
        MemToReg_out: out std_logic;
        MemWrite_out: out std_logic;
        Jump_out: out std_logic;
        Branch_out: out std_logic;

        Zero_out : out std_logic;
        AluOut_out : out std_logic_vector(31 downto 0);
        WriteData_out : out std_logic_vector(31 downto 0);
        WriteReg_out : out std_logic_vector(4 downto 0);
        PCBranch_out : out std_logic_vector(31 downto 0)

    );
end entity;


architecture BH of EX_MEM is

begin
    process (clk) begin
        if (clk'event and clk = '1') then
            RegWrite_out <= RegWrite_in;
            MemToReg_out <= MemToReg_in;
            MemWrite_out <= MemWrite_in;
            Jump_out <= Jump_in;
            Branch_out <= Branch_in;
        
            Zero_out <= Zero_in;
            AluOut_out <= AluOut_in;
            WriteData_out <= WriteData_in;
            WriteReg_out <= WriteReg_in;
            PCBranch_out <= PCBranch_in;
        end if;
    end process;
end BH;
