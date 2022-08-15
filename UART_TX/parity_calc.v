module parity_calc #
(
  parameter DATA_WIDTH = 8
)
(
  input  wire                  clk         ,
  input  wire                  rst         ,
  
  input  wire [DATA_WIDTH-1:0] data_in     ,
  input  wire                  data_valid  ,
  
  input  wire                  parity_type ,

  output reg                   parity_bit  
);

always @ (posedge clk)
  begin  
    if (!rst)
      parity_bit <= 0;
    else if (data_valid)
      parity_bit <= ^ data_in ^ parity_type;
  end

endmodule