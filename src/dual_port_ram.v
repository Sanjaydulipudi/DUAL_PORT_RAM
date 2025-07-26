`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: VVIT (Student Project)
// Engineer: DULIPUDI LAASHMITH SANJAY
// 
// Create Date: 26.07.2025 13:06:24
// Design Name: True Dual Port RAM with Smart Arbitration
// Module Name: dual_port_ram
// Project Name: Dual Port RAM (256 x 8)
// Target Devices: Xilinx Artix-7 / Vivado Simulator
// Tool Versions: Vivado 2025.1
// Description: 
//   - 256 x 8 True Dual Port RAM
//   - Independent Clocks for Port A & Port B
//   - Smart Arbitration: Port A priority, Port B redirected to next free address
//
// Dependencies: None
//
// Revision:
// Revision 0.03 - PARAMETERS Restored, Arbitration Fixed
// Additional Comments:
//   Scalable, beginner-friendly version for academic learning
//
//////////////////////////////////////////////////////////////////////////////////

module dual_port_ram #(
    parameter ADDR_WIDTH = 8,          // 8-bit address → 256 locations
    parameter DATA_WIDTH = 8,          // 8-bit data width
    parameter DEPTH = 1 << ADDR_WIDTH  // 256 by default
)(
    input clk_a, clk_b,                 
    input write_enable_a, write_enable_b,
    input output_enable_a, output_enable_b,
    input [ADDR_WIDTH-1:0] address_a, address_b,
    input [DATA_WIDTH-1:0] data_in_a, data_in_b,
    output reg [DATA_WIDTH-1:0] data_out_a, data_out_b
);

    // ---------- MEMORY DECLARATION ----------
    reg [DATA_WIDTH-1:0] memory [0:DEPTH-1];

    // Track used memory locations (1 = used, 0 = free)
    reg [0:DEPTH-1] used_flag;  

    integer i;             
    integer free_address;  

    // ---------- INITIAL RESET ----------
    initial begin
        for(i = 0; i < DEPTH; i = i + 1) begin
            memory[i] = {DATA_WIDTH{1'b0}};
            used_flag[i] = 1'b0;
        end
    end

    // ---------- PORT A LOGIC ----------
    always @(posedge clk_a) begin
        if(write_enable_a) begin
            memory[address_a] <= data_in_a;
            used_flag[address_a] <= 1;
        end

        if(output_enable_a)
            data_out_a <= memory[address_a];
        else
            data_out_a <= {DATA_WIDTH{1'bZ}};
    end

    // ---------- PORT B LOGIC (Smart Arbitration) ----------
    always @(posedge clk_b) begin
        if(write_enable_b) begin
            if(write_enable_a && (address_a == address_b)) begin
                // Conflict Detected → search for first free location after original
                free_address = -1;
                for(i = address_b + 1; i < DEPTH; i = i + 1) begin
                    if(used_flag[i] == 0 && free_address == -1)
                        free_address = i;
                end
                if(free_address != -1) begin
                    memory[free_address] <= data_in_b;
                    used_flag[free_address] <= 1;
                end
                // else memory full → Port B write skipped
            end 
            else if(used_flag[address_b] == 0) begin
                // No conflict → only write if location free
                memory[address_b] <= data_in_b;
                used_flag[address_b] <= 1;
            end
            // else skip → prevents overwriting pre-filled memory
        end

        if(output_enable_b)
            data_out_b <= memory[address_b];
        else
            data_out_b <= {DATA_WIDTH{1'bZ}};
    end

endmodule
