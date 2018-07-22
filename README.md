# Lattice ispMach Breakout Board as UART

Example how to create UART in Verilog using:
* [ispMACH 4256ZE Breakout Board][]
* [USB Console Cable #954][] to transfer serial data from ispMach CPLD to PC

> WARNING! Work in progress - current status:
>
> 1. reached M1: TX (transmit to PC) is working - sending `!` each 0.5 seconds!

![ispMach as UART Schematics](https://github.com/hpaluch/ispMach-uart/blob/master/schematic/latt_uart.png?raw=true)

NOTE: Serial port parameters (you can use Putty Serial connection) are following:

* Baud rate: 9600
* Start bit: `1`
* Data bits: `8`
* Stop bit: `1`
* Parity: `none`
* Flow control: `none` 

Please see my [PIC UART demo project][] for more information
on serial cable and especially driver tips.

# Clock base verification

We need accurate clock for UART - the signal `txbd_clk` is critical.
Here is table of expected and measured frequencies:


ispMach PIN|Verilog HDL name|Expected frequency|Measured frequency|Error
-----------|----------------|------------------|------------------|----- 
4|osc_clk|5 MHz|5.001 MHz|0.02%
5|osc_tmr|5 MHz/1048576=4.76Hz|- kHz|-%
6|**txbd_clk**|5Mhz / 521=9596Hz (9600 Hz needed)|~9610 Hz|0.1%

> NOTE: Part of Frequency error is likely error of used DMM - Metex MS1280


[ispMACH 4256ZE Breakout Board]: http://www.latticesemi.com/Products/DevelopmentBoardsAndKits/ispMACH4256ZEBreakoutBoard.aspx
   "ispMACH 4256ZE Breakout Board"
[USB Console Cable #954]: https://www.modmypi.com/raspberry-pi/communication-1068/serial-1075/usb-to-ttl-serial-cable-debug--console-cable-for-raspberry-pi "USB Console Cable #954"
[PIC UART demo project]: https://bitbucket.org/hpaluch/pic16f88-demo.x

 