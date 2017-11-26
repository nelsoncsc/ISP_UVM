//Output Transaction
class frame_out_tr extends uvm_sequence_item;
    //rand integer Y, Cb, Cr;
    longint unsigned a;

    `uvm_object_utils_begin(frame_out_tr)
        /*`uvm_field_int(Y, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(Cb, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(Cr, UVM_ALL_ON|UVM_HEX)*/
        `uvm_field_int(a, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end

    function new(string name="frame_out_tr");
        super.new(name);
    endfunction: new

    function string convert2string();
       // chamar frame_tr_convert2string (por DPI)
       // return aquilo que frame_tr_convert2string devolva
    endfunction

    function int compare(frame_out_tr tr); // verificar assinatura
      // chamar frameCompare(this, tr)
    endfunction

endclass: frame_out_tr
