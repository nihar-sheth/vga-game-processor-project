----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:03:12 11/25/2019 
-- Design Name: 
-- Module Name:    paddles - Behavioral 
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

entity paddles is
    Port ( 
			  inclk : in  STD_LOGIC;
           s0 : in  STD_LOGIC;
           s1 : in  STD_LOGIC;
           s2 : in  STD_LOGIC;
           s3 : in  STD_LOGIC;
			  y1 : inout integer;
			  y2 : inout integer
			  --p1y : out integer;
			  --p2y : out integer
			  );
end paddles;

architecture Behavioral of paddles is
signal delay : integer := 0;
signal pos1 : integer := 240;
signal pos2 : integer := 240;
begin
	process(inclk) begin
	if(rising_edge(inclk)) then
		delay <= delay + 1;
		if(delay > 300000) then
			delay <= 0;
			if( (s0 xor s1) = '1') then
				if(s0 = '1') then
					pos1 <= pos1 + 1;
				else
					pos1 <= pos1 - 1;
				end if;
			end if;
			if( (s2 xor s3) = '1') then
				if(s2 = '1') then
					pos2 <= pos2 + 1;
				else
					pos2 <= pos2 - 1;
				end if;
			end if;
		end if;
		
		if(pos1 > 420) then pos1 <= 420; end if;
		if(pos1 < 60) then pos1 <= 60; end if;
		if(pos2 > 420) then pos2 <= 420; end if;
		if(pos2 < 60) then pos2 <= 60; end if;
	end if;
	end process;
	
y1 <= pos1;
y2 <= pos2;

end Behavioral;

