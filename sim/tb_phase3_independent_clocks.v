`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: VVIT College
// Engineer: DULIPUDI LAASHMITH SANJAY
//
// Create Date: 26.07.2025
// Design Name: Dual Port RAM
// Module Name: tb_phase3_independent_clocks
// Project Name: Dual Port RAM (Phase 3)
// Description:
//   - Testing independent clock operation for both ports
//   - Port A (fast clock) writes quickly while Port B (slow clock) reads slower
//////////////////////////////////////////////////////////////////////////////////

module tb_phase3_independent_clocks;

    reg clk_a, clk_b;
    reg [7:0] address_a, address_b, data_in_a;
    reg write_enable_a, output_enable_a;
    reg output_enable_b;
    wire [7:0] data_out_a, data_out_b;

    dual_port_ram uut (
        .clk_a(clk_a), .clk_b(clk_b),
        .write_enable_a(write_enable_a), .write_enable_b(1'b0), // B only reads
        .output_enable_a(output_enable_a), .output_enable_b(output_enable_b),
        .address_a(address_a), .address_b(address_b),
        .data_in_a(data_in_a), .data_in_b(8'h00),
        .data_out_a(data_out_a), .data_out_b(data_out_b)
    );

    // Different clock speeds
    always #5 clk_a = ~clk_a;   // Fast clock (100 MHz)
    always #7 clk_b = ~clk_b;   // Slow clock (~71 MHz)

    integer i;

    initial begin
        clk_a = 0; clk_b = 0;
        $display("\n=========== PHASE 3: INDEPENDENT CLOCKS ===========");
        $display("NOTE: clk_a fast, clk_b slow - proving independent operation\n");

        // --- WRITE Phase ---
        write_enable_a = 1; output_enable_a = 0; output_enable_b = 0;
        for (i = 0; i < 5; i = i + 1) begin
            address_a = 8'd40 + i;
            data_in_a = 8'ha0 + i;
            #10; // each fast clock step
        end

        // --- READ Phase (Port B slow) ---
        write_enable_a = 0; output_enable_a = 0; output_enable_b = 1;
        for (i = 0; i < 5; i = i + 1) begin
            address_b = 8'd40 + i;
            #14; // slow read step
        end

        $display("===================================================\n");
        #10 $finish;
    end

    // --------- EVENT LOGGING (Text Proof) ----------
    always @(posedge clk_a) begin
        if (write_enable_a)
            $display("@%0t ns: [PORT A] WRITE >> Data=%h to Addr=%0d", 
                     $time, data_in_a, address_a);
    end

    always @(posedge clk_b) begin
        if (output_enable_b)
            $display("@%0t ns: [PORT B] READ  << Data=%h from Addr=%0d", 
                     $time, data_out_b, address_b);
    end

endmodule
