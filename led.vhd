----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/03/2018 9:22:42 PM
-- Design Name: 
-- Module Name: led - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

 
entity led is
    Port ( led : out std_logic_vector (15 downto 0);
           sw : in  STD_LOGIC_VECTOR (15 downto 0)
                    );
end led;

architecture Behavioral of led is
begin
        led <= sw;
end Behavioral;