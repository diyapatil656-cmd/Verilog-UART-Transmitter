// uart_tx.v
// A simple UART Transmitter module that converts parallel data to serial.

module uart_tx (
    input        clk,        // System Clock
    input        rst_n,      // Active-low asynchronous reset
    input        tx_start,   // Signal to kick off transmission
    input  [7:0] tx_data,    // 8-bit parallel byte to send
    output reg   tx_serial,  // Serial data out line
    output reg   tx_active,  // High when transmission is running
    output reg   tx_done     // High for 1 cycle when transmission finishes
);

    // State definitions using localparam
    localparam S_IDLE   = 2'b00,
               S_START  = 2'b01,
               S_DATA   = 2'b10,
               S_STOP   = 2'b11;

    reg [1:0] current_state, next_state;
    reg [2:0] bit_index;    // Keeps track of which bit (0 to 7) we are sending
    reg [7:0] data_buffer;  // Holds data so changes during transmission don't break it

    // State Transition Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S_IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next State and Output Control Logic
    always @(*) begin
        next_state = current_state;
        
        case (current_state)
            S_IDLE: begin
                if (tx_start)
                    next_state = S_START;
            end
            S_START: begin
                next_state = S_DATA;
            end
            S_DATA: begin
                if (bit_index == 3'd7)
                    next_state = S_STOP;
            end
            S_STOP: begin
                next_state = S_IDLE;
            end
            default: next_state = S_IDLE;
        endcase
    end

    // Datapath logic for shifting data out sequentially
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tx_serial   <= 1'b1; // UART idle state is pulled High
            tx_active   <= 1'b0;
            tx_done     <= 1'b0;
            bit_index   <= 3'd0;
            data_buffer <= 8'd0;
        end else begin
            case (current_state)
                S_IDLE: begin
                    tx_serial <= 1'b1;
                    tx_active <= 1'b0;
                    tx_done   <= 1'b0;
                    bit_index <= 3'd0;
                    if (tx_start) data_buffer <= tx_data;
                end
                S_START: begin
                    tx_active <= 1'b1;
                    tx_serial <= 1'b0; // Start bit is always Low
                end
                S_DATA: begin
                    tx_serial <= data_buffer[bit_index];
                    if (bit_index == 3'd7) begin
                        bit_index <= 3'd0;
                    end else begin
                        bit_index <= bit_index + 1'b1;
                    end
                end
                S_STOP: begin
                    tx_serial <= 1'b1; // Stop bit is always High
                    tx_active <= 1'b0;
                    tx_done   <= 1'b1;
                end
            end
        end
    end

endmodule
