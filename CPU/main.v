`timescale 1ns / 1ps

module main(clk, reset, leds, switches);

input clk, reset;
wire clock;

cpuclk clk1(.clk_in1(clk), .clk_out1(clock));

wire[31:0] Instruction, branch_base_addr, Addr_result, Read_data_1, opcplus4;
wire Branch, nBranch, Jmp, Jal, Jr, Zero;

Ifetc32 ifetch(.Instruction(Instruction),
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
               .reset(reset), 
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
                .reset(reset), 
                .opcplus4(opcplus4));

wire[6:0] Opcode;
wire[6:0] Function_opcode;

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
                 .readData(readDataFromMemory));

wire[5:0] Shamt;
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

assign lowTwoBitAddr = memoryAddress[1:0];

led led(.clock(clock),
        .reset(reset),
        .LEDCtrl(LEDCtrl),
        .ioWrite(IOWrite),
        .write_data(writeData),
        .ledAddr(lowTwoBitAddr),
        .leds(leds));

input[23:0] switches;

switch switch(.clock(clock),
              .reset(reset),
              .SwitchCtrl(SwitchCtrl),
              .ioRead(IORead),
              .switches(switches),
              .switchAddr(lowTwoBitAddr),
              .input_data(readDataFromIO));

endmodule