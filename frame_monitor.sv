`include "cvFunction.svh"

class frame_monitor extends uvm_monitor;
    rgb_vif  vif;

    frame_rgb_tr tr;
    uvm_analysis_port #(frame_rgb_tr) item_collected_port;
    `uvm_component_utils(frame_monitor)
   
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new ("item_collected_port", this);
	`uvm_info("MONITOR CREATED","new",UVM_MEDIUM)
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(rgb_vif)::get(this, "", "vif", vif));
        tr = frame_rgb_tr::type_id::create("tr", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info("Monitor rgb","started run_phase",UVM_MEDIUM)

        wait (vif.rst === 1);
        @(negedge vif.rst);

        //forever begin
            tr.a = allocateFrame();
            @(posedge vif.clk);
            begin_tr(tr, "frame_monitor");
	    for(int i = 0; i < `HEIGHT; i++)begin
                for(int j = 0; j < `WIDTH; j++)begin
                    setPixel(tr.a, i, j, vif.R, vif.G, vif.B);
                    `uvm_info("Monitor rgb",$sformatf("Received pixel i=%d j=%d R=%d G=%d, B=%d", i, j, vif.R, vif.G, vif.B), UVM_LOW)
	    	    @(posedge vif.clk); 
                end
            end
            `uvm_info("Monitor rgb ", "Received frame", UVM_LOW)	 
            item_collected_port.write(tr);
            `uvm_info("Monitor rgb ", "Wrote frame to port", UVM_LOW)	 
            end_tr(tr);
            `uvm_info("Monitor rgb ", "ended tr", UVM_LOW)	 
        //end
    endtask
	
endclass
