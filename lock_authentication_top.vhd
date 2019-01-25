----------------------------------------------------------------------------------
-- Company: 
-- Engineer:        Maharshi Shah
-- 
-- Create Date: 06/12/2018 09:31:58 PM
-- Design Name: 
-- Module Name: lock_authentication_top - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lock_authentication_top is
  Port (
            clk: in std_logic;
            sw: in std_logic_vector(15 downto 0);
            led: out std_logic_vector(15 downto 0);
            an : out std_logic_vector (3 downto 0);
            sseg : out std_logic_vector (7 downto 0);
            btnC, btnD,btnL,btnR,btnU: in std_logic
            
   );
end lock_authentication_top;

architecture Behavioral of lock_authentication_top is
    signal bc, bd, bu, bl, br: std_logic;
    signal false_and_locked: std_logic;
    signal true_keys: std_logic;
    signal display: std_logic_vector(3 downto 0);
begin  
        
        Authentication: entity work.lock(fsm_arch)
        Port map(   clk => clk,
                    in_sequence => sw(3 downto 0), 
                    btnC => bc, 
                    btnU => bu, 
                    btnD => bd, 
                    btnR => br, 
                    btnL => bl,
                    false_and_locked => false_and_locked, 
                    true_keys=> true_keys);

        Debounce_buttonC: entity work.debounce(Behavioral)          --Debounce circuit with in built clock divider for btn C
                    Port map   (clk => clk, 
                                button => btnC,
                                result => bc
                                );
        
         Debounce_buttonD: entity work.debounce(Behavioral)         --Debounce circuit with in built clock divider for btn D
                  Port map (clk => clk, 
                            button => btnD,
                            result => bd
                             );             
        
         Debounce_buttonU: entity work.debounce(Behavioral)         --Debounce circuit with in built clock divider for btn U
                            Port map(clk => clk, 
                                     button => btnU,
                                     result => bu
                                        );
                
         Debounce_buttonL: entity work.debounce(Behavioral)         --Debounce circuit with in built clock divider for btn L
                                      Port map(clk => clk, 
                                                button => btnL,
                                                result => bl 
                                                );       
         
         Debounce_buttonR: entity work.debounce(Behavioral)         --Debounce circuit with in built clock divider for btn R
                                        Port map( clk => clk, 
                                                  button => btnR,
                                                  result => br
                                                  );
        
        display_sseg: entity work.disp_hex_mux(Behavioral)
        Port map(   clk => clk, 
                    reset => '0', 
                    an => an, 
                    sseg => sseg, 
                    dp_in =>"1111", 
                    hex3 => display,
                    hex2 => display,
                    hex1 => display,
                    hex0 => sw(3 downto 0) );
        
        led <= (others => '1')  when true_keys = '1' else sw; 
        display <= ("1111") when false_and_locked = '1' else (others => '0');     
        --1111 is defined as "-" on display insead of F                  
        
end Behavioral;
