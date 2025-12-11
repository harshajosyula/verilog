cordic algorithm details 
Added files
-> cordic.v  -> verilog file
-> cordic_test.v -> testbench file to test code
-> image to show the results

points to remember:
-> This verilog code is synthesizable (FPGA probably not in ASIC because of Look up table).
-> Angles handled  = 0 to 180 
-> only sine and cosine values are generated
-> more bits to x_coordinate and y_coordinate  as well as  more iterations, will yield better precision.
-> Rotation mode of cordic is implemented which can handle upto  180 degrees only.
-> To cover 180 to 360  angles, we just have map the angles to quandrant 1 just like I showed in the code.