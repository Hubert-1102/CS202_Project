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
    
    reg [31:0] registers[31:0];
    
    reg [31:0] write_data;

    reg [4:0] write_address;
    wire[15:0] Immediate;
    wire [4:0]rd;
    wire [4:0]rt;
    wire extend;
    // wire[17:0] t;
    // assign t={Immediate,2'b0};
    assign read_data_1=(Instruction[25:21])?registers[Instruction[25:21]]:32'b0;//rs
    assign read_data_2=(Instruction[20:16])?registers[Instruction[20:16]]:32'b0;//rt

    assign extend=(andi==1'b1||ori==1'b1||xori==1'b1||Instruction[31:26]==6'b001001||Instruction[31:26]==6'b001011)
    ?1'b0:Immediate[15];
    assign Immediate=Instruction[15:0];
    assign andi=Instruction[31:26]==6'b001100;
    assign ori=Instruction[31:26]==6'b001101;
    assign xori=Instruction[31:26]==6'b001110;
    assign lui=Instruction[31:26]==6'b001111;
    assign Sign_extend=(lui==1'b1)?{Immediate,{16'b0}}:
    ((Instruction[31:26]==6'b000100||Instruction[31:26]==6'b000101)?
    {{14{Immediate[15]}},Immediate,2'b0}:{{16{extend}},Immediate});
    
    assign rd=Instruction[15:11];
    assign rt=Instruction[20:16];
    
  always @(*) begin //where to write data
    if(RegWrite==1'b1)begin
        if(Jal==1'b1)begin
        write_address=5'b11111;
        end
        else if(RegDst==1'b1)
        begin
            write_address=rd;
        end
        else begin
        write_address=rt;
        end
    end 
  end
  always @(*) begin //determine what data to write
      if(MemtoReg==1'b1)begin
      write_data=mem_data;
      end
    else if(Jal==1'b1)begin
        write_data=opcplus4;
    end
    else begin
        write_data=ALU_result;//other situations, the data is from ALU
    end
    end
      integer k;

  always @(posedge clock) begin
      if(reset==1'b1)begin
          for(k=5'b00000;k<=5'b11111;k=k+5'b00001)begin
              registers[k]=32'b0;
          end
      end
      else begin
      if(RegWrite==1'b1)begin
          registers[write_address]=write_data;
      end
      end
  end
    endmodule