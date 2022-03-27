import uvm_pkg::*;
`include "uvm_macros.svh"
`include "transaction.svh"

class predictor extends uvm_subscriber #(transaction);
  `uvm_component_utils(predictor) 

  uvm_analysis_port #(transaction) pred_ap;
  transaction output_tx;

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    pred_ap = new("pred_ap", this);
  endfunction


  logic [3:0] predict_a;
  logic [3:0] predict_b;
  logic predict_carry_in;
  logic predict_overflow;
  logic predict_sum;

  function void write(transaction t);
    output_tx = transaction#(4)::type_id::create("output_tx", this);
    output_tx.copy(t);
   // calculate the expected count_out

   predict_a = t.a;
   predict_b = t.b;
   predict_carry_in = t.carry_in;

   `uvm_info("PREDICTOR", $sformatf("5 bit sum: %b", (5'(t.a) + 5'(t.b) + 5'(t.carry_in))), UVM_LOW);
    if((5'(t.a) + 5'(t.b) + 5'(t.carry_in)) > 5'b01111) begin
      output_tx.result_overflow = 1;
    predict_overflow = 1;
    end
    else begin
      output_tx.result_overflow = 0;
      predict_overflow = 0;
    end
    
    output_tx.result_sum = t.a + t.b + t.carry_in;
    predict_sum = t.a + t.b + t.carry_in;


    // after prediction, the expected output send to the scoreboard 
   `uvm_info("PREDICTOR", $sformatf("a: %b, b: %b, c: %b", predict_a, predict_b, predict_carry_in), UVM_LOW);
    pred_ap.write(output_tx);
  endfunction: write

endclass: predictor

