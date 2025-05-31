-- this is a VHDL code for stack memory (LIFO - Last In First Out)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stack is

	generic(
		ADDR_BITS : integer := 6;
		BIT_WIDTH : integer := 8
		);

	port(

		clk : in std_logic;
		rst: in std_logic;
		push_pop : in std_logic;
		en : in std_logic;

		din : in std_logic_vector(BIT_WIDTH - 1 downto 0);
		dout : out std_logic_vector(BIT_WIDTH - 1 downto 0);

		empty : out std_logic;
		full : out std_logic

		);

end stack;

architecture arch of stack is

	component RAM is
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
	end component;

	signal top, top_minus_one : unsigned(ADDR_BITS - 1 downto 0);
	signal addr_mux : std_logic_vector(ADDR_BITS - 1 downto 0);
	signal we_i : std_logic;

begin

	-- top counter (write location in stack)
	process(clk, rst) begin

		if(rst = '1') then

			top <= (others => '0');

		elsif(clk'event and clk = '1' and en = '1') then

			if(push_pop = '0') then -- push operation

				top <= top + 1;

			else -- pop operation

				top <= top - 1;

			end if;

		end if;

	end process;

	-- top - 1 counter (read location in stack)
	process(clk, rst) begin

		if(rst = '1') then

			top_minus_one <= (others => '1');

		elsif(clk'event and clk = '1' and en = '1') then

			if(push_pop = '0') then -- push operation

				top_minus_one <= top_minus_one + 1;

			else -- pop operation

				top_minus_one <= top_minus_one - 1;

			end if;

		end if;

	end process;

	-- address multiplexer
	addr_mux <= std_logic_vector(top_minus_one) when push_pop = '1' else std_logic_vector(top);

	-- empty flag
	empty <= '1' when top = "000000" else '0';

	-- full flag
	full <= '1' when top = "111111" else '0';

	-- RAM port mapping
	we_i <= not push_pop;

	RAM_unit : RAM
		generic map(
			ADDR_BITS => ADDR_BITS,
			BIT_WIDTH => BIT_WIDTH
			)
		port map(
			clk => clk,
			rst => rst,
			en => en,
			we => we_i,
			addr => addr_mux,
			din => din,
			dout => dout
			);

end arch;