----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:59:58 11/25/2019 
-- Design Name: 
-- Module Name:    counter - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter is
    Port ( DAC_clk : in  STD_LOGIC;
			  --h : out integer;
			  --v : out integer;
           hsync : out  integer;
           vsync : out  integer);
end counter;

architecture Behavioral of counter is
signal h : integer := 0;
signal v : integer := 0;
begin
	process(DAC_clk) begin
		if(rising_edge(DAC_clk)) then
			if(h < 799) then
				h <= h + 1;
			else
				h <= 0;
				if(v < 524) then
					v <= v + 1;
				else
					v <= 0;
				end if;
			end if;
		end if;
	end process;

	hsync <= h;
	vsync <= v;
	--hsync <= std_logic_vector(to_unsigned(h, hsync'length));
	--vsync <= std_logic_vector(to_unsigned(v, vsync'length));
	
end Behavioral;

