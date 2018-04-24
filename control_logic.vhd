----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:05:15 03/16/2018 
-- Design Name: 
-- Module Name:    control_logic - Behavioral 
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

entity control_logic is
    Port ( dm_we0 : out  STD_LOGIC_VECTOR (0 downto 0);
           dm_we1 : out  STD_LOGIC_VECTOR (0 downto 0);
           alu0_src : out  STD_LOGIC;
           alu1_src : out  STD_LOGIC;
           we_rd0 : out  STD_LOGIC;
           we_rd1 : out  STD_LOGIC;
		   alu_op0 : out STD_LOGIC_VECTOR (3 downto 0);
		   alu_op1 : out STD_LOGIC_VECTOR (3 downto 0);
		   data_select0 : out STD_LOGIC;
		   data_select1 : out STD_LOGIC;
		   bgt_e : out STD_LOGIC;
		   blt_e : out STD_LOGIC;
		   beq_e : out STD_LOGIC;
		   jump_e : out STD_LOGIC;
           opcode0 : in  STD_LOGIC_VECTOR (3 downto 0);
           opcode1 : in  STD_LOGIC_VECTOR (3 downto 0));
end control_logic;

architecture Behavioral of control_logic is

begin
	process (opcode0, opcode1)
		begin
		
					--DESTINATION REGISTER (rd) WRITE ENABLE CONTROL--
					
			if opcode0 = X"0" or opcode0 = X"A" or opcode0 = X"B" or opcode0 = X"C" or opcode0 = X"D" or opcode0 = X"F" then
				we_rd0 <= '0';
			else
				we_rd0 <= '1';
			end if;
			
			if opcode1 = X"0" or opcode1 = X"A" or opcode1 = X"B" or opcode1 = X"C" or opcode1 = X"D" or opcode1 = X"F"  then
				we_rd1 <= '0';
			else
				we_rd1 <= '1';
				
			end if;
					-- ALU DATA SOURCE (rt/imm) CONTROL--
			if opcode0 = "0010" or opcode0 = "0100" or opcode0 = "0110" then
				alu0_src <= '1';
			else 
				alu0_src <= '0';
			end if;
			
			if opcode1 = "0010" or opcode1 = "0100" or opcode1 = "0110" then
				alu1_src <= '1';
			else
				alu1_src <= '0';
			end if;
			
					-- DATA MEMORY WRITE ENABLE CONTROL--
			if opcode0 = X"F" then 
				dm_we0 <= "1";
			else
				dm_we0 <= "0";
			end if;
			
		   if opcode1 = X"F" then
				dm_we1 <= "1";
			else
				dm_we1 <= "0";
			end if;
			
				-- DESTINATION REGISTER DATA SOURCE (DATA MEMORY / ALU)--
			if opcode0 = "1110" then
				data_select0 <= '1';
			else
				data_select0 <= '0';
			end if;
			
			if opcode1 = "1110" then
				data_select1 <= '1';
			else
				data_select1 <= '0';
			end if;		
	end process;
	
			-- ALU OP DECODE-- 
	alu_op0 <= X"0" when opcode0 = "0000" or opcode0 = "0010" or opcode0 = "0010" else -- add / addi /nop
				  X"1" when opcode0 = "0011" or opcode0 = "0100" else -- sub / subi
				  X"2" when opcode0 = "0101" or opcode0 = "0110" else -- or/ori
				  X"3" when opcode0 = "0111" else -- and
				  X"4" when opcode0 = "1000" else -- nor
				  X"5" when opcode0 = "1001" else -- nand
				  "0000";
				 
	alu_op1 <= X"0" when opcode1 = "0000" or opcode1 = "0010" or opcode1 = "0010" else -- add / addi /nop
				  X"1" when opcode1 = "0011" or opcode1 = "0100" else -- sub / subi
				  X"2" when opcode1 = "0101" or opcode0 = "0110" else -- or/ori
				  X"3" when opcode1 = "0111" else -- and
				  X"4" when opcode1 = "1000" else -- nor
				  X"5" when opcode1 = "1001" else -- nand
				  "0000";
				  
			
			--BRANCH CONTROL--
			
	beq_e <= '1' when opcode0 = X"A" else '0'; -- branch on equal
	bgt_e <= '1' when opcode0 = X"B" else '0'; -- branch on greater than
	blt_e <= '1' when opcode0 = X"C" else '0'; -- branch on less than
	jump_e <= '1' when opcode0 = X"D" else '0'; -- jump to target / function
				
		

end Behavioral;

