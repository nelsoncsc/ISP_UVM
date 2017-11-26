`include "cvFunction.svh"

// Basic frame transaction
class frame_tr extends uvm_sequence_item;
    longint unsigned a;

    `uvm_object_utils_begin(frame_tr)
        `uvm_field_int(a, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="frame_tr");
        super.new(name);
    endfunction: new

    function int compare(frame_tr tr); 
       return frameCompare(a, tr.a);
    endfunction

endclass: frame_tr
