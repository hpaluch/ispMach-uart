// Future UART on ispMACH 4256ZE Breakout Board 
//
// Top Level module
//
module bb_top(nled,nrst);
  output [7:0]nled;
  input nrst;

  assign nled[0] = nrst;         // LED D1 on when RESET active
  assign nled[7:1] = 7'b1111111; // turn other LEDs off

endmodule
