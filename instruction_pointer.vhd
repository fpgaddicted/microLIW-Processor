----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:06:13 01/18/2018 
-- Design Name: 
-- Module Name:    instruction_pointer - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity instruction_pointer is
    Port ( clk : in  STD_LOGIC;
           instr_addr : out  STD_LOGIC_VECTOR (7 downto 0);
			  target_enable : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  jump_branch_target : in STD_LOGIC_VECTOR (7 downto 0);
           stall_if : in  STD_LOGIC);
end instruction_pointer;

architecture Behavioral of instruction_pointer is

signal pc : std_logic_vector (7 downto 0);

begin
	process (reset, target_enable, jump_branch_target, stall_if, clk)
		begin
			if rising_edge (clk) then
				if reset = '1' then
					pc <= (others => '0');
				elsif target_enable = '1' then
					pc <= jump_branch_target;	
				else
					pc <= pc + 1;
				end if;
			end if;
	end process;
		
	instr_addr <= pc;

end Behavioral;

