// 48 bit to 24 bit  normalization topic (greatly useful in floating point multipliers)

module normalisation(

    input [47:0] multiplicationResult,
    
    output [23:0] normalisedResult,
    output [2:0] exponentInc

);


wire [23:0] beforeRound_result = (~multiplicationResult[47]) ? multiplicationResult[46:23] : multiplicationResult[47:24] >> 1 ;

//wire[2:0] expIncrement = ( multiplicationResult[47] ) ? 3'd1 : 3'd0;

wire guardBit = ( multiplicationResult[47] ) ? multiplicationResult[23] : multiplicationResult[22];

wire round_bit = ( multiplicationResult[47] ) ? multiplicationResult[22] : multiplicationResult[21];

wire sticky_bits = ( multiplicationResult[47] ) ? |multiplicationResult[22:0] : |multiplicationResult[20:0];


wire [24:0] afterRound_result = (guardBit && ( round_bit || sticky_bits )) ? (beforeRound_result + 24'd1) : (beforeRound_result)   ;

assign normalisedResult = (afterRound_result[24]) ?  afterRound_result[24:1] : afterRound_result[23:0] ;

assign exponentInc = ( multiplicationResult[47])  ? ( (afterRound_result[24]) ? 3'd2 : 3'd1 ) : 
                        
                        (afterRound_result[24]) ? 3'd1 : 3'd0 ;



endmodule;


