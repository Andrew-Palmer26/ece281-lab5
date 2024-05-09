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
    o_cycle              : out std_logic_vector(3 downto 0)
  );
end controller_fsm;

architecture Behavioral of controller_fsm is

    signal w_cycle : std_logic_vector(3 downto 0):= "0001";
    
begin

advance_proc : process(i_reset, i_adv) 
begin
    case w_cycle is 
        when "0001" => 
            if i_adv = '1'
                then w_cycle <= "0010";
            elsif i_reset = '1'
                then w_cycle <= "0001";
            end if;
        when "0010" => 
            if i_adv = '1'
                then w_cycle <= "0100";
            elsif i_reset = '1'
                then w_cycle <= "0001";
            end if;
        when "0100" => 
            if i_adv = '1'
                then w_cycle <= "1000";
            elsif i_reset = '1'
                then w_cycle <= "0001";
            end if; 
        when "1000" => 
            if i_adv = '1'
                then w_cycle <= "0001";
            elsif i_reset = '1'
                then w_cycle <= "0001";      
            end if;
        end case;
    end process advance_proc;
    o_cycle <= w_cycle;
end Behavioral;
