`timescale 1ns / 1ps

module cordicTestbench;

    // Inputs
    wire clk;
    wire reset;
    wire signed [19:0] angle;

    //Outputs
    reg[7:0] sine;
    reg[7:0] cosine;


// instantiate module name 
    cordic uut (

        .clk(clk),
        .reset(reset),
        .x(cosine),
        .y(sine)
    );

/*
    function to generate sine and cosine
*/

function real generateValues;
    input [7:0] coordinate;

