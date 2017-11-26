//Nelson Campos, September 20, 2015
module RGB2YCbCr(rgb_if.in in, ycbcr_if.out out);

   always @(posedge in.clk)begin
       if(in.rst) begin
          out.Y <= 0;
          out.Cb <= 0;
          out.Cr <= 0;
       end
       else begin
          out.Y <= 16+(((in.R<<6)+(in.R<<1)+(in.G<<7)+in.G+(in.B<<4)+(in.B<<3)+in.B)>>8);
          out.Cb <= 128 + ((-((in.R<<5)+(in.R<<2)+(in.R<<1))-((in.G<<6)+(in.G<<3)+(in.G<<1))+(in.B<<7)-(in.B<<4))>>8);
          out.Cr <= 128 + (((in.R<<7)-(in.R<<4)-((in.G<<6)+(in.G<<5)-(in.G<<1))-((in.B<<4)+(in.B<<1)))>>8);
          $display("R = %d G = %d B = %d Y = %d Cb = %d Cr = %d", in.R,in.G, in.B, out.Y, out.Cb, out.Cr);
       end
    end
endmodule : RGB2YCbCr
