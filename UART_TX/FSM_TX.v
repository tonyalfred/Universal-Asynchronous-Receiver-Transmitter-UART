module FSM_TX 
(
  input  wire       clk,
  input  wire       rst,
  
  input  wire       data_valid, 
  input  wire       parity_en,
  input  wire       ser_done,
 
  output reg        ser_en,
  output reg  [1:0] mux_sel,
  output reg        busy       
);

  localparam [1:0] start_bit_sel = 2'b00,
                   stop_bit_sel  = 2'b01,
                   ser_data_sel  = 2'b10,
                   par_bit_sel   = 2'b11;

  localparam [2:0] S0_IDLE = 3'b000,
                   S1_STRT = 3'b001,
                   S2_DATA = 3'b010,
                   S3_PART = 3'b011,
                   S4_STOP = 3'b100;

  reg [2:0] current_state, next_state;

  always @ (posedge clk or negedge rst)
    begin
      if (!rst)
        current_state <= S0_IDLE;
      else 
        current_state <= next_state;
    end

  always @ (*)
    begin    
      casex (current_state)
        S0_IDLE:
          begin
            ser_en = 0; mux_sel = stop_bit_sel; busy = 0;
            
            next_state = (data_valid) ? S1_STRT : S0_IDLE;
          end
        
        S1_STRT:
          begin
            ser_en = 0; mux_sel = start_bit_sel; busy = 1;
            
            next_state = S2_DATA;
          end
          
        S2_DATA:
          begin
            ser_en = 1; mux_sel = ser_data_sel; busy = 1;
            
            if (ser_done)
              next_state = (parity_en) ? S3_PART : S4_STOP;
            else
              next_state = S2_DATA; 
          end
          
        S3_PART:
          begin
            ser_en = 0; mux_sel = par_bit_sel; busy = 1;
            
            next_state = S4_STOP;
          end
          
        S4_STOP:
          begin
            ser_en = 0; mux_sel = stop_bit_sel; busy = 1;
                    
            next_state = (data_valid) ? S1_STRT : S0_IDLE;
          end
          
        default: 
          begin
            ser_en = 0; mux_sel = stop_bit_sel; busy = 0;

            next_state = S0_IDLE;  
          end        
      endcase
    end
endmodule