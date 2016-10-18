---------------------------------------------------------------------------------------
-- Title          : Wishbone slave core for Mini NIC for WhiteRabbit
---------------------------------------------------------------------------------------
-- File           : minic_wbgen2_pkg.vhd
-- Author         : auto-generated by wbgen2 from mini_nic.wb
-- Created        : Fri Oct 21 10:25:03 2016
-- Standard       : VHDL'87
---------------------------------------------------------------------------------------
-- THIS FILE WAS GENERATED BY wbgen2 FROM SOURCE FILE mini_nic.wb
-- DO NOT HAND-EDIT UNLESS IT'S ABSOLUTELY NECESSARY!
---------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wbgen2_pkg.all;

package minic_wbgen2_pkg is
  
  
  -- Input registers (user design -> WB slave)
  
  type t_minic_in_registers is record
    mcr_tx_idle_i                            : std_logic;
    mcr_tx_error_i                           : std_logic;
    mcr_rx_ready_i                           : std_logic;
    mcr_rx_full_i                            : std_logic;
    mcr_tx_ts_ready_i                        : std_logic;
    mcr_ver_i                                : std_logic_vector(3 downto 0);
    tx_fifo_empty_i                          : std_logic;
    tx_fifo_full_i                           : std_logic;
    rx_fifo_dat_i                            : std_logic_vector(15 downto 0);
    rx_fifo_type_i                           : std_logic_vector(1 downto 0);
    rx_fifo_empty_i                          : std_logic;
    rx_fifo_full_i                           : std_logic;
    tsr0_valid_i                             : std_logic;
    tsr0_pid_i                               : std_logic_vector(4 downto 0);
    tsr0_fid_i                               : std_logic_vector(15 downto 0);
    tsr1_tsval_i                             : std_logic_vector(31 downto 0);
    dbgr_irq_cnt_i                           : std_logic_vector(23 downto 0);
    dbgr_wb_irq_val_i                        : std_logic;
    end record;
  
  constant c_minic_in_registers_init_value: t_minic_in_registers := (
    mcr_tx_idle_i => '0',
    mcr_tx_error_i => '0',
    mcr_rx_ready_i => '0',
    mcr_rx_full_i => '0',
    mcr_tx_ts_ready_i => '0',
    mcr_ver_i => (others => '0'),
    tx_fifo_empty_i => '0',
    tx_fifo_full_i => '0',
    rx_fifo_dat_i => (others => '0'),
    rx_fifo_type_i => (others => '0'),
    rx_fifo_empty_i => '0',
    rx_fifo_full_i => '0',
    tsr0_valid_i => '0',
    tsr0_pid_i => (others => '0'),
    tsr0_fid_i => (others => '0'),
    tsr1_tsval_i => (others => '0'),
    dbgr_irq_cnt_i => (others => '0'),
    dbgr_wb_irq_val_i => '0'
    );
    
    -- Output registers (WB slave -> user design)
    
    type t_minic_out_registers is record
      mcr_tx_start_o                           : std_logic;
      mcr_rx_en_o                              : std_logic;
      mcr_rx_class_o                           : std_logic_vector(7 downto 0);
      tx_fifo_dat_o                            : std_logic_vector(15 downto 0);
      tx_fifo_dat_wr_o                         : std_logic;
      tx_fifo_type_o                           : std_logic_vector(1 downto 0);
      tx_fifo_type_wr_o                        : std_logic;
      mprot_lo_o                               : std_logic_vector(15 downto 0);
      mprot_hi_o                               : std_logic_vector(15 downto 0);
      end record;
    
    constant c_minic_out_registers_init_value: t_minic_out_registers := (
      mcr_tx_start_o => '0',
      mcr_rx_en_o => '0',
      mcr_rx_class_o => (others => '0'),
      tx_fifo_dat_o => (others => '0'),
      tx_fifo_dat_wr_o => '0',
      tx_fifo_type_o => (others => '0'),
      tx_fifo_type_wr_o => '0',
      mprot_lo_o => (others => '0'),
      mprot_hi_o => (others => '0')
      );
    function "or" (left, right: t_minic_in_registers) return t_minic_in_registers;
    function f_x_to_zero (x:std_logic) return std_logic;
    function f_x_to_zero (x:std_logic_vector) return std_logic_vector;
