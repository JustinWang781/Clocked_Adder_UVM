import uvm_pkg::*;
`include "uvm_macros.svh"
`include "adder_if.svh"
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual adder_if vif;

  uvm_analysis_port #(transaction) adder_ap;
  uvm_analysis_port #(transaction) result_ap;
  transaction prev_tx; // to see if a new transaction has been sent
  transaction tx;
  
  function new(string name, uvm_component parent = null);
    super.new(name, parent);
    adder_ap = new("adder_ap", this);
    result_ap = new("result_ap", this);
  endfunction: new

  // Build Phase - Get handle to virtual if from config_db
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif)) begin
      `uvm_fatal("monitor", "No virtual interface specified for this monitor instance")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    prev_tx = transaction#(4)::type_id::create("prev_tx");
    
    forever begin
      // captures activity between the driver and DUT
      `uvm_info("MONITOR", $sformatf("vif.check = %0d", vif.check), UVM_LOW);
      //wait(!vif.check);
      @(posedge vif.clk);
      tx = transaction#(4)::type_id::create("tx");
      tx.a = vif.a;
      tx.b = vif.b;
      tx.carry_in = vif.carry_in;

      // check if there is a new transaction
      if (!tx.input_equal(prev_tx)) begin
        // send the new transaction to predictor though counter_ap
        `uvm_info("MONITOR", $sformatf("New Transaction a: %b, b: %b, c: %b", tx.a, tx.b, tx.carry_in), UVM_LOW);
        adder_ap.write(tx);
        // wait until check is asserted
        while(!vif.check) begin
          @(posedge vif.clk);
        end
        // capture the responses from DUT and send it to scoreboard through result_ap
        tx.result_sum = vif.sum;
        tx.result_overflow = vif.overflow;
        result_ap.write(tx);
        prev_tx.copy(tx);
      end
    end
  endtask: run_phase

endclass: monitor
