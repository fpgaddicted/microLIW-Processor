----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Stefan Naco -- github.com/fpgaddicted
-- 
-- Create Date:    18:48:24 03/13/2018 / 03/24/2018 (complete)
-- Design Name: 	 vliw processor /pipeline/
-- Module Name:    core - Behavioral 
-- Project Name: VLIW PROCESSOR
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: IF_ID , ID_EX, EX_MEM, MEM_WB
--
-- Revision: 
-- Revision 1.0 Initial datapath construction
-- Additional Comments: -- work in progress
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity core is
	port( 
		clk : in std_logic;
		reset : in std_logic;
		pipe_stall : in std_logic;
		data_o : out  std_logic_vector(15 downto 0)
		);
end core;

architecture Behavioral of core is
		
		COMPONENT IF_ID
    PORT(
         clk : IN  std_logic;
         next_pc : IN  std_logic_vector(7 downto 0);
		 reset : IN std_logic;
         br_en : IN  std_logic;
         instr_out : OUT  std_logic_vector(39 downto 0);
         stall : IN  std_logic
        );
    END COMPONENT;
	 
	 
	 COMPONENT ID_EX
    PORT(
         clk : IN  std_logic;
         instr_in : IN  std_logic_vector(39 downto 0);
         d_rd0_wb : IN  std_logic_vector(15 downto 0);
         d_rd1_wb : IN  std_logic_vector(15 downto 0);
         a_rd0_wb : IN  std_logic_vector(3 downto 0);
         a_rd1_wb : IN  std_logic_vector(3 downto 0);
         we0_wb : IN  std_logic;
         we1_wb : IN  std_logic;
         we_dm0_ex : OUT  std_logic_vector(0 downto 0);
         we_dm1_ex : OUT  std_logic_vector(0 downto 0);
         we_rd0_ex : OUT  std_logic;
         we_rd1_ex : OUT  std_logic;
         a_rd0_ex : OUT  std_logic_vector(3 downto 0);
         a_rd1_ex : OUT  std_logic_vector(3 downto 0);
         rs0_ex : OUT  std_logic_vector(15 downto 0);
         rt0_ex : OUT  std_logic_vector(15 downto 0);
         rs1_ex : OUT  std_logic_vector(15 downto 0);
         rt1_ex : OUT  std_logic_vector(15 downto 0);
         imm0_ex : OUT  std_logic_vector(7 downto 0);
         imm1_ex : OUT  std_logic_vector(7 downto 0);
         alu0_src_ex : OUT  std_logic;
         alu1_src_ex : OUT  std_logic;
		 bgt_e_ex : OUT std_logic;
		 beq_e_ex : OUT std_logic;
		 blt_e_ex : OUT std_logic;
		 jump_e_ex : OUT std_logic;
         ret_select0_ex : OUT  std_logic;
         ret_select1_ex : OUT  std_logic;
         aluop0_ex : OUT  std_logic_vector(3 downto 0);
         aluop1_ex : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
	 
	 
	 COMPONENT EX_MEM
    PORT(
         clk : IN  std_logic;
         aluop0_id : IN  std_logic_vector(3 downto 0);
         aluop1_id : IN  std_logic_vector(3 downto 0);
         rt0_id : IN  std_logic_vector(15 downto 0);
         rs0_id : IN  std_logic_vector(15 downto 0);
         rt1_id : IN  std_logic_vector(15 downto 0);
         rs1_id : IN  std_logic_vector(15 downto 0);
         we_rd0_id : IN  std_logic;
         we_rd1_id : IN  std_logic;
         we_rd0_mem : OUT  std_logic;
         we_rd1_mem : OUT  std_logic;
         imm0_id : IN  std_logic_vector(7 downto 0);
         imm1_id : IN  std_logic_vector(7 downto 0);
         alu0src_id : IN  std_logic;
         alu1src_id : IN  std_logic;
         we_dm0_id : IN  std_logic_vector(0 downto 0);
         we_dm1_id : IN  std_logic_vector(0 downto 0);
         we_dm0_mem : OUT  std_logic_vector(0 downto 0);
         we_dm1_mem : OUT  std_logic_vector(0 downto 0);
         a_dm0_mem : OUT  std_logic_vector(7 downto 0);
         a_dm1_mem : OUT  std_logic_vector(7 downto 0);
         d_dm0_mem : OUT  std_logic_vector(15 downto 0);
         d_dm1_mem : OUT  std_logic_vector(15 downto 0);
		 a_rd0_mem : OUT std_logic_vector (3 downto 0);
		 a_rd1_mem : OUT std_logic_vector (3 downto 0); 
		 a_rd1_id : IN std_logic_vector (3 downto 0); 
		 a_rd0_id : IN std_logic_vector (3 downto 0);
         ret_select0_id : IN  std_logic;
         ret_select1_id : IN  std_logic;
         ret_select0_mem : OUT  std_logic;
         ret_select1_mem : OUT  std_logic;
		 bgt_e_id : in std_logic;
		 beq_e_id : in std_logic;
		 blt_e_id : in std_logic;
		 jump_e_id : in std_logic;
		 br_jmp_trgt_if : out std_logic_vector (7 downto 0);
		 br_jmp_en_if : out std_logic;
         d_rd0_mem : OUT  std_logic_vector(15 downto 0);
         d_rd1_mem : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
	 
	 
	 COMPONENT MEM_WB
    PORT(
         clk : IN  std_logic;
         d_rd0_id : OUT  std_logic_vector(15 downto 0);
         d_rd1_id : OUT  std_logic_vector(15 downto 0);
         a_rd0_id : OUT  std_logic_vector(3 downto 0);
         a_rd1_id : OUT  std_logic_vector(3 downto 0);
         a_rd0_ex : IN  std_logic_vector(3 downto 0);
         a_rd1_ex : IN  std_logic_vector(3 downto 0);
         d_rd0_ex : IN  std_logic_vector(15 downto 0);
         d_rd1_ex : IN  std_logic_vector(15 downto 0);
         we_rd0_ex : IN  std_logic;
         we_rd1_ex : IN  std_logic;
         we_rd0_id : OUT  std_logic;
         we_rd1_id : OUT  std_logic;
         we_dm0_ex : IN  std_logic_vector(0 downto 0);
         we_dm1_ex : IN  std_logic_vector(0 downto 0);
         a_dm0_ex : IN  std_logic_vector(7 downto 0);
         a_dm1_ex : IN  std_logic_vector(7 downto 0);
         d_dm0_ex : IN  std_logic_vector(15 downto 0);
         d_dm1_ex : IN  std_logic_vector(15 downto 0);
         ret_select0_ex : IN  std_logic;
         ret_select1_ex : IN  std_logic
        );
    END COMPONENT;
	 
	 --top level connection lines (Ending represents the pipeline stages that are connected together)
	 
	 --ex. _idex = IF_ID => EX_MEM, _wbid = MEM_WB => ID_EX (return to RF) ...
	 
signal instruction_ifid : std_logic_vector(39 downto 0);
signal d_rd0_exmem, d_rd1_exmem, d_rd0_wbid, d_rd1_wbid : std_logic_vector(15 downto 0); --rd data
signal a_rd0_idex, a_rd1_idex, a_rd0_exmem, a_rd1_exmem : std_logic_vector(3 downto 0); --rd address
signal a_rd0_wbid, a_rd1_wbid : std_logic_vector(3 downto 0); -- rd return address
signal we0_wbid, we1_wbid, we_rd0_idex, we_rd1_idex, we_rd0_exmem, we_rd1_exmem : std_logic; -- rd write enable

signal a_dm0_exmem, a_dm1_exmem : std_logic_vector(7 downto 0); -- data memory address

signal d_dm0_exmem, d_dm1_exmem : std_logic_vector(15 downto 0); -- data memory data
signal we_dm0_idex, we_dm1_idex, we_dm0_exmem, we_dm1_exmem : std_logic_vector (0 downto 0); -- data mem write enable
signal rs0_idex, rt0_idex, rs1_idex, rt1_idex : std_logic_vector(15 downto 0); --rs/rt to ALU/ AGU/ MEM
signal imm0_idex, imm1_idex : std_logic_vector(7 downto 0); --immediate value to ALU/ AGU
signal alu0_src_idex, alu1_src_idex : std_logic; -- alu source select (rt or immediate)
signal ret_select0_idex, ret_select1_idex, ret_select0_exmem, ret_select1_exmem : std_logic; --ALU or DM data ret.
signal br_jmp_trgt_ifex : std_logic_vector(7 downto 0); -- -- next address to instruction pointer
signal br_jmp_en_ifex : std_logic;
signal bgt_e_idex, beq_e_idex, blt_e_idex, jump_e_idex : std_logic;
signal aluop0_idex, aluop1_idex : std_logic_vector(3 downto 0); -- alu function


begin	
		IFID: IF_ID PORT MAP (
          clk => clk,
          next_pc => br_jmp_trgt_ifex,
          br_en => br_jmp_en_ifex,
		  reset => reset,
          instr_out => instruction_ifid,
          stall => pipe_stall
        );
		
		IDEX: ID_EX PORT MAP (
          clk => clk,
          instr_in => instruction_ifid,
          d_rd0_wb => d_rd0_wbid,
          d_rd1_wb => d_rd1_wbid,
          a_rd0_wb => a_rd0_wbid,
          a_rd1_wb => a_rd1_wbid,
          we0_wb => we0_wbid,
          we1_wb => we1_wbid,
          we_dm0_ex => we_dm0_idex,
          we_dm1_ex => we_dm1_idex,
          we_rd0_ex => we_rd0_idex,
          we_rd1_ex => we_rd1_idex,
          a_rd0_ex => a_rd0_idex,
          a_rd1_ex => a_rd1_idex,
          rs0_ex => rs0_idex,
          rt0_ex => rt0_idex,
          rs1_ex => rs1_idex,
          rt1_ex => rt1_idex,
          imm0_ex => imm0_idex,
          imm1_ex => imm1_idex,
          alu0_src_ex => alu0_src_idex,
          alu1_src_ex => alu1_src_idex,
		  bgt_e_ex => bgt_e_idex,
	      beq_e_ex => beq_e_idex,
		  blt_e_ex => blt_e_idex,
		  jump_e_ex => jump_e_idex,
          ret_select0_ex => ret_select0_idex,
          ret_select1_ex => ret_select1_idex,
          aluop0_ex => aluop0_idex,
          aluop1_ex => aluop1_idex
        );

		EXMEM: EX_MEM PORT MAP (
          clk => clk,
          aluop0_id => aluop0_idex,
          aluop1_id => aluop1_idex,
          rt0_id => rt0_idex,
          rs0_id => rs0_idex,
          rt1_id => rt1_idex,
          rs1_id => rs1_idex,
          we_rd0_id => we_rd0_idex,
          we_rd1_id => we_rd1_idex,
          we_rd0_mem => we_rd0_exmem,
          we_rd1_mem => we_rd1_exmem,
          imm0_id => imm0_idex,
          imm1_id => imm1_idex,
          alu0src_id => alu0_src_idex,
          alu1src_id => alu1_src_idex,
          we_dm0_id => we_dm0_idex,
          we_dm1_id => we_dm1_idex,
          we_dm0_mem => we_dm0_exmem,
          we_dm1_mem => we_dm1_exmem,
          a_dm0_mem => a_dm0_exmem,
          a_dm1_mem => a_dm1_exmem,
          d_dm0_mem => d_dm0_exmem,
          d_dm1_mem => d_dm1_exmem,
		  a_rd0_id => a_rd0_idex,
		  a_rd1_id => a_rd1_idex,
		  a_rd0_mem => a_rd0_exmem,
		  a_rd1_mem => a_rd1_exmem,
		  br_jmp_trgt_if => br_jmp_trgt_ifex,
		  br_jmp_en_if => br_jmp_en_ifex,
		  bgt_e_id => bgt_e_idex,
		  beq_e_id => beq_e_idex,
		  blt_e_id => blt_e_idex,
		  jump_e_id => jump_e_idex,
          ret_select0_id => ret_select0_idex,
          ret_select1_id => ret_select1_idex,
          ret_select0_mem => ret_select0_exmem,
          ret_select1_mem => ret_select1_exmem,
          d_rd0_mem => d_rd0_exmem,
          d_rd1_mem => d_rd1_exmem
        );

		MEMWB: MEM_WB PORT MAP (
          clk => clk,
          d_rd0_id => d_rd0_wbid,
          d_rd1_id => d_rd1_wbid,
          a_rd0_id => a_rd0_wbid,
          a_rd1_id => a_rd1_wbid,
          a_rd0_ex => a_rd0_exmem,
          a_rd1_ex => a_rd1_exmem,
          d_rd0_ex => d_rd0_exmem,
          d_rd1_ex => d_rd1_exmem,
          we_rd0_ex => we_rd0_exmem,
          we_rd1_ex => we_rd1_exmem,
          we_rd0_id => we0_wbid,
          we_rd1_id => we1_wbid,
          we_dm0_ex => we_dm0_exmem,
          we_dm1_ex => we_dm1_exmem,
          a_dm0_ex => a_dm0_exmem,
          a_dm1_ex => a_dm1_exmem,
          d_dm0_ex => d_dm0_exmem,
          d_dm1_ex => d_dm1_exmem,
          ret_select0_ex => ret_select0_exmem,
          ret_select1_ex => ret_select1_exmem
        );

			data_o <= d_rd0_wbid;
end Behavioral;

