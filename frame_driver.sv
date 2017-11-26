`include "cvFunction.svh"

//Input Driver
typedef virtual rgb_if rgb_vif;

class frame_driver extends uvm_driver #(frame_rgb_tr);
    `uvm_component_utils(frame_driver)
    rgb_vif vif;
    frame_rgb_tr tr;

    function new(string name = "frame_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(rgb_vif)::get(this, "", "vif", vif));
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            reset_signals();
            get_and_drive(phase);
        join
    endtask

    virtual protected task reset_signals();
        wait (vif.rst === 1);
        forever begin
            vif.R <= 'x;
            vif.G <= 'x;
            vif.B <= 'x;
            @(posedge vif.rst);
        end
    endtask
    
    int rows, cols;
    string message, message2; 
    virtual protected task get_and_drive(uvm_phase phase);
        wait (vif.rst === 1);
        @(negedge vif.rst);

        //forever begin
        seq_item_port.get(tr);
        begin_tr(tr, "frame_driver");
	for(rows = 0; rows < `HEIGHT; rows++)begin
             for(cols = 0; cols < `WIDTH; cols++)begin
                 vif.R = getChannel(tr.a, cols, rows, 2);
                 vif.G = getChannel(tr.a, cols, rows, 1);
                 vif.B = getChannel(tr.a, cols, rows, 0);
		 `uvm_info("DRIVER",$sformatf("Sent pixel R=%d G=%d, B=%d", vif.R, vif.G, vif.B), UVM_LOW)
                 @(posedge vif.clk);
             end
         end
         end_tr(tr);
         `uvm_info("DRIVER","ended", UVM_LOW)
        //end
    endtask

endclass
