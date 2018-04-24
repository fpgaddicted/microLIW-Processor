----------------------------------------------------------------------------------
-- Company: TEI OF CRETE
-- Engineer: Stefan Naco - fpgaddicted
-- 
-- Create Date:    01:30:02 12/03/2017 
-- Design Name: 
-- Module Name:    aluop_dec - Behavioral 
-- Project Name: VLIW_PROCESSOR
-- Target Devices: 
-- Tool versions: XILINX ISE 14.7
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.02 corrected bw.nor instruction
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity aluop_dec is
    Port ( I_op : in  STD_LOGIC_VECTOR (2 downto 0);
           O_ainv : out  STD_LOGIC;
           O_binv : out  STD_LOGIC;
           O_carryin : out  STD_LOGIC;
           O_muxctrl : out  STD_LOGIC_VECTOR (2 downto 0));
end aluop_dec;

architecture Behavioral of aluop_dec is
signal int_op_sig : std_logic_vector (5 downto 0); -- to be splitted in indiv. outputs

begin
	process (I_op)
		begin
			case I_op is
				when "000" => int_op_sig <= "000000"; --add
				when "001" => int_op_sig <= "011000"; --sub
				when "010" => int_op_sig <= "000001"; --or
				when "011" => int_op_sig <= "000010"; --and
				when "100" => int_op_sig <= "110010"; --nor
				when "101" => int_op_sig <= "110001"; --nand
				when "110" => int_op_sig <= "000110"; --mul !!
				when "111" => int_op_sig <= "000111"; --div !!
				when others => int_op_sig <= "XXXXXX";
			end case;
	end process;
	--signal split from the main "int_op_bus" --
	
	O_ainv <= int_op_sig(5);
	O_binv <= int_op_sig(4);
	O_carryin <= int_op_sig(3);
	O_muxctrl <= int_op_sig(2 downto 0);
	
end Behavioral;

