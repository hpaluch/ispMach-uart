// UART on ispMACH 4256ZE Breakout Board (bb)
//
// NOT YET TESTED!
//
// TX - transmit data via UART from ispMACH to PC
// Parameters:
// rst    - input - RESET, active on High
// txen   - input - transmit enable - starts transmit (txreg must contain data to send)
// bdclk - input baud clock - for 9600 Bd must be  9600 Hz, etc...
// txd   - output - transmit data - connect to RS232 (using MAX232 etc...) or use USB Serial Cable #954
// txbsy - output - transmitter is busy
module bb_uart_tx(rst, txen, txreg, bdclk, txd, txbsy);
  input rst;
  input txen;
  input [7:0]txreg;
  input bdclk;
  output txd;
  output txbsy;

  reg [1:0]state;
  reg [7:0]txreg2; // shift register for transfer

  parameter s0  = 4'b0000; // state 0 - idle
  parameter s1  = 4'b0001; // state 1 - transmit
  parameter s8  = 4'b1000; // state 8 - transmit
  parameter s9  = 4'b1001; // state 9 - stop bit
  parameter s10 = 4'b1010; // state 10 - go to idle

  // finite state machine FSM
  // sequential logic
  always @(posedge bdclk)
  if (rst)
  begin
    state  <= s0; // async RESET
    txbsy  <= 0;
    txd    <= 1; // idle is 1 in RS232
  end
  else
  begin
    if ( state == s0 && txen )
    begin
      state  <= s1; // transfer start bit
      txreg2 <= txreg;
      txbsy  <= 1;
      txd    <= 1;
    end
    else
    if ( state >= s1 && state <= s8 )
    begin
      state  <= state + 1;
      txd    <= txreg2[0];
      txreg2 <= { 1, txreg[7:1] };
    end
    else 
    if ( state == s9 )
    begin
	txd   <= 1; // transfer stop bit
        state <= s10;
    end;
    else 
    if ( state == s10 )
    begin
        txbsy <= 0; // go to s0 - idle state
	state <= s0;
    end         
  end


endmodule
