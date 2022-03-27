import uvm_pkg::*;
`include "uvm_macros.svh"

`include "adder_if.svh"

class driver extends uvm_driver#(transaction);
  `uvm_component_utils(driver)

  virtual adder_if vif;

  function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // get interface from database
    if( !uvm_config_db#(virtual adder_if)::get(this, "", "adder_vif", vif) ) begin
      // if the interface was not correctly set, raise a fatal message
      `uvm_fatal("Driver", "No virtual interface specified for this test instance");
		end
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    transaction req_item;
    vif.check = 1;

    DUT_reset();

    forever begin 
      seq_item_port.get_next_item(req_item);
      `uvm_info("DRIVER", $sformatf("transaction received by driver"), UVM_LOW);
      DUT_reset_check();
      vif.a = req_item.a;
      vif.b = req_item.b;
      vif.carry_in = req_item.carry_in;
      `uvm_info("DRIVER", $sformatf("Driver: a: %b, b: %b, cin: %b", vif.a, vif.b, vif.carry_in), UVM_LOW);
      @(posedge vif.clk);
      vif.check = 1;
      @(posedge vif.clk);
      seq_item_port.item_done();
    end
  endtask: run_phase

  task DUT_reset_check();
    vif.check = 0;
    @(posedge vif.clk);
  endtask

  task DUT_reset();
    vif.n_rst = 0;
    @(posedge vif.clk);
    vif.n_rst = 1;
  endtask
endclass: driver
