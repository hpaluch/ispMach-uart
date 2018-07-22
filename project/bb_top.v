// Future UART on ispMACH 4256ZE Breakout Board 
//
// Top Level module
//
module bb_top(osc_clk, tmr_clk,txbd_clk, nled, nrst, txd);
  output osc_clk;
  output tmr_clk;
  output [7:0]nled;
  output txbd_clk;
  output txd;

  input nrst;

  assign nled[0] = nrst;         // LED D1 on when RESET active
  assign nled[7:3] = 5'b11111; // turn other LEDs off

  // osc_clk should be 5 MHz
  // tmr_clk should osc_clk / 1048576 = ~4.768 Hz
  defparam I1.TIMER_DIV = "1048576";
  OSCTIMER I1 (.DYNOSCDIS(1'b0), .TIMERRES(1'b0), .OSCOUT(osc_clk), .TIMEROUT(tmr_clk));

  wire rst;
  assign rst = ~nrst;

  //assign txbd_clk = bd_cnt_out;

  bb_uart_clockbase cb1( .rst(rst), .clk(osc_clk), .bdout(txbd_clk) );

  reg [11:0]counter;

  wire   wtxbusy;
  assign nled[1] = ~wtxbusy;

  reg rtxen;

  assign nled[2] = ~txd;

  bb_uart_tx tx1( .rst(rst), .txen(rtxen), .txreg(8'h21), .bdclk(txbd_clk), .txd(txd), .txbsy(wtxbusy));

  always @(posedge txbd_clk)
  if (rst)
  begin
    counter <= 0;
    rtxen <= 0;
  end
  else
  begin
    rtxen <= (counter == 4095);
    counter <= counter + 1;
  end

endmodule

// generated 9600 Hz (Baud) clock - as accurately as possible - from 5 MHz
module bb_uart_clockbase(rst,clk,bdout);
	input rst;
	input clk;
	output bdout;

	// warning - must adjust also reg size, etc...
	parameter CLK_DIVIDER = 522;
	parameter HALF_DIVIDER = CLK_DIVIDER/2;

	reg [9:0]bd_cnt;
	reg bd_cnt_out;

	assign bdout = bd_cnt_out;

always @(posedge clk)
    if ( rst )
    begin
       bd_cnt     <= 10'b0000000000; // async reset
       bd_cnt_out <= 0;
    end
    else
    begin
       if ( bd_cnt == HALF_DIVIDER )
	   bd_cnt_out <= 1; // try to make output clock symetrical...
       if ( bd_cnt < CLK_DIVIDER )
          bd_cnt <= bd_cnt + 1; // sync couting
       else
       begin
          bd_cnt <= 10'b0000000000;
	  bd_cnt_out <= 0;
       end
    end

endmodule
