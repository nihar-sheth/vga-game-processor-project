
-- VHDL Instantiation Created from source file counter.vhd -- 18:30:04 11/25/2019
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT counter
	PORT(
		DAC_clk : IN std_logic;          
		hsync : OUT std_logic;
		vsync : OUT std_logic
		);
	END COMPONENT;

	Inst_counter: counter PORT MAP(
		DAC_clk => ,
		hsync => ,
		vsync => 
	);


