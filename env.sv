
class env extends uvm_env;
  
    frame_agent frag;
 
    frame_agent_out frago;
    bvm_comparator #(frame_ycbcr_tr) comp;  
  
    uvm_tlm_analysis_fifo #(frame_rgb_tr) to_refmod;
    `uvm_component_utils(env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
        to_refmod = new("to_refmod", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        frag = frame_agent::type_id::create("frag", this);
        frago = frame_agent_out::type_id::create("frago", this);
        comp = bvm_comparator#(frame_ycbcr_tr)::type_id::create("comp", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // connect agent to refmod via fifo 
        frag.item_collected_port.connect(to_refmod.analysis_export);
        uvmc_tlm1 #(frame_rgb_tr)::connect(to_refmod.get_export, "refmod_i.in");
        
        //Connect scoreboard
        uvmc_tlm1 #(frame_ycbcr_tr)::connect(comp.from_refmod,"refmod_i.out");
        frago.item_collected_port.connect(comp.from_dut); 
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
    endfunction
  
    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info(get_type_name(), $sformatf("Reporting matched %0d", comp.m_matches), UVM_NONE)
        if (comp.m_mismatches) begin
            `uvm_error(get_type_name(), $sformatf("Saw %0d mismatched samples", comp.m_mismatches))
        end
    endfunction
endclass
