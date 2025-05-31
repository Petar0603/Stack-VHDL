library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity stack_tb is
end stack_tb;

architecture stack_tb of stack_tb is

	component stack is
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
	end component;

	signal clk, rst, full, empty, en : std_logic;
	signal push_pop : std_logic;
	signal din, dout : std_logic_vector(7 downto 0);

	constant clk_period : time := 10 ns;
	constant ADDR_BITS : integer := 6;
	constant BIT_WIDTH : integer := 8;

begin

	uut: stack
		generic map(
			ADDR_BITS => ADDR_BITS,
			BIT_WIDTH => BIT_WIDTH
			)
		port map(
			clk => clk,
			en => en,
			push_pop => push_pop,
			rst => rst,
			din => din,
			full => full,
			empty => empty,
			dout => dout
			);

	clk_process: process begin

		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;

	end process;

	stim: process begin

		rst <= '1';
		push_pop <= '0';
		en <= '0';
		din <= "00000111"; -- 7
		wait for clk_period;

		rst <= '0';
		en <= '1';
		wait for clk_period;

		din <= "00000010"; -- 2
		wait for clk_period;

		din <= "00000001"; -- 1
		wait for clk_period;

		din <= "11111111"; -- 255
		wait for clk_period;

		en <= '0';
		wait for clk_period;

		push_pop <= '1';
		wait for clk_period;

		en <= '1';
		wait for clk_period*4;

		en <= '0';
		wait;

	end process;

end stack_tb;