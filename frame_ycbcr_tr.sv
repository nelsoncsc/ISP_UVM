`include "cvFunction.svh"
// pixels are Y Cb Cr
class frame_ycbcr_tr extends frame_tr;
  `uvm_object_utils(frame_ycbcr_tr)

    function new(string name="frame_ycbcr_tr");
        super.new(name);
    endfunction: new

    function string convert2string();
       return frame_tr_convert2string(a, 0);
    endfunction

endclass: frame_ycbcr_tr
