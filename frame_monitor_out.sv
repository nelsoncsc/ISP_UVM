`include "cvFunction.svh"

class frame_monitor_out extends uvm_monitor;
    ycbcr_vif  vif;

    frame_ycbcr_tr tr;
    uvm_analysis_port #(frame_ycbcr_tr) item_collected_port;
    `uvm_component_utils(frame_monitor_out)
   
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new ("item_collected_port", this);
	`uvm_info("MONITOR OUT CREATED","new",UVM_MEDIUM)
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(ycbcr_vif)::get(this, "", "vif", vif));
        tr = frame_ycbcr_tr::type_id::create("tr", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("Monitor ycbcr ","started run_phase",UVM_MEDIUM)

        wait (vif.rst === 1);
        @(negedge vif.rst);
	@(posedge vif.clk);
        //forever begin
         tr.a = allocateFrame();
	 @(posedge vif.clk);
         begin_tr(tr, "frame_monitor_out");
         for(int i = 0; i < `HEIGHT; i++)begin
             for(int j = 0; j < `WIDTH; j++)begin
                 setPixel(tr.a, i, j, vif.Y, vif.Cb, vif.Cr);
                 `uvm_info("Monitor ycbcr",$sformatf("Received pixel i=%d j=%d Y=%d Cb=%d, Cr=%d", i, j, vif.Y, vif.Cb, vif.Cr), UVM_LOW)
                 `uvm_info("Monitor ycbcr",$sformatf("loop i=%d j=%d before clk", i, j), UVM_LOW)
                 @(posedge vif.clk);
                 `uvm_info("Monitor ycbcr",$sformatf("loop i=%d j=%d ended", i, j), UVM_LOW)
              end
         end
         `uvm_info("Monitor ycbcr ", "Received frame", UVM_LOW)	 
         item_collected_port.write(tr);
         `uvm_info("Monitor ycbcr ", "Wrote frame to port", UVM_LOW)	 
	 end_tr(tr);
	
        //end
        @(posedge vif.clk);
       `uvm_info("Monitor ycrcb", "Stopping the test", UVM_LOW);
        phase.drop_objection(this);
    endtask
	
endclass
