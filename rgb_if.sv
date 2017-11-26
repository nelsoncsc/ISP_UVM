///Interface
interface rgb_if(input logic clk, rst);
    logic [7:0] R, G, B;
    
    modport in(input clk, rst, R, G, B);
endinterface

