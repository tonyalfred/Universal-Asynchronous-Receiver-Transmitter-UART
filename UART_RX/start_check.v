module start_check
(
  input  wire  clk,
  input  wire  rst,
  
  input  wire  en,
  input  wire  in,
  
  output reg   err  
);

  always @ (posedge clk or negedge rst)
    begin
      if (!rst)
        err <= 0;
      else if (en)
        err <= in;
    end
endmodule