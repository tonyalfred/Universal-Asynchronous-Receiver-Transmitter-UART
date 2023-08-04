module data_sampler
(
  input  wire       clk,   
  input  wire       rst,
  
  input  wire       en,
  input  wire       in,  

  output reg        out 
);

  reg [2:0] sampled_bits;

  always @ (posedge clk or negedge rst)
    begin
      if (!rst)
        sampled_bits <= 1'b0;
      else if (en)
        sampled_bits <= {sampled_bits, in};   
    end

  //  By using a MAJORITY GATE for 3-INPUTS (X,Y,Z):  //
  //        (X && Y) || (X && Z) || (Y && Z)          //

  always @ (posedge clk or negedge rst)
    begin
      if (!rst)
        out <= 1'b0;
      else if (en)
        out <= ((sampled_bits[0] &&  sampled_bits[1]) || (sampled_bits[0] &&  sampled_bits[2]) || (sampled_bits[1] &&  sampled_bits[2]));
    end
endmodule