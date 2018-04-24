----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:06:00 01/24/2018 
-- Design Name: 
-- Module Name:    ID_EX - Behavioral 
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

entity ID_EX is
    Port ( clk : in STD_LOGIC;
			  instr_in : in  STD_LOGIC_VECTOR (39 downto 0); -- instruction input from IF stage
			  d_rd0_wb : in STD_LOGIC_VECTOR (15 downto 0); --rd0 data from WB stage
			  d_rd1_wb : in STD_LOGIC_VECTOR (15 downto 0); --rd1 data from WB stage
			  a_rd0_wb : in STD_LOGIC_VECTOR (3 downto 0); --rd0 address return from WB
			  a_rd1_wb : in STD_LOGIC_VECTOR (3 downto 0); --rd1 address return from WB
			  we0_wb : in STD_LOGIC; --rd0 write enable from MEM/WB stage
			  we1_wb : in STD_LOGIC; --rd1 write enable from MEM/WB stage
			  we_dm0_ex : out STD_LOGIC_VECTOR (0 downto 0); --mem write enable 0 to EX stage
			  we_dm1_ex : out STD_LOGIC_VECTOR (0 downto 0); --mem write enable 0 to EX stage
			  we_rd0_ex : out STD_LOGIC; -- rd0 write enable to EX stage
			  we_rd1_ex : out STD_LOGIC;  --rd1 write enable to EX stage
			  a_rd0_ex : out STD_LOGIC_VECTOR (3 downto 0); --rd0 address to EX
			  a_rd1_ex : out STD_LOGIC_VECTOR (3 downto 0); --rd1 address to EX 
			  rs0_ex : out  STD_LOGIC_VECTOR (15 downto 0); --rs0 to EX stage
              rt0_ex : out  STD_LOGIC_VECTOR (15 downto 0); --rt0 to EX stage
              rs1_ex : out  STD_LOGIC_VECTOR (15 downto 0); --rs1 to EX stage
			  rt1_ex : out  STD_LOGIC_VECTOR (15 downto 0); --rt1 to EX stage
			  imm0_ex : out STD_LOGIC_VECTOR (7 downto 0); --immediate value 0 to EX
			  imm1_ex : out STD_LOGIC_VECTOR (7 downto 0); --immediate value 1 to EX
			  alu0_src_ex : out STD_LOGIC; -- alu operand source
			  alu1_src_ex : out STD_LOGIC; -- alu operand source
			  ret_select0_ex : out STD_LOGIC;
			  ret_select1_ex : out STD_LOGIC;
			  bgt_e_ex : out STD_LOGIC;
			  beq_e_ex : out STD_LOGIC;
			  blt_e_ex : out STD_LOGIC;
			  jump_e_ex : out STD_LOGIC;
			  aluop0_ex : out STD_LOGIC_VECTOR (3 downto 0); -- alu opcode 0 to EX
			  aluop1_ex : out STD_LOGIC_VECTOR (3 downto 0)); -- alu opcode 1 to EX
		end ID_EX;

architecture Behavioral of ID_EX is 
	
	COMPONENT control_logic
    PORT(
		 dm_we0 : out  STD_LOGIC_VECTOR (0 downto 0);
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
         opcode1 : in  STD_LOGIC_VECTOR (3 downto 0)
		);
    END COMPONENT;
	
	COMPONENT quad_port16x16_regfile
    PORT(
         r_addra : IN  std_logic_vector(3 downto 0);
         r_addrb : IN  std_logic_vector(3 downto 0);
         r_addrc : IN  std_logic_vector(3 downto 0);
         r_addrd : IN  std_logic_vector(3 downto 0);
         reg_we_0 : IN  std_logic;
		 reg_we_1 : IN std_logic;
         datain_0 : IN  std_logic_vector(15 downto 0);
         datain_1 : IN  std_logic_vector(15 downto 0);
         w_addr0 : IN  std_logic_vector(3 downto 0);
         w_addr1 : IN  std_logic_vector(3 downto 0);
         reg_outa : OUT  std_logic_vector(15 downto 0);
         reg_outb : OUT  std_logic_vector(15 downto 0);
         reg_outc : OUT  std_logic_vector(15 downto 0);
         reg_outd : OUT  std_logic_vector(15 downto 0);
         clk : IN  std_logic
        );
    END COMPONENT;
	
	 
