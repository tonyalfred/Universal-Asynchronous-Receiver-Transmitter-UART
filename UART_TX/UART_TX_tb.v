module UART_TX_tb;
  // test bench signals
  reg        CLK_tb;
  reg        RST_tb;
  
  reg        PAR_EN_tb;
  reg        PAR_TYP_tb;

  reg  [7:0] P_DATA_tb;
  reg        DATA_VALID_tb;
  
  wire       TX_OUT_tb;
  wire       BUSY_tb;

  // design under test   
  UART_TX UART_TX0 
  (
  .CLK        (CLK_tb),
  .RST        (RST_tb),

  .PAR_EN     (PAR_EN_tb),
  .PAR_TYP    (PAR_TYP_tb),

  .P_DATA     (P_DATA_tb),
  .DATA_VALID (DATA_VALID_tb),
  
  .TX_OUT     (TX_OUT_tb),
  .BUSY       (BUSY_tb)
  );
  
  // clock generation
  localparam CLK_PERIOD = 5;
  initial    CLK_tb     = 1'b1;
  always     #(0.5 * CLK_PERIOD) CLK_tb = ~ CLK_tb;
 
  initial 
    begin
      // reset generation
      RST_tb = 1'b1;
      #(0.4 * CLK_PERIOD)
      RST_tb = 1'b0;
      #(0.4 * CLK_PERIOD)
      RST_tb = 1'b1;
      #(0.2 * CLK_PERIOD)

      // stimulus generation
      // first frame
      P_DATA_tb = 8'b1000_0001; DATA_VALID_tb = 1'b1; PAR_EN_tb = 1'b0; PAR_TYP_tb = 1'b0;

      #(CLK_PERIOD)
      DATA_VALID_tb = 1'b0;

      // discarded frame
      #(3 * CLK_PERIOD)

      P_DATA_tb = 8'b1111_1111; DATA_VALID_tb = 1'b1; PAR_EN_tb = 1'b1; PAR_TYP_tb = 1'b1;

      #(CLK_PERIOD)
      DATA_VALID_tb = 1'b0;

      #(10 * CLK_PERIOD)

      // second frame
      P_DATA_tb = 8'b1000_0001; DATA_VALID_tb = 1'b1; PAR_EN_tb = 1'b0; PAR_TYP_tb = 1'b0;

      #(CLK_PERIOD)
      DATA_VALID_tb = 1'b0;

      #(14 * CLK_PERIOD)

      // third frame
      P_DATA_tb = 8'b1000_0001; DATA_VALID_tb = 1'b1; PAR_EN_tb = 1'b1; PAR_TYP_tb = 1'b0;

      #(CLK_PERIOD)
      DATA_VALID_tb = 1'b0;

      #(14 * CLK_PERIOD)

      // fourth frame
      P_DATA_tb = 8'b1000_0001; DATA_VALID_tb = 1'b1; PAR_EN_tb = 1'b1; PAR_TYP_tb = 1'b1;

      #(CLK_PERIOD)
      DATA_VALID_tb = 1'b0;

      #(14 * CLK_PERIOD)
      $finish;
    end
endmodule