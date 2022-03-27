`include "adder_Nbit.sv"

// interface file
`include "adder_if.svh"

// UVM test file
`include "test.svh"

`timescale 1ns/1ps
// import uvm packages
import uvm_pkg::*;

module tb_adder ();
  logic clk;
  //clock generation
  initial begin
    clk = 0;
    forever #10 clk = !clk;
  end



  adder_if add_if(clk);
  
  // instantiate the DUT
  adder_nbit adder (add_if.adder);
  initial begin
    uvm_config_db#(virtual adder_if)::set( null, "", "adder_vif", add_if); // configure the interface into the database, so that it can be accessed throughout the hierachy
    run_test("test"); // initiate test component
  end
endmodule
