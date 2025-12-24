`timescale 1ns / 1ps

module tb_bytesub;

    reg [7:0] text;
    wire [7:0] result;


    byteSub uut (
        .plaintext(text),
        .substitutedText(result)
    );

task test_byteSub;
 input [7:0] val;
        real resultvalue;
        
    begin
        text = val;
         #10;
        resultvalue = result;
        $display("%h",result);
    end
    endtask

    initial begin
     $dumpfile("wave.vcd");
     $dumpvars(0, tb_bytesub);

    test_byteSub(8'b00110101);
    test_byteSub(8'b00000000);

    end

endmodule