`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: VVIT College
// Engineer: DULIPUDI LAASHMITH SANJAY
// 
// Create Date: 26.07.2025
// Design Name: Dual Port RAM
// Module Name: tb_phase1_initial_check
// Project Name: Dual Port RAM (Phase 1)
// Target Devices: Xilinx Vivado
// Description:
//   Check that all memory locations are initially 0
//////////////////////////////////////////////////////////////////////////////////

module tb_phase1_initial_check;

    reg clk_a, clk_b;
    reg [7:0] address_a, address_b;
    reg output_enable_a, output_enable_b;
    wire [7:0] data_out_a, data_out_b;

    // DUT instantiation
    dual_port_ram uut (
        .clk_a(clk_a), .clk_b(clk_b),
        .write_enable_a(0), .write_enable_b(0),
        .output_enable_a(output_enable_a), .output_enable_b(output_enable_b),
        .address_a(address_a), .address_b(address_b),
        .data_in_a(8'h00), .data_in_b(8'h00),
        .data_out_a(data_out_a), .data_out_b(data_out_b)
    );

    always #5 clk_a = ~clk_a;
    always #5 clk_b = ~clk_b;

    integer i;

    initial begin
        clk_a = 0; clk_b = 0;
        output_enable_a = 1; output_enable_b = 1;

        $display("\n=========== PHASE 1: INITIAL MEMORY CHECK ===========");
        $display("NOTE: All locations expected to be 0 at start\n");
        $display("Addr | Port A | Port B");

        for (i = 0; i < 10; i = i + 1) begin
            address_a = i;
            address_b = i;
            #10;
            $display(" %0d   |   %0d    |   %0d", i, data_out_a, data_out_b);
        end

        $display("=====================================================\n");
        #10 $finish;
    end

endmodule
