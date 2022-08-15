module serializer #
(
  parameter DATA_WIDTH = 8 , 
  parameter CNTR_WIDTH = 3
)
(
  input  wire                    clk      ,
  input  wire                    rst      ,

  input  wire  [DATA_WIDTH-1:0]  data_in  ,
  input  wire                    ser_en   ,

  output wire                    ser_data ,
  output wire                    ser_done 
);

reg [DATA_WIDTH-1:0] REG  ;
reg [CNTR_WIDTH-1:0] CNTR ;

always @ (posedge clk or negedge rst)
  begin
    if (!rst)
      REG <= 0;
    else if (ser_en)
      begin
        if (CNTR == 0)
          REG <= data_in;
        else
          REG <= REG >> 1;
      end
  end

always @ (posedge clk or negedge rst)
  begin
    if (!rst)
      CNTR <= 0;
    else if (ser_en)
      begin
        if (ser_done)
          CNTR <= 0;
        else
          CNTR <= CNTR + 1;
      end
  end

assign ser_done = (CNTR == 3'b111); 
assign ser_data =  REG [0];

endmodule