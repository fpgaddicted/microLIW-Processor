----------------------------------------------------------------------------------
-- Company: TEI OF CRETE 
-- Engineer: Stefan Naco - fpgaddicted
-- 
-- Create Date:    01:33:46 11/28/2017 
-- Design Name: 
-- Module Name:    ALU_TOP - Behavioral 
-- Project Name: VLIW PROCESSOR
-- Target Devices: 
-- Tool versions: XILINX ISE 14.7
-- Description: ALU TOP MODULE 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.08 -- minor correction / added comments
-- Additional Comments: WORK IN PROGRESS
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ALU_TOP is
    Port ( ALUIN_A : in  STD_LOGIC_VECTOR (15 downto 0); --operand A
           ALUIN_B : in  STD_LOGIC_VECTOR (15 downto 0); --operand B
			  OP : in  STD_LOGIC_VECTOR (2 downto 0); -- Operation Code 
           ALUOUT : out  STD_LOGIC_VECTOR (15 downto 0); -- ALU Result
			  AGTB : out STD_LOGIC; -- A > B flag (greater than)
			  ALTB : out STD_LOGIC; -- A < B flag (lesser than)
			  AETB : out STD_LOGIC; -- A = B flag (equal to)
           CARRYOUT : out  STD_LOGIC); -- Carry Flag
end ALU_TOP;

architecture Behavioral of ALU_TOP is
						--ALU LOGIC--
component adder16bit 
      port ( add_sub   : in    std_logic; 
             add_a     : in    std_logic_vector (15 downto 0); 
             add_b     : in    std_logic_vector (15 downto 0); 
             carry_out : out   std_logic; 
             result    : out   std_logic_vector (15 downto 0));
   end component;
   
   component bitinvert
      port ( sub_select : in    std_logic; 
             addend     : in    std_logic_vector (15 downto 0); 
             comp_out   : out   std_logic_vector (15 downto 0));
   end component;
	
	component aluop_dec
		port ( I_op : in  STD_LOGIC_VECTOR (2 downto 0);
             O_ainv : out  STD_LOGIC;
             O_binv : out  STD_LOGIC;
             O_carryin : out  STD_LOGIC;
             O_muxctrl : out  STD_LOGIC_VECTOR (2 downto 0));
		end component;
	
	component mux8to1
		port ( op_select : in  STD_LOGIC_VECTOR (2 downto 0);
				 i0 : in  STD_LOGIC_VECTOR (15 downto 0);
				 i1 : in  STD_LOGIC_VECTOR (15 downto 0);
             i2 : in  STD_LOGIC_VECTOR (15 downto 0);
             i3 : in  STD_LOGIC_VECTOR (15 downto 0);
             i4 : in  STD_LOGIC_VECTOR (15 downto 0);
             i5 : in  STD_LOGIC_VECTOR (15 downto 0);
             i6 : in  STD_LOGIC_VECTOR (15 downto 0);
             i7 : in  STD_LOGIC_VECTOR (15 downto 0);
             mux_out : out  STD_LOGIC_VECTOR (15 downto 0));
		end component;
   
signal SIG0, SIG1, SIG2 : std_logic_vector (15 downto 0);
signal bw_and, bw_or : std_logic_vector (15 downto 0); -- bitwise gates output
signal sig_cri, sig_inva, sig_invb : std_logic; -- op control dec -> ALU logic
signal sig_muxsel : std_logic_vector (2 downto 0); -- op control dec -> ALU logic


begin
		--PORT MAP--
   ADDER16 : adder16bit
      port map (add_a=>SIG0,
                add_b=>SIG1,
                add_sub=> sig_cri,
                carry_out=>CARRYOUT,
                result=> SIG2);
   
   Ainv : bitinvert
      port map (addend=>ALUIN_A,
                sub_select=>sig_inva,
                comp_out=>SIG0);
					 
	Binv : bitinvert
      port map (addend=>ALUIN_B,
                sub_select=>sig_invb,
                comp_out=>SIG1);
					 
	op_dec : aluop_dec
		port map (I_op => OP,
					 O_ainv => sig_inva,
					 O_binv => sig_invb,
					 O_carryin => sig_cri,
					 O_muxctrl => sig_muxsel
					 );
					 
	alu_output : mux8to1
		port map (op_select => sig_muxsel,
					 i0 => SIG2, --add/sub
					 i1 => bw_or, --bitwise or /nand              
					 i2 => bw_and,  --bitwise and /nor
					 i3 => (others=>'0'),  
					 i4 => (others=>'0'),
					 i5 => (others=>'0'),
					 i6 => (others=>'0'),
					 i7 => (others=>'0'),
					 mux_out =>ALUOUT);
					 
			--COMPARE LOGIC--
			
	process (ALUIN_A, ALUIN_B)
		begin
			if ALUIN_A < ALUIN_B then
				ALTB <= '1';
			else
				ALTB <= '0';
			end if;
			
			if ALUIN_A > ALUIN_B then
				AGTB <= '1';
			else
				AGTB <= '0';
			end if;
			
			if ALUIN_A = ALUIN_B then
				AETB <= '1';
			else				
				AETB <= '0';
			end if;
			
	end process;
				
					 
			--	BITWISE OPERERATION GATE ARRAY -- 
			
bw_and <= SIG0 and SIG1;
bw_or <= SIG0 or SIG1;
end Behavioral;

