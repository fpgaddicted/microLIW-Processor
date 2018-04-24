----------------------------------------------------------------------------------
-- Company: TEI OF CRETE	
-- Engineer: Stefan Naco - fpgaddicted
-- 
-- Create Date:    17:26:01 11/27/2017 
-- Design Name: 
-- Module Name:    adder16bit - Behavioral 
-- Project Name: VLIW PROCESSOR
-- Target Devices: 
-- Tool versions: XILINX ISE 14.7
-- Description: 16bit adder - substractor 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder16bit is
    Port ( add_a : in  STD_LOGIC_VECTOR (15 downto 0);
           add_b : in  STD_LOGIC_VECTOR (15 downto 0);
           add_sub : in  STD_LOGIC;  -- REPURPOSED CARRY IN FOR SUBSTRACTION CONTROL
           carry_out : out  STD_LOGIC;
           result : out  STD_LOGIC_VECTOR (15 downto 0));
end adder16bit;

architecture Behavioral of adder16bit is

signal ext_a, ext_b,sum :std_logic_vector (16 downto 0); --17bit extension

begin
	ext_a <= ('0'&add_a); --EXTENSION TO 17BIT/FILL MSB WITH ZERO
	ext_b <= ('0'&add_b); -- EXTENSION TO 17BIT/FILL MSB WITH ZERO
	sum <= (ext_a + ext_b + add_sub); --ADD CONTENTS - SUBSTRACTION CONTROL
	result <= sum (15 downto 0); -- SUM OUTPUT / SEPARATE 16BIT
	carry_out <= sum (16); -- CARRY OUTPUT / MSB
	
end Behavioral;

