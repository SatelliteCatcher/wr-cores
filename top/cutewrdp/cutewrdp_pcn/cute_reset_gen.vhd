library ieee;
use ieee.STD_LOGIC_1164.all;
use ieee.NUMERIC_STD.all;

use work.gencores_pkg.all;

entity cute_reset_gen is
  
  port (
    clk_sys_i : in std_logic;
    rst_n_o : out std_logic;
    rst_button_n_a_i:in std_logic
    );

end cute_reset_gen;

architecture behavioral of cute_reset_gen is

  signal powerup_cnt     : unsigned(15 downto 0) := x"0000";
  signal powerup_n       : std_logic            := '0';
  signal button_synced_n : std_logic;

begin  -- behavioral

  U_Sync_Button : gc_sync_ffs port map (
    clk_i    => clk_sys_i,
    rst_n_i  => '1',
    data_i   => rst_button_n_a_i,
    synced_o => button_synced_n);


  p_powerup_reset : process(clk_sys_i)
  begin
    if rising_edge(clk_sys_i) then
      if(powerup_cnt /= x"ffff") then
        powerup_cnt <= powerup_cnt + 1;
        powerup_n   <= '0';
      else
        powerup_n <= '1';
      end if;
    end if;
  end process;

  rst_n_o <= powerup_n and button_synced_n;

end behavioral;
