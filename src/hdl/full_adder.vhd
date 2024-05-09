--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2018 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : top_basys3.vhd
--| AUTHOR(S)     : Capt Dan Johnson
--| CREATED       : 01/30/2019 Last Modified 06/24/2020
--| DESCRIPTION   : This file implements the top level module for a BASYS 3 to create a full adder
--|                 from two half adders.
--|
--|					Inputs:  sw (2:0) 	 --> 3-bit sw input (Sum bits and 1 cin)
--|							 
--|					Outputs: led (1:0)   --> sum output and carry out.
--|
--| DOCUMENTATION : None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : sevenSegDecoder.vhd
--|
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
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity full_adder is
	port(
		-- Switches
		i_A, i_B, i_c		: in std_logic;
		
		
	
		o_S     : out std_logic;
		o_Cout     : out std_logic
	);
end full_adder;

architecture full_adder_arch of full_adder is 
	
  -- declare the component of your top-level design 
  component halfAdder is 
    port(
      i_A     : in  std_logic; 
      i_B     : in  std_logic; 
      o_S     : out std_logic;
      o_Cout  : out std_logic 
    );
  end component halfAdder;

  -- declare any signals you will need	
  signal w_s1, w_Cout1, w_Cout2 : std_logic := '0';
  
begin
	-- PORT MAPS --------------------
        halfAdder1_inst: halfAdder 
        port map(
            i_A     => i_A,
            i_B     => i_B,
            o_S     => w_s1,
            o_Cout  => w_Cout1
        );
    
        halfAdder2_inst: halfAdder
        port map(
            i_A     => w_s1,
            i_B     => i_c,
            o_S     => o_s,
            o_Cout  => w_Cout2
            
        );
	
	-- CONCURRENT STATEMENTS --------
	 o_Cout <= w_Cout1 OR w_Cout2;
	---------------------------------
end full_adder_arch;
