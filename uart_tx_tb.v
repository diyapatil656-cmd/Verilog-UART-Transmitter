// uart_tx_tb.v
// Testbench to verify serial data output shifting

`timescale 1ns / 1ps

module uart_tx_tb;

    reg clk;
    reg rst_n;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx_serial;
    wire tx_active;
    wire tx_done;

    // Instantiate the Unit Under Test (UUT)
    uart_tx uut (
        .clk(clk),
        .rst_n(rst_n),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx_serial(tx_serial),
        .tx_active(tx_active),
        .tx_done(tx_done)
    );

    // Generate system clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        tx_start = 0;
        tx_data = 8'd0;

        // Apply reset
        #15;
        rst_n = 1;
        #10;

        // Test Case 1: Send byte 8'b10101011 (Decimal 171)
        tx_data = 8'b10101011;
        tx_start = 1;
        #10;
        tx_start = 0; // Clear start signal immediately

        // Monitor serial line bits outputting over time
        $monitor("Time=%0dns | Active=%b | Serial Out Pin=%b | Done=%b", 
                 $time, tx_active, tx_serial, tx_done);

        // Wait until transmission is complete
        @(posedge tx_done);
        #30;

        // Test Case 2: Send byte 8'b11000101 (Decimal 197)
        tx_data = 8'b11000101;
        tx_start = 1;
        #10;
        tx_start = 0;

        @(posedge tx_done);
        #40;

        $finish;
    end
      
endmodule
