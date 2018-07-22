// Future UART on ispMACH 4256ZE Breakout Board 
//
// Top Level module
//
module bb_top(osc_clk, tmr_clk, nled, nrst);
  output osc_clk;
  output tmr_clk;
  output [7:0]nled;
  input nrst;

  assign nled[0] = nrst;         // LED D1 on when RESET active
  assign nled[7:1] = 7'b1111111; // turn other LEDs off

  // osc_clk should be 5 MHz
  // tmr_clk should osc_clk / 128 = ~39 kHz
  defparam I1.TIMER_DIV = "128";
  OSCTIMER I1 (.DYNOSCDIS(1'b0), .TIMERRES(1'b0), .OSCOUT(osc_clk), .TIMEROUT(tmr_clk));

endmodule
