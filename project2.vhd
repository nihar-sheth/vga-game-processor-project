
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.Numeric_STD.ALL;


entity project2 is
    Port ( 	clk 					: in   STD_LOGIC;
				SW0,SW1,SW2,SW3 	: in   STD_LOGIC;
				DAC_CLK 				: out  STD_LOGIC;
				H 						: out  STD_LOGIC;
				V 						: out  STD_LOGIC;
				Bout 					: out  STD_LOGIC_VECTOR (7 downto 0);
				Gout 					: out  STD_LOGIC_VECTOR (7 downto 0);
				Rout 					: out  STD_LOGIC_VECTOR (7 downto 0)
				);
end project2;

architecture Behavioral of project2 is
-- For VGA Horizontal Parameters
	--Front Porch 			: 16
	--Sync Pulse			: +96
	--Back Porch			: +48
	--Active Image Area	: +640
	--Complete Line 		: =800
	
-- For VGA Vertical Parameters
	--Front Porch 			: 10  Lines
	--Sync Pulse			: +2  Lines
	--Back Porch			: +33  Lines
	--Active Image Area	: +480 Lines
	--Complete Line 		: =525 Lines
--VGA Control & Color Signals
	signal x, y, VSync, HSync, hBP, vBP	: integer := 0;
	signal sR,sB,sG 			: STD_LOGIC_VECTOR(7 downto 0):= "00000000";
	signal sH, sV,sDAC_CLK : STD_LOGIC :='0';

------------------------------------------------------------------
--Graphics

--Paddles: Each paddle will have x, y coordinate incidating the center. Paddle will be 61 pixels by 21
--			  Height 30 Up and down from x
--			  Width  10 left and right from y
	
	-- Y positions of paddles 
	signal p1_y : integer := 240;
	signal p2_y : integer := 240;
	
	--signal sw1, sw2, sw3, sw4 : std_logic;
	
	--Used to slow down the ball
	signal ballcounter : integer;
	
--Ball  -- radius of 5 pixels, x and y coordinate
	signal ballx : integer := 80;
	signal bally : integer := 80;
	
	--Motion Vector for the ball
	signal x_vel :integer := 1; 
	signal y_vel :integer := 1;

--Score
	--used to pause the ball after a goal is made.
	signal pause			: integer :=0;
	
	--H- and V-count 
	COMPONENT counter
	PORT(
		DAC_clk : IN std_logic;          
		hsync : OUT integer;
		vsync : OUT integer
		);
	END COMPONENT;
	
	--DAC_CLK generator
	COMPONENT clock_gen
	PORT(
		in_clk : IN std_logic;          
		out_clk : OUT std_logic
		);
	END COMPONENT;
	
	--Paddle movement
	COMPONENT paddles
	PORT(
		inclk : IN std_logic;
		s0 : IN std_logic;
		s1 : IN std_logic;
		s2 : IN std_logic;
		s3 : IN std_logic;
		y1 : INOUT integer;
		y2 : INOUT integer
		);
	END COMPONENT;
	
	COMPONENT my_icon
	PORT(
		CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0)
		);
	END COMPONENT;
	signal control0 : std_logic_vector(35 downto 0);
	signal ila_data : std_logic_vector (51 downto 0);
	signal trig0 : std_logic_vector(7 downto 0);
	
	component my_ila
	PORT(
		CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
		CLK : IN STD_LOGIC;
		DATA : IN STD_LOGIC_VECTOR(51 DOWNTO 0);
		TRIG0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
		);
	END COMPONENT;
begin

	icon : my_icon	port map (CONTROL0 => control0);
  
	ila : my_ila port map (
    CONTROL => control0,
    CLK => clk,
    DATA => ila_data,
    TRIG0 => trig0);
	
	--Produce DAC_CLK by cuting the clk in half
	Inst_clock_gen: clock_gen PORT MAP(
		in_clk => clk,
		out_clk => sDAC_CLK
	);
	
	--H and V Counters - generates H sync and v sync
	Inst_counter: counter PORT MAP(
		DAC_clk => sDAC_CLK,
		hsync => HSync,
		vsync => VSync
	);
	
