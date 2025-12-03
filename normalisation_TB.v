`timescale 1ns / 1ps

module tb_multiplier;

    // Inputs
    reg [31:0] x;
    reg [31:0] y;

    // Outputs
    wire [31:0] k;

    // Test variables
    real real_x, real_y, real_result, real_expected;
    integer passed, failed, total;
    integer test_num;

    // Instantiate the multiplier
    multiplier uut (
        .x(x),
        .y(y),
        .k(k)
    );

    // Function to convert 32-bit IEEE 754 to real
    function real fp32_to_real;
        input [31:0] fp;
        real mantissa;
        integer exponent;
        integer sign;
        begin
            sign = fp[31];
            exponent = fp[30:23] - 127;
            mantissa = 1.0 + ($itor(fp[22:0]) / $itor(2**23));
            fp32_to_real = (sign ? -1.0 : 1.0) * mantissa * (2.0 ** exponent);
        end
    endfunction

    // Task to test multiplication
    task test_mult;
        input [31:0] a, b;
        real expected, result, rel_error, abs_error;
        reg pass;
        begin
            x = a;
            y = b;
            #10;

            real_x = fp32_to_real(x);
            real_y = fp32_to_real(y);
            expected = real_x * real_y;
            result = fp32_to_real(k);

            abs_error = $abs(result - expected);
            if (expected != 0.0)
                rel_error = abs_error / $abs(expected) * 100.0;
            else
                rel_error = abs_error;

            // Pass criteria: relative error < 0.01% OR absolute error < 1e-6
            pass = (rel_error < 0.01 || abs_error < 1e-6);

            if (pass)
                passed = passed + 1;
            else
                failed = failed + 1;

            $display("%-4d | %8h | %8h | %8f | %8f | %s",
                     test_num, x, y, expected, result, pass ? "PASS" : "FAIL");

            test_num = test_num + 1;
            total = total + 1;
        end
    endtask

    initial begin

        $dumpfile("wave.vcd");
        $dumpvars(0, tb_multiplier);

        passed = 0;
        failed = 0;
        total = 0;
        test_num = 0;

        $display("========================================");
        $display("Floating-Point Multiplier Testbench");
        $display("========================================");
        $display("Test | A        | B        | Expected | Actual   | Status");
        $display("-------------------------------------------------------");

        // Test 1: Simple positive numbers
test_mult(32'h3F800000, 32'h3F800000); // 1.0 * 1.0 = 1.0
        test_mult(32'h40000000, 32'h40000000); // 2.0 * 2.0 = 4.0
        test_mult(32'h40000000, 32'h40400000); // 2.0 * 3.0 = 6.0
        test_mult(32'h40400000, 32'h40400000); // 3.0 * 3.0 = 9.0
        test_mult(32'h40800000, 32'h40000000); // 4.0 * 2.0 = 8.0
        test_mult(32'h40A00000, 32'h40C00000); // 5.0 * 6.0 = 30.0
        test_mult(32'h41200000, 32'h41200000); // 10.0 * 10.0 = 100.0

        // Test 2: Negative numbers
        test_mult(32'hC0000000, 32'h40400000); // -2.0 * 3.0 = -6.0
        test_mult(32'hC0000000, 32'hC0400000); // -2.0 * -3.0 = 6.0
        test_mult(32'h3F800000, 32'hBF800000); // 1.0 * -1.0 = -1.0
        test_mult(32'hC0A00000, 32'hC0C00000); // -5.0 * -6.0 = 30.0

        // Test 3: Fractional numbers
        test_mult(32'h3F000000, 32'h3F000000); // 0.5 * 0.5 = 0.25
        test_mult(32'h3E800000, 32'h3F000000); // 0.25 * 0.5 = 0.125
        test_mult(32'h3E800000, 32'h3E800000); // 0.25 * 0.25 = 0.0625
        test_mult(32'h3F000000, 32'h40000000); // 0.5 * 2.0 = 1.0

        // Test 4: Powers of 2 (should be exact)
        test_mult(32'h41000000, 32'h40800000); // 8.0 * 4.0 = 32.0
        test_mult(32'h41800000, 32'h41000000); // 16.0 * 8.0 = 128.0
        test_mult(32'h3E800000, 32'h3E800000); // 0.25 * 0.25 = 0.0625
        test_mult(32'h3E000000, 32'h3F000000); // 0.125 * 0.5 = 0.0625

        // Test 5: Large numbers
        test_mult(32'h42C80000, 32'h42480000); // 100.0 * 50.0 = 5000.0
        test_mult(32'h461C4000, 32'h42C80000); // 10000.0 * 100.0 = 1000000.0
        test_mult(32'h4B189680, 32'h3F800000); // 10000000.0 * 1.0 = 10000000.0

        // Test 6: Small numbers
        test_mult(32'h3C23D70A, 32'h3C23D70A); // 0.01 * 0.01 = 0.0001
        test_mult(32'h3A83126F, 32'h3C23D70A); // 0.001 * 0.01 = 0.00001

        // Test 7: Mixed magnitude
        test_mult(32'h42C80000, 32'h3F800000); // 100.0 * 1.0 = 100.0
        test_mult(32'h447A0000, 32'h3F000000); // 1000.0 * 0.5 = 500.0
        test_mult(32'h41200000, 32'h3F000000); // 10.0 * 0.5 = 5.0

        // Test 8: More combinations
        test_mult(32'h40E00000, 32'h40A00000); // 7.0 * 5.0 = 35.0
        test_mult(32'h41100000, 32'h40E00000); // 9.0 * 7.0 = 63.0
        test_mult(32'h3FC00000, 32'h40200000); // 1.5 * 2.5 = 3.75
        test_mult(32'h40100000, 32'h40300000); // 2.25 * 2.75 = 6.1875

        // Test 5: Large numbers
        test_mult(32'h42C80000, 32'h42480000); // 100.0 * 50.0 = 5000.0


        // Summary
        $display("-------------------------------------------------------");
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Total Tests: %0d", total);
        $display("Passed:      %0d", passed);
        $display("Failed:      %0d", failed);
        $display("Pass Rate:   %.2f%%", (passed * 100.0) / total);
        $display("========================================\n");

        if (failed == 0)
            $display("All tests PASSED!");
        else
            $display("%0d test(s) FAILED", failed);

        $finish;
    end

endmodule