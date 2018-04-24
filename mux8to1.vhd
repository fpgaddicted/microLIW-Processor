----------------------------------------------------------------------------------
-- Company: TEI OF CRETE
-- Engineer: Stefan Naco - fpgaddicted
-- 
-- Create Date:    00:32:17 12/03/2017 
-- Design Name: 
-- Module Name:    mux8to1 - Behavioral 
-- Project Name: VLIW_PROCESSOR
-- Target Devices: 
-- Tool versions: 
-- Description: 8 TO 1 ALU OUTPUT MULTIPLEXER
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

--8 TO 1 ALU OUTPUT MULTIPLEXER

entity mux8to1 is
    Port ( op_select : in  STD_LOGIC_VECTOR (2 downto 0);
           i0 : in  STD_LOGIC_VECTOR (15 downto 0);
           i1 : in  STD_LOGIC_VECTOR (15 downto 0);
           i2 : in  STD_LOGIC_VECTOR (15 downto 0);
           i3 : in  STD_LOGIC_VECTOR (15 downto 0);
           i4 : in  STD_LOGIC_VECTOR (15 downto 0);
           i5 : in  STD_LOGIC_VECTOR (15 downto 0);
           i6 : in  STD_LOGIC_VECTOR (15 downto 0);
           i7 : in  STD_LOGIC_VECTOR (15 downto 0);
           mux_out : out  STD_LOGIC_VECTOR (15 downto 0));
end mux8to1;

architecture Behavioral of mux8to1 is

begin
	process (op_select, i0,i1,i2,i3,i4,i5,i6,i7)
		begin
			case op_select is
				when "000" => mux_out <= i0;
				when "001" => mux_out <= i1;
				when "010" => mux_out <= i2;
				when "011" => mux_out <= i3;
				when "100" => mux_out <= i4;
				when "101" => mux_out <= i5;
				when "110" => mux_out <= i6;
				when "111" => mux_out <= i7;
				when others => mux_out <= "0000000000000000";
			end case;
	end process;


end Behavioral;

