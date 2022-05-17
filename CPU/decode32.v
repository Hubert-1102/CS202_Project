`timescale 1ns / 1ps

module decode32(read_data_1,read_data_2,Instruction,mem_data,ALU_result,
                 Jal,RegWrite,MemtoReg,RegDst,Sign_extend,clock,reset,opcplus4);
    output[31:0] read_data_1;               // 输出的第一操作数
    output[31:0] read_data_2;               // 输出的第二操作数
    input[31:0]  Instruction;               // 取指单元来的指令
    input[31:0]  mem_data;   				//  从DATA RAM or I/O port取出的数据
    input[31:0]  ALU_result;   				// 从执行单元来的运算的结果
    input        Jal;                       //  来自控制单元，说明是JAL指令 
    input        RegWrite;                  // 来自控制单元
    input        MemtoReg;              // 来自控制单元
    input        RegDst;             
    output[31:0] Sign_extend;               // 扩展后的32位立即数
    input		 clock,reset;                // 时钟和复位
    input[31:0]  opcplus4;                 // 来自取指单元，JAL中用

    reg[4:0] read_register, write_register;
    reg[31:0] write_data;

    reg[31:0] data1, data2;

    reg[31:0] register[0:31];
    wire[5:0] Opcode, Function_opcode;

    wire[15:0] immediate;

    wire[5:0] rs, rt, rd;

    assign Opcode = Instruction[31:26];
    assign Function_opcode = Instruction[5:0];
    assign rs = Instruction[25:21];
    assign rt = Instruction[20:16];
    assign rd = Instruction[15:11];
    assign immediate = Instruction[15:0];

    //OUTPUT
    assign read_data_1 = register[rs];
    assign read_data_2 = register[rt];
    assign Sign_extend = (Opcode == 6'b001011 || Opcode == 6'b001100 || Opcode == 6'b001101 || Opcode == 6'b001110) ?  {16'h0000, immediate} : {{16{immediate[15]}}, immediate};

    always @(*) begin
      if (Jal) begin
        write_data = opcplus4;
      end
      else if (MemtoReg) begin
        write_data = mem_data;
      end
      else begin
        write_data = ALU_result;
      end
    end

      always @(*) begin
        if (Jal) begin
          write_register = 5'b11111;
        end
        else if (RegDst) begin
          write_register = rd;
        end
        else begin
          write_register = rt;
        end
      end

      integer n;
      always @(posedge clock or posedge reset) begin
          if (reset) begin
            for (n = 0; n < 32 ;n = n + 1) begin
              register[n] <= 32'h0000_0000;
            end
          end
          else if (RegWrite == 1) begin
            register[write_register] <= write_data;
          end
          else begin
            register[write_register] <= register[write_register];
          end
      end

endmodule