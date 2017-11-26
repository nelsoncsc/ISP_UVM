//Test
class simple_test extends uvm_test;
  env env_h;
  frame_seq fseq;

  `uvm_component_utils(simple_test)

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_h = env::type_id::create("env_h", this);
    fseq = frame_seq::type_id::create("fseq", this);
  endfunction
 
  task run_phase(uvm_phase phase);
    fork
        fseq.start(env_h.frag.sqr);
    join
  endtask: run_phase

endclass
