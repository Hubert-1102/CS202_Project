`timescale 1ns / 1ps

module dmemory32(clock,memWrite,address,writeData,readData);

    input clock, memWrite;  //memWrite 来自controller，为1'b1时表示要对data-memory做写操作

    input [31:0] address;   //address 以字节为单位

    input [31:0] writeData; //writeData ：向data-memory中写入的数据

    output[31:0] readData;  //writeData ：从data-memory中读出的数据

    assign clk = !clock;

    RAM ram(.clka(clk), .wea(memWrite), .addra(address[15:2]), .dina(writeData), .douta(readData));

endmodule