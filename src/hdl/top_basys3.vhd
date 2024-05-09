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


entity top_basys3 is
    port(
        i_A, i_B : std_logic_vector(7 downto 0);
        btnU     :   in std_logic;
        btnC     :   in std_logic; 
        sw       :   in std_logic_vector(15 downto 0);
        
        led      :   out std_logic_vector(15 downto 0);
        seg      :   out std_logic_vector(6 downto 0);
        an       :   out std_logic_vector(3 downto 0)
    
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 

component twoscomp_decimal is
    port (
        i_binary: in std_logic_vector(7 downto 0);
        o_negative: out std_logic;
        o_hundreds: out std_logic_vector(3 downto 0);
        o_tens: out std_logic_vector(3 downto 0);
        o_ones: out std_logic_vector(3 downto 0)
    );
end component twoscomp_decimal;
    
component clock_divider is
	generic ( constant k_DIV : natural := 2	); -- How many clk cycles until slow clock toggles
											   -- Effectively, you divide the clk double this 
											   -- number (e.g., k_DIV := 2 --> clock divider of 4)
	port ( 	i_clk    : in std_logic;
			i_reset  : in std_logic;		   -- asynchronous
			o_clk    : out std_logic		   -- divided (slow) clock
	);
end component clock_divider;

component controller_fsm is
    port(
    i_reset, i_adv       : in std_logic;  
    o_cycle              : out std_logic_vector(3 downto 0)
  );
end component controller_fsm;

component TDM4 is
	generic ( constant k_WIDTH : natural  := 4); -- bits in input and output
    Port ( i_clk		: in  STD_LOGIC;
           i_reset		: in  STD_LOGIC; -- asynchronous
           i_D3 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   i_D2 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   i_D1 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   i_D0 		: in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   o_data		: out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
		   o_sel		: out STD_LOGIC_VECTOR (3 downto 0)	-- selected data line (one-cold)
	);
end component TDM4;

component ALU is
    port(
    i_A, i_B        : in std_logic_vector(7 downto 0); 
    i_S            : in std_logic_vector(2 downto 0);
    o_flags         : out std_logic_vector(15 downto 13);
    o_ALU_result    : out std_logic_vector(7 downto 0)
  );
end component ALU;

component sevenSegDecoder is
    Port ( i_D : in STD_LOGIC_VECTOR (3 downto 0);
           o_S : out STD_LOGIC_VECTOR (6 downto 0));
end component sevenSegDecoder;
   
component mux is
    port ( i_sel  : in std_logic_vector (1 downto 0);
           i_A : in std_logic_vector (7 downto 0);
           i_result : in std_logic_vector (7 downto 0);
           i_B : in std_logic_vector (7 downto 0);
           o_data_out  : out std_logic_vector (7 downto 0)
    );
end component mux;

    signal w_A, w_B, w_mux, w_num : std_logic_vector(7 downto 0);
    signal w_cycle                : std_logic_vector(3 downto 0);
    signal w_flags                : std_logic_vector(2 downto 0);
    signal w_result               : std_logic_vector(2 downto 0);
    signal  w_sign,w_hund, w_tens, w_ones : std_logic_vector(3 downto 0); --sign is the problem
    signal w_clk_div      : std_logic;
    signal w_anode                : std_logic_vector(3 downto 0);
   
begin
	-- PORT MAPS ---------------------------------------- 
	controller_fsm_inst : controller_fsm
	   port map(
        i_reset => btnU,
        i_adv   => btnC,   
        o_cycle => w_cycle 
    );
    
	w_A <= i_A when w_cycle = "0001" else w_A;
	w_B <= i_B when w_cycle = "0010" else w_B;
	
    ALU_inst : ALU
        port map(
            i_A           => i_A,
            i_B           => i_B,    
            i_S           => "000",   --wtf does this do       
            o_flags       => led(15 downto 13),
            o_ALU_result  => w_result
            );
            
	mux_inst : mux 
	   port map(
	       i_sel       => w_cycle,
           i_A         => i_A,
           i_result    => w_result,
           i_B         => i_B,
           o_data_out  => w_mux
    );
	
	twoscomp_decimal_inst : twoscomp_decimal
	   port map(
        i_binary   => w_mux,
        o_negative => w_sign,
        o_hundreds => w_hund,
        o_tens     => w_tens,
        o_ones     => w_ones
    );
    
    TDM4_inst : TDM4
        Port map( 
           i_clk   => w_clk_div,
           i_reset => btnU,		
           i_D3    => w_sign,		
		   i_D2    => w_hund,	
		   i_D1    => w_tens,
		   i_D0    => w_ones,
		   o_data  => w_num,
		   o_sel   => an
	);
	
	sevenSegDecoder_inst : sevenSegDecoder
	   Port map( 
	       i_D => w_num,
           o_S => seg
	);
	
	led(3 downto 0) <= w_cycle;
	led(12 downto 4) <= (others => '0');
	
end top_basys3_arch;
