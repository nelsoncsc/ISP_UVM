class frame_agent_out extends uvm_agent;
    frame_driver_out    drv;
    frame_monitor_out   mon;

    uvm_analysis_port #(frame_ycbcr_tr) item_collected_port;

    `uvm_component_utils(frame_agent_out)

    function new(string name = "frame_agent_out", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = frame_driver_out::type_id::create("drv", this);
        mon = frame_monitor_out::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.item_collected_port.connect(item_collected_port);
    endfunction
endclass: frame_agent_out