signal rs0,rt0,rs1,rt1 :std_logic_vector(15 downto 0); --reg data lines
signal a_rs0,a_rt0,a_rd0,a_rs1,a_rt1,a_rd1 : std_logic_vector (3 downto 0); --reg address lines
signal opcode_0, opcode_1 : std_logic_vector (3 downto 0); -- opcode from instruction split (inside ID_EX)
signal imm0, imm1 : std_logic_vector (7 downto 0); --immediate lines
signal werd0, werd1 : std_logic; -- register file write enable lines (from MEM_WB return)
signal dmwe0, dmwe1 : std_logic_vector (0 downto 0); -- data memory write enable lines (inside MEM_WB)
signal alu0src, alu1src : std_logic; -- alu source control lines (inside EX_MEM)
signal dsel0, dsel1 : std_logic; -- alu /mem source select  (inside MEM_WB)
signal aluctrl0, aluctrl1 : std_logic_vector(3 downto 0); -- alu opcode 
signal be, bl, bg, jm : std_logic;
--opcode to control unit

begin
	--INSTRUCTION DECODE / SPLIT
	
	RF: quad_port16x16_regfile PORT MAP (
          r_addra => a_rs0,
          r_addrb => a_rt0,
          r_addrc => a_rt1,
          r_addrd => a_rs1,
          reg_we_0 => we0_wb,
		  reg_we_1 => we1_wb,
		  datain_0 => d_rd0_wb,
          datain_1 => d_rd1_wb,
          w_addr0 => a_rd0_wb,
          w_addr1 => a_rd1_wb,
          reg_outa => rs0,
          reg_outb => rt0,
          reg_outc => rs1,
          reg_outd => rt1,
          clk => clk
        );
		  
		control: control_logic PORT MAP (
          dm_we0 => dmwe0,
          dm_we1 => dmwe1,
          alu0_src => alu0src,
          alu1_src => alu1src,
          we_rd0 => werd0,
          we_rd1 => werd1,
		  alu_op0 => aluctrl0,
		  alu_op1 => aluctrl1,
		  data_select0 => dsel0,
		  data_select1 => dsel1,
		  bgt_e => bg,
		  beq_e => be,
		  blt_e => bl,
		  jump_e => jm,
          opcode0 => opcode_0,
          opcode1 => opcode_1
        );

--instruction 0
opcode_0 <=	instr_in(39 downto 36);  
a_rd0 <= instr_in(35 downto 32);
a_rt0 <= instr_in(31 downto 28);
a_rs0 <= instr_in(27 downto 24);
imm0 <= instr_in(27 downto 20);
--instruction 1
opcode_1 <=	instr_in(19 downto 16);  
a_rd1 <= instr_in(15 downto 12);
a_rt1 <= instr_in(11 downto 8);
a_rs1 <= instr_in(7 downto 4);
imm1 <= instr_in(7 downto 0);

	--REGISTERED OUTPUTS--
	process(clk)
		begin
			if rising_edge(clk) then
				imm0_ex <= imm0;
				imm1_ex <= imm1;
				a_rd0_ex <= a_rd0;
				a_rd1_ex <= a_rd1;
				rs0_ex <= rs0;
				rt0_ex <= rt0;
				rs1_ex <= rt1;
				rt1_ex <= rs1;
				we_rd0_ex <= werd0;
				we_rd1_ex <= werd1;
				we_dm0_ex <= dmwe0;
				we_dm1_ex <= dmwe1;
				aluop0_ex <= aluctrl0;
				aluop1_ex <= aluctrl1;
				alu0_src_ex <= alu0src;
				alu1_src_ex <= alu1src;
				bgt_e_ex <= bg;
				beq_e_ex <= be;
				blt_e_ex <= bl;
				jump_e_ex <= jm;
				ret_select0_ex <= dsel0;
				ret_select1_ex <= dsel1;
			end if;
	end process;
	
	
end Behavioral;

