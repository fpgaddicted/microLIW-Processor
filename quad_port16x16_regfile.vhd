----------------------------------------------------------------------------------
-- Company: TEI OF CRETE
-- Engineer: Stefan Naco - fpgaddicted
-- 
-- Create Date:    01:53:35 11/29/2017 
-- Design Name: 
-- Module Name:    quad_port16x16_regfile - Behavioral 
-- Project Name: VLIW PROCESSOR
-- Target Devices: 
-- Tool versions: XILINX ISE 14.7
-- Description: REGISTER FILE
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.05 - Updated port behavioral - outputs/enable signals
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity quad_port16x16_regfile is
    Port ( r_addra : in  STD_LOGIC_VECTOR (3 downto 0); --READ REGISTER_A ADDR
           r_addrb : in  STD_LOGIC_VECTOR (3 downto 0); --READ REGISTER_B ADDR
           r_addrc : in  STD_LOGIC_VECTOR (3 downto 0); --READ REGISTER_C ADDR
           r_addrd : in  STD_LOGIC_VECTOR (3 downto 0); --READ REGISTER_D ADDR
           reg_we_0 : in STD_LOGIC; -- WE FOR WRITE REGISTER 0
		   reg_we_1 : in STD_LOGIC; -- WE FOR WRITE REGISTER 1
           datain_0 : in  STD_LOGIC_VECTOR (15 downto 0); -- DATA IN WR0
           datain_1 : in  STD_LOGIC_VECTOR (15 downto 0); -- DATA IN WR1
           w_addr0 : in  STD_LOGIC_VECTOR (3 downto 0); --WRITE ADDRESS 0 //FROM ALU_0
           w_addr1 : in  STD_LOGIC_VECTOR (3 downto 0); --WRITE ADDRESS 1 //FROM ALU_1
           reg_outa : out  STD_LOGIC_VECTOR (15 downto 0); --READ REG_A OUT
           reg_outb : out  STD_LOGIC_VECTOR (15 downto 0); --READ REG_B OUT 
           reg_outc : out  STD_LOGIC_VECTOR (15 downto 0); --READ REG_C OUT 
           reg_outd : out  STD_LOGIC_VECTOR (15 downto 0); --READ REG_D OUT
		   clk : in STD_LOGIC); -- SYSTEM CLOCK 50MHz
end quad_port16x16_regfile;

architecture Behavioral of quad_port16x16_regfile is
type regfile is array (0 to 15) of std_logic_vector(15 downto 0);
signal reg_addr: regfile;

begin
	process(clk)
		begin
			if rising_edge(clk) then -- Synchronous output
					
				if (reg_we_0 ='1')then --write enable for write reg 0
					reg_addr(to_integer(unsigned(w_addr0))) <= datain_0;
				end if;
				
				if (reg_we_1 = '1')then --write enable for write reg 1
					reg_addr(to_integer(unsigned(w_addr1))) <= datain_1;
				end if;
			end if;		
	end process;
	--register data read
		process(r_addra, r_addrb, r_addrc, r_addrd, reg_addr)
			begin
				if r_addra = X"0" then
					reg_outa <= (others => '0');
				else
				reg_outa <= reg_addr(to_integer(unsigned(r_addra)));
				end if;
				
				if r_addrb = X"0" then
					reg_outb <= (others => '0');
				else
				reg_outb <= reg_addr(to_integer(unsigned(r_addrb)));
				end if;
				
				if r_addrc = X"0" then
					reg_outc <= (others => '0');
				else
				reg_outc <= reg_addr(to_integer(unsigned(r_addrc)));
				end if;
				
				if r_addrd = X"0" then
					reg_outd <= (others => '0');
				else
				reg_outd <= reg_addr(to_integer(unsigned(r_addrd)));
				end if;
		end process;


end Behavioral;

