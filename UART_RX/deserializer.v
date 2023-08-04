module deserializer #
(
  parameter DATA_SIZE = 8
)
(
  input  wire                 clk, 
  input  wire                 rst, 
  
  input  wire                 en_shift,  
  input  wire                 in, 
  
  input  wire                 en_out, 

  output reg  [DATA_SIZE-1:0] out, 
  output reg  [DATA_SIZE-1:0] out_reg 
);

  always @ (posedge clk or negedge rst)
    begin
      if (!rst)
        out <= 0;
      else if (en_shift)
        out <= {in, out[DATA_SIZE-1:1]};
    end

  always @ (posedge clk or negedge rst)
    begin
      if (!rst)
        out_reg <= 0;
      else if (en_out)
        out_reg <= out;
    end
endmodule