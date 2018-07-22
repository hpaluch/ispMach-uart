// UART on ispMACH 4256ZE Breakout Board (bb)
//
// Disclaimer: Seems to work (at least for me). But no warranty!
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

  reg rtxbsy;
  assign txbsy = rtxbsy;

  reg rtxd;
  assign txd = rtxd;

  reg [3:0]rstate;
  reg [7:0]rtxreg; // shift register for transfer

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
    rstate  <= s0; // async RESET
    rtxbsy  <= 0;
    rtxd    <= 1; // idle is 1 in RS232
  end
  else
  begin
    if ( rstate == s0 && txen )
    begin
      rstate  <= s1; // transfer start bit
      rtxreg <= txreg;
      rtxbsy  <= 1;
      rtxd    <= 0;
    end
    else
    if ( rstate >= s1 && rstate <= s8 )
    begin
      rstate  <= rstate + 1;
      rtxd    <= rtxreg[0];
      rtxreg  <= { 1'b1, rtxreg[7:1] };
    end
    else 
    if ( rstate == s9 )
    begin
	rtxd   <= 1; // transfer stop bit
        rstate <= s10;
    end
    else 
    if ( rstate == s10 )
    begin
        rtxbsy <= 0; // go to s0 - idle state
	rstate <= s0;
    end         
  end


endmodule
