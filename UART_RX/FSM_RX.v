module FSM_RX
(
  input  wire       clk,
  input  wire       rst,

  input  wire       par_en,
  input  wire [4:0] prescale, 
  input  wire       rx_in,
  
  input  wire [4:0] edg_cnt,
  input  wire [3:0] bit_cnt, 
  
  input  wire       str_err,
  input  wire       par_err,
  input  wire       stp_err,
  
  output wire       str_chk_en,
  output wire       par_chk_en,
  output wire       stp_chk_en,
     
  output reg       edg_cnt_en,
  output wire       sampler_en,
  output wire       deser_en,

  output wire       data_valid, 
  output wire data_out_valid
);

  localparam [2:0] S0_IDLE = 3'b000,
                   S1_STRT = 3'b001, 
                   S2_DATA = 3'b010,
                   S3_PART = 3'b011,
                   S4_STOP = 3'b100;

  reg [2:0] current_state, next_state;

  wire [4:0] mid_sample;

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
            if (rx_in) 
              begin
                edg_cnt_en = 1'b0;
                next_state = S0_IDLE;
              end 
            else 
              begin
                edg_cnt_en = 1'b1;
                next_state = S1_STRT;
              end
          end
        S1_STRT:
          begin
            if (str_err)
              begin
                edg_cnt_en = 1'b0;
                next_state = S0_IDLE;
              end
            else if (bit_cnt == 4'd1)
              begin
                edg_cnt_en = 1'b1;
                next_state = S2_DATA;
              end
            else 
              begin
                edg_cnt_en = 1'b1;
                next_state = S1_STRT;
              end
          end
        S2_DATA:
          begin
            if (bit_cnt == 4'd9)
              begin
                if (par_en) 
                  begin
                    edg_cnt_en = 1'b1;
                    next_state = S3_PART;
                  end
                else 
                  begin
                    edg_cnt_en = 1'b1;
                    next_state = S4_STOP;
                  end
              end
            else
              begin
                edg_cnt_en = 1'b1;
                next_state = S2_DATA;
              end
          end
        S3_PART:
          begin
            if (bit_cnt == 4'd10)
              begin
                if (par_err)
                  begin
                    edg_cnt_en = 1'b0;
                    next_state = S0_IDLE;
                  end
                else
                  begin
                    edg_cnt_en = 1'b1;
                    next_state = S4_STOP;
                  end
              end
            else
              begin
                edg_cnt_en = 1'b1;
                next_state = S3_PART;
              end
          end
        S4_STOP:
          begin
            if (par_en)
              begin
                if (bit_cnt == 4'd11)
                  begin
                    edg_cnt_en = 1'b0;
                    next_state = S0_IDLE;
                  end
                else
                  begin
                    edg_cnt_en = 1'b1;
                    next_state = S4_STOP;
                  end
              end
            else if (bit_cnt == 4'd10)
              begin
                edg_cnt_en = 1'b0;
                next_state = S0_IDLE;
              end
            else
              begin
                edg_cnt_en = 1'b1;
                next_state = S4_STOP;
              end
          end
      endcase
    end

  assign mid_sample = prescale >> 1;    
  assign par_chk_en     = ((current_state == S3_PART) && (edg_cnt == mid_sample + 2)) ? 1'b1 : 1'b0;
  assign str_chk_en     = ((current_state == S1_STRT) && (edg_cnt == mid_sample + 2)) ? 1'b1 : 1'b0;
  assign stp_chk_en     = ((current_state == S4_STOP) && (edg_cnt == mid_sample + 2)) ? 1'b1 : 1'b0;
  assign deser_en       = ((current_state == S2_DATA) && (edg_cnt == mid_sample + 2)) ? 1'b1 : 1'b0;
  assign sampler_en     = (edg_cnt == mid_sample || edg_cnt == mid_sample-1 || edg_cnt == mid_sample+1) ? 1'b1 : 1'b0;
  assign data_out_valid = ((current_state == S4_STOP) && (!(par_err || stp_err)) && (edg_cnt == mid_sample - 1)) ? 1'b1 : 1'b0;
  assign data_valid     = ((current_state == S4_STOP) && (!(par_err || stp_err)) && (edg_cnt == mid_sample)) ? 1'b1 : 1'b0;
endmodule