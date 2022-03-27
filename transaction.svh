`ifndef TRANSACTION_SVH
`define TRANSACTION_SVH

import uvm_pkg::*;
`include "uvm_macros.svh"

class transaction #(parameter BIT_WIDTH = 4) extends uvm_sequence_item;
  rand bit [BIT_WIDTH - 1:0] a;
  rand bit [BIT_WIDTH - 1:0] b;
  rand bit carry_in;

  bit [BIT_WIDTH - 1:0] result_sum;
  bit result_overflow;

  `uvm_object_utils_begin(transaction)
    `uvm_field_int(a, UVM_NOCOMPARE)
    `uvm_field_int(b, UVM_NOCOMPARE)
    `uvm_field_int(carry_in, UVM_NOCOMPARE)
    `uvm_field_int(result_sum, UVM_DEFAULT)
    `uvm_field_int(result_overflow, UVM_DEFAULT)
  `uvm_object_utils_end

  //constraint a_con {a < 4'b0100;}

  function new(string name = "transaction");
    super.new(name);
  endfunction: new

  // comparison between two transaction object
  // if two transactions are the same, return 1 else return 
  function int input_equal(transaction tx);
    int result;

   `uvm_info("TRANSACTION", $sformatf("a = %b, tx.a = %b, b = %b, tx.b = %b, carry_in = %b, tx.carry_in = %b",a , tx.a, b , tx.b, carry_in, tx.carry_in), UVM_LOW);
    if((a == tx.a) && (b == tx.b) && (carry_in == tx.carry_in)) begin
      result = 1;
      return result;
    end
    result = 0;
    return result;
  endfunction

endclass //transaction

`endif
