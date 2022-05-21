`timescale 1ns / 1ps

module erase_shake
#(parameter Max=21'd2000_000)(
    input clk,
    input rst,
    input key_in,
    output reg key_out
    );
    reg [21:0] cnt;
    always@(posedge clk or posedge rst)
    begin
        if(rst==1'b1)
            cnt<=22'd0;
        else if(key_in==1'b0)
            cnt<=22'd0;
        else if (cnt==Max)
            cnt <=Max;
        else
            cnt<=cnt+20'd1;
    end
    always@(posedge clk or posedge rst) 
    begin
        if(rst==1'b1)
            key_out<=1'b0;
        else if(cnt >= Max-20'd8 && cnt < Max)
            key_out<=1'b1;
        else
            key_out<=1'b0;
    end
endmodule
