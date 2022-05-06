-------------------------------------------------------------------------------
-- Copyright (c) 2019 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 13.4
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : my_ila.vhd
-- /___/   /\     Timestamp  : Tue Nov 26 15:29:28 EST 2019
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY my_ila IS
  port (
    CONTROL: inout std_logic_vector(35 downto 0);
    CLK: in std_logic;
    DATA: in std_logic_vector(51 downto 0);
    TRIG0: in std_logic_vector(7 downto 0));
END my_ila;

ARCHITECTURE my_ila_a OF my_ila IS
BEGIN

END my_ila_a;
