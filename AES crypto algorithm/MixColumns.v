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

    + in Galoei fields -> bitwise xor 

    * -> It follows that multiplication by x (i.e., {0000 0010} or {02}) 
    can be implemented at the byte level as a left shift and 
    a subsequent conditional bitwise XOR with {1b} (modular 2)

*/


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


assign mixedArray[0] = xtime_by2(shiftedArray[0]) ^ xtime_by2(shiftedArray[1]) ^ shiftedArray[1] ^ shiftedArray[2] ^ shiftedArray[3] ;
assign mixedArray[1] = shiftedArray[0] ^ xtime_by2(shiftedArray[1]) ^ xtime_by2(shiftedArray[2]) ^ shiftedArray[2] ^ shiftedArray[3] ;
assign mixedArray[2] = shiftedArray [0] ^ shiftedArray[1] ^ xtime_by2(shiftedArray[2]) ^ xtime_by2(shiftedArray[3]) ^ shiftedArray[3] ;
assign mixedArray[3] = xtime_by2(shiftedArray[0]) ^ shiftedArray[0] ^ shiftedArray[1] ^ shiftedArray[2] ^ xtime_by2(shiftedArray[3]);



assign mixedArray[4] = xtime_by2(shiftedArray[4]) ^ xtime_by2(shiftedArray[5]) ^ shiftedArray[5] ^ shiftedArray[6] ^ shiftedArray[7] ;
assign mixedArray[5] = shiftedArray[4] ^ xtime_by2(shiftedArray[5]) ^ xtime_by2(shiftedArray[6]) ^ shiftedArray[6] ^ shiftedArray[7] ;
assign mixedArray[6] = shiftedArray [4] ^ shiftedArray[5] ^ xtime_by2(shiftedArray[6]) ^ xtime_by2(shiftedArray[7]) ^ shiftedArray[7] ;
assign mixedArray[7] = xtime_by2(shiftedArray[4]) ^ shiftedArray[4] ^ shiftedArray[5] ^ shiftedArray[6] ^ xtime_by2(shiftedArray[7]);



assign mixedArray[8] = xtime_by2(shiftedArray[8]) ^ xtime_by2(shiftedArray[9]) ^ shiftedArray[9] ^ shiftedArray[10] ^ shiftedArray[11] ;
assign mixedArray[9] = shiftedArray[8] ^ xtime_by2(shiftedArray[9]) ^ xtime_by2(shiftedArray[10]) ^ shiftedArray[10] ^ shiftedArray[11] ;
assign mixedArray[10] = shiftedArray [8] ^ shiftedArray[9] ^ xtime_by2(shiftedArray[10]) ^ xtime_by2(shiftedArray[11]) ^ shiftedArray[11] ;
assign mixedArray[11] = xtime_by2(shiftedArray[8]) ^ shiftedArray[8] ^ shiftedArray[9] ^ shiftedArray[10] ^ xtime_by2(shiftedArray[11]);



assign mixedArray[12] = xtime_by2(shiftedArray[12]) ^ xtime_by2(shiftedArray[13]) ^ shiftedArray[13] ^ shiftedArray[14] ^ shiftedArray[15] ;
assign mixedArray[13] = shiftedArray[12] ^ xtime_by2(shiftedArray[13]) ^ xtime_by2(shiftedArray[14]) ^ shiftedArray[14] ^ shiftedArray[15] ;
assign mixedArray[14] = shiftedArray [12] ^ shiftedArray[13] ^ xtime_by2(shiftedArray[14]) ^ xtime_by2(shiftedArray[15]) ^ shiftedArray[15] ;
assign mixedArray[15] = xtime_by2(shiftedArray[12]) ^ shiftedArray[12] ^ shiftedArray[13] ^ shiftedArray[14] ^ xtime_by2(shiftedArray[15]);


genvar k;

generate for( k =0; k<16 ; k=k+1 )
        begin
        assign mixedCols[(127 - 8*k) -: 8] = mixedArray [k ]; 
        end
endgenerate

endmodule