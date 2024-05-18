-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
-- Date        : Mon May  6 23:07:59 2024
-- Host        : LAPTOP-1890NNVV running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub {D:/Desktop/Computer
--               organization/MineCPU/vivado_project/vivado_project.srcs/sources_1/ip/VGAClkGen/VGAClkGen_stub.vhdl}
-- Design      : VGAClkGen
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tfgg484-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity VGAClkGen is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end VGAClkGen;

architecture stub of VGAClkGen is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_in1";
begin
end;
