//Input Sequencer
class frame_sqr extends uvm_sequencer #(frame_rgb_tr);
    `uvm_component_utils(frame_sqr)

    function new (string name = "frame_sqr", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass: frame_sqr
