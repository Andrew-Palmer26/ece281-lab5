----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/08/2024 09:28:56 PM
-- Design Name: 
-- Module Name: mux - Behavioral
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

entity mux is
    port ( i_sel  : in std_logic_vector (1 downto 0);
           i_A : in std_logic_vector (7 downto 0);
           i_result : in std_logic_vector (7 downto 0);
           i_B : in std_logic_vector (7 downto 0);
           o_data_out  : out std_logic_vector (7 downto 0)
    );
end mux;

architecture Behavioral of mux is

begin

    o_data_out <= (i_A) when (i_sel = "00") else
                  (i_B) when (i_sel = "01") else
                  (i_result) when (i_sel = "10") else
                  "0101010";


end Behavioral;
