----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:33:00 11/06/2019 
-- Design Name: 
-- Module Name:    project2 - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity project2 is
    Port ( 
	 clk : in  STD_LOGIC;
	 hysnc : out std_logic;
	 vsync : out std_logic;
	 rout	 : out std_logic_vector(7 downto 0);
	 gout	 : out std_logic_vector(7 downto 0);
	 bout	 : out std_logic_vector(7 downto 0);
	 sw0   : out std_logic;
	 sw1 	 : out std_logic;
	 sw2   : out std_logic;
	 sw3   : out std_logic);
end project2;

architecture Behavioral of project2 is

-- paddle movement constraints
constant p_top 		: integer := 5;
constant p_bottom 	: integer := 475;
-- size of paddle/ball
constant b_len		: integer := 4;
constant p_len		: integer := 10;
constant p_wid		: integer := 4;
-- ball movement
signal b_x 		: integer range 5 to 475:= 315;
signal b_y 		: integer range 5 to 635:= 235;
signal b_xvel 	: integer range -1 to 1 := 1;
signal b_yvel 	: integer range -1 to 1 := 1;

-- paddle movement
signal p_x 			: integer range 5 to 475 := 610;
signal p_y 			: integer range 5 to 635:= 230;
signal p_yvel		: integer range -1 to 1 := 0;

begin
paddle_move : process(clk) begin
	-- keeping paddle in bounds
	if(p_y <= top) then
		p_y <= top;
	end if;	
	if(p_w+p_len >= bottom) then
		p_w <= bottom - p_len;
	end if;
	-- sw0-> up, sw1-> down (XOR)
	if(sw0 = '1' and sw1 = '0') then
		p_yvel <= 1;
	elsif (sw0 = '0' and sw1 = '1') then
		p_yvel <= -1;
	else
		p_yvel <= 0;
	end if;
end process;

ball_move : process(clk) begin

end process;
proc_name: process(clk) begin
	if(clk'event and clk = '1') then
	
	end if;
end process;

end Behavioral;

