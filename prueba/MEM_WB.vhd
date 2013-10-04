library ieee;
    use ieee.std_logic_1164.all;

entity MEM_WB is
    port (
        AluOut_in : in std_logic_vector(31 downto 0);
        ReadData_in : in std_logic_vector(31 downto 0);
        WriteReg_in : in std_logic_vector(4 downto 0);

        RegWrite_in: in std_logic;
        MemToReg_in: in std_logic;

        clk : in std_logic;

        RegWrite_out: out std_logic;
        MemToReg_out: out std_logic;


        AluOut_out : out std_logic_vector(31 downto 0);
        ReadData_out : out std_logic_vector(31 downto 0);
        WriteReg_out : out std_logic_vector(4 downto 0)


    );
end entity;


architecture BH of MEM_WB is
begin

    process (clk) begin
        if (clk'event and clk = '1') then
            RegWrite_out <= RegWrite_in;
            MemToReg_out <= MemToReg_in;


            AluOut_out <= AluOut_in;
            ReadData_out <= ReadData_in;
            WriteReg_out <= WriteReg_in;
        end if;
    end process;
end BH;
