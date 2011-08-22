library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.genram_pkg.all;
use work.endpoint_private_pkg.all;
use work.ep_wbgen2_pkg.all;

entity ep_packet_filter is
  
  port (
    clk_sys_i : in std_logic;
    rst_n_i   : in std_logic;

    snk_fab_i  : in  t_ep_internal_fabric;
    snk_dreq_o : out std_logic;

    src_fab_o  : out t_ep_internal_fabric;
    src_dreq_i : in  std_logic;

    done_o   : out std_logic;
    pclass_o : out std_logic_vector(7 downto 0);
    drop_o   : out std_logic;

    regs_b : inout t_ep_registers
    );

end ep_packet_filter;

architecture behavioral of ep_packet_filter is

  constant c_PC_SIZE : integer := 6;

  constant c_MODE_LOGIC   : std_logic := '1';
  constant c_MODE_COMPARE : std_logic := '0';

  type t_microcode_instruction is record
    fin       : std_logic;
    mode      : std_logic;
    cmp_bit   : std_logic;
    cmp_mask  : std_logic_vector(3 downto 0);
    cmp_value : std_logic_vector(15 downto 0);
    offset    : std_logic_vector(5 downto 0);
    op        : std_logic_vector(2 downto 0);
    op2       : std_logic_vector(2 downto 0);

    rd : std_logic_vector(4 downto 0);
    ra : std_logic_vector(4 downto 0);
    rb : std_logic_vector(4 downto 0);
    rc : std_logic_vector(4 downto 0);
  end record;

  function f_decode_insn
    (ir           : std_logic_vector) return t_microcode_instruction is
    variable insn : t_microcode_instruction;
  begin
    insn.fin            := ir(35);
    insn.mode           := ir(34);
    insn.cmp_bit        := ir(33);
    insn.cmp_mask       := ir(32 downto 29);
    insn.cmp_value      := ir(28 downto 13);
    insn.offset         := ir(12 downto 7);
    insn.rd(3 downto 0) := ir(6 downto 3);
    insn.op             := ir(2 downto 0);
    insn.rd(4)          := ir(34) and ir(7);
    insn.ra             := ir(12 downto 8);
    insn.rb             := ir(17 downto 13);
    insn.rc             := ir(22 downto 18);
    insn.op2            := ir(25 downto 23);
    return insn;
  end f_decode_insn;

  function f_eval
    (
      a, b : std_logic;
      op   : std_logic_vector
      ) return std_logic is
    variable r    : std_logic;
    variable op_t : std_logic_vector(2 downto 0);
  begin
    op_t := op;
    case op_t is
      when "000"  => r := a and b;
      when "100"  => r := a nand b;
      when "001"  => r := a or b;
      when "101"  => r := a nor b;
      when "010"  => r := a xor b;
      when "110"  => r := a xnor b;
      when "011"  => r := a;
      when "111"  => r := not a;
      when others => null;
    end case;
    return r;
  end f_eval;

  function f_pick_reg(regs : std_logic_vector; index : std_logic_vector)return std_logic is
    variable idx_int : integer;
  begin
    idx_int := to_integer(unsigned(index));
    return regs(idx_int);
  end f_pick_reg;



  signal pc   : unsigned(c_PC_SIZE-1 downto 0);
  signal ir   : std_logic_vector(35 downto 0);
  signal insn : t_microcode_instruction;

  signal done_int : std_logic;
  signal regs     : std_logic_vector(31 downto 0);

  signal result_cmp : std_logic;
  signal mask       : std_logic_vector(15 downto 0);

  signal ra, rb, rc, result1, result2, rd : std_logic;

  signal pmem_addr  : unsigned(c_PC_SIZE-1 downto 0);
  signal pmem_rdata : std_logic_vector(15 downto 0);

  signal mm_write           : std_logic;
  signal mm_rdata, mm_wdata : std_logic_vector(35 downto 0);

  type t_state is (WAIT_FRAME, PROCESS_FRAME, GEN_OUTPUT);

  signal stage1, stage2 : std_logic;
  
