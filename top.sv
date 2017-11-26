import uvm_pkg::*;
import uvmc_pkg::*;
`include "uvm_macros.svh"

`include "./rgb_if.sv"
`include "./ycbcr_if.sv"
`include "RGB2YCbCr.sv"
`include "./frame_tr.sv"
`include "./frame_rgb_tr.sv"
`include "./frame_ycbcr_tr.sv"
`include "./frame_seq.sv"
`include "./frame_sqr.sv"
`include "./frame_driver.sv"
`include "./frame_monitor.sv"
`include "./frame_agent.sv"
`include "./frame_driver_out.sv"
`include "./frame_monitor_out.sv"
`include "./frame_agent_out.sv"

`include "./bvm_comparator.sv"
`include "./env.sv"
`include "./simple_test.sv"

//Top
module top;
  logic clk;
  logic rst;
  
  initial begin
    clk = 0;
    rst = 1;
    #22 rst = 0;
    
  end
  
  always #5 clk = !clk;
  
  rgb_if in(clk, rst);
  ycbcr_if out(clk, rst);
  
  RGB2YCbCr rtl(in, out);
  
  initial begin
    `ifdef INCA
       $recordvars();
    `endif
    `ifdef VCS
       $vcdpluson;
    `endif
    `ifdef QUESTA
       $wlfdumpvars();
       set_config_int("*", "recording_detail", 1);
    `endif
    
    uvm_config_db#(rgb_vif)::set(uvm_root::get(), "*.env_h.frag.*", "vif", in);
    uvm_config_db#(ycbcr_vif)::set(uvm_root::get(), "*.env_h.frago.*", "vif", out);
    run_test("simple_test");
  end
endmodule
