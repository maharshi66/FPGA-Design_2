----------------------------------------------------------------------------------
-- Company: 
-- Engineer:        Maharshi Shah
-- 
-- Create Date: 06/16/2018 04:50:05 PM
-- Design Name: 
-- Module Name: debounce - behav
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debounce is             -- Debouncing circuit with in-built Clock Divider
 Port ( clk     : IN  STD_LOGIC;  --input clock
        button  : IN  STD_LOGIC;  --input signal to be debounced
        result  : OUT STD_LOGIC); --debounced signal 
end debounce;

architecture Behavioral of debounce is
    signal   inff    : std_logic_vector(1 downto 0); -- input flip flops
    constant cnt_max : integer := (33000000/50)-1;   -- 33MHz and 1/20ms=50Hz
    signal   count   : integer range 0 to cnt_max := 0; 

begin
  process(clk)
  begin
    if(clk'event and clk = '1') then
      inff <= inff(0) & button;  -- sync in the input
      if(inff(0)/=inff(1)) then  -- reset counter because input is changing
        count <= 0;
      elsif(count < cnt_max) then  -- stable input time is not yet met
        count <= count + 1;
      else                       -- stable input time is met
        result <= inff(1);
      end if;    
    end if;
  end process;

end Behavioral;
