----------------------------------------------------------------------------------
-- Company: 
-- Engineer:            Maharshi Shah
-- 
-- Create Date: 06/13/2018 01:24:39 PM
-- Design Name: 
-- Module Name: lock - fsm_arch
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

entity lock is
Port (   clk: in std_logic;
         btnC, btnD, btnL, btnU, btnR: in std_logic;
         in_sequence: in std_logic_vector (3 downto 0);
         true_keys: out std_logic;
         false_and_locked: out std_logic);
end lock;

architecture fsm_arch of lock is
        type state_name is (P1, P2, P3,                 -- Programming mode states
                            read1, read2, read3,        -- Reading input in Programming mode
                            ready_store,                -- Store programmed keys
                            N1, N2, N3,                 -- Normal mode states
                            r1, r2, r3,                 -- Reading input in Normal mode
                            ready_check,                -- Store and compare normal mode keys
                            fail,                
                            unlock, lock);              -- Take action: Unlock or Lock after 3 tries           
        
        signal state_reg , state_next : state_name;    
        signal program_num1, program_num2, program_num3: std_logic_vector(3 downto 0);
        signal try_keys1, try_keys2, try_keys3: std_logic_vector(3 downto 0);
        signal count: std_logic_vector(3 downto 0);
        signal true_keynum1, true_keynum2,true_keynum3: std_logic_vector(3 downto 0);
        signal normalnum1, normalnum2, normalnum3: std_logic_vector(3 downto 0);
        signal fail_tick_1: std_logic;
        signal fail_tick_2: std_logic;
begin
        
-- Next state logic
        process(clk , btnC)
        begin
        if (btnC = '1') then
            state_reg <= P1;
        elsif (clk'event and clk = '1') then
            state_reg <= state_next;
                  
        end if;
        end process;
        
        process(clk, btnC)
        begin
        if (clk'event and clk = '1') then
            if(btnC = '1')then
                count <= (others => '0');
            elsif(state_reg = fail)then
               count <= count + "0001";
            end if;
        end if;
        end process;
        
        
        process( state_reg, 
                 in_sequence, 
                 true_keynum1,true_keynum2,
                 true_keynum3, 
                 normalnum1,
                 normalnum2, 
                 normalnum3,
                 count, 
                 btnC,
                 btnD, btnL, btnU, btnR)
                 
        begin
        state_next <= state_reg;
        case state_reg is
 -----------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------            
--PROGRAMMING MODE:
             when P1 =>
                      if(btnL = '1')then
                         state_next <= read1;
                      elsif(btnC = '1'or btnD ='1')then
                          state_next <= P1;
                      else 
                          state_next <= P1;
                      end if;
            when read1 =>
                    if(btnC = '1'or btnD ='1')then
                        state_next <= P1;
                    else
                        state_next <= P2;
                    end if;
                                     
            when P2 =>
                  if(btnL = '1')then
                    state_next <= read2;
                  elsif(btnC = '1'or btnD ='1')then
                    state_next <= P1;                 
                  else 
                    state_next <= P2;
                 end if;
            
            when read2 => 
                      if(btnC = '1'or btnD ='1')then
                        state_next <= P1; 
                      else 
                        state_next <= P3;   
                      end if;                
            when P3 =>
                if(btnL = '1')then
                   state_next <= read3;
                elsif(btnC = '1'or btnD ='1')then
                    state_next <= P1;                         
                else 
                    state_next <= P3;
                end if;
            
            when read3 =>
                    if(btnR = '1')then
                       state_next <= ready_store;
                    elsif (btnC = '1'or btnD ='1')then
                        state_next <= P1;
                    else 
                        state_next <= read3;
                    end if;
 -- Ready to store key          
            when ready_store =>
                    if(btnU = '1')then
                        state_next <= N1;
                    elsif(btnC = '1'or btnD ='1')then
                        state_next <= P1;
                    else 
                        state_next <= ready_store;
                    end if;                              
---------------------------------------------------------------------------------------------
-- NORMAL MODE:
                when N1 =>
                        if(btnL = '1')then
                           state_next <= r1;
                        elsif(btnC = '1'or btnD ='1')then
                            state_next <= P1;
                        else 
                            state_next <= N1;
                        end if;
                                    
                when r1 =>
                        state_next <= N2;
                        if(btnC = '1'or btnD ='1')then
                            state_next <= P1;
                        end if;
                
                when N2 =>
                        if(btnL = '1') then
                            state_next <= r2;
                        elsif(btnC = '1'or btnD ='1')then
                            state_next <= P1;
                        else 
                            state_next <= N2;
                        end if;
                when r2 =>
                       state_next <= N3;
                       if(btnC = '1'or btnD ='1')then 
                            state_next <= P1;
                       end if;
                       
                when N3 =>
                   if(btnL = '1') then
                       state_next <= r3;
                   elsif(btnC = '1'or btnD ='1')then
                        state_next <= P1;
                   else 
                        state_next <= N3;
                   end if;
                           
                when r3 =>
                        if(btnR = '1')then
                             state_next <= ready_check;
                        elsif(btnC = '1' or btnD ='1')then 
                             state_next <= P1;
                        else 
                             state_next <= r3;
                        end if;  
                
                when ready_check =>
                     if(true_keynum1 = normalnum1 and true_keynum2 = normalnum2 and true_keynum3 = normalnum3)then
                        state_next <= unlock;
                     else
                        state_next <= fail;
                     end if;             
                    
                 when fail =>
                    if(count < "0010")then
                        state_next <= N1;
                    else state_next <= lock;
                    end if;       
                    
                    
-------------------------------------------------------------------------------------------------
--UNLOCK MODE:
            when unlock =>
         -- authenticate if all keys are true.
                state_next <= unlock;    
                if( btnC = '1')then
                    state_next <= P1;                            
                end if;
--------------------------------------------------------------------------------------------------
--LOCK MODE:                
                when lock =>
                      state_next <= lock;
                      if(btnC = '1')then
                        state_next <= P1;
                      end if;
            end case;               
        end process;
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--Input/Output Logic:

--Programming mode i/o:      
      program_num1 <= in_sequence when (state_reg = read1);
      program_num2 <= in_sequence when (state_reg = read2);
      program_num3 <= in_sequence when (state_reg = read3);
      
      true_keynum1 <= program_num1 when (state_reg = ready_store);
      true_keynum2 <= program_num2 when (state_reg = ready_store);
      true_keynum3 <= program_num3 when (state_reg = ready_store);

-- Normal mode i/o:
      try_keys1 <= in_sequence when (state_reg = r1);
      try_keys2 <= in_sequence when (state_reg = r2);
      try_keys3 <= in_sequence when (state_reg = r3);
      
      normalnum1 <= try_keys1 when (state_reg = ready_check);
      normalnum2 <= try_keys2 when (state_reg = ready_check);
      normalnum3 <= try_keys3 when (state_reg = ready_check);

--Unlock mode o/p
      true_keys <= '1' when (state_reg = unlock) else '0';

--Lock mode o/p
      false_and_locked <= '1' when (state_reg = lock) else '0';
--------------------------------------------------------------------------------------------------------      
--------------------------------------------------------------------------------------------------------
end fsm_arch;