end package;

package body minic_wbgen2_pkg is
function f_x_to_zero (x:std_logic) return std_logic is
begin
if x = '1' then
return '1';
else
return '0';
end if;
end function;
function f_x_to_zero (x:std_logic_vector) return std_logic_vector is
variable tmp: std_logic_vector(x'length-1 downto 0);
begin
for i in 0 to x'length-1 loop
if x(i) = '1' then
tmp(i):= '1';
else
tmp(i):= '0';
end if; 
end loop; 
return tmp;
end function;
function "or" (left, right: t_minic_in_registers) return t_minic_in_registers is
variable tmp: t_minic_in_registers;
begin
tmp.mcr_tx_idle_i := f_x_to_zero(left.mcr_tx_idle_i) or f_x_to_zero(right.mcr_tx_idle_i);
tmp.mcr_tx_error_i := f_x_to_zero(left.mcr_tx_error_i) or f_x_to_zero(right.mcr_tx_error_i);
tmp.mcr_rx_ready_i := f_x_to_zero(left.mcr_rx_ready_i) or f_x_to_zero(right.mcr_rx_ready_i);
tmp.mcr_rx_full_i := f_x_to_zero(left.mcr_rx_full_i) or f_x_to_zero(right.mcr_rx_full_i);
tmp.mcr_tx_ts_ready_i := f_x_to_zero(left.mcr_tx_ts_ready_i) or f_x_to_zero(right.mcr_tx_ts_ready_i);
tmp.mcr_ver_i := f_x_to_zero(left.mcr_ver_i) or f_x_to_zero(right.mcr_ver_i);
tmp.tx_fifo_empty_i := f_x_to_zero(left.tx_fifo_empty_i) or f_x_to_zero(right.tx_fifo_empty_i);
tmp.tx_fifo_full_i := f_x_to_zero(left.tx_fifo_full_i) or f_x_to_zero(right.tx_fifo_full_i);
tmp.rx_fifo_dat_i := f_x_to_zero(left.rx_fifo_dat_i) or f_x_to_zero(right.rx_fifo_dat_i);
tmp.rx_fifo_type_i := f_x_to_zero(left.rx_fifo_type_i) or f_x_to_zero(right.rx_fifo_type_i);
tmp.rx_fifo_empty_i := f_x_to_zero(left.rx_fifo_empty_i) or f_x_to_zero(right.rx_fifo_empty_i);
tmp.rx_fifo_full_i := f_x_to_zero(left.rx_fifo_full_i) or f_x_to_zero(right.rx_fifo_full_i);
tmp.tsr0_valid_i := f_x_to_zero(left.tsr0_valid_i) or f_x_to_zero(right.tsr0_valid_i);
tmp.tsr0_pid_i := f_x_to_zero(left.tsr0_pid_i) or f_x_to_zero(right.tsr0_pid_i);
tmp.tsr0_fid_i := f_x_to_zero(left.tsr0_fid_i) or f_x_to_zero(right.tsr0_fid_i);
tmp.tsr1_tsval_i := f_x_to_zero(left.tsr1_tsval_i) or f_x_to_zero(right.tsr1_tsval_i);
tmp.dbgr_irq_cnt_i := f_x_to_zero(left.dbgr_irq_cnt_i) or f_x_to_zero(right.dbgr_irq_cnt_i);
tmp.dbgr_wb_irq_val_i := f_x_to_zero(left.dbgr_wb_irq_val_i) or f_x_to_zero(right.dbgr_wb_irq_val_i);
return tmp;
end function;
end package body;
