`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: VVIT College (Student Project)
// Engineer: DULIPUDI LAASHMITH SANJAY
//
// Create Date: 26.07.2025
// Design Name: Dual Port RAM
// Module Name: tb_phase2_basic_read_write
// Project Name: Dual Port RAM (Phase 2)
// Description:
//   Basic write & read check (no conflicts)
//   - Port A & Port B write different locations
//   - Simple table display for verification
//////////////////////////////////////////////////////////////////////////////////

module tb_phase2_basic_read_write;

    reg clk_a = 0, clk_b = 0;
    reg [7:0] address_a, address_b, data_in_a, data_in_b;
    reg write_enable_a, write_enable_b;
    reg output_enable_a, output_enable_b;
    wire [7:0] data_out_a, data_out_b;

    dual_port_ram uut (
        .clk_a(clk_a), .clk_b(clk_b),
        .write_enable_a(write_enable_a), .write_enable_b(write_enable_b),
        .output_enable_a(output_enable_a), .output_enable_b(output_enable_b),
        .address_a(address_a), .address_b(address_b),
        .data_in_a(data_in_a), .data_in_b(data_in_b),
        .data_out_a(data_out_a), .data_out_b(data_out_b)
    );

    always #5 clk_a = ~clk_a;
    always #5 clk_b = ~clk_b;

    initial begin
        $display("\n=========== PHASE 2: BASIC WRITE & READ ===========");
        $display("NOTE: Port A & B writing separate locations, no conflicts.\n");

        // ---------- WRITE ----------
        write_enable_a = 1; write_enable_b = 1;
        output_enable_a = 0; output_enable_b = 0;

        // Port A writes (decimal values for clarity)
        address_a = 5;  data_in_a = 100; #10; $display("WROTE A[%0d] = %0d", address_a, data_in_a);
        address_a = 6;  data_in_a = 101; #10; $display("WROTE A[%0d] = %0d", address_a, data_in_a);
        address_a = 7;  data_in_a = 102; #10; $display("WROTE A[%0d] = %0d", address_a, data_in_a);

        // Port B writes
        address_b = 10; data_in_b = 200; #10; $display("WROTE B[%0d] = %0d", address_b, data_in_b);
        address_b = 11; data_in_b = 201; #10; $display("WROTE B[%0d] = %0d", address_b, data_in_b);
        address_b = 12; data_in_b = 202; #10; $display("WROTE B[%0d] = %0d", address_b, data_in_b);

        // ---------- READ ----------
        write_enable_a = 0; write_enable_b = 0;
        output_enable_a = 1; output_enable_b = 1;

        $display("\nAddr | Port A | Port B");
        $display("------------------------");

        address_a = 5;  address_b = 10; #10; $display(" %0d   |  %0d    |  %0d", address_a, data_out_a, data_out_b);
        address_a = 6;  address_b = 11; #10; $display(" %0d   |  %0d    |  %0d", address_a, data_out_a, data_out_b);
        address_a = 7;  address_b = 12; #10; $display(" %0d   |  %0d    |  %0d", address_a, data_out_a, data_out_b);

        $display("===================================================\n");
        #10 $finish;
    end

endmodule
