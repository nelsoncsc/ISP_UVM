class bvm_comparator #( type T = int ) extends uvm_scoreboard;

  typedef bvm_comparator #(T) this_type;
  `uvm_component_param_utils(this_type)

  const static string type_name = 
    "bvm_comparator #(T)";

  uvm_put_imp #(T, this_type) from_refmod;
  uvm_analysis_imp #(T, this_type) from_dut;

  typedef uvm_built_in_converter #( T ) convert; 

  int m_matches, m_mismatches;
  T exp;
  bit free;
  event compared;

  function new(string name, uvm_component parent);
    super.new(name, parent);
    from_refmod = new("from_refmod", this);
    from_dut = new("from_dut", this);
    m_matches = 0;
    m_mismatches = 0;
    exp = new("exp");
    free = 1;
  endfunction

  virtual function string get_type_name();
    return type_name;
  endfunction

  virtual task put(T t);
    if(!free) @compared;
    exp.copy(t);
    free = 0;
    @compared;
    free = 1;
  endtask

  virtual function bit try_put(T t);
    if(free) begin
      exp.copy(t);
      free = 0;
      return 1;
    end
    else return 0;
  endfunction

  virtual function bit can_put();
    return free;
  endfunction

  virtual function void write(T rec);
    string s;

    if (free) begin
      $sformat(s, "No expect transaction to compare with %s", convert::convert2string(rec));
      uvm_report_fatal("Comparator no expect", s);
    end

    if(!exp.compare(rec)) begin
      $sformat(s, "%s differs from %s", convert::convert2string(rec),
                                        convert::convert2string(exp));
      uvm_report_warning("Comparator Mismatch", s);
      m_mismatches++;
    end
    else begin
      s = convert::convert2string(exp);
      uvm_report_info("Comparator Match", s);
      m_matches++;
    end

    -> compared;
  endfunction
 
endclass
