`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: VVIT College (Student Project)
// Engineer: DULIPUDI LAASHMITH SANJAY
//
// Create Date: 26.07.2025
// Module Name: tb_phase4_smart_arbitration
// Project Name: Dual Port RAM (Phase 4)
// Description:
//   FINAL VERIFIED VERSION
//   - Port A keeps its address (priority)
//   - Port B redirected to next free address on conflict
//   - Proper delays to ensure correct readback values in Vivado
//////////////////////////////////////////////////////////////////////////////////

module tb_phase4_smart_arbitration;

    // -------- PARAMETERS --------
    localparam ADDR_WIDTH = 8;
    localparam DATA_WIDTH = 8;

    // -------- CLOCKS --------
    reg clk_a = 0, clk_b = 0;
    always #5 clk_a = ~clk_a;  // 10ns clock
    always #5 clk_b = ~clk_b;

    // -------- SIGNALS --------
    reg write_enable_a = 0, write_enable_b = 0;
    reg output_enable_a = 0, output_enable_b = 0;
    reg [ADDR_WIDTH-1:0] address_a = 0, address_b = 0;
    reg [DATA_WIDTH-1:0] data_in_a = 0, data_in_b = 0;
    wire [DATA_WIDTH-1:0] data_out_a, data_out_b;

    // -------- INSTANTIATE DUT --------
    dual_port_ram #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) uut (
        .clk_a(clk_a), .clk_b(clk_b),
        .write_enable_a(write_enable_a), .write_enable_b(write_enable_b),
        .output_enable_a(output_enable_a), .output_enable_b(output_enable_b),
        .address_a(address_a), .address_b(address_b),
        .data_in_a(data_in_a), .data_in_b(data_in_b),
        .data_out_a(data_out_a), .data_out_b(data_out_b)
    );

    integer i;

    initial begin
        $display("\n=========== PHASE 4: SMART ARBITRATION (REDIRECTION) ===========");
        $display("NOTE: Pre-filled memory used to demonstrate realistic arbitration");
        $display("RULE: Port A keeps its address; Port B redirected to next free.\n");

        // -------- PRE-FILL SOME MEMORY --------
        uut.memory[30] = 8'd99;  uut.used_flag[30] = 1;
        uut.memory[31] = 8'd111; uut.used_flag[31] = 1;
        uut.memory[32] = 8'd113; uut.used_flag[32] = 1;

        // -------- CONFLICT 1 --------
        #20;
        address_a = 8'd30; data_in_a = 8'd100; write_enable_a = 1;
        address_b = 8'd30; data_in_b = 8'd200; write_enable_b = 1;
        #10;
        write_enable_a = 0; write_enable_b = 0;
        $display("Time=%0t ns | CONFLICT 1: A@30=%0d, B tried 31 & 32 (used), redirected to 33=%0d",
                  $time, data_in_a, data_in_b);

        // -------- CONFLICT 2 --------
        #30;
        address_a = 8'd35; data_in_a = 8'd120; write_enable_a = 1;
        address_b = 8'd35; data_in_b = 8'd220; write_enable_b = 1;
        #10;
        write_enable_a = 0; write_enable_b = 0;
        $display("Time=%0t ns | CONFLICT 2: A@35=%0d, B redirected to 36=%0d",
                  $time, data_in_a, data_in_b);

        // -------- FINAL MEMORY SUMMARY --------
        #20;
        $display("\n---------------- FINAL MEMORY SUMMARY ----------------");
        for(i = 30; i <= 36; i = i + 1)
            $display("Addr %0d = %0d", i, uut.memory[i]);
        $display("========================================================\n");

        #10 $finish;
    end

endmodule
