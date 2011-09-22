-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx 
-- \   \   \/     Version : 1.4
--  \   \         Application : Spartan-6 FPGA GTP Transceiver Wizard
--  /   /         Filename : whiterabbitgtp_wrapper.vhd
-- /___/   /\     Timestamp :
-- \   \  /  \ 
--  \___\/\___\
--
--
-- Module WHITERABBITGTP_WRAPPER (a GTP Wrapper)
-- Generated by Xilinx Spartan-6 FPGA GTP Transceiver Wizard
-- 
-- 
-- (c) Copyright 2009 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of,
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES. 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library UNISIM;
use UNISIM.VCOMPONENTS.all;


--***************************** Entity Declaration ****************************

entity WHITERABBITGTP_WRAPPER is
  generic
    (
                                        -- Simulation attributes
      WRAPPER_SIM_GTPRESET_SPEEDUP : integer := 0;  -- Set to 1 to speed up sim reset
      WRAPPER_CLK25_DIVIDER_0      : integer := 5;
      WRAPPER_CLK25_DIVIDER_1      : integer := 5;
      WRAPPER_PLL_DIVSEL_FB_0      : integer := 2;
      WRAPPER_PLL_DIVSEL_FB_1      : integer := 2;
      WRAPPER_PLL_DIVSEL_REF_0     : integer := 1;
      WRAPPER_PLL_DIVSEL_REF_1     : integer := 1;
      WRAPPER_SIMULATION           : integer := 0  -- Set to 1 for simulation    
      );
  port
    (

                                        --_________________________________________________________________________
                                        --_________________________________________________________________________
                                        --TILE0  (X1_Y0)

                                        ------------------------ Loopback and Powerdown Ports ----------------------
      TILE0_LOOPBACK0_IN          : in  std_logic_vector(2 downto 0);
      TILE0_LOOPBACK1_IN          : in  std_logic_vector(2 downto 0);
                                        --------------------------------- PLL Ports --------------------------------
      TILE0_CLK00_IN              : in  std_logic;
      TILE0_CLK01_IN              : in  std_logic;
      TILE0_GTPRESET0_IN          : in  std_logic;
      TILE0_GTPRESET1_IN          : in  std_logic;
      TILE0_PLLLKDET0_OUT         : out std_logic;
      TILE0_RESETDONE0_OUT        : out std_logic;
      TILE0_RESETDONE1_OUT        : out std_logic;
      TILE0_REFCLKOUT0_OUT           : out std_logic;
      TILE0_REFCLKOUT1_OUT           : out std_logic;

                                        ----------------------- Receive Ports - 8b10b Decoder ----------------------
      TILE0_RXCHARISK0_OUT        : out std_logic;
      TILE0_RXCHARISK1_OUT        : out std_logic;
      TILE0_RXDISPERR0_OUT        : out std_logic;
      TILE0_RXDISPERR1_OUT        : out std_logic;
      TILE0_RXNOTINTABLE0_OUT     : out std_logic;
      TILE0_RXNOTINTABLE1_OUT     : out std_logic;
                                        --------------- Receive Ports - Comma Detection and Alignment --------------
      TILE0_RXBYTEISALIGNED0_OUT  : out std_logic;
      TILE0_RXBYTEISALIGNED1_OUT  : out std_logic;
      TILE0_RXCOMMADET0_OUT       : out std_logic;
      TILE0_RXCOMMADET1_OUT       : out std_logic;
      TILE0_RXSLIDE0_IN           : in  std_logic;
      TILE0_RXSLIDE1_IN           : in  std_logic;
                                        ------------------- Receive Ports - RX Data Path interface -----------------
      TILE0_RXDATA0_OUT           : out std_logic_vector(7 downto 0);
      TILE0_RXDATA1_OUT           : out std_logic_vector(7 downto 0);
      TILE0_RXUSRCLK0_IN          : in  std_logic;
      TILE0_RXUSRCLK1_IN          : in  std_logic;
      TILE0_RXUSRCLK20_IN         : in  std_logic;
      TILE0_RXUSRCLK21_IN         : in  std_logic;
                                        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
      TILE0_RXCDRRESET0_IN        : in  std_logic;
      TILE0_RXCDRRESET1_IN        : in  std_logic;
      TILE0_RXN0_IN               : in  std_logic;
      TILE0_RXN1_IN               : in  std_logic;
      TILE0_RXP0_IN               : in  std_logic;
      TILE0_RXP1_IN               : in  std_logic;
                                        ---------------------------- TX/RX Datapath Ports --------------------------
      TILE0_GTPCLKFBEAST_OUT      : out std_logic_vector(1 downto 0);
      TILE0_GTPCLKFBWEST_OUT      : out std_logic_vector(1 downto 0);
      TILE0_GTPCLKOUT0_OUT        : out std_logic_vector(1 downto 0);
      TILE0_GTPCLKOUT1_OUT        : out std_logic_vector(1 downto 0);
                                        ------------------- Transmit Ports - 8b10b Encoder Control -----------------
      TILE0_TXCHARISK0_IN         : in  std_logic;
      TILE0_TXCHARISK1_IN         : in  std_logic;
                                        --------------- Transmit Ports - TX Buffer and Phase Alignment -------------
      TILE0_TXENPMAPHASEALIGN0_IN : in  std_logic;
      TILE0_TXENPMAPHASEALIGN1_IN : in  std_logic;
      TILE0_TXPMASETPHASE0_IN     : in  std_logic;
      TILE0_TXPMASETPHASE1_IN     : in  std_logic;
                                        ------------------ Transmit Ports - TX Data Path interface -----------------
      TILE0_TXDATA0_IN            : in  std_logic_vector(7 downto 0);
      TILE0_TXDATA1_IN            : in  std_logic_vector(7 downto 0);
      TILE0_TXUSRCLK0_IN          : in  std_logic;
      TILE0_TXUSRCLK1_IN          : in  std_logic;
      TILE0_TXUSRCLK20_IN         : in  std_logic;
      TILE0_TXUSRCLK21_IN         : in  std_logic;
                                        --------------- Transmit Ports - TX Driver and OOB signalling --------------
      TILE0_TXN0_OUT              : out std_logic;
      TILE0_TXN1_OUT              : out std_logic;
      TILE0_TXP0_OUT              : out std_logic;
      TILE0_TXP1_OUT              : out std_logic


      );

  
