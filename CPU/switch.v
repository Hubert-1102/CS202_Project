`timescale 1ns / 1ps

module switch(clock, reset, SwitchCtrl, ioRead, switches, switchAddr, input_data);

input clock, reset, SwitchCtrl, ioRead;
input[23:0] switches;             // 0xFFFFFC70 --------> 0xFFFFFC72
input[1:0] switchAddr;           // 判断当前输入的是编号还是数字  2'b00  2'b01  2'b10
output[15:0] input_data;

reg[15:0] switchData;

assign input_data = switchData[15:0];

always @(negedge clock or posedge reset) begin
    if (reset == 1'b1) begin
        switchData <= 16'h0000;
    end
    else begin
        if (SwitchCtrl == 1'b1 && ioRead == 1'b1) begin
            if (switchAddr == 2'b00 || switchAddr == 2'b01) begin
                switchData <= switches[15:0];
            end
            else begin
                switchData <= {8'h00, switches[23:16]};
            end
        end
        else begin
            switchData <= switchData[15:0];
        end
    end
end

endmodule
