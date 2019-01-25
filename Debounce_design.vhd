----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/16/2018 04:26:31 PM
-- Design Name: 
-- Module Name: Debounce_design - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debounce_design is
    port(   clk : in std_logic;
            Reset : in std_logic;
            button_in : in std_logic;
            pulse_out : out std_logic
        );
end Debounce_design;

architecture Behavioral of Debounce_design is
    signal clock: std_logic;
--the below constants decide the working parameters.
--the higher this is, the more longer time the user has to press the button.
constant COUNT_MAX : integer := 20; 
--set it '1' if the button creates a high pulse when its pressed, otherwise '0'.
constant BTN_ACTIVE : std_logic := '1';

signal count : integer := 0;
type state_type is (idle,wait_time); --state machine
signal state : state_type := idle;

begin
  
clk_divider: entity work.clock_divider(Behavioral)
    port map(clk => clk, reset => Reset, clk_out => clock);

process(Reset,clock)
begin
    if(Reset = '1') then
        state <= idle;
        pulse_out <= '0';
   elsif(rising_edge(clock)) then
        case (state) is
            when idle =>
                if(button_in = BTN_ACTIVE) then  
                    state <= wait_time;
                else
                    state <= idle; --wait until button is pressed.
                end if;
                pulse_out <= '0';
            when wait_time =>
                if(count = COUNT_MAX) then
                    count <= 0;
                    if(button_in = BTN_ACTIVE) then
                        pulse_out <= '1';
                    end if;
                    state <= idle;  
                else
                    count <= count + 1;
                end if; 
        end case;       
    end if;        
end process;                  
                                                                                
end architecture Behavioral;
