typedef virtual ycbcr_if ycbcr_vif;

class frame_driver_out extends uvm_driver #(frame_ycbcr_tr);
    `uvm_component_utils(frame_driver_out)
    ycbcr_vif vif;

    function new(string name = "frame_driver_out", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(ycbcr_vif)::get(this, "", "vif", vif));
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            reset_signals();
            drive(phase);
        join
    endtask

    virtual protected task reset_signals();
        wait (vif.rst === 1);
        forever begin
            vif.Y <= 'x;
            vif.Cb <= 'x;
            vif.Cr <= 'x;
            @(posedge vif.rst);
        end
    endtask

    virtual protected task drive(uvm_phase phase);
        wait(vif.rst === 1);
        @(negedge vif.rst);
        @(posedge vif.clk);
    endtask
endclass
