module parity_calc #
(
  parameter DATA_WIDTH = 8
)
(
  input  wire                  clk,
  input  wire                  rst,

  input  wire                  parity_en, 
  input  wire                  parity_type, 

  input  wire                  data_valid, 
  input  wire                  busy,
  
  input  wire [DATA_WIDTH-1:0] data_in,
  
  output reg                   parity_bit  
);

  always @ (posedge clk or negedge rst)
    begin  
      if (!rst) begin
        parity_bit <= 0;
      end else if (parity_en && data_valid && !busy) begin
        parity_bit <= ^ data_in ^ parity_type;
      end
    end
endmodule