--Parallel Code
	
	--h_sync
	--HI for image + front porch 640 + 16
	--LOW for sync pulse length
	--Hi for image + front + back porch 640 + 16 + 96	
	sH <=	'1' when (HSync < 656) OR (HSync > 752) else	'0';
	
	--v_sync
	--HI for image + front porch
	--Low for sync pulse length
	--HI for image + front + back porch
	sV <=	'1' when (VSync < 490) OR (VSync > 492) else '0';
			
	--the x and y coordinates point to the current pixel being drawn
	-- otherwise they are unknown
	x <= HSync when (HSync < 640);-- else X;
	
	y <= VSync when (VSync < 480);-- else X;
	
--PONG GAME Logic:
	
	--Paddle Movement
	--SW0: Player 1 UP, SW1: Player 1 DOWN 
	Inst_paddles: paddles PORT MAP(
		inclk => sDAC_CLK,
		s0 => SW0,
		s1 => SW1,
		S2 => SW2,
		S3 => SW3,
		y1 => p1_y,
		y2 => p2_y
	);
	
	--Ball Movement
	--Ball moves faster than paddles
	process(sDAC_CLK)
	begin
	if (rising_edge(sDAC_CLK)) then
		ballcounter <= ballcounter + 1;
		if (ballcounter > 150000) then
			ballcounter <= 0; --artificial slowdown of ball movement
			ballx <= ballx + x_vel;
			bally <= bally + y_vel;
			--Goal position: 160<y<320
			--Checks if player 1 scored a goal
			if ((ballx + x_vel - 4) <= 20) AND 
			( ((bally + y_vel - 4) > 160) AND ((bally + y_vel + 4) < 320 ) ) then
					pause <= pause + 1;
					x_vel <= 0;
					y_vel <= 0;
					if (pause = 20) then
						ballx <= 320;
						bally <= 240;
						pause <= 0;
						x_vel <= 1;
						y_vel <= 1;
					end if;
			end if;
			---Checks if player 2 scored a goal		
			if ((ballx + x_vel + 4) >= 620) AND 
			( ((bally + y_vel - 4) > 160) AND ((bally + y_vel + 4) < 320 ) ) then
					pause <= pause + 1;
					x_vel <= 0;
					y_vel <= 0;
					if (pause = 20) then
						ballx <= 320;
						bally <= 240;
						pause <= 0;
						x_vel <= -1;
						y_vel <= 1;
					end if;
			end if;
			if (bally >= p1_y - 30) AND (bally <= p1_y + 30) then
				if(ballx >= 65 AND ballx <= 70) then --right side of p1 paddle
					x_vel <= +1;
				elsif (ballx < 65 AND ballx >= 60) then --left side of p1 paddle
					x_vel <= -1;
				end if;
			end if;
			if (bally >= p2_y - 30) AND (bally <= p2_y + 30) then
				if(ballx <= 575 AND ballx >= 570) then --left side of p2 paddle
					x_vel <= -1;
				elsif (ballx > 575 AND ballx <= 580) then --right side of p2 paddle
					x_vel <= +1;
				end if;
			end if;
				--Check for collision between ball and  paddles (back and front)
				--if (((ballx - 4 <= 70) AND (ballx + 4 > 60)) AND ( (p1_y+30 > bally + y_vel + 4 ) AND (p1_y-30 < bally + y_vel - 4) ) ) 
				--OR (((ballx + x_vel + 4 > 570) AND (ballx + x_vel - 4 < 580)) AND ( (p2_y+30 > bally + y_vel + 4 ) AND (p2_y-30 < bally + y_vel - 4) )) Then
				--	x_vel <= -x_vel;
					--ballx <= ballx + 4*x_vel;
					--Check for collision with borders
					--vertical borders
			if(bally <= 160 or bally >320) then
					if (ballx + x_vel +4 > 600) then 
						x_vel <= -1;
					elsif (ballx + x_vel - 4 < 40) then 
						x_vel <= +1;
					end if;
			end if;
					--horizontal borders
			if (bally + y_vel + 4 > 450) then
					y_vel <= -1;
			elsif (bally +y_vel -4 < 30) then
					y_vel <= 1;
			end if;
			-- Updates  the ball condition with the ball motion vector
			--end if;
		end if; --if ball updates
	end if; --rising edge
	end process;
	
	--Background drawing process
	process (sDAC_CLK)
	begin
			if (VSync < 480 AND HSync < 640) then -- Active Region
				--Above game borders
				if ((y < 10) OR (y > 470)) then
					sR <= "10000000";
					sG <= "11111111";
					sB <= "01111111";
				--White game border
				elsif(  ((y > 15 AND y < 30) AND (x > 30 AND x < 610)) OR 
				((y < 465 AND y>450) AND (x > 30 AND x < 610)) OR 
				(((y>15 AND y<160) OR (y>320 AND y<465)) AND (x>30 AND x<45)) OR 
				(((y>15 AND y<160) OR (y>320 AND y<465)) AND (x>595 AND x<610))) then
					sR <= "11111111";
					sG <= "11111111";
					sB <= "11111111";
			   --Create Yellow Dividing Line in the Center (center = 640/2 +-2
				elsif ((x > 318 AND x < 322) AND ((y>60 AND y<100) OR 
				(y>140 AND y<180) OR  (y>220 AND y<260) OR 
				(y>300 AND y<340) OR  (y>380 AND y<420))) then
					sR <= "11111111";
					sG <= "11111111";
					sB <= "00000000";
						--Draw Paddle One (left)                -Back    -Front
					elsif ((y>(p1_y-30) AND y<(p1_y+30)) AND (x>60 AND x<70)) then
						sB <= "11111111";	
						sR <= "00000000";
						sG <= "00000000";							
						--Draw Paddle 2 (right)							  -Front		-Back
					elsif ((y>(p2_y-30) AND y<(p2_y+30)) AND (x>570 AND x<580)) then
						sB <= "11111111";
						sR <= "00000000";
						sG <= "00000000";
						--Draw the ball
					elsif(((y > (bally-4)) AND (y < (bally+4)))  AND ((x > (ballx-4)) AND (x < (ballx+4)))) then
						if (pause > 0) then -- A goal was scored recently, then flash the ball for a frame
							sR <= "11111111";
							sG <= "00000000";
							sB <= "00000000";
						else --ball is yellow
							sR <= "11111111";
							sG <= "11111111";
							sB <= "00000000";
						end if;
					else
						--Make everything else a sickly-green
						sR <= "00000000"; 
						sG <= "11111111";
						sB <= "01111111";
				end if;	
				
			else -- Blanking Region is black
				sR <= "00000000";
				sG <= "00000000";
				sB <= "00000000";
			end if;
	end process;

	--Assign ouputs
	DAC_CLK <= sDAC_CLK;
	Rout <= sR;
	Gout <= sG;
	Bout <= sB;
	H	  <= sH;
	V	  <= sV;
	
	--Assign debug outputs
	ila_data(0) <= SDAC_CLK;
	ila_data(1) <= sH;
	ila_data(2) <= sV;
	ila_data(12 downto 3) <= std_logic_vector(to_unsigned(HSync, 10));
	ila_data(22 downto 13) <= std_logic_vector(to_unsigned(Vsync, 10));
	ila_data(30 downto 23) <= sR;
	ila_data(38 downto 31) <= sG;
	ila_data(46 downto 39) <= sB;
	ila_data(47) <= SW0;
	ila_data(48) <= SW1;
	ila_data(49) <= SW2;
	ila_data(50) <= SW3;
	ila_data(51) <= '0';
	trig0(0) <= sH;
	trig0(1) <= sV;
	trig0(7 downto 2) <= (others => '0');
end Behavioral;