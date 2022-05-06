----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:27:54 11/25/2019 
-- Design Name: 
-- Module Name:    clock_gen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clock_gen is
    Port ( in_clk : in  STD_LOGIC;
           out_clk : out  STD_LOGIC);
end clock_gen;

architecture Behavioral of clock_gen is
signal sclk : std_logic := '0';
begin
	process(in_clk) begin
		if(rising_edge(in_clk)) then
			sclk <= NOT sclk;
		end if;
	end process;
	out_clk <= sclk;

end Behavioral;

