module edge_bit_counter
(
  input  wire         clk        ,
  input  wire         rst        , 
  
  input  wire         en         , 
  input  wire  [4:0]  presecalar , 
  
  output reg   [5:0]  edge_cnt   ,
  output reg   [3:0]  bit_cnt 
);

always @ (posedge clk or negedge rst)
  begin
    if (!rst)
      begin
        edge_cnt <= 0;
        bit_cnt  <= 0;
      end
    else if (en)
      begin
        if (edge_cnt == (presecalar + 1))
          begin
            edge_cnt <= 0;
            bit_cnt  <= bit_cnt + 1;
          end
        else
          begin
            edge_cnt <= edge_cnt + 1;
          end
      end
    else
      begin
        edge_cnt <= 0;
        bit_cnt  <= 0;
      end
  end
  
endmodule