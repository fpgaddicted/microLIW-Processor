----------------------------------------------------------------------------------
-- Company: TEI OF CRETE
-- Engineer: Stefan Naco - fpgaddicted
-- 
-- Create Date:    17:56:03 11/27/2017 
-- Design Name: 
-- Module Name:    bitinvert - Behavioral 
-- Project Name: VLIW_PROCESSOR
-- Target Devices: 
-- Tool versions: XILINX ISE 14.7
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - FIRST IMPLEMENTATION
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bitinvert is
    Port ( addend : in  STD_LOGIC_VECTOR (15 downto 0);
           comp_out     : out  STD_LOGIC_VECTOR (15 downto 0);
           sub_select : in  STD_LOGIC);
end bitinvert;

architecture Behavioral of bitinvert is

signal inverted_addend : std_logic_vector (15 downto 0);

begin
	inverted_addend <= not addend;
	process(sub_select,addend, inverted_addend)
		begin
			if sub_select = '1' then
				comp_out <= inverted_addend; -- SELECT BIT INVERT FOR SUB / BITWISE OPS
			else 
				comp_out <= addend;
			end if;
	end process;

end Behavioral;

