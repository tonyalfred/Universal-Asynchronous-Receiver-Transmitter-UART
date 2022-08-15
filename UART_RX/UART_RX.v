module UART_RX
(
  input  wire         CLK        , 
  input  wire         RST        , 
  
  input  wire  [4:0]  PRESCALE   ,
  
  input  wire         PAR_EN     , 
  input  wire         PAR_TYP    ,

  input  wire         RX_IN      ,
  
  output wire  [7:0]  P_DATA     ,
  output wire         DATA_VALID 
);

 /* Internal Signals */  
  wire  edg_cnt_en ;
  
  wire  edg_cnt     ;
  wire  bit_cnt     ; 
  
  wire  sampler_en  ;
    
  wire  str_chk_en  ;
  wire  par_chk_en  ;
  wire  stp_chk_en  ;
  
  wire  str_err     ;
  wire  par_err     ;
  wire  stp_err     ;
     
  wire  deser_en    ;

  wire  data_valid  ;
  
  wire  sampled_bit ;

 /* Modules Instantiations */

  FSM_RX FSM_RX0
(
  .clk        (CLK)        ,
  .rst        (RST)        ,

  .par_en     (PAR_EN )    ,
  .rx_in      (RX_IN)      ,
  
  .edg_cnt    (edg_cnt)    ,
  .bit_cnt    (bit_cnt)    ,   
  
  .str_err    (str_err)    ,
  .par_err    (par_err)    ,
  .stp_err    (stp_err)    ,
  
  .str_chk_en (str_chk_en) ,
  .par_chk_en (par_chk_en) ,
  .stp_chk_en (stp_chk_en) ,
     
  .edg_cnt_en (edg_cnt_en) ,
  .sampler_en (sampler_en) ,
  .deser_en   (deser_en)   ,

  .data_valid (DATA_VALID)
);

  edge_bit_counter EDGE_CNTR0
(
  .clk        (CLK)        ,
  .rst        (RST)        , 
  
  .en         (edg_cnt_en) , 
  .presecalar (PRESCALE)   , 
  
  .edge_cnt   (edg_cnt)    ,
  .bit_cnt    (bit_cnt)
);
 
  data_sampler SAMPLER0
(
  .clk (CLK)         ,   
  .rst (RST)         ,
  
  .en  (sampler_en)  ,
  .in  (RX_IN)       ,    

  .out (sampled_bit)
);

  start_check STR_CHK0
(
  .clk    (CLK)         ,
  .rst    (RST)         ,
  
  .en     (str_chk_en)  ,
  .in     (sampled_bit) ,
  
  .error  (str_err)
);
 
  parity_check PRT_CHK0
(
  .clk    (CLK)         ,
  .rst    (RST)         ,
  
  .typ    (PAR_TYP)     ,
  
  .en     (par_chk_en)  ,
  .sample (sampled_bit) , 
  .in     (P_DATA)      ,
  
  .error  (par_err) 
);
 
  stop_check STP_CHK0
(
  .clk   (CLK)         ,
  .rst   (RST)         ,
  
  .en    (stp_chk_en)  ,
  .in    (sampled_bit) ,
  
  .error (stp_err)
);
 
endmodule