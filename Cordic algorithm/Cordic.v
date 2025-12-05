/*

    cordic algorithm to find sine and cosine of an angle using rotation mode

*/

module cordic(

    input clk,
    input reset,
    input wire signed [19:0] angle,

    output reg[7:0] x;
    output reg[7:0] y;

);

reg signed [7:0] x_coordinate[10:0];
reg signed [7:0] y_coordinate[10:0];
reg signed [19:0] z_angle[10:0];
reg d_sign[10:0];




// creating a lookup table i.e ROM for tan_inverse

reg [19:0] invTan[10:0];    memory with 12 bit data and 11 location

initial begin
    invTan[0] = 20'b00101101000000000000;
    invTan[1] = 20'b00011010100011110101;
    invTan[2] = 20'b00001110000010010011;
    invTan[3] = 20'b00000111001000000000;
    invTan[4] = 20'b00000011100100110111;
    invTan[5] = 20'b00000001110010100011;
    invTan[6] = 20'b00000000111001010001;
    invTan[7] = 20'b00000000011100100110;
    invTan[8] = 20'b00000000001110010100;
    invTan[9] = 20'b00000000000111001010;
   invTan[10] = 20'b00000000000011100100;  

// initial loading 

always @(posedge clk)
begin
    if(reset)
        begin
                x_coordinate[0] <= 8'd32 ; // x_coordinate = 001.00000 => +1
                y_coordinate[0] <= 8'd0 ;      // y_coordinate = 000.00000 => +0
                z_angle[0] <= angle;
                d_sign[0] <= 1'b1;
        end
    else
        begin
            x_coordinate[0] <=8'd0;
            y_coordinate[0] <=8'd0;
            z_angle[0] <= 8'd0;

        end
end



genvar i;


generate      
        for (i = 0; i < 10; i = i + 1) begin

        always @(posedge clk) 
            begin

            x_coordinate[i+1] <= (d_sign[i]) ? (x_coordinate[i] - (y_coordinate[i]) >>> i) : ((x_coordinate[i] + (y_coordinate[i])>>i)) ;    

            y_coordinate[i+1] <= (d_sign[i]) ? ( y_coordinate[i] + (x_coordinate[i]) >>> i  ) : (y_coordinate[i] - (x_coordinate[i]) >> i) ;

            z_angle[i+1] <= (d_sign[i]) ? (z_angle[i] - invTan[i]) : ( (z_angle[i] + invTan[i])) ;

            d_sign[i+1] <= (z_angle[i][19]) ? 1'b0 : 1'b1;
            
            end

        end

endgenerate


always @(posedge clk) begin

        x <= x_coordinate[10];
        y <= y_coordinate[10];
end

endmodule
