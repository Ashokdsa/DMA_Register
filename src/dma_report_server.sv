class dma_report_server extends uvm_report_server;

  `uvm_object_utils(dma_report_server)

  localparam string RED     = "\033[1;31m";
  localparam string GREEN   = "\033[1;32m";
  localparam string YELLOW  = "\033[1;33m";
  localparam string BLUE    = "\033[1;34m";
  localparam string MAGENTA = "\033[1;35m";
  localparam string CYAN    = "\033[1;36m";
  localparam string RESET   = "\033[0m";

  function new(string name = "dma_report_server");
    super.new();
  endfunction

  virtual function string compose_message(
    uvm_severity severity,
    string name,
    string id,
    string message,
    string filename,
    int line
  );

    string sev_color, sev_label;
    string composed;

    case(severity)
      UVM_INFO:    begin sev_color = GREEN;   sev_label = "[UVM_INFO] ";  end
      UVM_WARNING: begin sev_color = YELLOW;  sev_label = "[UVM_WARNING] ";  end
      UVM_ERROR:   begin sev_color = RED;     sev_label = "[UVM_ERROR] "; end
      UVM_FATAL:   begin sev_color = MAGENTA; sev_label = "[UVM_FATAL] "; end
      default:     begin sev_color = RESET;   sev_label = "[UVM_MSG] ";   end
    endcase


    composed = $sformatf("%s%s%s %s[%s]%s %s[time = %0t]%s %s",
      sev_color, sev_label, RESET,
      CYAN, id, RESET,
      BLUE, $time, RESET,
      message);
    return composed;
  endfunction

endclass
