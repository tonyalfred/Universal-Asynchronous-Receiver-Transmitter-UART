module deserializer #
(
  parameter DATA_SIZE = 8
)
(
  input  wire                  clk , 
  input  wire                  rst , 
  
  input  wire                  en  ,  
  input  wire                  in  , 
  
  output reg  [DATA_SIZE-1:0]  out
);

always @ (posedge clk or negedge rst)
  begin
    if (!rst)
      out <= 0;
    else if (en)
      out <= {in, out [DATA_SIZE-1:1]};
  end

endmodule