// Future UART on ispMACH 4256ZE Breakout Board 
//
// Top Level module
//
module bb_top(osc_clk, tmr_clk,txbd_clk, nled, nrst);
  output osc_clk;
  output tmr_clk;
  output [7:0]nled;
  output txbd_clk;

  input nrst;

  assign nled[0] = nrst;         // LED D1 on when RESET active
  assign nled[7:1] = 7'b1111111; // turn other LEDs off

  // osc_clk should be 5 MHz
  // tmr_clk should osc_clk / 128 = ~39 kHz
  defparam I1.TIMER_DIV = "128";
  OSCTIMER I1 (.DYNOSCDIS(1'b0), .TIMERRES(1'b0), .OSCOUT(osc_clk), .TIMEROUT(tmr_clk));

  wire rst;
  assign rst = ~nrst;

  reg [9:0]bd_cnt;
  reg bd_cnt_out;

  // generate 9600 Hz (Baud) for UART transmit
  always @(posedge osc_clk)
    if (rst)
    begin
       bd_cnt <= 10'b0000000000; // async reset
       bd_cnt_out <= 0;
    end
    else
    begin
       bd_cnt_out <= ( bd_cnt >= (520/2) );
       if ( bd_cnt < 522 )
          bd_cnt <= bd_cnt + 1; // sync couting
       else
          bd_cnt <= 10'b0000000000;
    end

  assign txbd_clk = bd_cnt_out;

endmodule
