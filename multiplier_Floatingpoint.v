module multiplier(

input [31:0] x,
input [31:0] y,

output[31:0] k

);


wire sign = x[31] ^ y[31];

wire [23:0] mantissa;
wire [2:0] inc;

wire rounding_value;

wire [47:0] productResult = {1'd1,x[22:0] }* {1'd1,y[22:0]} ;

normalisation norm(

.multiplicationResult(productResult),
.normalisedResult(mantissa),
.exponentInc(inc),
.roundup(rounding_value)
);

wire [7:0] output_exp = x[30:23] + y[30:23] -8'd127 + inc;

assign k = (~rounding_value) ? {sign,output_exp,mantissa[23:1]} : {sign,output_exp,mantissa[22:0]};

endmodule;




module normalisation(

    input [47:0] multiplicationResult,
    
    output [23:0] normalisedResult,
    output [2:0] exponentInc,
    output roundup

);


wire [23:0] beforeRound_result = (~multiplicationResult[47]) ? multiplicationResult[46:23] : multiplicationResult[47:24] >> 1 ;

//wire[2:0] expIncrement = ( multiplicationResult[47] ) ? 3'd1 : 3'd0;

wire guardBit = ( multiplicationResult[47] ) ? multiplicationResult[23] : multiplicationResult[22];

wire round_bit = ( multiplicationResult[47] ) ? multiplicationResult[22] : multiplicationResult[21];

wire sticky_bits = ( multiplicationResult[47] ) ? |multiplicationResult[21:0] : |multiplicationResult[20:0];


wire [24:0] afterRound_result = (guardBit && ( round_bit || sticky_bits )) ? (beforeRound_result + 24'd1) : (beforeRound_result)   ;

assign roundup = afterRound_result[24];

// finding leading 1

     integer i;
    reg [24:0] temp_shifted;

    always @(*) begin : leading_one_detector_block
        temp_shifted = 5'd0; 
        
        for (i = 23; i >= 0; i = i - 1) begin
            if (afterRound_result[i] == 1) begin
                temp_shifted = 23 - i + 1; // Calculate the shift amount
                disable leading_one_detector_block; // Exit the *entire* always block immediately
            end
        end
    end

assign normalisedResult = (afterRound_result[24]) ?  afterRound_result[24:1] :  afterRound_result << temp_shifted ;

assign exponentInc = ( multiplicationResult[47])  ? ( (afterRound_result[24]) ? 3'd2 : 3'd1 ) : 
                        
                        (afterRound_result[24]) ? 3'd1 : 3'd0 ;



endmodule;