module data_sampler
(
  input  wire  clk ,   
  input  wire  rst ,
  
  input  wire  en  ,
  input  wire  in  ,  

  output wire  out 
);

reg [2:0] data_sampled;

always @ (posedge clk or negedge rst)
  begin
    if (!rst)
        data_sampled <= 0;
    else if (en)
        data_sampled <= {in , data_sampled [2:1]};   
  end

/*   By using a MAJORITY GATE for 3-INPUTS (X,Y,Z): 
            (X && Y) || (X && Z) || (Y && Z)                  */
assign out = ((data_sampled[0] && data_sampled[1]) || (data_sampled[0] && data_sampled[2]) || (data_sampled[1] && data_sampled[2]));

endmodule