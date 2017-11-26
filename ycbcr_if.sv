//Interface
interface ycbcr_if(input clk, rst);
    logic [7:0] Y, Cb, Cr;
    
    modport out(input clk, rst, output Y, Cb, Cr);
endinterface

