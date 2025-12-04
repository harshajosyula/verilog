# verilog
verilog projects

normalisation:

after 24 bit by 24 bit mantissa multiplication we get a 48 bit result.

48bit result = 01.xxxxxxxx...... 48 bits (or) 10.xxxxxxxxxxxxx...... (or) 11.xxxxxxxxxxxx  

normalisation is done only in cases 2 and 3 

but rounding is done in all cases

in general mantissa is like this (a47 a46 a45 so on .. a25 a24).(a23 a22 a21 ... a0)

if after dot bit  a23 = 1 --> corresponds to 0.5 
                  a22 = 1 --->  0.25            
                  total = 0.75 hence roundoff to be done

if after dot bit a23 =0 ---> 0
                 a22 = 1 ---> 0.25

                 total = 0.25 no round off required

if after dot bit a23 =0 ----> 1

            any of other bits are 1 

            total >0.5 ---> roundoff required



4 dec 2025

added the zero special case i.e multiplication with zero.
Code is not synthesizable due to the for loop ---> modify the for and every thing will work fine when synthesizing.
End of the multiplier as I am not interested in adding further special case handling
