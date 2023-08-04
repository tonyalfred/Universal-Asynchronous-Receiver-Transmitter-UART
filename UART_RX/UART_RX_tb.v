module UART_RX_tb;
  // testbench signals
  reg        CLK_tb; 
  reg        RST_tb; 

  reg  [4:0] PRESCALE_tb; 
  reg        PAR_EN_tb; 
  reg        PAR_TYP_tb;

  reg        RX_IN_tb;

  wire [7:0] P_DATA_tb;
  wire       DATA_VALID_tb;

  integer PRESCALE_VALUE;
  
  // design under test
  UART_RX UART_RX0 
  (
    .CLK        (CLK_tb),
    .RST        (RST_tb),

    .PRESCALE   (PRESCALE_tb),
    .PAR_EN     (PAR_EN_tb),
    .PAR_TYP    (PAR_TYP_tb),

    .RX_IN      (RX_IN_tb),

    .P_DATA     (P_DATA_tb),
    .DATA_VALID (DATA_VALID_tb)
  );
  
  // clock generation
  localparam CLK_PERIOD = 5;
  initial    CLK_tb     = 1'b1;
  always     #(0.5 * CLK_PERIOD) CLK_tb = ~ CLK_tb;
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////// Tests ////////////////////////////////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  initial 
    begin
      RX_IN_tb = 1'b1; RST_tb = 1'b1; PAR_EN_tb = 1'b0; PAR_TYP_tb = 1'b0;
      @(negedge CLK_tb) RST_tb = 1'b0;
      @(negedge CLK_tb) RST_tb = 1'b1;
      repeat (2) @(posedge CLK_tb);

      PRESCALE_tb = 5'd16; PAR_EN_tb = 1'b1; PAR_TYP_tb = 1'b1; RX_IN_tb = 1'b1;

      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b1;
      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b0;

      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b0;
      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b1;

      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b0;
      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b1;

      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b0;
      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b1;

      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b0;
      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b1;

      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b1;
      repeat (8) @(posedge CLK_tb); RX_IN_tb = 1'b1;
      #(64 * CLK_PERIOD) $finish;
    end
endmodule