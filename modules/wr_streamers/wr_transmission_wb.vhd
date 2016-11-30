---------------------------------------------------------------------------------------
-- Title          : Wishbone slave core for WR Transmission control, status and debug
---------------------------------------------------------------------------------------
-- File           : wr_transmission_wb.vhd
-- Author         : auto-generated by wbgen2 from wr_transmission_wb.wb
-- Created        : Wed Nov 30 10:02:17 2016
-- Standard       : VHDL'87
---------------------------------------------------------------------------------------
-- THIS FILE WAS GENERATED BY wbgen2 FROM SOURCE FILE wr_transmission_wb.wb
-- DO NOT HAND-EDIT UNLESS IT'S ABSOLUTELY NECESSARY!
---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.wr_transmission_wbgen2_pkg.all;


entity wr_transmission_wb is
  port (
    rst_n_i                                  : in     std_logic;
    clk_sys_i                                : in     std_logic;
    wb_adr_i                                 : in     std_logic_vector(4 downto 0);
    wb_dat_i                                 : in     std_logic_vector(31 downto 0);
    wb_dat_o                                 : out    std_logic_vector(31 downto 0);
    wb_cyc_i                                 : in     std_logic;
    wb_sel_i                                 : in     std_logic_vector(3 downto 0);
    wb_stb_i                                 : in     std_logic;
    wb_we_i                                  : in     std_logic;
    wb_ack_o                                 : out    std_logic;
    wb_stall_o                               : out    std_logic;
    regs_i                                   : in     t_wr_transmission_in_registers;
    regs_o                                   : out    t_wr_transmission_out_registers
  );
end wr_transmission_wb;

architecture syn of wr_transmission_wb is

signal wr_transmission_sscr1_rst_stats_dly0     : std_logic      ;
signal wr_transmission_sscr1_rst_stats_int      : std_logic      ;
signal wr_transmission_sscr1_rst_seq_id_dly0    : std_logic      ;
signal wr_transmission_sscr1_rst_seq_id_int     : std_logic      ;
signal wr_transmission_sscr1_snapshot_stats_int : std_logic      ;
signal wr_transmission_tx_cfg0_ethertype_int    : std_logic_vector(15 downto 0);
signal wr_transmission_tx_cfg1_mac_local_lsb_int : std_logic_vector(31 downto 0);
signal wr_transmission_tx_cfg2_mac_local_msb_int : std_logic_vector(15 downto 0);
signal wr_transmission_tx_cfg3_mac_target_lsb_int : std_logic_vector(31 downto 0);
signal wr_transmission_tx_cfg4_mac_target_msb_int : std_logic_vector(15 downto 0);
signal wr_transmission_rx_cfg0_ethertype_int    : std_logic_vector(15 downto 0);
signal wr_transmission_rx_cfg0_accept_broadcast_int : std_logic      ;
signal wr_transmission_rx_cfg0_filter_remote_int : std_logic      ;
signal wr_transmission_rx_cfg1_mac_local_lsb_int : std_logic_vector(31 downto 0);
signal wr_transmission_rx_cfg2_mac_local_msb_int : std_logic_vector(15 downto 0);
signal wr_transmission_rx_cfg3_mac_remote_lsb_int : std_logic_vector(31 downto 0);
signal wr_transmission_rx_cfg4_mac_remote_msb_int : std_logic_vector(15 downto 0);
signal wr_transmission_rx_cfg5_fixed_latency_int : std_logic_vector(27 downto 0);
signal wr_transmission_cfg_or_tx_ethtype_int    : std_logic      ;
signal wr_transmission_cfg_or_tx_mac_loc_int    : std_logic      ;
signal wr_transmission_cfg_or_tx_mac_tar_int    : std_logic      ;
signal wr_transmission_cfg_or_rx_ethertype_int  : std_logic      ;
signal wr_transmission_cfg_or_rx_mac_loc_int    : std_logic      ;
signal wr_transmission_cfg_or_rx_mac_rem_int    : std_logic      ;
signal wr_transmission_cfg_or_rx_acc_broadcast_int : std_logic      ;
signal wr_transmission_cfg_or_rx_ftr_remote_int : std_logic      ;
signal wr_transmission_cfg_or_rx_fix_lat_int    : std_logic      ;
signal wr_transmission_dbg_ctrl_mux_int         : std_logic      ;
signal wr_transmission_dbg_ctrl_start_byte_int  : std_logic_vector(7 downto 0);
signal ack_sreg                                 : std_logic_vector(9 downto 0);
signal rddata_reg                               : std_logic_vector(31 downto 0);
signal wrdata_reg                               : std_logic_vector(31 downto 0);
signal bwsel_reg                                : std_logic_vector(3 downto 0);
signal rwaddr_reg                               : std_logic_vector(4 downto 0);
signal ack_in_progress                          : std_logic      ;
signal wr_int                                   : std_logic      ;
signal rd_int                                   : std_logic      ;
signal allones                                  : std_logic_vector(31 downto 0);
signal allzeros                                 : std_logic_vector(31 downto 0);

