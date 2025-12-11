`timescale 1ns / 1ps

module cordicTestbench;
    // Inputs
    reg clk;
    reg reset;
    reg signed [20:0] angle;

    // Outputs
    wire [11:0] sine;
    wire [11:0] cosine;

    // Variables required
    real angle_in_decimal;

    // Instantiate module
    cordic uut (
        .clk(clk),
        .reset(reset),
        .angle(angle),
        .x(cosine),
        .y(sine)
    );

    // 100MHz clock (10ns period)
    always #5 clk = ~clk;

    // Function to generate sine and cosine from coordinates
    function real generateValues;
        input [11:0] coordinate;
        real decimalValue;
        begin
            decimalValue = coordinate[10]*2 + coordinate[9]*1 + coordinate[8]*0.5 + coordinate[7]*0.25
                         + coordinate[6]*0.125 + coordinate[5]*0.0625 + coordinate[4]*0.03125 + coordinate[3]*0.015625 + coordinate[2] * ( 2.0 ** -7 )
                         + coordinate[1] * (2 ** -8) + coordinate[0] * (2 ** -9)  ;
            generateValues = (coordinate[11]) ? (-1 * decimalValue) : (1 * decimalValue);
        end
    endfunction

    // Task to test CORDIC algorithm
    task testCORDIC_algo;
        input signed [20:0] test_angle;
        real sin_value, cosin_value;
        begin
            angle = test_angle;
            #20; // Wait for 2 clock cycles for angle to be loaded

            // Wait for CORDIC pipeline to complete (need enough cycles for all iterations)
            #250;

            // Convert fixed-point angle to decimal
            angle_in_decimal =  angle[19] * 128 +angle[18] * 64 + angle[17] * 32 + angle[16] * 16
                             + angle[15] * 8  + angle[14] * 4  + angle[13] * 2
                             + angle[12] * 1   + angle[11] * 0.5  + angle[10] * 0.25
                             + angle[9] * 0.125 + angle[8] * 0.0625 + angle[7] * 0.03125
                             + angle[6] *(2.0 ** -6) + angle[5] * (2.0 ** -7) + angle[4] * (2.0 ** -8)
                             + angle[3] * (2.0 ** -9) + angle[2] * (2.0 ** -10) + angle[1] * (2.0 ** -11)
                             + angle[0] * (2.0 ** -12) ;

            // Apply sign bit if negative
            if (angle[20])
                angle_in_decimal = -angle_in_decimal;

            sin_value = 0.6073 * generateValues(sine);
            cosin_value = 0.6073 * generateValues(cosine);

            $display(" %-10f | %10f | %10f ", angle_in_decimal, sin_value, cosin_value);
        end
    endtask

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, cordicTestbench);

        // Initialize all signals
        clk = 0;
        reset = 1;  // Start with reset asserted
        angle = 0;

        // Hold reset for a few cycles
        #30;
        reset = 0;  // Release reset to start operation

        #20;

        $display("Angle       | sine       | cosine ");
        $display("----------------------------------------");

       testCORDIC_algo(21'b000000000000000000000); // 0 degrees
       testCORDIC_algo(21'b000011110000000000000); // 30 degrees
       testCORDIC_algo(21'b000111100000000000000); // 60 degrees
       testCORDIC_algo(21'b001011010000000000000); // 90 degrees
       testCORDIC_algo(21'b000001111000000000000); // 15 degrees
       testCORDIC_algo(21'b000101101000000000000); // 45 degrees
       testCORDIC_algo(21'b001111000000000000000); // 120 degrees
       testCORDIC_algo(21'b001101001000000000000);
       testCORDIC_algo(21'b010110100000000000000);

        #50;
        $finish;
    end

endmodule