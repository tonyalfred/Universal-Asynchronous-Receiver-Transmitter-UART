module parity_check #
(
  parameter DATA_WIDTH = 8
)
(
  input  wire                  clk,
  input  wire                  rst,

  input  wire                  en,
  input  wire                  typ,
  
  input  wire                  sample,
  input  wire [DATA_WIDTH-1:0] in,
  
  output reg                   err  
);

  always @ (posedge clk or negedge rst)
    begin
      if (!rst)
        err <= 0;
      else if (en)
        err <= ((^ in ^ typ) != sample);
    end
endmodule