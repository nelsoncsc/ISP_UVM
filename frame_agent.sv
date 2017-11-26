class frame_agent extends uvm_agent;
    frame_sqr sqr;
    frame_driver    drv;
    frame_monitor   mon;

    uvm_analysis_port #(frame_rgb_tr) item_collected_port;

    `uvm_component_utils(frame_agent)

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sqr = frame_sqr::type_id::create("sqr", this);
        drv = frame_driver::type_id::create("drv", this);
        mon = frame_monitor::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.item_collected_port.connect(item_collected_port);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass: frame_agent
