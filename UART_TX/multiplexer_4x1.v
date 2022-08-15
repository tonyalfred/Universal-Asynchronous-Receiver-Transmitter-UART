module multiplexer_4x1 
(
  input  wire        in_0 ,
  input  wire        in_1 ,
  input  wire        in_2 ,
  input  wire        in_3 ,
  input  wire [1:0 ] sel  ,
  
  output reg         out
);

always @ (*)
  begin
    casex (sel)
      2'b00  : out = in_0;
      2'b01  : out = in_1;
      2'b10  : out = in_2;
      2'b11  : out = in_3;
      default: out = in_1; 
    endcase
  end 
  
endmodule