begin
-- Some internal signals assignments. For (foreseen) compatibility with other bus standards.
  wrdata_reg <= wb_dat_i;
  bwsel_reg <= wb_sel_i;
  rd_int <= wb_cyc_i and (wb_stb_i and (not wb_we_i));
  wr_int <= wb_cyc_i and (wb_stb_i and wb_we_i);
  allones <= (others => '1');
  allzeros <= (others => '0');
-- 
-- Main register bank access process.
  process (clk_sys_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      ack_sreg <= "0000000000";
      ack_in_progress <= '0';
      rddata_reg <= "00000000000000000000000000000000";
      wr_transmission_sscr1_rst_stats_int <= '0';
      wr_transmission_sscr1_rst_seq_id_int <= '0';
      wr_transmission_sscr1_snapshot_stats_int <= '0';
      wr_transmission_tx_cfg0_ethertype_int <= "0000000000000000";
      wr_transmission_tx_cfg1_mac_local_lsb_int <= "00000000000000000000000000000000";
      wr_transmission_tx_cfg2_mac_local_msb_int <= "0000000000000000";
      wr_transmission_tx_cfg3_mac_target_lsb_int <= "00000000000000000000000000000000";
      wr_transmission_tx_cfg4_mac_target_msb_int <= "0000000000000000";
      wr_transmission_rx_cfg0_ethertype_int <= "0000000000000000";
      wr_transmission_rx_cfg0_accept_broadcast_int <= '0';
      wr_transmission_rx_cfg0_filter_remote_int <= '0';
      wr_transmission_rx_cfg1_mac_local_lsb_int <= "00000000000000000000000000000000";
      wr_transmission_rx_cfg2_mac_local_msb_int <= "0000000000000000";
      wr_transmission_rx_cfg3_mac_remote_lsb_int <= "00000000000000000000000000000000";
      wr_transmission_rx_cfg4_mac_remote_msb_int <= "0000000000000000";
      wr_transmission_rx_cfg5_fixed_latency_int <= "0000000000000000000000000000";
      wr_transmission_cfg_or_tx_ethtype_int <= '0';
      wr_transmission_cfg_or_tx_mac_loc_int <= '0';
      wr_transmission_cfg_or_tx_mac_tar_int <= '0';
      wr_transmission_cfg_or_rx_ethertype_int <= '0';
      wr_transmission_cfg_or_rx_mac_loc_int <= '0';
      wr_transmission_cfg_or_rx_mac_rem_int <= '0';
      wr_transmission_cfg_or_rx_acc_broadcast_int <= '0';
      wr_transmission_cfg_or_rx_ftr_remote_int <= '0';
      wr_transmission_cfg_or_rx_fix_lat_int <= '0';
      wr_transmission_dbg_ctrl_mux_int <= '0';
      wr_transmission_dbg_ctrl_start_byte_int <= "00000000";
    elsif rising_edge(clk_sys_i) then
-- advance the ACK generator shift register
      ack_sreg(8 downto 0) <= ack_sreg(9 downto 1);
      ack_sreg(9) <= '0';
      if (ack_in_progress = '1') then
        if (ack_sreg(0) = '1') then
          wr_transmission_sscr1_rst_stats_int <= '0';
          wr_transmission_sscr1_rst_seq_id_int <= '0';
          ack_in_progress <= '0';
        else
        end if;
      else
        if ((wb_cyc_i = '1') and (wb_stb_i = '1')) then
          case rwaddr_reg(4 downto 0) is
          when "00000" => 
            if (wb_we_i = '1') then
              wr_transmission_sscr1_rst_stats_int <= wrdata_reg(0);
              wr_transmission_sscr1_rst_seq_id_int <= wrdata_reg(1);
              wr_transmission_sscr1_snapshot_stats_int <= wrdata_reg(2);
            end if;
            rddata_reg(0) <= '0';
            rddata_reg(1) <= '0';
            rddata_reg(2) <= wr_transmission_sscr1_snapshot_stats_int;
            rddata_reg(3) <= regs_i.sscr1_rx_latency_acc_overflow_i;
            rddata_reg(31 downto 4) <= regs_i.sscr1_rst_ts_cyc_i;
            ack_sreg(2) <= '1';
            ack_in_progress <= '1';
          when "00001" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.sscr2_rst_ts_tai_lsb_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "00010" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.tx_stat_tx_sent_cnt_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "00011" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.rx_stat1_rx_rcvd_cnt_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "00100" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.rx_stat2_rx_loss_cnt_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "00101" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(27 downto 0) <= regs_i.rx_stat3_rx_latency_max_i;
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "00110" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(27 downto 0) <= regs_i.rx_stat4_rx_latency_min_i;
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "00111" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.rx_stat5_rx_latency_acc_lsb_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01000" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.rx_stat6_rx_latency_acc_msb_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01001" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.rx_stat7_rx_latency_acc_cnt_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01010" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.rx_stat8_rx_lost_block_cnt_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01011" => 
            if (wb_we_i = '1') then
              wr_transmission_tx_cfg0_ethertype_int <= wrdata_reg(15 downto 0);
            end if;
            rddata_reg(15 downto 0) <= wr_transmission_tx_cfg0_ethertype_int;
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01100" => 
            if (wb_we_i = '1') then
              wr_transmission_tx_cfg1_mac_local_lsb_int <= wrdata_reg(31 downto 0);
            end if;
            rddata_reg(31 downto 0) <= wr_transmission_tx_cfg1_mac_local_lsb_int;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01101" => 
            if (wb_we_i = '1') then
              wr_transmission_tx_cfg2_mac_local_msb_int <= wrdata_reg(15 downto 0);
            end if;
            rddata_reg(15 downto 0) <= wr_transmission_tx_cfg2_mac_local_msb_int;
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01110" => 
            if (wb_we_i = '1') then
              wr_transmission_tx_cfg3_mac_target_lsb_int <= wrdata_reg(31 downto 0);
            end if;
            rddata_reg(31 downto 0) <= wr_transmission_tx_cfg3_mac_target_lsb_int;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "01111" => 
            if (wb_we_i = '1') then
              wr_transmission_tx_cfg4_mac_target_msb_int <= wrdata_reg(15 downto 0);
            end if;
            rddata_reg(15 downto 0) <= wr_transmission_tx_cfg4_mac_target_msb_int;
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10000" => 
            if (wb_we_i = '1') then
              wr_transmission_rx_cfg0_ethertype_int <= wrdata_reg(15 downto 0);
              wr_transmission_rx_cfg0_accept_broadcast_int <= wrdata_reg(16);
              wr_transmission_rx_cfg0_filter_remote_int <= wrdata_reg(17);
            end if;
            rddata_reg(15 downto 0) <= wr_transmission_rx_cfg0_ethertype_int;
            rddata_reg(16) <= wr_transmission_rx_cfg0_accept_broadcast_int;
            rddata_reg(17) <= wr_transmission_rx_cfg0_filter_remote_int;
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10001" => 
            if (wb_we_i = '1') then
              wr_transmission_rx_cfg1_mac_local_lsb_int <= wrdata_reg(31 downto 0);
            end if;
            rddata_reg(31 downto 0) <= wr_transmission_rx_cfg1_mac_local_lsb_int;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10010" => 
            if (wb_we_i = '1') then
              wr_transmission_rx_cfg2_mac_local_msb_int <= wrdata_reg(15 downto 0);
            end if;
            rddata_reg(15 downto 0) <= wr_transmission_rx_cfg2_mac_local_msb_int;
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10011" => 
            if (wb_we_i = '1') then
              wr_transmission_rx_cfg3_mac_remote_lsb_int <= wrdata_reg(31 downto 0);
            end if;
            rddata_reg(31 downto 0) <= wr_transmission_rx_cfg3_mac_remote_lsb_int;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10100" => 
            if (wb_we_i = '1') then
              wr_transmission_rx_cfg4_mac_remote_msb_int <= wrdata_reg(15 downto 0);
            end if;
            rddata_reg(15 downto 0) <= wr_transmission_rx_cfg4_mac_remote_msb_int;
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10101" => 
            if (wb_we_i = '1') then
              wr_transmission_rx_cfg5_fixed_latency_int <= wrdata_reg(27 downto 0);
            end if;
            rddata_reg(27 downto 0) <= wr_transmission_rx_cfg5_fixed_latency_int;
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10110" => 
            if (wb_we_i = '1') then
              wr_transmission_cfg_or_tx_ethtype_int <= wrdata_reg(0);
              wr_transmission_cfg_or_tx_mac_loc_int <= wrdata_reg(1);
              wr_transmission_cfg_or_tx_mac_tar_int <= wrdata_reg(2);
              wr_transmission_cfg_or_rx_ethertype_int <= wrdata_reg(16);
              wr_transmission_cfg_or_rx_mac_loc_int <= wrdata_reg(17);
              wr_transmission_cfg_or_rx_mac_rem_int <= wrdata_reg(18);
              wr_transmission_cfg_or_rx_acc_broadcast_int <= wrdata_reg(19);
              wr_transmission_cfg_or_rx_ftr_remote_int <= wrdata_reg(20);
              wr_transmission_cfg_or_rx_fix_lat_int <= wrdata_reg(21);
            end if;
            rddata_reg(0) <= wr_transmission_cfg_or_tx_ethtype_int;
            rddata_reg(1) <= wr_transmission_cfg_or_tx_mac_loc_int;
            rddata_reg(2) <= wr_transmission_cfg_or_tx_mac_tar_int;
            rddata_reg(16) <= wr_transmission_cfg_or_rx_ethertype_int;
            rddata_reg(17) <= wr_transmission_cfg_or_rx_mac_loc_int;
            rddata_reg(18) <= wr_transmission_cfg_or_rx_mac_rem_int;
            rddata_reg(19) <= wr_transmission_cfg_or_rx_acc_broadcast_int;
            rddata_reg(20) <= wr_transmission_cfg_or_rx_ftr_remote_int;
            rddata_reg(21) <= wr_transmission_cfg_or_rx_fix_lat_int;
            rddata_reg(3) <= 'X';
            rddata_reg(4) <= 'X';
            rddata_reg(5) <= 'X';
            rddata_reg(6) <= 'X';
            rddata_reg(7) <= 'X';
            rddata_reg(8) <= 'X';
            rddata_reg(9) <= 'X';
            rddata_reg(10) <= 'X';
            rddata_reg(11) <= 'X';
            rddata_reg(12) <= 'X';
            rddata_reg(13) <= 'X';
            rddata_reg(14) <= 'X';
            rddata_reg(15) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "10111" => 
            if (wb_we_i = '1') then
              wr_transmission_dbg_ctrl_mux_int <= wrdata_reg(0);
              wr_transmission_dbg_ctrl_start_byte_int <= wrdata_reg(15 downto 8);
            end if;
            rddata_reg(0) <= wr_transmission_dbg_ctrl_mux_int;
            rddata_reg(15 downto 8) <= wr_transmission_dbg_ctrl_start_byte_int;
            rddata_reg(1) <= 'X';
            rddata_reg(2) <= 'X';
            rddata_reg(3) <= 'X';
            rddata_reg(4) <= 'X';
            rddata_reg(5) <= 'X';
            rddata_reg(6) <= 'X';
            rddata_reg(7) <= 'X';
            rddata_reg(16) <= 'X';
            rddata_reg(17) <= 'X';
            rddata_reg(18) <= 'X';
            rddata_reg(19) <= 'X';
            rddata_reg(20) <= 'X';
            rddata_reg(21) <= 'X';
            rddata_reg(22) <= 'X';
            rddata_reg(23) <= 'X';
            rddata_reg(24) <= 'X';
            rddata_reg(25) <= 'X';
            rddata_reg(26) <= 'X';
            rddata_reg(27) <= 'X';
            rddata_reg(28) <= 'X';
            rddata_reg(29) <= 'X';
            rddata_reg(30) <= 'X';
            rddata_reg(31) <= 'X';
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "11000" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.dbg_data_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "11001" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.dbg_rx_bvalue_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "11010" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.dbg_tx_bvalue_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when "11011" => 
            if (wb_we_i = '1') then
            end if;
            rddata_reg(31 downto 0) <= regs_i.dummy_dummy_i;
            ack_sreg(0) <= '1';
            ack_in_progress <= '1';
          when others =>
-- prevent the slave from hanging the bus on invalid address
            ack_in_progress <= '1';
            ack_sreg(0) <= '1';
          end case;
        end if;
      end if;
    end if;
  end process;
  
  
-- Drive the data output bus
  wb_dat_o <= rddata_reg;
-- Reset statistics
  process (clk_sys_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      wr_transmission_sscr1_rst_stats_dly0 <= '0';
      regs_o.sscr1_rst_stats_o <= '0';
    elsif rising_edge(clk_sys_i) then
      wr_transmission_sscr1_rst_stats_dly0 <= wr_transmission_sscr1_rst_stats_int;
      regs_o.sscr1_rst_stats_o <= wr_transmission_sscr1_rst_stats_int and (not wr_transmission_sscr1_rst_stats_dly0);
    end if;
  end process;
  
  
-- Reset tx seq id
  process (clk_sys_i, rst_n_i)
  begin
    if (rst_n_i = '0') then 
      wr_transmission_sscr1_rst_seq_id_dly0 <= '0';
      regs_o.sscr1_rst_seq_id_o <= '0';
    elsif rising_edge(clk_sys_i) then
      wr_transmission_sscr1_rst_seq_id_dly0 <= wr_transmission_sscr1_rst_seq_id_int;
      regs_o.sscr1_rst_seq_id_o <= wr_transmission_sscr1_rst_seq_id_int and (not wr_transmission_sscr1_rst_seq_id_dly0);
    end if;
  end process;
  
  
-- Snapshot statistics
  regs_o.sscr1_snapshot_stats_o <= wr_transmission_sscr1_snapshot_stats_int;
-- Latency accumulator overflow
-- Reset timestamp cycles
-- Reset timestamp 32 LSB of TAI
-- WR Streamer frame sent count
-- WR Streamer frame received count
-- WR Streamer frame loss count
-- WR Streamer frame latency
-- WR Streamer frame latency
-- WR Streamer frame latency
-- WR Streamer frame latency
-- WR Streamer frame latency counter
-- WR Streamer block loss count
-- Ethertype
  regs_o.tx_cfg0_ethertype_o <= wr_transmission_tx_cfg0_ethertype_int;
-- MAC Local LSB
  regs_o.tx_cfg1_mac_local_lsb_o <= wr_transmission_tx_cfg1_mac_local_lsb_int;
-- MAC Local MSB
  regs_o.tx_cfg2_mac_local_msb_o <= wr_transmission_tx_cfg2_mac_local_msb_int;
-- MAC Target LSB
  regs_o.tx_cfg3_mac_target_lsb_o <= wr_transmission_tx_cfg3_mac_target_lsb_int;
-- MAC Target MSB
  regs_o.tx_cfg4_mac_target_msb_o <= wr_transmission_tx_cfg4_mac_target_msb_int;
-- Ethertype
  regs_o.rx_cfg0_ethertype_o <= wr_transmission_rx_cfg0_ethertype_int;
-- Accept Broadcast
  regs_o.rx_cfg0_accept_broadcast_o <= wr_transmission_rx_cfg0_accept_broadcast_int;
-- Filter Remote
  regs_o.rx_cfg0_filter_remote_o <= wr_transmission_rx_cfg0_filter_remote_int;
-- MAC Local LSB
  regs_o.rx_cfg1_mac_local_lsb_o <= wr_transmission_rx_cfg1_mac_local_lsb_int;
-- MAC Local MSB
  regs_o.rx_cfg2_mac_local_msb_o <= wr_transmission_rx_cfg2_mac_local_msb_int;
-- MAC Remote LSB
  regs_o.rx_cfg3_mac_remote_lsb_o <= wr_transmission_rx_cfg3_mac_remote_lsb_int;
-- MAC Remote MSB
  regs_o.rx_cfg4_mac_remote_msb_o <= wr_transmission_rx_cfg4_mac_remote_msb_int;
-- Fixed Latency
  regs_o.rx_cfg5_fixed_latency_o <= wr_transmission_rx_cfg5_fixed_latency_int;
-- Tx Ethertype
  regs_o.cfg_or_tx_ethtype_o <= wr_transmission_cfg_or_tx_ethtype_int;
-- Tx MAC Local
  regs_o.cfg_or_tx_mac_loc_o <= wr_transmission_cfg_or_tx_mac_loc_int;
-- Tx MAC Target
  regs_o.cfg_or_tx_mac_tar_o <= wr_transmission_cfg_or_tx_mac_tar_int;
-- Rx Ethertype
  regs_o.cfg_or_rx_ethertype_o <= wr_transmission_cfg_or_rx_ethertype_int;
-- Rx MAC Local
  regs_o.cfg_or_rx_mac_loc_o <= wr_transmission_cfg_or_rx_mac_loc_int;
-- Rx MAC Remote
  regs_o.cfg_or_rx_mac_rem_o <= wr_transmission_cfg_or_rx_mac_rem_int;
-- Rx Accept Broadcast
  regs_o.cfg_or_rx_acc_broadcast_o <= wr_transmission_cfg_or_rx_acc_broadcast_int;
-- Rx Filter Remote
  regs_o.cfg_or_rx_ftr_remote_o <= wr_transmission_cfg_or_rx_ftr_remote_int;
-- Rx Fixed Latency 
  regs_o.cfg_or_rx_fix_lat_o <= wr_transmission_cfg_or_rx_fix_lat_int;
-- Debug Tx (0) or Rx (1)
  regs_o.dbg_ctrl_mux_o <= wr_transmission_dbg_ctrl_mux_int;
-- Debug Start byte
  regs_o.dbg_ctrl_start_byte_o <= wr_transmission_dbg_ctrl_start_byte_int;
-- Debug content
-- Debug content
-- Debug content
-- DUMMY value to read
  rwaddr_reg <= wb_adr_i;
  wb_stall_o <= (not ack_sreg(0)) and (wb_stb_i and wb_cyc_i);
-- ACK signal generation. Just pass the LSB of ACK counter.
  wb_ack_o <= ack_sreg(0);
end syn;
