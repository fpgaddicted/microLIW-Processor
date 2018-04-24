----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:00:53 03/15/2018 
-- Design Name: 
-- Module Name:    MEM_WB - Behavioral 
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


entity MEM_WB is
	Port ( 	 clk : in STD_LOGIC;
			 d_rd0_id : out STD_LOGIC_VECTOR(15 downto 0);-- rd0 data return to RF
			 d_rd1_id : out STD_LOGIC_VECTOR(15 downto 0);-- rd1 data return to RF
			 a_rd0_id : out STD_LOGIC_VECTOR(3 downto 0); --rd0 address return to RF
			 a_rd1_id : out STD_LOGIC_VECTOR(3 downto 0); --rd1 address return to RF
			 a_rd0_ex : in STD_LOGIC_VECTOR(3 downto 0); 
			 a_rd1_ex : in STD_LOGIC_VECTOR(3 downto 0); 
			 d_rd0_ex : in STD_LOGIC_VECTOR(15 downto 0); --rd0 data from EX
			 d_rd1_ex : in STD_LOGIC_VECTOR(15 downto 0); --rd1 data from EX
			 we_rd0_ex : in STD_LOGIC;
			 we_rd1_ex : in STD_LOGIC;
			 we_rd0_id :out STD_LOGIC; -- WE return to (RF) ID/EX
			 we_rd1_id : out STD_LOGIC; -- WE return to (RF) ID/EX
			 we_dm0_ex : in STD_LOGIC_VECTOR(0 downto 0);
			 we_dm1_ex : in STD_LOGIC_VECTOR(0 downto 0);
			 a_dm0_ex : in STD_LOGIC_VECTOR (7 downto 0);
			 a_dm1_ex : in STD_LOGIC_VECTOR (7 downto 0);
			 d_dm0_ex : in STD_LOGIC_VECTOR (15 downto 0);
			 d_dm1_ex : in STD_LOGIC_VECTOR (15 downto 0);
			 ret_select0_ex : in STD_LOGIC;
			 ret_select1_ex : in STD_LOGIC
			);
			 
end MEM_WB;

architecture Behavioral of MEM_WB is
	
		COMPONENT data_memory
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
--	clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
	END COMPONENT;

signal memrd0, memrd1 : std_logic_vector(15 downto 0);
signal memdata0, memdata1 : std_logic_vector (15 downto 0);

begin
		--MEMORY ACCESS--
		DM : data_memory
  PORT MAP (
    clka => clk,
    wea => we_dm0_ex,
    addra => a_dm0_ex,
    dina => d_dm0_ex,
    douta => memdata0,
--	clkb => clk,
    web => we_dm1_ex,
    addrb => a_dm1_ex,
    dinb => d_dm1_ex,
    doutb => memdata1
  );
		
		
	process(ret_select0_ex, ret_select1_ex, memdata0, memdata1, d_rd0_ex, d_rd1_ex)
		begin
			if ret_select0_ex = '1' then
				memrd0 <= memdata0;
			else
				memrd0 <= d_rd0_ex;
			end if;
			
			if ret_select1_ex = '1' then
				memrd1 <= memdata1;
			else
				memrd1 <= d_rd1_ex;
			end if;
	end process;
			
		--REGISTERED OUTPUTS--
	process(clk)
		begin
			if rising_edge(clk) then
				we_rd0_id <= we_rd0_ex;
				we_rd1_id <= we_rd1_ex;
				d_rd0_id <= d_rd0_ex;
				d_rd1_id <= d_rd1_ex;
				a_rd0_id <= a_rd0_ex;
				a_rd1_id <= a_rd1_ex;
				d_rd0_id <= memrd0;
				d_rd1_id <= memrd1;
			end if;
	end process;
end Behavioral;

