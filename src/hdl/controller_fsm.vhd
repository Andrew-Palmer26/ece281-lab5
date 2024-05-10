----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/06/2024 05:20:40 PM
-- Design Name: 
-- Module Name: controller_fsm - Behavioral
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

entity controller_fsm is
    port(
    i_reset, i_adv       : in std_logic;  
    o_cycle              : out std_logic_vector(3 downto 0);
    i_clk                : in std_logic
  );
end controller_fsm;

architecture Behavioral of controller_fsm is
    type state is (state0, state1, state2, state3);
    
    signal f_Q, f_Q_next : state;

    signal w_adv : std_logic := '1';
begin

    f_Q_next <= state1 when (f_Q = state0) else
                state2 when (f_Q = state1) else
                state3 when (f_Q = state2) else
                state0 when (f_Q = state3) else
                state0;
                
    with f_Q select 
        o_cycle <= "0001" when state0,
                   "0010" when state1,
                   "0100" when state2,
                   "1000" when state3;

register_proc : process (i_clk)
    begin
        if (rising_edge(i_clk)) then
             -- synchronous reset
            if i_reset = '1' then
                f_Q <= state0;
            elsif  (i_adv ='1' and w_adv = '1') then
                f_Q <= f_Q_next;   
                w_adv <= '0';             
            elsif (i_adv = '0' and w_adv = '0') then
                w_adv <= '1' after 1000 ms;
            end if;   
        end if;
    end process;
end Behavioral;
