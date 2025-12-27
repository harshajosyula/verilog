/*

    main module of AES algorithm

*/

module AES(

    input clk,
    input reset,
    input wire[127:0] plainText,
    output wire[127:0] alteredText

);

reg [7:0] inputArray[0:15];
reg [127:0] outputText;
wire [7:0] byteshiftArray[0:15];


integer i;
always @(posedge clk)
begin

    if(reset)
        begin
//        inputText <= 128'd0;
        outputText <= 128'd0;
        end
    else
        begin
        for( i=0 ; i<=15 ; i= i+1)
            begin
                inputArray[i] <=  plainText[( 8*i) +: 8];
            end
        end

end

// byteSub layer

    byteSub inst1(
        .text(inputArray[0]),
        .substitutedText(byteshiftArray[0])
    );

    byteSub inst2(
        .text(inputArray[1]),
        .substitutedText(byteshiftArray[1])
    );

    byteSub inst3(
        .text(inputArray[2]),
        .substitutedText(byteshiftArray[2])
    );

    byteSub inst4(
        .text(inputArray[3]),
        .substitutedText(byteshiftArray[3])
    );


    byteSub inst5(
        .text(inputArray[4]),
        .substitutedText(byteshiftArray[4])
    );

    byteSub inst6(
        .text(inputArray[5]),
        .substitutedText(byteshiftArray[5])
    );

    byteSub inst7(
        .text(inputArray[6]),
        .substitutedText(byteshiftArray[6])
    );

    byteSub inst8(
        .text(inputArray[7]),
        .substitutedText(byteshiftArray[7])
    );

    byteSub inst9(
        .text(inputArray[8]),
        .substitutedText(byteshiftArray[8])
    );


    byteSub inst10(
        .text(inputArray[9]),
        .substitutedText(byteshiftArray[9])
    );

    byteSub inst11(
        .text(inputArray[10]),
        .substitutedText(byteshiftArray[10])
    );

    byteSub inst12(
        .text(inputArray[11]),
        .substitutedText(byteshiftArray[11])
    );

    byteSub inst13(
        .text(inputArray[12]),
        .substitutedText(byteshiftArray[12])
    );

    byteSub inst14(
        .text(inputArray[13]),
        .substitutedText(byteshiftArray[13])
    );

    byteSub inst15(
        .text(inputArray[14]),
        .substitutedText(byteshiftArray[14])
    );

     byteSub inst16(
        .text(inputArray[15]),
        .substitutedText(byteshiftArray[15])
    );



integer j;
    always @(posedge clk)
    begin

    for( j=0; j<=15 ; j =j+1)
        begin
        outputText[ (127-8*j) -: 8] <= byteshiftArray[15-j];
        end

    end

assign alteredText = outputText;



// step 2 shift rows layer

/*
        -----------------------
        | b0 |  b4 | b8 | b12 |
        -----------------------
        | b1 |  b5 | b9 | b13 |
        -----------------------
        | b2 |  b6 | b10| b14 |
        -----------------------
        | b3 |  b7 | b11| b15 |
        -----------------------


*/

wire [127:0] shiftedRowArray;

shiftRows ins1(
    .byteShiftedText(outputText),
    .shiftedRows(shiftedRowArray)
);

wire [127:0] mixedText;

MixCols(
    .shiftedText(shiftedRowArray),
    .mixedCols(mixedText)
);



endmodule

