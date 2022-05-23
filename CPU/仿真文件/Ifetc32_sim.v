`timescale 1ns / 1ps

module Ifetc32_sim();

reg[31:0] Addr_result;
reg[31:0] Read_data_1;
reg Branch;
reg nBranch;            
reg Jmp;                
reg Jal;                
reg Jr;
reg Zero;
reg clock,reset;  
reg[31:0] Instruction;		
wire[31:0] branch_base_addr;  
wire[31:0] link_addr; 

Ifetc32 ifetc(Instruction,branch_base_addr,Addr_result,Read_data_1,Branch,nBranch,Jmp,Jal,Jr,Zero,clock,reset,link_addr);

initial begin
    clock = 1'b0;
    reset = 1'b0;
    Branch = 1'b0;
    nBranch = 1'b0;
    Jmp = 1'b0;
    Jal = 1'b0;
    Jr = 1'b0;
    Zero = 1'b0;
    Addr_result = 32'b0;
    Read_data_1 = 32'b0;
    Instruction = 872939524;

    #500 clock = ~clock;
    Instruction = 873005060;

end


endmodule
