module FSM_RX
(
  input  wire         clk        ,
  input  wire         rst        ,

  input  wire         par_en     ,
  input  wire         rx_in      ,
  
  input  wire  [5:0]  edg_cnt    ,
  input  wire  [3:0]  bit_cnt    , 
  
  input  wire         str_err    ,
  input  wire         par_err    ,
  input  wire         stp_err    ,
  
  output wire         str_chk_en ,
  output wire         par_chk_en ,
  output wire         stp_chk_en ,
     
  output wire         edg_cnt_en ,
  output wire         sampler_en ,
  output wire         deser_en   ,

  output wire         data_valid 
);

reg    [6:0] FSM_OUT;
assign {str_chk_en, par_chk_en, stp_chk_en, edg_cnt_en, sampler_en, deser_en, data_valid} = FSM_OUT;

localparam [2:0] S0_IDLE = 3'b000 ; 
localparam [2:0] S1_STRT = 3'b001 ;
localparam [2:0] S2_DATA = 3'b011 ;
localparam [2:0] S3_PART = 3'b010 ;
localparam [2:0] S4_STOP = 3'b110 ;
localparam [2:0] S5_CHCK = 3'b111 ;
localparam [2:0] S6_VALD = 3'b101 ;

reg [2:0] current_state ;
reg [2:0] next_state    ;

always @ (posedge clk or negedge rst)
  if (!rst)
    current_state <= S0_IDLE;
  else 
    current_state <= next_state;

always @ (*)
  begin
    case (current_state)
      S0_IDLE:
        begin
          FSM_OUT    = 7'b000_000_0;
        
          next_state = rx_in   ? S0_IDLE : S1_STRT;
        end      
      S1_STRT:
        begin
          FSM_OUT    = 7'b100_110_0;
          
          next_state = str_err ? S0_IDLE : S2_DATA;
        end
        
      S2_DATA:
        begin
          FSM_OUT    = 7'b000_111_0;
          
          if (bit_cnt == 8)
            next_state = par_en ? S3_PART : S4_STOP;
          else
            next_state = S2_DATA;
        end
        
      S3_PART:
        begin
          FSM_OUT    = 7'b010_110_0;
          
          next_state = (bit_cnt == 9)  ? S4_STOP : S3_PART;
        end
        
      S4_STOP:
        begin
          FSM_OUT    = 7'b001_110_0;
          
          next_state = (bit_cnt == 10) ? S5_CHCK : S4_STOP;
        end
        
      S5_CHCK:
        begin
          FSM_OUT    = 7'b000_000_0;
          
          next_state = (par_err || stp_err) ? S0_IDLE : S6_VALD;
        end
        
      S6_VALD:
        begin
          FSM_OUT    = 7'b000_000_1;
          
          next_state = rx_in  ? S0_IDLE : S1_STRT;
        end
        
      default: 
        begin
          FSM_OUT    = 7'b000_000_0;
          
          next_state = S0_IDLE;
        end        
    endcase
  end

endmodule