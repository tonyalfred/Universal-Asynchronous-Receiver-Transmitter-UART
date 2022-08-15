module stop_check
(
  input  wire  clk   ,
  input  wire  rst   ,
  
  input  wire  en    ,
  input  wire  in    ,
  
  output reg   error  
);

always @ (posedge clk or negedge rst)
  begin
    if (!rst)
      error <= 0;
    else if (en)
      error <= ~ in;
  end

endmodule