----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/12/2018 05:59:15 PM
-- Design Name: 
-- Module Name: lock_authentication - fsm_arch
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity lock_authentication is
  Port ( clk: in std_logic;
         reset: in std_logic;
         btnC, btnD, btnL, btnU, btnR: in std_logic;
         in_sequence: in std_logic_vector (3 downto 0);
         true_keys: out std_logic;
         false_and_locked: out std_logic
         --display_number: out std_logic_vector (3 downto 0)
                 );
end lock_authentication;

architecture fsm_arch of lock_authentication is
        type state_name is (P, N, L);
        signal state_reg , state_next : state_name;    
        signal num1, num2, num3: std_logic_vector(3 downto 0);
        signal true_key1, true_key2, true_key3: std_logic_vector(3 downto 0);

begin
       -- next state logic
        process(clk , reset)
        begin
        if (reset = '1') then
            state_reg <= P;
        elsif (clk ' event and clk = '1') then
            state_reg <= state_next;
            end if ;
        end process;
      
       process(state_reg, in_sequence, num1, num2, num3, 
                btnC, btnR, btnD, btnU, btnL, true_key1, 
                true_key2, true_key3)
       --variable count: integer:=0;
       begin
       state_next <= state_reg;
       true_keys <= '0';
       false_and_locked <= '0';
       case state_reg is
            --Programming mode state logic:
            when P =>  
                if(btnD = '1' or btnC = '1')then
                        if(btnL = '1')then
                             num1 <= in_sequence;
                           --  display_number <= num1;
                             if(btnL = '1') then
                                num2 <= in_sequence;
                             --   display_number <= num1;
                                if(btnL = '1') then
                                    num3 <= in_sequence;
                                    if(btnR = '1')then
                                    true_key1 <= num1;
                                    true_key2 <= num2;
                                    true_key3 <= num3;
                                    state_next <= N;
                                    end if;
                                end if;
                            end if;
                        end if;
             elsif(btnU = '1')then
                state_next <= N;
             end if;
      --Normal mode state logic:
             when N => 
                  if(btnU = '1')then
                        if(btnL = '1')then  
                            num1 <= in_sequence;    
                           -- display_number <= num1;
                            if (btnL = '1')then
                                num2 <= in_sequence;
                                --display_number <= num2;
                              if(btnL = '1') then
                                   num3 <= in_sequence;
                                --   display_number <= num3;
                                if(btnR = '1' and num1 = true_key1 and num2 = true_key2 and num3 = true_key3)then
                                    true_keys <= '1';
                                else state_next <= L; 
                                end if;
                              end if;
                            end if;
                        end if;
                   elsif(btnC = '1' or btnD = '1')then
                        state_next <= P;
                   end if;  
       -- Lock mode state logic:                          
          when L =>
                --display_number <= "1100"; -- temporary. What is "---" in display mux?
                false_and_locked <= '1'; 
                state_next <= L;
                if(btnC = '1')then
                    state_next <= P;
                end if;
       end case;
   end process;
end fsm_arch;
