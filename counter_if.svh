`ifndef COUNTER_IF_SVH
`define COUNTER_IF_SVH

interface counter_if #(parameter NUM_BITS = 4) (input logic clk);
  logic n_rst;
  logic clear;
  logic count_enable;
  logic [NUM_BITS - 1:0] rollover_val;
  logic [NUM_BITS - 1:0] count_out;
  logic rollover_flag;
  logic check; //monitor check the result when this is high
  int enable_time; //number of clock cycles that counter_enable will be on

  modport tester
  (
    input count_out, rollover_flag, clk,
    output n_rst, clear, count_enable, rollover_val, check, enable_time
  );

  modport counter // modport to DUT
  (
    output count_out, rollover_flag,
    input n_rst, clear, count_enable, rollover_val, clk
  );
endinterface

`endif