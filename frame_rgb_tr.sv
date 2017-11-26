`include "cvFunction.svh"
// pixels are RGB
class frame_rgb_tr extends frame_tr;
  `uvm_object_utils(frame_rgb_tr)

    function new(string name="frame_rgb_tr");
        super.new(name);
    endfunction: new

    function string convert2string();
       return $sformatf("a=%d %s", a, frame_tr_convert2string(a, 1));
    endfunction

endclass: frame_rgb_tr

