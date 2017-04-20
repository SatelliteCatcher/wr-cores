library ieee;
use ieee.std_logic_1164.all;
use work.wr_fabric_pkg.all;
use work.wrcore_pkg.all;
use work.wishbone_pkg.all;  -- needed for t_wishbone_slave_in, etc

package streamers_pkg is
  type t_streamers_op_mode is (RX_ONLY, TX_ONLY, TX_AND_RX);
  -----------------------------------------------------------------------------------------
  -- Transmission parameters (tx)
  -----------------------------------------------------------------------------------------
  type t_tx_streamer_params is record
    -- Width of data words on tx_data_i, must be multiple of 16 bits.
    data_width            : integer;

    -- Size of Tx buffer, in data words.
    buffer_size           : integer;

    -- Minimum number of data words in the TX buffer that will trigger transmission of an
    -- Ethernet frame. It cannot be breater than g_tx_buffer_size; it is recommended that
    -- g_tx_buffer_size = 2 * g_tx_threshold.
    -- Note that in order for a frame to be transmitted, the buffer must conatain at
    -- least one complete block.ransmitted, the buffer must conatain at
    -- least one complete block.
    threshold             : integer;

    -- Maximum number of data words in a single Ethernet frame. It also defines
    -- the maximum block size (since blocks can't be currently split across
    -- multiple frames). It cannot be greater than g_tx_buffer_size
    max_words_per_frame   : integer;

    -- Transmission timeout (in clk_sys_i cycles), after which the contents
    -- of TX buffer are sent regardless of the amount of data that is currently
    -- stored in the buffer, so that data in the buffer does not get stuck.
    timeout               : integer;

    -- DO NOT USE unless you know what you are doing
    -- legacy stuff: the streamers initially used in Btrain did not check/insert the escape
    -- code. This is justified if only one block of a known number of words is sent/expected
    escape_code_disable   : boolean;
  end record;

  -----------------------------------------------------------------------------------------
  -- Reception parameters (rx)
  -----------------------------------------------------------------------------------------
  type t_rx_streamer_params is record
    -- Width of the data words, must be multiple of 16 bits. This value set to this generic
    -- on the receviving device must be the same as the value of g_tx_data_width set on the
    -- transmitting node. The g_rx_data_width and g_tx_data_width can be set to different
    -- values in the same device (i.e. instantiation of xwr_transmission entity). It is the
    -- responsibility of a network designer to make sure these parameters are properly set 
    -- in the network.
    data_width            : integer;

    -- Size of RX buffer, in data words.
    buffer_size           : integer;

    -- DO NOT USE unless you know what you are doing
    -- legacy stuff: the streamers that were initially used in Btrain did not check/insert 
    -- the escape code. This is justified if only one block of a known number of words is 
    -- sent/expected.
    escape_code_disable   : boolean;

    -- DO NOT USE unless you know what you are doing
    -- legacy stuff: the streamers that were initially used in Btrain accepted only a fixed
    -- number of words, regardless of the frame content. If this generic is set to number
    -- other than zero, only a fixed number of words is accepted. 
    -- In combination with the g_escape_code_disable generic set to TRUE, the behaviour of
    -- the "Btrain streamers" can be recreated.
    expected_words_number : integer;
  end record;

  constant c_tx_streamer_params_defaut: t_tx_streamer_params :=(
      data_width            => 32,
      buffer_size           => 256,
      threshold             => 128,
      max_words_per_frame   => 256,
      timeout               => 1024,
      escape_code_disable   => FALSE);

  constant c_rx_streamer_params_defaut: t_rx_streamer_params :=(
      data_width            => 32,
      buffer_size           => 256,
      escape_code_disable   => FALSE,
      expected_words_number => 0);

  component xtx_streamer
    generic (
      g_data_width             : integer := 32;
      g_tx_buffer_size         : integer := 256;
      g_tx_threshold           : integer := 128;
      g_tx_max_words_per_frame : integer := 256;
      g_tx_timeout             : integer := 1024;
      g_escape_code_disable    : boolean := FALSE);
    port (
      clk_sys_i        : in  std_logic;
      rst_n_i          : in  std_logic;
      src_i            : in  t_wrf_source_in;
      src_o            : out t_wrf_source_out;
      clk_ref_i        : in  std_logic                     := '0';
      tm_time_valid_i  : in  std_logic                     := '0';
      tm_tai_i         : in  std_logic_vector(39 downto 0) := x"0000000000";
      tm_cycles_i      : in  std_logic_vector(27 downto 0) := x"0000000";
      tx_data_i        : in  std_logic_vector(g_data_width-1 downto 0);
      tx_valid_i       : in  std_logic;
      tx_dreq_o        : out std_logic;
      tx_last_p1_i     : in  std_logic                     := '1';
      tx_flush_p1_i    : in  std_logic                     := '0';
      tx_reset_seq_i   : in  std_logic                     := '0';
      tx_frame_p1_o    : out std_logic;
      cfg_mac_local_i  : in  std_logic_vector(47 downto 0) := x"000000000000";
      cfg_mac_target_i : in  std_logic_vector(47 downto 0);
      cfg_ethertype_i  : in  std_logic_vector(15 downto 0) := x"dbff");
  end component;
  
  component xrx_streamer
    generic (
      g_data_width        : integer := 32;
      g_buffer_size       : integer := 256;
      g_escape_code_disable : boolean := FALSE;
      g_expected_words_number : integer := 0);
    port (
      clk_sys_i               : in  std_logic;
      rst_n_i                 : in  std_logic;
      snk_i                   : in  t_wrf_sink_in;
      snk_o                   : out t_wrf_sink_out;
      clk_ref_i               : in  std_logic                     := '0';
      tm_time_valid_i         : in  std_logic                     := '0';
      tm_tai_i                : in  std_logic_vector(39 downto 0) := x"0000000000";
      tm_cycles_i             : in  std_logic_vector(27 downto 0) := x"0000000";
      rx_first_p1_o           : out std_logic;
      rx_last_p1_o            : out std_logic;
      rx_data_o               : out std_logic_vector(g_data_width-1 downto 0);
      rx_valid_o              : out std_logic;
      rx_dreq_i               : in  std_logic;
      rx_lost_p1_o            : out std_logic := '0';
      rx_lost_blocks_p1_o     : out std_logic := '0';
      rx_lost_frames_p1_o     : out std_logic := '0';
      rx_lost_frames_cnt_o    : out std_logic_vector(14 downto 0);
      rx_latency_o            : out std_logic_vector(27 downto 0);
      rx_latency_valid_o      : out std_logic;
      rx_frame_p1_o           : out std_logic;
      cfg_mac_local_i         : in  std_logic_vector(47 downto 0) := x"000000000000";
      cfg_mac_remote_i        : in  std_logic_vector(47 downto 0) := x"000000000000";
      cfg_ethertype_i         : in  std_logic_vector(15 downto 0) := x"dbff";
      cfg_accept_broadcasts_i : in  std_logic                     := '1';
      cfg_filter_remote_i     : in std_logic                      := '0';
      cfg_fixed_latency_i     : in  std_logic_vector(27 downto 0) := x"0000000");
  end component;

  constant c_STREAMERS_ARR_SIZE_OUT : integer := 14;
  constant c_STREAMERS_ARR_SIZE_IN  : integer := 1;

  component xrtx_streamers_stats is
    generic (
      g_streamers_op_mode    : t_streamers_op_mode  := TX_AND_RX;
      g_cnt_width            : integer := 32;
      g_acc_width            : integer := 64
      );
    port (
      clk_i                  : in std_logic;
      rst_n_i                : in std_logic;
      sent_frame_i           : in std_logic;
      rcvd_frame_i           : in std_logic;
      lost_block_i           : in std_logic;
      lost_frame_i           : in std_logic;
      lost_frames_cnt_i      : in std_logic_vector(14 downto 0);
      rcvd_latency_i         : in  std_logic_vector(27 downto 0);
      rcvd_latency_valid_i   : in  std_logic;
      clk_ref_i              : in std_logic;
      tm_time_valid_i        : in std_logic := '0';
      tm_tai_i               : in std_logic_vector(39 downto 0) := x"0000000000";
      tm_cycles_i            : in std_logic_vector(27 downto 0) := x"0000000";
      reset_stats_i          : in std_logic;
      snapshot_ena_i         : in std_logic := '0';
      reset_time_tai_o       : out std_logic_vector(39 downto 0) := x"0000000000";
      reset_time_cycles_o    : out std_logic_vector(27 downto 0) := x"0000000";
      sent_frame_cnt_o       : out std_logic_vector(g_cnt_width-1 downto 0);
      rcvd_frame_cnt_o       : out std_logic_vector(g_cnt_width-1 downto 0);
      lost_frame_cnt_o       : out std_logic_vector(g_cnt_width-1 downto 0);
      lost_block_cnt_o       : out std_logic_vector(g_cnt_width-1 downto 0);
      latency_cnt_o          : out std_logic_vector(g_cnt_width-1 downto 0);
      latency_acc_overflow_o : out std_logic;
      latency_acc_o          : out std_logic_vector(g_acc_width-1  downto 0);
      latency_max_o          : out std_logic_vector(27  downto 0);
      latency_min_o          : out std_logic_vector(27  downto 0);
      snmp_array_o           : out t_generic_word_array(c_STREAMERS_ARR_SIZE_OUT-1 downto 0);
      snmp_array_i           : in  t_generic_word_array(c_STREAMERS_ARR_SIZE_IN -1 downto 0) := (others => (others=>'0'))
      );
  end component;

  constant c_WR_TRANS_ARR_SIZE_OUT : integer := c_STREAMERS_ARR_SIZE_OUT+3;
  constant c_WR_TRANS_ARR_SIZE_IN  : integer := c_STREAMERS_ARR_SIZE_IN;

  component xwr_transmission is
  generic (
    g_streamers_op_mode        : t_streamers_op_mode  := TX_AND_RX;
    --tx/rx
    g_tx_streamer_params       : t_tx_streamer_params := c_tx_streamer_params_defaut;
    g_rx_streamer_params       : t_rx_streamer_params := c_rx_streamer_params_defaut;
    -- stats
    g_stats_cnt_width          : integer := 32;
    g_stats_acc_width          : integer := 64;
    -- WB i/f
    g_slave_mode               : t_wishbone_interface_mode      := CLASSIC;
    g_slave_granularity        : t_wishbone_address_granularity := BYTE
    );

  port (
    clk_sys_i                  : in std_logic;
    rst_n_i                    : in std_logic;
    -- WR tx/rx interface
    src_i                      : in  t_wrf_source_in;
    src_o                      : out t_wrf_source_out;
    snk_i                      : in  t_wrf_sink_in;
    snk_o                      : out t_wrf_sink_out;
    -- User tx interface
    tx_data_i                  : in std_logic_vector(g_tx_streamer_params.data_width-1 downto 0);
    tx_valid_i                 : in std_logic;
    tx_dreq_o                  : out std_logic;
    tx_last_p1_i               : in std_logic := '1';
    tx_flush_p1_i              : in std_logic := '0';
    -- User rx interface
    rx_first_p1_o              : out std_logic;
    rx_last_p1_o               : out std_logic;
    rx_data_o                  : out std_logic_vector(g_rx_streamer_params.data_width-1 downto 0);
    rx_valid_o                 : out std_logic;
    rx_dreq_i                  : in  std_logic;
    -- WRC Timing interface, used for latency measurement
    clk_ref_i                  : in std_logic := '0';
    tm_time_valid_i            : in std_logic := '0';
    tm_tai_i                   : in std_logic_vector(39 downto 0) := x"0000000000";
    tm_cycles_i                : in std_logic_vector(27 downto 0) := x"0000000";
    wb_slave_i                 : in  t_wishbone_slave_in := cc_dummy_slave_in;
    wb_slave_o                 : out t_wishbone_slave_out;
    snmp_array_o               : out t_generic_word_array(c_WR_TRANS_ARR_SIZE_OUT-1 downto 0);
    snmp_array_i               : in  t_generic_word_array(c_WR_TRANS_ARR_SIZE_IN -1 downto 0);
    -- Transmission (tx) configuration
    tx_cfg_mac_local_i         : in std_logic_vector(47 downto 0) := x"000000000000";
    tx_cfg_mac_target_i        : in std_logic_vector(47 downto 0):= x"ffffffffffff";
    tx_cfg_ethertype_i         : in std_logic_vector(15 downto 0) := x"dbff";
    -- Reception (rx)configuration
    rx_cfg_mac_local_i         : in std_logic_vector(47 downto 0) := x"000000000000";
    rx_cfg_mac_remote_i        : in std_logic_vector(47 downto 0) := x"000000000000";
    rx_cfg_ethertype_i         : in std_logic_vector(15 downto 0) := x"dbff";
    rx_cfg_accept_broadcasts_i : in std_logic                     := '1';
    rx_cfg_filter_remote_i     : in std_logic                     := '0';
    rx_cfg_fixed_latency_i     : in std_logic_vector(27 downto 0) := x"0000000"
    );
  end component;

end streamers_pkg;