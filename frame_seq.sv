`include "cvFunction.svh"

//Input Sequence
class frame_seq extends uvm_sequence #(frame_rgb_tr);
    `uvm_object_utils(frame_seq)

    function new(string name="frame_seq");
        super.new(name);
    endfunction: new

    task body;
         frame_rgb_tr tx;
            tx = frame_rgb_tr::type_id::create("tx");
            start_item(tx);
            tx.a = readframe();
	    finish_item(tx);
    endtask: body
endclass: frame_seq

