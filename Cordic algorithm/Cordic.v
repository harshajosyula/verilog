/*

    cordic algorithm to find sine and cosine of an angle using rotation mode

*/

module cordic(

    input clk,
    input reset,
    input wire signed [19:0] angle,

    output reg[31:0] x;
    output reg[31:0] y;

);

reg signed [7:0] x_coordinate;
reg signed [7:0] y_coordinate;
reg signed [19:0] z_angle;



// creating a lookup table i.e ROM for tan_inverse

reg [19:0] invTan[10:0];    memory with 12 bit data and 11 location

initial begin
    invTan[0] = 20'b00101101.000000000000;
    invTan[1] = 20'b00011010.100011110101;
    invTan[2] = 20'b00001110.000010010011;
    invTan[3] = 20'b00000111.001000000000;
    invTan[4] = 20'b00000011.100100110111;
    invTan[5] = 20'b00000001.110010100011;
    invTan[6] = 20'b00000000.111001010001;
    invTan[7] = 20'b00000000.011100100110;
    invTan[8] = 20'b00000000.001110010100;
    invTan[9] = 20'b00000000.000111001010;
   invTan[10] = 20'b00000000.000011100100;  
// loading 

always @(posedge clk)
begin
    if(reset)
        begin
                x_coordinate <= 8'd32 ; // x_coordinate = 001.00000 => +1
                y_coordinate <= 8'd0 ;      // y_coordinate = 000.00000 => +0
                z_angle <= angle;
        end
    else
        begin
            x_coordinate <=8'd0;
            y_coordinate <=8'd0;
            z_angle <= 8'd0;

        end
end

endmodule
