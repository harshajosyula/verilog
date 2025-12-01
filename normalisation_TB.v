//testbench for normalisation
`timescale 1ns/1ps

module normalisation_tb();

    // Inputs
    reg [47:0] multiplicationResult;

    // DUT outputs
    wire [23:0] normalisedResult;
    wire [2:0]  exponentInc;

    // Expected reference values
    reg [23:0] expected_normalised;
    reg [2:0]  expected_exponentInc;

    integer i;
    integer errors;

    // Instantiate DUT
    normalisation uut (
        .multiplicationResult(multiplicationResult),
        .normalisedResult(normalisedResult),
        .exponentInc(exponentInc)
    );


    // Reference logic procedure
    task compute_expected;
        input [47:0] in;
        reg [23:0] beforeRound;
        reg guardBit, roundBit, stickyBit;
        reg [24:0] afterRound;
        begin

            // Determine which shift case
            if (~in[47])
                beforeRound = in[46:23];
            else
                beforeRound = in[47:24] >> 1;

            guardBit  = (in[47]) ? in[23] : in[22];
            roundBit  = (in[47]) ? in[22] : in[21];
            stickyBit = (in[47]) ? (|in[22:0]) : (|in[20:0]);

            if (guardBit && (roundBit || stickyBit))
                afterRound = beforeRound + 1;
            else
                afterRound = beforeRound;

            // Final normalization
            if (afterRound[24] == 1'b1) begin
                expected_normalised = afterRound[24:1];
                expected_exponentInc = (in[47]) ? 2 : 1;
            end else begin
                expected_normalised = afterRound[23:0];
                expected_exponentInc = (in[47]) ? 1 : 0;
            end
        end
    endtask


    // Test process
    initial begin

        $display("\n===============================================");
        $display(" NORMALISATION UNIT TEST (48-bit → 24-bit) ");
        $display("===============================================");
        $display("Test   Input (Hex)     Expected       Actual    ExpInc | Result");
        $display("----------------------------------------------------------------");

        errors = 0;

        // Run 15 test patterns (mix random + edge cases)
        for (i = 0; i < 15; i = i + 1) begin
            case(i)
                0: multiplicationResult = 48'h8000_00000000;
                1: multiplicationResult = 48'h4000_00000000;
                2: multiplicationResult = 48'h7FFF_FFFFFFFF;
                3: multiplicationResult = 48'h0000_00000001;
                4: multiplicationResult = 48'h00FF_F0000000;
                default: multiplicationResult = $random;
            endcase

            #5 compute_expected(multiplicationResult);

            if ((normalisedResult !== expected_normalised) ||
                (exponentInc !== expected_exponentInc)) begin

                $display("%2d   %h   %h/%0d     %h/%0d     FAIL ❌",
                    i, multiplicationResult,
                    expected_normalised, expected_exponentInc,
                    normalisedResult, exponentInc);

                errors = errors + 1;

            end else begin
                $display("%2d   %h   %h/%0d     %h/%0d     PASS ✅",
                    i, multiplicationResult,
                    expected_normalised, expected_exponentInc,
                    normalisedResult, exponentInc);
            end
        end

        $display("\n================== SUMMARY ==================");

        if (errors == 0)
            $display("✔ All %0d tests PASSED!", i);
        else
            $display("❌ %0d tests FAILED!", errors);

        $display("=============================================\n");

        $finish;
    end

endmodule