library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is

	generic(
		ADDR_BITS : integer;
		BIT_WIDTH : integer
		);

	port(
		rst : in std_logic;
		clk : in std_logic;
		din : in std_logic_vector(BIT_WIDTH - 1 downto 0);
		addr : in std_logic_vector(ADDR_BITS - 1 downto 0);
		we : in std_logic;
		en : in std_logic;
		dout : out std_logic_vector(BIT_WIDTH - 1 downto 0)
	);

end ram;

architecture arch of RAM is

	type reg_array is array ((2**ADDR_BITS - 1) downto 0) of std_logic_vector(BIT_WIDTH - 1 downto 0);
	signal memory : reg_array := (others => (others => '0'));

begin

	process(clk, rst)
	begin
		if(rst = '1') then
			memory <= (others => (others => '0'));
		elsif(clk'event and clk = '1' and en = '1') then
			if we = '1' then
				memory(to_integer(unsigned(addr))) <= din;
			end if;
		end if;
	end process;

	dout <= memory(to_integer(unsigned(addr))) when (we = '0' and en = '1') else (others => 'Z');

end arch;