end WHITERABBITGTP_WRAPPER;

architecture RTL of WHITERABBITGTP_WRAPPER is
  attribute CORE_GENERATION_INFO        : string;
  attribute CORE_GENERATION_INFO of RTL : architecture is "WHITERABBITGTP_WRAPPER,s6_gtpwizard_v1_4,{gtp0_protocol_file=Start_from_scratch,gtp1_protocol_file=Use_GTP0_settings}";

--***************************** Signal Declarations *****************************

                                        -- ground and tied_to_vcc_i signals
  signal tied_to_ground_i     : std_logic;
  signal tied_to_ground_vec_i : std_logic_vector(63 downto 0);
  signal tied_to_vcc_i        : std_logic;

  signal tile0_plllkdet0_i : std_logic;
  signal tile0_plllkdet1_i : std_logic;

  signal tile0_plllkdet0_i2 : std_logic;


--*************************** Component Declarations **************************

  component WHITERABBITGTP_WRAPPER_TILE
    generic
      (
                                        -- Simulation attributes
        TILE_SIM_GTPRESET_SPEEDUP : integer := 0;  -- Set to 1 to speed up sim reset 
        TILE_CLK25_DIVIDER_0      : integer := 4;
        TILE_CLK25_DIVIDER_1      : integer := 4;
        TILE_PLL_DIVSEL_FB_0      : integer := 5;
        TILE_PLL_DIVSEL_FB_1      : integer := 5;
        TILE_PLL_DIVSEL_REF_0     : integer := 2;
        TILE_PLL_DIVSEL_REF_1     : integer := 2;
                                        --
        TILE_PLL_SOURCE_0         : string  := "PLL0";
        TILE_PLL_SOURCE_1         : string  := "PLL1"
        );
    port
      (
                                                   ------------------------ Loopback and Powerdown Ports ----------------------
        LOOPBACK0_IN          : in  std_logic_vector(2 downto 0);
        LOOPBACK1_IN          : in  std_logic_vector(2 downto 0);
        REFCLKOUT0_OUT           : out std_logic;
        REFCLKOUT1_OUT           : out std_logic;
                                   --------------------------------- PLL Ports --------------------------------
        CLK00_IN              : in  std_logic;
        CLK01_IN              : in  std_logic;
        GTPRESET0_IN          : in  std_logic;
        GTPRESET1_IN          : in  std_logic;
        PLLLKDET0_OUT         : out std_logic;
        PLLLKDET1_OUT         : out std_logic;
        RESETDONE0_OUT        : out std_logic;
        RESETDONE1_OUT        : out std_logic;
                                                   ----------------------- Receive Ports - 8b10b Decoder ----------------------
        RXCHARISK0_OUT        : out std_logic;
        RXCHARISK1_OUT        : out std_logic;
        RXDISPERR0_OUT        : out std_logic;
        RXDISPERR1_OUT        : out std_logic;
        RXNOTINTABLE0_OUT     : out std_logic;
        RXNOTINTABLE1_OUT     : out std_logic;
                                                   --------------- Receive Ports - Comma Detection and Alignment --------------
        RXBYTEISALIGNED0_OUT  : out std_logic;
        RXBYTEISALIGNED1_OUT  : out std_logic;
        RXCOMMADET0_OUT       : out std_logic;
        RXCOMMADET1_OUT       : out std_logic;
        RXSLIDE0_IN           : in  std_logic;
        RXSLIDE1_IN           : in  std_logic;
                                                   ------------------- Receive Ports - RX Data Path interface -----------------
        RXDATA0_OUT           : out std_logic_vector(7 downto 0);
        RXDATA1_OUT           : out std_logic_vector(7 downto 0);
        RXUSRCLK0_IN          : in  std_logic;
        RXUSRCLK1_IN          : in  std_logic;
        RXUSRCLK20_IN         : in  std_logic;
        RXUSRCLK21_IN         : in  std_logic;
                                                   ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
        RXCDRRESET0_IN        : in  std_logic;
        RXCDRRESET1_IN        : in  std_logic;
        RXN0_IN               : in  std_logic;
        RXN1_IN               : in  std_logic;
        RXP0_IN               : in  std_logic;
        RXP1_IN               : in  std_logic;
                                                   ---------------------------- TX/RX Datapath Ports --------------------------
        GTPCLKFBEAST_OUT      : out std_logic_vector(1 downto 0);
        GTPCLKFBWEST_OUT      : out std_logic_vector(1 downto 0);
        GTPCLKOUT0_OUT        : out std_logic_vector(1 downto 0);
        GTPCLKOUT1_OUT        : out std_logic_vector(1 downto 0);
                                                   ------------------- Transmit Ports - 8b10b Encoder Control -----------------
        TXCHARISK0_IN         : in  std_logic;
        TXCHARISK1_IN         : in  std_logic;
                                                   --------------- Transmit Ports - TX Buffer and Phase Alignment -------------
        TXENPMAPHASEALIGN0_IN : in  std_logic;
        TXENPMAPHASEALIGN1_IN : in  std_logic;
        TXPMASETPHASE0_IN     : in  std_logic;
        TXPMASETPHASE1_IN     : in  std_logic;
                                                   ------------------ Transmit Ports - TX Data Path interface -----------------
        TXDATA0_IN            : in  std_logic_vector(7 downto 0);
        TXDATA1_IN            : in  std_logic_vector(7 downto 0);
        TXUSRCLK0_IN          : in  std_logic;
        TXUSRCLK1_IN          : in  std_logic;
        TXUSRCLK20_IN         : in  std_logic;
        TXUSRCLK21_IN         : in  std_logic;
                                                   --------------- Transmit Ports - TX Driver and OOB signalling --------------
        TXN0_OUT              : out std_logic;
        TXN1_OUT              : out std_logic;
        TXP0_OUT              : out std_logic;
        TXP1_OUT              : out std_logic


        );
  end component;


