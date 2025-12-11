module cordic(
    input clk,
    input reset,
    input wire signed [20:0] angle,
    output reg[11:0] x,
    output reg[11:0] y
);

reg signed [11:0] x_coordinate[16:0];
reg signed [11:0] y_coordinate[16:0];
reg signed [20:0] z_angle[16:0];
reg d_sign[16:0];
reg invert_x;
reg invert_y;


// Creating a lookup table i.e ROM for tan_inverse
reg [19:0] invTan[0:19];
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
    invTan[11] = 20'b00000000000001110010;
    invTan[12] = 20'b00000000000011100101;
    invTan[13] = 20'b00000000000000011100;
    invTan[14] = 20'b00000000000000001110;
    invTan[15] = 20'b00000000000000000111;
    invTan[16] = 20'b00000000000000000011;
end

// Single always block for CORDIC iterations

integer i;

always @(posedge clk)
begin

if(reset)
    begin
    for (i = 0; i <= 11; i = i + 1)
        begin
            x_coordinate[i] <= 12'd0;
            y_coordinate[i] <= 12'd0;
            z_angle[i] <= 20'd0;
            d_sign[i] <= 1'b0;
        end
      x <= 12'd0;
      y <= 12'd0;
    end
else
    begin
    x_coordinate[0] <= 12'd512;  // x_coordinate = 001.000000000
    y_coordinate[0] <= 12'd0;   // y_coordinate = 000.000000000
    z_angle[0] <= (angle <= 21'd368640 ) ? angle : 21'd737280 - angle;
    invert_x <= (angle <= 21'd368640 ) ? 0 : 1;
    invert_y <= 0;
    d_sign[0] <= ( angle[20] ) ? 1'b0 : 1'b1;  // 0 if angle is negative, 1 if positive
    end
end



genvar j;

generate for (j=0;j<16; j=j+1)
begin: pipeline

always @(posedge clk) begin
    x_coordinate[j+1] <= (d_sign[j]) ? (x_coordinate[j] - (y_coordinate[j] >>> j)) : (x_coordinate[j] + (y_coordinate[j] >>> j)) ;
    y_coordinate[j+1] <= (d_sign[j]) ? y_coordinate[j] + (x_coordinate[j] >>> j) :  y_coordinate[j] - (x_coordinate[j] >>> j) ;
    z_angle[j+1] <= (d_sign[j]) ? z_angle[j] - invTan[j] : z_angle[j] + invTan[j]  ;
    d_sign[j+1] <= (z_angle[j+1][20]) ? 1'b0 : 1'b1;
end
end
endgenerate


always @(posedge clk)
begin
    if(reset) begin
      x <= 12'd0;
      y <= 12'd0;
    end

    else begin
    x <= (invert_x ) ? {1'b1,x_coordinate[16][10:0]} : (x_coordinate[16]);
    y <= (invert_y ) ? {1'b1,y_coordinate[16][10:0]} : (y_coordinate[16]);
    end

end

endmodule