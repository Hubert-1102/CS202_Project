`timescale 1ns / 1ps

module switch(clock, reset, SwitchCtrl, ioRead, switches, switchAddr, input_data, submit_posedge, status_posedge);

input clock, reset, SwitchCtrl, ioRead;
input[23:0] switches;             // 0xFFFFFC70 --------> 0xFFFFFC72
input[2:0] switchAddr;           // 判断当前输入的是编号还是数字  3'b
output[15:0] input_data;
input submit_posedge;
input status_posedge;

reg[15:0] switchData;

assign input_data = switchData[15:0];

always @(negedge clock or posedge reset) begin
    if (reset == 1'b1) begin
        switchData <= 16'h0000;
    end
    else begin
        if (SwitchCtrl == 1'b1 && ioRead == 1'b1) begin
            if (switchAddr == 3'b000) begin
                // switchData <= switches[15:0];
                switchData <= {8'h00, switches[7:0]};
            end
            else if (switchAddr == 3'b001) begin
                switchData <= {8'h00, switches[15:8]};
            end
            else if (switchAddr == 3'b010) begin
                switchData <= {8'h00, switches[23:16]};
            end
            else if (switchAddr == 3'b011) begin
                switchData <= submit_posedge;
            end
            else begin
                switchData <= status_posedge;
            end
        end
        else begin
            switchData <= switchData[15:0];
        end
    end
end

endmodule