--********************************* Main Body of Code**************************
  
begin
  
  tied_to_ground_i                  <= '0';
  tied_to_ground_vec_i(63 downto 0) <= (others => '0');
  tied_to_vcc_i                     <= '1';

  simulation : if WRAPPER_SIMULATION = 1 generate
    
    TILE0_PLLLKDET0_OUT <= tile0_plllkdet0_i2;
    process
    begin
      wait until tile0_plllkdet0_i'event;
      if(tile0_plllkdet0_i = '1') then
        tile0_plllkdet0_i2 <= '1' after 100 ns;
      else
        tile0_plllkdet0_i2 <= tile0_plllkdet0_i;
      end if;
    end process;
    
    
    
  end generate simulation;

  implementation : if WRAPPER_SIMULATION = 0 generate
    
    TILE0_PLLLKDET0_OUT <= tile0_plllkdet0_i;
    
  end generate implementation;

                                        --------------------------- Tile Instances  -------------------------------   


                                        --_________________________________________________________________________
                                        --_________________________________________________________________________
                                        --TILE0  (X1_Y0)

  tile0_whiterabbitgtp_wrapper_i : WHITERABBITGTP_WRAPPER_TILE
    generic map
    (
                                        -- Simulation attributes
      TILE_SIM_GTPRESET_SPEEDUP => WRAPPER_SIM_GTPRESET_SPEEDUP,
      TILE_CLK25_DIVIDER_0      => WRAPPER_CLK25_DIVIDER_0,
      TILE_CLK25_DIVIDER_1      => WRAPPER_CLK25_DIVIDER_1,
      TILE_PLL_DIVSEL_FB_0      => WRAPPER_PLL_DIVSEL_FB_0,
      TILE_PLL_DIVSEL_FB_1      => WRAPPER_PLL_DIVSEL_FB_1,
      TILE_PLL_DIVSEL_REF_0     => WRAPPER_PLL_DIVSEL_REF_0,
      TILE_PLL_DIVSEL_REF_1     => WRAPPER_PLL_DIVSEL_REF_1,

                                        -- 
      TILE_PLL_SOURCE_0 => "PLL0",
      TILE_PLL_SOURCE_1 => "PLL0"
      )
    port map
    (
                                        ------------------------ Loopback and Powerdown Ports ----------------------
      LOOPBACK0_IN          => TILE0_LOOPBACK0_IN,
      LOOPBACK1_IN          => TILE0_LOOPBACK1_IN,
                                        --------------------------------- PLL Ports --------------------------------
      REFCLKOUT1_OUT => REFCLKOUT1_OUT,
      REFCLKOUT0_OUT => REFCLKOUT0_OUT,
      CLK00_IN              => TILE0_CLK00_IN,
      CLK01_IN              => TILE0_CLK01_IN,
      GTPRESET0_IN          => TILE0_GTPRESET0_IN,
      GTPRESET1_IN          => TILE0_GTPRESET1_IN,
      PLLLKDET0_OUT         => tile0_plllkdet0_i,
      PLLLKDET1_OUT         => tile0_plllkdet1_i,
      RESETDONE0_OUT        => TILE0_RESETDONE0_OUT,
      RESETDONE1_OUT        => TILE0_RESETDONE1_OUT,
                                        ----------------------- Receive Ports - 8b10b Decoder ----------------------
      RXCHARISK0_OUT        => TILE0_RXCHARISK0_OUT,
      RXCHARISK1_OUT        => TILE0_RXCHARISK1_OUT,
      RXDISPERR0_OUT        => TILE0_RXDISPERR0_OUT,
      RXDISPERR1_OUT        => TILE0_RXDISPERR1_OUT,
      RXNOTINTABLE0_OUT     => TILE0_RXNOTINTABLE0_OUT,
      RXNOTINTABLE1_OUT     => TILE0_RXNOTINTABLE1_OUT,
                                        --------------- Receive Ports - Comma Detection and Alignment --------------
      RXBYTEISALIGNED0_OUT  => TILE0_RXBYTEISALIGNED0_OUT,
      RXBYTEISALIGNED1_OUT  => TILE0_RXBYTEISALIGNED1_OUT,
      RXCOMMADET0_OUT       => TILE0_RXCOMMADET0_OUT,
      RXCOMMADET1_OUT       => TILE0_RXCOMMADET1_OUT,
      RXSLIDE0_IN           => TILE0_RXSLIDE0_IN,
      RXSLIDE1_IN           => TILE0_RXSLIDE1_IN,
                                        ------------------- Receive Ports - RX Data Path interface -----------------
      RXDATA0_OUT           => TILE0_RXDATA0_OUT,
      RXDATA1_OUT           => TILE0_RXDATA1_OUT,
      RXUSRCLK0_IN          => TILE0_RXUSRCLK0_IN,
      RXUSRCLK1_IN          => TILE0_RXUSRCLK1_IN,
      RXUSRCLK20_IN         => TILE0_RXUSRCLK20_IN,
      RXUSRCLK21_IN         => TILE0_RXUSRCLK21_IN,
                                        ------- Receive Ports - RX Driver,OOB signalling,Coupling and Eq.,CDR ------
      RXCDRRESET0_IN        => TILE0_RXCDRRESET0_IN,
      RXCDRRESET1_IN        => TILE0_RXCDRRESET1_IN,
      RXN0_IN               => TILE0_RXN0_IN,
      RXN1_IN               => TILE0_RXN1_IN,
      RXP0_IN               => TILE0_RXP0_IN,
      RXP1_IN               => TILE0_RXP1_IN,
                                        ---------------------------- TX/RX Datapath Ports --------------------------
      GTPCLKFBEAST_OUT      => TILE0_GTPCLKFBEAST_OUT,
      GTPCLKFBWEST_OUT      => TILE0_GTPCLKFBWEST_OUT,
      GTPCLKOUT0_OUT        => TILE0_GTPCLKOUT0_OUT,
      GTPCLKOUT1_OUT        => TILE0_GTPCLKOUT1_OUT,
                                        ------------------- Transmit Ports - 8b10b Encoder Control -----------------
      TXCHARISK0_IN         => TILE0_TXCHARISK0_IN,
      TXCHARISK1_IN         => TILE0_TXCHARISK1_IN,
                                        --------------- Transmit Ports - TX Buffer and Phase Alignment -------------
      TXENPMAPHASEALIGN0_IN => TILE0_TXENPMAPHASEALIGN0_IN,
      TXENPMAPHASEALIGN1_IN => TILE0_TXENPMAPHASEALIGN1_IN,
      TXPMASETPHASE0_IN     => TILE0_TXPMASETPHASE0_IN,
      TXPMASETPHASE1_IN     => TILE0_TXPMASETPHASE1_IN,
                                        ------------------ Transmit Ports - TX Data Path interface -----------------
      TXDATA0_IN            => TILE0_TXDATA0_IN,
      TXDATA1_IN            => TILE0_TXDATA1_IN,
      TXUSRCLK0_IN          => TILE0_TXUSRCLK0_IN,
      TXUSRCLK1_IN          => TILE0_TXUSRCLK1_IN,
      TXUSRCLK20_IN         => TILE0_TXUSRCLK20_IN,
      TXUSRCLK21_IN         => TILE0_TXUSRCLK21_IN,
                                        --------------- Transmit Ports - TX Driver and OOB signalling --------------
      TXN0_OUT              => TILE0_TXN0_OUT,
      TXN1_OUT              => TILE0_TXN1_OUT,
      TXP0_OUT              => TILE0_TXP0_OUT,
      TXP1_OUT              => TILE0_TXP1_OUT

      );

  
end RTL;
