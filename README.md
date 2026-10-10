# Verilog-UART-Transmitter
# UART Serial Transmitter Module (Verilog RTL)

## Project Overview
This repository features a fully functional **Universal Asynchronous Receiver-Transmitter (UART) Transmitter** designed in Verilog. The core hardware logic captures an 8-bit parallel data block and serializes it out across a single output bit stream using standard framing rules.

## Protocol Structure
The hardware follows classical UART frame encapsulation configurations:
* **Idle State:** Serial line remains tied high (`1`).
* **Start Bit:** Automatically drops the line low (`0`) for 1 clock cycle to signal data frame onset.
* **Data Payload:** Shifts out the 8-bit parallel byte sequentially starting from the Least Significant Bit (LSB).
* **Stop Bit:** Pulls the serial line high (`1`) to close out transmission.

## File Configurations
* `/uart_tx.v` : Core RTL design file modeling FSM datapath layout.
* `/uart_tx_tb.v` : Behavioral validation verification testbench infrastructure.
