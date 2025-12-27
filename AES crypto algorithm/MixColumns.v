/*

    Mix columns

*/

module MixCols(
    input wire[127:0] shiftedText,
    output wire[127:0] mixedCols
);

wire[7:0] shiftedArray[0:15];

wire[7:0] mixedArray[0:15];

genvar j;

generate for( j =0; j<16 ; j=j+1 )
        begin
        assign shiftedArray[j] = shiftedText [(127-8*j) -:8 ]; 
        end
endgenerate

/*
    b0_new = ( {02} * b0 + {03} * b1 + {01} * b2 + {01} * b3 )
    b1_new = ( {01} * b0 + {02} * b1+  {03} * b2 + {01} * b3 )

    + in Galoie fields -> bitwise xor 

    * -> It follows that multiplication by x (i.e., {0000 0010} or {02}) 
    can be implemented at the byte level as a left shift and 
    a subsequent conditional bitwise XOR with {1b} (modular 2)

*/

// functions  for multiplication

function [7:0] xtime_by2;
    input [7:0] byte;

    begin
        xtime_by2  = byte[7] == 1'd0 ? (byte << 1) : ( byte << 1  ^ 8'h1b);
    end
endfunction

function [7:0] xtime_by1;
    input [7:0] byte;
    begin
        xtime_by1 = byte;
    end
endfunction


endmodule