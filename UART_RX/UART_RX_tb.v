module UART_RX_tb;

  reg          CLK        ; 
  reg          RST        ; 

  reg   [4:0]  PRESCALE   ; 
  reg          PAR_EN     ; 
  reg          PAR_TYP    ;

  reg          RX_IN      ;

  wire  [7:0]  P_DATA     ;
  wire         DATA_VALID ;
  
  UART_RX U2 
  (
    .CLK        (CLK)        ,
    .RST        (RST)        ,

    .PRESCALE   (PRESCALE)   ,
    .PAR_EN     (PAR_EN)     ,
    .PAR_TYP    (PAR_TYP)    ,

    .RX_IN      (RX_IN)      ,

    .P_DATA     (P_DATA)     ,
    .DATA_VALID (DATA_VALID)
  );
  
  initial 
    begin
      
    end
  
  always 
    begin
      CLK = 1; #20; CLK = 0; #20;
    end
  
endmodule