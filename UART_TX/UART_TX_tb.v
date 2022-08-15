module UART_TX_tb;

  /* Test-Bench Signals */
  reg                       CLK        ;
  reg                       RST        ;
  
  reg                       PAR_EN     ;
  reg                       PAR_TYP    ;

  reg  [7:0]                P_DATA     ;
  reg                       DATA_VALID ;
  
  wire                      TX_OUT     ;
  wire                      BUSY       ;
  
  /* Design Under Test DUT */
  UART_TX U1 
  (
  .CLK        (CLK)        ,
  .RST        (RST)        ,

  .PAR_EN     (PAR_EN)     ,
  .PAR_TYP    (PAR_TYP)    ,

  .P_DATA     (P_DATA)     ,
  .DATA_VALID (DATA_VALID) ,
  
  .TX_OUT     (TX_OUT)     ,
  .BUSY       (BUSY)
  );
  
  /* Clock Signal */
  localparam CLK_PERIOD = 5;
  always #(0.5*CLK_PERIOD) CLK = ~ CLK;
  
  /* Initial Block */
  initial 
    begin

    end
  
endmodule