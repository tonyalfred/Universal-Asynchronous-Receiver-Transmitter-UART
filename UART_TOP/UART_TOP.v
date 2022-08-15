module UART_TOP #
(
  parameter DATA_WIDTH = 8
)
(
  input  wire                       CLK        ,
  input  wire                       RST        ,
  
  input  wire                       PAR_EN     ,
  input  wire                       PAR_TYP    ,

  input  wire  [DATA_WIDTH-1:0]     P_DATA     ,
  input  wire                       DATA_VALID ,

  output wire                       TX_OUT     ,
  output wire                       BUSY       
);

localparam START_BIT = 0;
localparam STOP_BIT  = 1;

/* Internal Signals */
wire       ser_done ;
wire       ser_en   ; 
wire       ser_data ;
wire [1:0] mux_sel  ;
wire       par_bit  ;
wire       busy     ;

/* Modules Instantiation */
  FSM_TX FSM_TX0
(
  .clk        (CLK)        ,
  .rst        (RST)        ,
  
  .data_valid (DATA_VALID) , 
  .parity_en  (PAR_EN)     ,
  .ser_done   (ser_done)   ,
 
  .ser_en     (ser_en)     ,
  .mux_sel    (mux_sel)    ,
  .busy       (BUSY)
);

  serializer SERIALIZER0
(
  .clk      (CLK)      ,
  .rst      (RST)      ,
  
  .data_in  (P_DATA)   ,
  .ser_en   (ser_en)   ,
  
  .ser_done (ser_done) ,
  .ser_data (ser_data)
);

  parity_calc PARITY_CALC0
(
  .clk           (CLK)        ,
  .rst           (RST)        ,
  
  .data_in       (P_DATA)     ,
  .data_valid    (DATA_VALID) ,
  
  .parity_type   (PAR_TYP)    ,
  
  .parity_bit    (par_bit)
);

  multiplexer_4x1 MUX0
(
  .in_0 (START_BIT) ,
  .in_1 (STOP_BIT)  ,
  .in_2 (ser_data)  ,
  .in_3 (par_bit)   ,
  .sel  (mux_sel)   ,
  
  .out  (TX_OUT)
);

endmodule