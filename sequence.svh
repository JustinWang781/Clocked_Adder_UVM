import uvm_pkg::*;
`include "uvm_macros.svh"

`include "transaction.svh"

class adder_sequence extends uvm_sequence #(transaction);
  `uvm_object_utils(adder_sequence)
  function new(string name = "");
    super.new(name);
  endfunction: new

  task body();
    transaction req_item;
    req_item = transaction#(4)::type_id::create("req_item");
    
    repeat(60) begin
      start_item(req_item);
      if(!req_item.randomize()) begin
        // if the transaction is unable to be randomized, send a fatal message
        `uvm_fatal("sequence", "not able to randomize")
      end
      `uvm_info("SEQUENCE", $sformatf("Send transaction to driver"), UVM_LOW);
      `uvm_info("SEQUENCE", $sformatf("Sent: a: %b, b: %b, c: %b", req_item.a, req_item.b, req_item.carry_in), UVM_LOW);
      finish_item(req_item);
    end
  endtask: body
endclass //sequence

class sequencer extends uvm_sequencer#(transaction);

   `uvm_component_utils(sequencer)
 
   function new(input string name = "sequencer", uvm_component parent=null);
      super.new(name, parent);
   endfunction : new
endclass : sequencer
