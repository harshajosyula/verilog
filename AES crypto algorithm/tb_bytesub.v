module tb_AES;

reg clk;
reg reset;
reg [127:0] plainText;
wire [127:0] alteredText;

// Instantiate AES module
AES dut(
    .clk(clk),
    .reset(reset),
    .plainText(plainText),
    .alteredText(alteredText)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Test
initial begin
    $dumpfile("aes.vcd");
    $dumpvars(0, tb_AES);

    // Reset
    reset = 1;
    plainText = 128'd0;
    #20;
    reset = 0;

    // Test case from FIPS 197 Appendix B (page 28)
    // Input: 32 43 f6 a8 88 5a 30 8d 31 31 98 a2 e0 37 07 34
    plainText = 128'h3243f6a8885a308d313198a2e0370734;

    #20;


    $display("Input:    %h", plainText);
    $display("Output:   %h", alteredText);



    #20;
    $finish;
end

endmodule