begin  -- behavioral
  regs_b  <= c_ep_registers_init_value;

  mm_write <= not regs_b.ecr_rx_en_o and regs_b.pfcr0_mm_write_o and regs_b.pfcr0_mm_write_wr_o;
  mm_wdata <= regs_b.pfcr0_mm_data_msb_o & regs_b.pfcr1_mm_data_lsb_o;

  U_microcode_ram : generic_spram
    generic map (
      g_data_width => 36,
      g_size       => 2**c_PC_SIZE)
    port map (
      rst_n_i => rst_n_i,
      clk_i   => clk_sys_i,
      bwe_i   => "11111",
      we_i    => mm_write,
      a_i     => regs_b.pfcr0_mm_addr_o,
      d_i     => mm_wdata,
      q_o     => mm_rdata);


  U_backlog_ram : generic_dpram
    generic map (
      g_data_width       => 16,
      g_size             => 2**c_PC_SIZE,
      g_with_byte_enable => false,
      g_dual_clock       => false)
    port map (
      rst_n_i => rst_n_i,
      clka_i  => clk_sys_i,
      bwea_i  => "11",
      wea_i   => snk_fab_i.dvalid,
      aa_i    => std_logic_vector(pc),
      da_i    => snk_fab_i.data,
      qa_o    => open,
      clkb_i  => clk_sys_i,
      bweb_i  => "00",
      web_i   => '0',
      ab_i    => insn.offset,
      db_i    => x"0000",
      qb_o    => pmem_rdata);

  snk_dreq_o <= src_dreq_i;
  src_fab_o  <= snk_fab_i;

  p_pc_counter : process(clk_sys_i)
  begin
    if rising_edge(clk_sys_i) then
      if rst_n_i = '0' or snk_fab_i.eof = '1' or snk_fab_i.error = '1' or done_int = '1' then
        pc     <= (others => '0');
        stage1 <= '0';
      elsif(snk_fab_i.dvalid = '1') then
        pc     <= pc + 1;
        stage1 <= '1';
      else
        stage1 <= '0';
      end if;
    end if;
  end process;

  p_stage2 : process(clk_sys_i)
  begin
    if rising_edge(clk_sys_i) then
      if rst_n_i = '0' or done_int = '1' then
        stage2 <= '0';
      else
        stage2 <= stage1;
        ir     <= mm_rdata;
      end if;
    end if;
  end process;

  p_gen_mask : process(insn)
  begin
    if(insn.cmp_bit = '0') then
      mask(3 downto 0)   <= (insn.cmp_mask(0) & insn.cmp_mask(0) & insn.cmp_mask(0) & insn.cmp_mask(0));
      mask(7 downto 4)   <= (insn.cmp_mask(1) & insn.cmp_mask(1) & insn.cmp_mask(1) & insn.cmp_mask(1));
      mask(11 downto 8)  <= (insn.cmp_mask(2) & insn.cmp_mask(2) & insn.cmp_mask(2) & insn.cmp_mask(2));
      mask(15 downto 12) <= (insn.cmp_mask(3) & insn.cmp_mask(3) & insn.cmp_mask(3) & insn.cmp_mask(3));
    else
      case insn.cmp_mask is
        when x"0"   => mask <= x"0001";
        when x"1"   => mask <= x"0002";
        when x"2"   => mask <= x"0004";
        when x"3"   => mask <= x"0008";
        when x"4"   => mask <= x"0010";
        when x"5"   => mask <= x"0020";
        when x"6"   => mask <= x"0040";
        when x"7"   => mask <= x"0080";
        when x"8"   => mask <= x"0100";
        when x"9"   => mask <= x"0200";
        when x"a"   => mask <= x"0400";
        when x"b"   => mask <= x"0800";
        when x"c"   => mask <= x"1000";
        when x"d"   => mask <= x"2000";
        when x"e"   => mask <= x"4000";
        when x"f"   => mask <= x"8000";
        when others => mask <= (others => 'X');
      end case;
    end if;
  end process;

  result_cmp <= '1' when ((pmem_rdata and mask) xor mask) = x"0000" else '0';

  insn <= f_decode_insn(ir);
  ra   <= f_pick_reg(regs, insn.ra) when insn.mode = c_MODE_LOGIC else result_cmp;
  rb   <= f_pick_reg(regs, insn.rb) when insn.mode = c_MODE_LOGIC else f_pick_reg(regs, insn.rd);
  rc   <= f_pick_reg(regs, insn.rc);

  result1 <= f_eval(ra, rb, insn.op);
  result2 <= f_eval(result1, rc, insn.op2);

  rd <= result1 when insn.mode = c_MODE_LOGIC else result2;

  p_execute : process(clk_sys_i)
  begin
    if rising_edge(clk_sys_i) then
      if rst_n_i = '0' or snk_fab_i.eof = '1' or snk_fab_i.error = '1' or done_int = '1' then
        regs <= (others => '0');
      else
        if(stage2 = '1') then
          regs(to_integer(unsigned(insn.rd))) <= rd;
        end if;
      end if;
    end if;
  end process;

  p_gen_status : process(clk_sys_i)
  begin
    if rising_edge(clk_sys_i) then
      if rst_n_i = '0' or snk_fab_i.eof = '1' or snk_fab_i.error = '1' then
        done_int <= '0';
        drop_o   <= '0';
      else
        if(stage2 = '1' and insn.fin = '1') then
          done_int   <= '1';
          pclass_o <= regs(31 downto 24);
          drop_o   <= regs(23);
        end if;
      end if;
    end if;
  end process;

  done_o <= done_int;
  
end behavioral;


