library ieee;
    use ieee.std_logic_1164.all;

entity IF_ID is
    port (
        clk : in std_logic;
        instr_in : in std_logic_vector(31 downto 0);
        pcplus4_in : in std_logic_vector(31 downto 0);
        instr_out : out std_logic_vector(31 downto 0);
        pcplus4_out : out std_logic_vector(31 downto 0)
    );

end entity;


architecture BH of IF_ID is
begin
    process (clk) begin
        if (clk'event and clk = '1') then
            instr_out <= instr_in;
            pcplus4_out <= pcplus4_in;
        end if;
    end process;
end BH;
