----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:05:40 04/13/2018 
-- Design Name: 
-- Module Name:    data_memory - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;



entity data_memory is
	generic (
			ADDR_WIDTH : integer := 8;
			DATA_WIDTH : integer := 16
			);
			
	Port ( clka : in  STD_LOGIC;
           wea : in  STD_LOGIC_VECTOR (0 downto 0);
           addra : in  STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           dina : in  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0);
           douta : out  STD_LOGIC_VECTOR (15 downto 0);
           web : in  STD_LOGIC_VECTOR (0 downto 0);
           addrb : in  STD_LOGIC_VECTOR (ADDR_WIDTH-1 downto 0);
           dinb : in  STD_LOGIC_VECTOR (15 downto 0);
           doutb : out  STD_LOGIC_VECTOR (DATA_WIDTH-1 downto 0));
end data_memory;

architecture Behavioral of data_memory is
type a_bram is array (2** ADDR_WIDTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
signal bram : a_bram;

begin
	process (clka)
		begin
			if rising_edge(clka) then
			
				if wea = "1" then
					bram (to_integer(unsigned(addra))) <= dina;
				end if;
				
				if web = "1" then
					bram (to_integer(unsigned(addrb))) <= dinb;
				end if;
				
			end if;
			
	end process;
	
	douta <= bram(to_integer(unsigned(addra)));
	doutb <= bram(to_integer(unsigned(addrb)));
					

end Behavioral;

