`timescale 1ns / 1ps

module main(start_pg,uart_in,uart_out,clk, reset, leds, switches, submit, status);

input clk, reset, submit, status,start_pg,uart_in;
output uart_out;
wire clock;
wire submit_posedge, status_posedge;

wire upg_clk,upg_clk_o,upg_wen_o;
wire upg_done_o;
wire [14:0] upg_adr_o;
wire [31:0] upg_dat_o;
wire spg_bufg;
BUFG U1(.I(start_pg),.O(spg_bufg));
reg upg_rst;

always@(posedge clk)begin
        if(spg_bufg)upg_rst=0;
        if(reset)upg_rst=1;
end
wire rst;
assign rst=reset|!upg_rst;



uart u(.upg_clk_i(upg_clk),.upg_rst_i(upg_rst),
.upg_rx_i(uart_in),.upg_clk_o(upg_clk_o),
.upg_wen_o(upg_wen_o),.upg_adr_o(upg_adr_o),
.upg_dat_o(upg_dat_o),.upg_done_o(upg_done_o),
.upg_tx_o(uart_out)
);

erase_shake submit_shake(.clk(clock),
                        .rst(reset),
                        .key_in(submit),
                        .key_out(submit_posedge));

erase_shake status_shake(.clk(clock),
                        .rst(reset),
                        .key_in(status),
                        .key_out(status_posedge));

cpuclk clk1(.clk_in1(clk), .clk_out1(clock),.clk_out2(upg_clk));

wire[31:0] Instruction, branch_base_addr, Addr_result, Read_data_1, opcplus4;
wire Branch, nBranch, Jmp, Jal, Jr, Zero;

wire[31:0] Instruction_i;
wire [13:0] addr_o;
programrom p(
        .clk_i(clock),
        .adr_i(addr_o),
        .upg_rst_i(upg_rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i((!upg_adr_o[14])&upg_wen_o),
        .upg_adr_i(upg_adr_o[13:0]),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o),
        .Instruction_o(Instruction_i)
);

Ifetc32 ifetch(.Instruction(Instruction),
                .Instruction_i(Instruction_i),
                .addr_o(addr_o),
               .branch_base_addr(branch_base_addr),
               .Addr_result(Addr_result), 
               .Read_data_1(Read_data_1), 
               .Branch(Branch), 
               .nBranch(nBranch), 
               .Jmp(Jmp), 
               .Jal(Jal), 
               .Jr(Jr), 
               .Zero(Zero), 
               .clock(clock),
               .reset(rst), 
               .link_addr(opcplus4));

wire[31:0] Read_data_2, mem_data, ALU_Result, Sign_extend;
wire RegWrite, MemtoReg, RegDst;

decode32 decode(.read_data_1(Read_data_1), 
                .read_data_2(Read_data_2), 
                .Instruction(Instruction), 
                .mem_data(mem_data),
                .ALU_result(ALU_Result), 
                .Jal(Jal), 
                .RegWrite(RegWrite), 
                .MemtoReg(MemtoReg), 
                .RegDst(RegDst), 
                .Sign_extend(Sign_extend), 
                .clock(clock), 
                .reset(rst), 
                .opcplus4(opcplus4));

wire[5:0] Opcode;
wire[5:0] Function_opcode;

assign Opcode = Instruction[31:26];
assign Function_opcode = Instruction[5:0];

wire MemorIOtoReg, MemRead, MemWrite, IORead, IOWrite, ALUSrc, I_format, Sftmd;
wire[1:0] ALUOp;

control32 control(.Alu_resultHigh(ALU_Result[31:10]), 
                  .MemorIOtoReg(MemorIOtoReg), 
                  .MemRead(MemRead), 
                  .IORead(IORead), 
                  .IOWrite(IOWrite), 
                  .Opcode(Opcode), 
                  .Function_opcode(Function_opcode), 
                  .Jr(Jr), 
                  .RegDST(RegDst), 
                  .ALUSrc(ALUSrc), 
                  .MemtoReg(MemtoReg), 
                  .RegWrite(RegWrite), 
                  .MemWrite(MemWrite), 
                  .Branch(Branch), 
                  .nBranch(nBranch), 
                  .Jmp(Jmp), 
                  .Jal(Jal), 
                  .I_format(I_format), 
                  .Sftmd(Sftmd), 
                  .ALUOp(ALUOp));

wire[31:0] memoryAddress, writeData, readDataFromMemory;

dmemory32 memory(.clock(clock), 
                 .memWrite(MemWrite), 
                 .address(memoryAddress), 
                 .writeData(writeData), 
                 .readData(readDataFromMemory),
                .upg_rst_i(upg_rst),
                 .upg_clk_i(upg_clk_o),
                 .upg_wen_i(upg_adr_o[14]&upg_wen_o),
                 .upg_adr_i(upg_adr_o[13:0]),
                 .upg_dat_i(upg_dat_o),
                 .upg_done_i(upg_done_o)
                 );

wire[4:0] Shamt;
assign Shamt = Instruction[10:6];

executs32 alu(.Read_data_1(Read_data_1), 
              .Read_data_2(Read_data_2), 
              .Sign_extend(Sign_extend), 
              .Function_opcode(Function_opcode), 
              .Exe_opcode(Opcode), 
              .ALUOp(ALUOp), 
              .Shamt(Shamt), 
              .Sftmd(Sftmd), 
              .ALUSrc(ALUSrc), 
              .I_format(I_format), 
              .Jr(Jr), 
              .Zero(Zero), 
              .ALU_Result(ALU_Result), 
              .Addr_Result(Addr_result), 
              .PC_plus_4(opcplus4));

wire[15:0] readDataFromIO;
wire LEDCtrl, SwitchCtrl;

MemOrIO memorio(.mRead(MemRead), 
                .mWrite(MemWrite), 
                .ioRead(IORead), 
                .ioWrite(IOWrite), 
                .addr_in(ALU_Result), 
                .addr_out(memoryAddress), 
                .m_rdata(readDataFromMemory), 
                .io_rdata(readDataFromIO), 
                .r_wdata(mem_data), 
                .r_rdata(Read_data_2),            // 因为要对应 sw 指令, sw 指令拿出寄存器中的数据使用的是 rt 寄存器的数值
                .write_data(writeData), 
                .LEDCtrl(LEDCtrl), 
                .SwitchCtrl(SwitchCtrl));

output[23:0] leds;

wire[1:0] lowTwoBitAddr;
wire[2:0] lowThreeBitAddr;

assign lowTwoBitAddr = memoryAddress[1:0];
assign lowThreeBitAddr = memoryAddress[2:0];

led led(.clock(clock),
        .reset(rst),
        .LEDCtrl(LEDCtrl),
        .ioWrite(IOWrite),
        .write_data(writeData[15:0]),
        .ledAddr(lowTwoBitAddr),
        .leds(leds));

input[23:0] switches;

// Read data from IO
switch switch(.clock(clock),
              .reset(rst),
              .SwitchCtrl(SwitchCtrl),
              .ioRead(IORead),
              .switches(switches),
              .switchAddr(lowThreeBitAddr),
              .input_data(readDataFromIO),
              .submit_posedge(submit_posedge),
              .status_posedge(status_posedge));

endmodule