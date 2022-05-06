-------------------------------------------------------------------------------
-- Copyright (c) 2019 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 13.4
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : my_icon.vhd
-- /___/   /\     Timestamp  : Tue Nov 26 15:25:28 EST 2019
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY my_icon IS
  port (
    CONTROL0: inout std_logic_vector(35 downto 0));
END my_icon;

ARCHITECTURE my_icon_a OF my_icon IS
BEGIN

END my_icon_a;
