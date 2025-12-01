module multiplier(

input [31:0] x,
input [31:0] y,

output[31:0] k

);


wire sign = x[31] ^ y[31];

wire [23:0] mantissa;
wire [2:0] inc;

wire [47:0] productResult = {1'd1,x[22:0] }* {1'd1,y[22:0]} ;

normalisation norm(

.multiplicationResult(productResult),
.normalisedResult(mantissa),
.exponentInc(inc)
);

wire [7:0] output_exp = x[30:23] + y[30:23] -8'd127 + inc;

assign k = {sign,output_exp,mantissa[22:0]};

endmodule;




module normalisation(

    input [47:0] multiplicationResult,
    
    output [23:0] normalisedResult,
    output [2:0] exponentInc

);


wire [23:0] beforeRound_result = (~multiplicationResult[47]) ? multiplicationResult[46:23] : multiplicationResult[47:24] >> 1 ;

//wire[2:0] expIncrement = ( multiplicationResult[47] ) ? 3'd1 : 3'd0;

wire guardBit = ( multiplicationResult[47] ) ? multiplicationResult[23] : multiplicationResult[22];

wire round_bit = ( multiplicationResult[47] ) ? multiplicationResult[22] : multiplicationResult[21];

wire sticky_bits = ( multiplicationResult[47] ) ? |multiplicationResult[21:0] : |multiplicationResult[20:0];


wire [24:0] afterRound_result = (guardBit && ( round_bit || sticky_bits )) ? (beforeRound_result + 24'd1) : (beforeRound_result)   ;

assign normalisedResult = (afterRound_result[24]) ?  afterRound_result[24:1] : afterRound_result[23:0] ;

assign exponentInc = ( multiplicationResult[47])  ? ( (afterRound_result[24]) ? 3'd2 : 3'd1 ) : 
                        
                        (afterRound_result[24]) ? 3'd1 : 3'd0 ;



endmodule;