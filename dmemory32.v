`timescale 1ns / 1ps

module dmemory32(clock,memWrite,address,writeData,readData,upg_rst_i,upg_clk_i,upg_wen_i,upg_adr_i
,upg_dat_i,upg_done_i);

    input clock, memWrite;  //memWrite 来自controller，为1'b1时表示要对data-memory做写操作

    input [31:0] address;   //address 以字节为单位

    input [31:0] writeData; //writeData ：向data-memory中写入的数据

    output[31:0] readData;  //writeData ：从data-memory中读出的数据

    assign clk = !clock;
    input upg_rst_i,upg_clk_i,upg_wen_i;
    input [13:0] upg_adr_i;
    input [31:0] upg_dat_i;
    input upg_done_i;
    wire kickOff = upg_rst_i|(~upg_rst_i&upg_done_i);


    // RAM ram(.clka(clk), .wea(memWrite), .addra(address[15:2]), .dina(writeData), .douta(readData));
    RAM ram(
        .clka(kickOff? clk:upg_clk_i),
        .wea(kickOff? memWrite:upg_wen_i),
        .addra(kickOff? address[15:2]:upg_adr_i),
        .dina(kickOff? writeData:upg_dat_i),
        .douta(readData)
    );
    // RAM ram(.clka(clk), .wea(memWrite), .addra(address[15:2]), .dina(writeData), .douta(readData));

endmodule