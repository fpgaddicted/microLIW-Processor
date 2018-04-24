----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:06:27 01/24/2018 
-- Design Name: 
-- Module Name:    EX_MEM - Behavioral 
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


entity EX_MEM is
	Port ( 
		clk : in std_logic;
		aluop0_id : in std_logic_vector (3 downto 0); -- ALU Op from ID
		aluop1_id : in std_logic_vector (3 downto 0); -- ALU Op from ID
		rt0_id : in std_logic_vector (15 downto 0); --rt0 from ID 
		rs0_id : in std_logic_vector (15 downto 0); --rs0 from ID 
		rt1_id : in std_logic_vector (15 downto 0); --rt1 from ID 
		rs1_id : in std_logic_vector (15 downto 0); --rs1 from ID
		we_rd0_id : in std_logic; -- rd0 we from ID
		we_rd1_id : in std_logic; -- rd1 we from ID
		we_rd0_mem : out std_logic; -- rd0 we to MEM
		we_rd1_mem : out std_logic; -- rd1 we to MEM
		imm0_id : in std_logic_vector (7 downto 0); -- imm value from ID
		imm1_id : in std_logic_vector (7 downto 0); -- imm value from ID
		alu0src_id : in std_logic; -- alu 0 source (rs/imm) from ID (control unit)
		alu1src_id : in std_logic; -- alu 1 source (rs/imm) from ID (control unit)
		we_dm0_id : in std_logic_vector (0 downto 0);  -- data memory we 0 from ID/Control
		we_dm1_id : in std_logic_vector (0 downto 0);  -- data memory we 1 from ID/Control
		we_dm0_mem : out std_logic_vector (0 downto 0); -- data memory we 0 to MEM
		we_dm1_mem : out std_logic_vector (0 downto 0); -- data memory we 1 to MEM
		a_dm0_mem : out std_logic_vector (7 downto 0); -- memory address 0 to MEM 
		a_dm1_mem : out std_logic_vector (7 downto 0); -- memory address 1 to MEM
		d_dm0_mem : out std_logic_vector (15 downto 0); -- memory data 0 to MEM
		d_dm1_mem : out std_logic_vector (15 downto 0); -- memory data 1 to MEM
		a_rd0_mem : out std_logic_vector (3 downto 0); -- rd0 address to MEM
		a_rd1_mem : out std_logic_vector (3 downto 0); -- rd0 address to MEM
		a_rd0_id : in std_logic_vector (3 downto 0); --rd0 address from ID
		a_rd1_id : in std_logic_vector (3 downto 0); --rd1 address from ID			 
		ret_select0_id : in std_logic;
		ret_select1_id : in std_logic;
		br_jmp_trgt_if : out std_logic_vector (7 downto 0); -- branch / jump target to IF (IP)
		br_jmp_en_if : out std_logic; -- when = '1' then next instr. addrr <= br_jmp_trgt
		ret_select0_mem : out std_logic;
		ret_select1_mem : out std_logic;
		bgt_e_id : in std_logic;
		beq_e_id : in std_logic;
		blt_e_id : in std_logic;
		jump_e_id : in std_logic;
		d_rd0_mem : out std_logic_vector (15 downto 0); -- alu result (rd) 0 to MEM
		d_rd1_mem : out std_logic_vector (15 downto 0)  -- alu result (rd) 1 to MEM
		);
end EX_MEM;

architecture Behavioral of EX_MEM is

	signal immext0, immext1 : std_logic_vector (15 downto 0); --immediate extension to 16bit
	signal ex_rd0, ex_rd1: std_logic_vector (15 downto 0);
	signal a_dm0, a_dm1  : std_logic_vector (7 downto 0);
	signal alu0_source, alu1_source : std_logic_vector (15 downto 0);
	signal agtb0,altb0,aetb0 : std_logic; -- FLAGS / BRANCH CONTROL BITS
	signal ge, eq, le : std_logic;
	
	
	COMPONENT ALU_TOP
    PORT(
         ALUIN_A : IN  std_logic_vector(15 downto 0);
         ALUIN_B : IN  std_logic_vector(15 downto 0);
         OP : IN  std_logic_vector(2 downto 0);
         ALUOUT : OUT  std_logic_vector(15 downto 0);
		 AGTB : out STD_LOGIC; 
		 ALTB : out STD_LOGIC; 
		 AETB : out STD_LOGIC; 
         CARRYOUT : OUT  std_logic
        );
    END COMPONENT;

begin
		--ARITHMETIC AND LOGIC UNIT / EXECUTION --
		  ALU_0: ALU_TOP PORT MAP (
          ALUIN_A => alu0_source,
          ALUIN_B => rt0_id,
          OP => aluop0_id (2 downto 0),
          ALUOUT => ex_rd0,
          CARRYOUT => open,
		  AGTB => agtb0,
		  ALTB => altb0,
		  AETB => aetb0
        );
		  
		  ALU_1: ALU_TOP PORT MAP (
          ALUIN_A => alu1_source,
          ALUIN_B => rt1_id,
          OP => aluop1_id (2 downto 0),
          ALUOUT => ex_rd1,
          CARRYOUT => open,
		  AGTB => open,
		  ALTB => open,
		  AETB => open
        );
	
		--ADDRESS CALCULATING - LOAD/STORE UNIT--
		immext0 (15 downto 8) <= X"00"; immext0 (7 downto 0) <= imm0_id;
		immext1 (15 downto 8) <= X"00"; immext1 (7 downto 0) <= imm1_id;
		a_dm0 <= rs0_id (7 downto 0) + imm0_id;
		a_dm1 <= rs1_id (7 downto 0) + imm1_id;
		
		
		
		--ALU CONTROL--
		process(alu0src_id, immext0, rs0_id)
			begin
				if alu0src_id = '1' then
					alu0_source <= immext0;
				else
					alu0_source <= rs0_id;
				end if;
		end process;
		
		process(alu1src_id, immext1, rs1_id)
			begin
				if alu1src_id = '1' then
					alu1_source <= immext1;
				else
					alu1_source <= rs1_id;
				end if;
		end process;
		
		-- BRANCH CONTROL UNIT--
	ge <= '1' when agtb0 ='1' and  bgt_e_id ='1' else '0';
	eq <= '1' when aetb0 ='1' and  beq_e_id ='1' else '0';
	le <= '1' when altb0 ='1' and  blt_e_id ='1' else '0';
	
	br_jmp_en_if <= ge or eq or le or jump_e_id; -- generate instruction address control (IP/ target)
	
	br_jmp_trgt_if <= imm0_id;
	

			
		
		--REGISTERED OUTPUTS--
	process(clk)
		begin
			if rising_edge(clk) then
				d_rd0_mem <= ex_rd0;
				d_rd1_mem <= ex_rd1;
				d_dm0_mem <= rt0_id;
				d_dm1_mem <= rt1_id;
				a_dm0_mem <= a_dm0;
				a_dm1_mem <= a_dm1;
				we_dm0_mem <= we_dm0_id;
				we_dm1_mem <= we_dm1_id;
				we_rd0_mem <= we_rd0_id;
				we_rd1_mem <= we_rd1_id;
				a_rd0_mem <= a_rd0_id;
				a_rd1_mem <= a_rd1_id;
				ret_select0_mem <= ret_select0_id;
				ret_select1_mem <= ret_select1_id;
			end if;
	end process;
end Behavioral;

