library ieee;
    use ieee.std_logic_1164.all;

entity ID_EX is
    port (
        RtD_in : in std_logic_vector(4 downto 0);
        RdD_in : in std_logic_vector(4 downto 0);
        SignImm_in : in std_logic_vector(31 downto 0);
        RD1_in : in std_logic_vector(31 downto 0);
        RD2_in : in std_logic_vector(31 downto 0);
    
        PCPlus4_in: in std_logic_vector(31 downto 0);

		MemToReg_in:	in std_logic;
		MemWrite_in:	in std_logic;
		Branch_in:		in std_logic;
		AluSrc_in:		in std_logic;
		RegDst_in:		in std_logic;
		RegWrite_in:	in std_logic;
		Jump_in:		in std_logic;
		alucontrol_in: in std_logic_vector (2 downto 0);


        clk : in std_logic;

        PCPlus4_out: out std_logic_vector(31 downto 0);

		MemToReg_out:	out std_logic;
		MemWrite_out:	out std_logic;
		Branch_out:		out std_logic;
		AluSrc_out:		out std_logic;
		RegDst_out:		out std_logic;
		RegWrite_out:	out std_logic;
		Jump_out:		out std_logic;
		alucontrol_out: out std_logic_vector (2 downto 0);

        RtD_out : out std_logic_vector(4 downto 0);
        RdD_out : out std_logic_vector(4 downto 0);
        SignImm_out : out std_logic_vector(31 downto 0);
        RD1_out : out std_logic_vector(31 downto 0);
        RD2_out : out std_logic_vector(31 downto 0)
    );

end entity;


architecture BH of ID_EX is
begin
    process (clk) begin
        if (clk'event and clk = '1') then
            MemToReg_out <= MemToReg_in;
		    MemWrite_out <= MemWrite_in;
		    Branch_out <= Branch_in;
		    AluSrc_out <= AluSrc_in;
		    RegDst_out <= RegDst_in;
		    RegWrite_out <= RegWrite_in;
		    Jump_out <= Jump_in;
		    alucontrol_out <= alucontrol_in;

            RtD_out <= RtD_in;
            RdD_out <= RdD_in;
            SignImm_out <= SignImm_in;
            RD1_out <= RD1_in;
            RD2_out <= RD2_in;
            
        end if;
    end process;
end BH;
