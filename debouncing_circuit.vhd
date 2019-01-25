----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/12/2018 09:16:22 PM
-- Design Name: 
-- Module Name: debouncing_circuit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncing_circuit is
  Port (    clk : in std_logic;
            reset : in std_logic;
            sw : in std_logic;
            db: out std_logic 
                 );
end debouncing_circuit;

architecture fsm_arch of debouncing_circuit is
    constant N: integer := 20; 
    type db_state_type is (zero , wait1_1 , wait1_2 , wait1_3 ,one , wait0_1 , wait0_2 , wait0_3 );
    signal clock: std_logic;
    signal q_reg , q_next : unsigned (N -1 downto 0);
    signal m_tick : std_logic ;
    signal state_reg : db_state_type ;
    signal state_next : db_state_type ;

begin

    clk_divider: entity work.clock_divider(Behavioral)
    port map(clk => clk, reset => reset, clk_out => clock);
    
    process(clock ,reset)
    begin
    if (clock'event and clock = '1') then
        q_reg <= q_next ;
    end if ;
    end process;
    
    q_next <= q_reg + 1;
    m_tick <= '1' when q_reg = 0 else '0';

    process(clock ,reset)
    begin
    if (reset = '1') then
        state_reg <= zero ;
    elsif (clock'event and clock = '1') then
        state_reg <= state_next ;
    end if ;
    end process;
    
    process(state_reg , sw, m_tick)
    begin
    state_next <= state_reg ; 
    db <= '0';
    case state_reg is
        when zero =>
        if sw = '1' then
            state_next <= wait1_1 ;
        end if ;
    
        when wait1_1 =>
        if sw = '0' then
            state_next <= zero ;
        else
           if m_tick ='1' then
                state_next <= wait1_2 ;
            end if ;
        end if ;
    
        when wait1_2 =>
        if sw = '0' then
            state_next <= zero ;
        else
            if m_tick ='1' then
                state_next <= wait1_3 ;
            end if ;
        end if ;
    
        when wait1_3 =>
        if sw = '0' then
            state_next <= zero ;
        else
            if m_tick ='1' then
                state_next <= one;
            end if ;
        end if ;
    
        when one =>
        db <= '1';
        if sw = '0' then
            state_next <= wait0_1 ;
        end if ;
    
        when wait0_1 =>
        db <= '1';
        if sw='1' then
            state_next <= one;
        else
            if m_tick ='1' then
                state_next <= wait0_2;
            end if ;
        end if ;
    
        when wait0_2 =>
        db <= '1';
        if sw = '1' then
            state_next <= one;
        else
            if m_tick = '1' then
                state_next <= wait0_3 ;
            end if ;
        end if ;
    
        when wait0_3 =>
        db <= '1';
        if sw = '1' then
            state_next <= one ;
        else
            if m_tick = '1' then
                state_next <= zero ;
            end if ;
        end if ;
        
     end case;
        
   end process;    

end fsm_arch;
