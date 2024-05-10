--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
--|
--| ALU OPCODES:
--|
--|     ADD     000
--|
--|
--|
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ALU is
    port(
    i_A, i_B        : in std_logic_vector(7 downto 0); 
    i_S            : in std_logic_vector(2 downto 0);
    o_flags         : out std_logic_vector(15 downto 13);
    o_ALU_result    : out std_logic_vector(7 downto 0)
  );
end ALU;



architecture behavioral of ALU is 

component full_adder is
	port(
		-- Switches
		i_A, i_B, i_c		: in std_logic;
		o_S     : out std_logic;
		o_Cout     : out std_logic
	);
end component full_adder;
    
    signal w_result_final, w_result     : std_logic_vector(7 downto 0);
    signal w_B     : std_logic_vector(7 downto 0);
    signal w_shiftL, w_shiftR, w_shift     : std_logic_vector(7 downto 0);
    signal w_state      : std_logic_vector(3 downto 0);
    signal w_sw         : std_logic_vector(2 downto 0);
    signal w_cout       : std_logic_vector (7 downto 0);
    signal w_zero, w_sign       : std_logic;
    signal w_and, w_or   : std_logic_vector(7 downto 0);
    
    
begin
	-- PORT MAPS ---------------------------------------- 
	adder0_inst : full_adder
	   port map (
	       i_A => i_A(0),
	       i_B => i_B(0),
	       i_c => i_S(0),
	       o_S => w_result_final(0),
	       o_Cout => w_cout(0)
	       );
	   adder1_inst :full_adder
	   port map (
	       i_A => i_A(1),
	       i_B => i_B(1),
	       i_c => w_cout(0),
	       o_S => w_result_final(1),
	       o_Cout => w_cout(1)
	       );
	   adder2_inst : full_adder
	   port map (
	       i_A => i_A(2),
	       i_B => i_B(2),
	       i_c => w_cout(1),
	       o_S => w_result_final(2),
	       o_Cout => w_cout(2)
	       );
	   adder3_inst : full_adder
	   port map (
	       i_A => i_A(3),
	       i_B => i_B(3),
	       i_c => w_cout(2),
	       o_S => w_result_final(3),
	       o_Cout => w_cout(3)
	       );
	   adder4_inst : full_adder
	   port map (
	       i_A => i_A(4),
	       i_B => i_B(4),
	       i_c => w_cout(3),
	       o_S => w_result_final(4),
	       o_Cout => w_cout(4)
	       );
	   adder5_inst : full_adder
	   port map (
	       i_A => i_A(5),
	       i_B => i_B(5),
	       i_c => w_cout(4),
	       o_S => w_result_final(5),
	       o_Cout => w_cout(5)
	       );
	   adder6_inst : full_adder
	   port map (
	       i_A => i_A(6),
	       i_B => i_B(6),
	       i_c => w_cout(5),
	       o_S => w_result_final(6),
	       o_Cout => w_cout(6)
	       );
	   adder7_inst : full_adder
	   port map (
	       i_A => i_A(7),
	       i_B => i_B(7),
	       i_c => w_cout(6),
	       o_S => w_result_final(7),
	       o_Cout => w_cout(7)
	       );
	
	
  
	-- CONCURRENT STATEMENTS ----------------------------
	w_B  <= i_B when i_S(0) = '0'
	        else not i_B;
	        
	w_shiftL <= std_logic_vector(shift_left(unsigned(i_A), to_integer(unsigned(i_B(2 downto 0)))));
	
	w_shiftR <= std_logic_vector(shift_right(unsigned(i_A), to_integer(unsigned(i_B(2 downto 0)))));
	           
	w_shift <= w_shiftL when i_S(0)= '0'
	           else w_shiftR;
	           
	o_ALU_result <= w_result_final when i_S(2 downto 1) = "00"
	               else w_shift when i_S(2 downto 1) = "01"
	               else (i_A and i_B) when i_S(2 downto 1) = "10"
	               else (i_A or i_B) when i_S(2 downto 1) = "11";
	              
    o_flags(13) <= w_cout(7);
    o_flags(14) <= '1' when w_result_final = "00000000";
    o_flags(15) <= '1' when w_result_final(7) = '1'
                    else '0';
	
	
end behavioral;
