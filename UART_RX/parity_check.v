module parity_check #
(
  parameter DATA_WIDTH = 8
)
(
  input  wire                    clk    ,
  input  wire                    rst    ,
  
  input  wire                    typ    ,
  
  input  wire                    en     ,
  input  wire                    sample ,
  input  wire  [DATA_WIDTH-1:0]  in     ,
  
  output reg                     error  
);

wire calc;

always @ (posedge clk or negedge rst)
  begin
    if (!rst)
      error <= 0;
    else if (en)
      error <= (calc != sample);
  end

assign calc = ^ in ^ typ;

endmodule