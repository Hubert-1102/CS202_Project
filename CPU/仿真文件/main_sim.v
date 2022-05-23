`timescale 1ns / 1ps

module main_sim();

reg clk, reset, submit, status;
reg[23:0] switches;
wire[23:0] leds;

wire[7:0] seg_en, seg_out;

main main(clk, reset, leds, switches, submit, status, seg_en, seg_out);

initial begin
    clk = 1'b0;
    reset = 1'b1;
    #3 reset = 1'b0;
    forever begin
        #5 clk = ~clk;
    end
end

// initial begin
//     submit = 1'b0;
//     #500 submit = 1'b1;
//     #25000 submit = 1'b0;
//     #500 submit = 1'b0;
//     #25000 submit = 1'b1;
// end

// 1011 1010
// 0000 0011

// test case 1

// initial begin
     // switches = {8'h00, 16'hffff};
    // 编号为0, 数字为 0000 1111 1111 0000
    // 0000 1011 1100 0111
    // 左移两位
    // 0010 1111 0001 1100        2f1c
    // 右移两位
    // 0000 0010 1111 0001        02f1
    // switches = {8'h01, 16'h0bc7};
    // #26000 switches = {8'h01, 16'h0002};
    // #10000 switches = {8'h02, 16'h0000};
    // #10000 switches = {8'h03, 16'h0000};
    // #10000 switches = {8'h04, 16'h0000};
    // #10000 switches = {8'h05, 16'h0000};
    // #10000 switches = {8'h06, 16'h0000};
    // #10000 switches = {8'h07, 16'h0000};
    // #10000 switches = {8'h08, 16'h0000};

    // forever begin
    //     #500
    //     switches = {switches[23:8] + 1, 8'h00};
    // end
    // switches = 0;
    // forever begin
    // #500
    // switches = switches + 1;
    // end
// end

initial begin
    submit = 1'b0;
    status = 1'b0;
    switches = {8'h00, 16'd3};
    #100 status = 1'b1; // 进入状态

    #1000 submit = 1'b1; // 提交按钮
    #3000 submit = 1'b0;

    switches = {8'h00, 16'd13};
    #1000 submit = 1'b1;
    #3000 submit = 1'b0;

    switches = {8'h00, 16'd9};
    #1000 submit = 1'b1;
    #3000 submit = 1'b0;

    switches = {8'h00, 16'd4};
    #1000 submit = 1'b1;
    #3000 submit = 1'b0;

end

endmodule
