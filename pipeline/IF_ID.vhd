----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:26:17 01/24/2018 
-- Design Name: 
-- Module Name:    IF_ID - Behavioral 
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


entity IF_ID is 
    Port ( 
			clk : in  STD_LOGIC; 
			next_pc : in STD_LOGIC_VECTOR (7 downto 0); -- Branch or Jump target address from EX/MEM
			br_en : in STD_LOGIC; -- Branch / Jump enable from EX/MEM
			reset : in STD_LOGIC; -- PROGRAM RESET / PROCESSOR MASTER RESET
			instr_out : out  STD_LOGIC_VECTOR (39 downto 0); -- Instruction output to ID/EX
			stall : in  STD_LOGIC); -- Stop instruction issue / pipeline flush - stall 
end IF_ID;

architecture Behavioral of IF_ID is

	component instruction_pointer is
		port ( 
			clk : in  STD_LOGIC;
			target_enable : in STD_LOGIC;
			reset : in STD_LOGIC;
			jump_branch_target : in STD_LOGIC_VECTOR (7 downto 0);
			instr_addr : out  STD_LOGIC_VECTOR (7 downto 0);
            stall_if : in  STD_LOGIC);
	end component;
		
	COMPONENT instruction_memory
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(39 DOWNTO 0)
  );
END COMPONENT;

signal i_a : std_logic_vector (7 downto 0);
signal instr : std_logic_vector (39 downto 0);
begin

	IM : instruction_memory
  PORT MAP (
    clka => clk,
    addra => i_a,
    douta => instr
  );
  
	IP : instruction_pointer
	PORT MAP (
		clk => clk,
		instr_addr => i_a,
		target_enable => br_en,
		reset => reset,
		jump_branch_target => next_pc,
		stall_if => stall
	);
	process (clk)
		begin
			if rising_edge(clk) then
				instr_out <= instr;
			end if;
	end process;

end Behavioral;

