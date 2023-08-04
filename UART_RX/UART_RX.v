module UART_RX
(
  input  wire       CLK, 
  input  wire       RST, 
  
  input  wire [4:0] PRESCALE,
  
  input  wire       PAR_EN, 
  input  wire       PAR_TYP,

  input  wire       RX_IN,
  
  output wire [7:0] P_DATA,
  output wire       DATA_VALID 
);

  // Internal Signals
  wire edg_cnt_en;
  
  wire [4:0] edg_cnt;
  wire [3:0] bit_cnt; 
  
  wire sampler_en;
    
  wire str_chk_en;
  wire par_chk_en;
  wire stp_chk_en;
  
  wire str_err;
  wire par_err;
  wire stp_err;
     
  wire deser_en;
  
  wire sampled_bit;
  wire [7:0] P_DATA_internal;

  wire data_out_valid;

  // Modules Instantiations
  FSM_RX FSM_RX0
  (
    .clk        (CLK),
    .rst        (RST),

    .par_en     (PAR_EN),
    .prescale   (PRESCALE),

    .rx_in      (RX_IN),
    
    .edg_cnt    (edg_cnt),
    .bit_cnt    (bit_cnt),   
    
    .str_err    (str_err),
    .par_err    (par_err),
    .stp_err    (stp_err),
    
    .str_chk_en (str_chk_en),
    .par_chk_en (par_chk_en),
    .stp_chk_en (stp_chk_en),
      
    .edg_cnt_en (edg_cnt_en),
    .sampler_en (sampler_en),
    .deser_en   (deser_en),

    .data_valid (DATA_VALID), 
    .data_out_valid (data_out_valid)
  );

  edge_bit_counter EDGE_CNTR0
  (
    .clk      (CLK),
    .rst      (RST), 
    
    .en       (edg_cnt_en), 
    .prescale (PRESCALE), 
    
    .edge_cnt (edg_cnt),
    .bit_cnt  (bit_cnt)
  );
 
  data_sampler SAMPLER0
  (
    .clk (CLK),   
    .rst (RST),
    
    .en  (sampler_en),
    .in  (RX_IN),    

    .out (sampled_bit)
  );

  start_check STR_CHK0
  (
    .clk (CLK),
    .rst (RST),
    
    .en  (str_chk_en),
    .in  (sampled_bit),
    
    .err (str_err)
  );
 
  parity_check PRT_CHK0
  (
    .clk    (CLK),
    .rst    (RST),

    .en     (par_chk_en),
    .typ    (PAR_TYP),
    
    .sample (sampled_bit), 
    .in     (P_DATA_internal),
    
    .err    (par_err) 
  );
 
  stop_check STP_CHK0
  (
    .clk (CLK),
    .rst (RST),
    
    .en  (stp_chk_en),
    .in  (sampled_bit),
    
    .err (stp_err)
  );

  deserializer DESR0
  (
    .clk      (CLK),
    .rst      (RST),

    .en_shift (sampled_bit),
    .en_out   (data_out_valid),
    
    .out      (P_DATA_internal), 
    .out_reg  (P_DATA)
  );
endmodule