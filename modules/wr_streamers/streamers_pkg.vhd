library ieee;
use ieee.std_logic_1164.all;
use work.wr_fabric_pkg.all;
use work.wrcore_pkg.all;
use work.wishbone_pkg.all;  -- needed for t_wishbone_slave_in, etc

package streamers_pkg is

  component xtx_streamer
    generic (
      g_data_width             : integer := 32;
      g_tx_threshold           : integer := 16;
      g_tx_max_words_per_frame : integer := 128;
      g_tx_timeout             : integer := 128;
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
      g_buffer_size       : integer := 16;
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
    -----------------------------------------------------------------------------------------
    -- Transmission (tx)
    -----------------------------------------------------------------------------------------
    -- Width of data words on tx_data_i.
    g_tx_data_width           : integer := 32;

    -- Minimum number of data words in the TX buffer that will trigger transmission of an
    -- Ethernet frame. Also defines the buffer size (2 * g_tx_threshold). Note
    -- that in order for a frame to be transmitted, the buffer must conatain at
    -- least one complete block.
    g_tx_threshold            : integer := 128;

    -- Maximum number of data words in a single Ethernet frame. It also defines
    -- the maximum block size (since blocks can't be currently split across
    -- multiple frames). 
    g_tx_max_words_per_frame  : integer := 128;

    -- Transmission timeout (in clk_sys_i cycles), after which the contents
    -- of TX buffer are sent regardless of the amount of data that is currently
    -- stored in the buffer, so that data in the buffer does not get stuck.
    g_tx_timeout               : integer := 1024;

    -- DO NOT USE unless you know what you are doing
    -- legacy stuff: the streamers initially used in Btrain did not check/insert the escape
    -- code. This is justified if only one block of a known number of words is sent/expected
    g_tx_escape_code_disable   : boolean := FALSE;

    -----------------------------------------------------------------------------------------
    -- Reception (rx)
    -----------------------------------------------------------------------------------------
    -- Width of the data words. Must be same as in the TX streamer.
    g_rx_data_width            : integer := 32;

    -- Size of RX buffer, in data words.
    g_rx_buffer_size           : integer := 16;

    -- DO NOT USE unless you know what you are doing
    -- legacy stuff: the streamers that were initially used in Btrain did not check/insert 
    -- the escape code. This is justified if only one block of a known number of words is 
    -- sent/expected.
    g_rx_escape_code_disable   : boolean := FALSE;

    -- DO NOT USE unless you know what you are doing
    -- legacy stuff: the streamers that were initially used in Btrain accepted only a fixed
    -- number of words, regardless of the frame content. If this generic is set to number
    -- other than zero, only a fixed number of words is accepted. 
    -- In combination with the g_escape_code_disable generic set to TRUE, the behaviour of
    -- the "Btrain streamers" can be recreated.
    g_rx_expected_words_number : integer := 0;

    -----------------------------------------------------------------------------------------
    -- Statistics config
    -----------------------------------------------------------------------------------------
    -- width of counters: frame rx/tx/lost, block lost, counter of accumuted latency
    -- (minimum 15 bits, max 32)
    g_stats_cnt_width          : integer := 32;
    -- width of latency accumulator (max value 64)
    g_stats_acc_width          : integer := 64;
    -----------------------------------------------------------------------------------------
    -- WB I/F configuration
    -----------------------------------------------------------------------------------------
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
    tx_data_i                  : in std_logic_vector(g_tx_data_width-1 downto 0);
    tx_valid_i                 : in std_logic;
    tx_dreq_o                  : out std_logic;
    tx_last_p1_i               : in std_logic := '1';
    tx_flush_p1_i              : in std_logic := '0';
    -- User rx interface
    rx_first_p1_o              : out std_logic;
    rx_last_p1_o               : out std_logic;
    rx_data_o                  : out std_logic_vector(g_rx_data_width-1 downto 0);
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