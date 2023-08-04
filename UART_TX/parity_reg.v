module parity_reg 
(
  input  wire clk,
  input  wire rst,

  input  wire parity_en,

  input  wire data_valid, 
  input  wire busy,
  
  output reg  out  
);

  always @ (posedge clk or negedge rst)
    begin
      if (!rst) begin
        out <= 1'b0;
      end else if (data_valid && !busy) begin
        out <= parity_en;
      end
    end
endmodule