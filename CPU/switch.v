`timescale 1ns / 1ps

module switch(clock, reset, SwitchCtrl, ioRead, switches, input_data);

input clock, reset, SwitchCtrl, ioRead;
input[23:0] switches;
output[15:0] input_data;

reg[15:0] switchData;

assign input_data = switchData[15:0];

always @(negedge clock or posedge reset) begin
    if (reset == 1'b1) begin
        switchData <= 16'h0000;
    end
    else begin
        if (SwitchCtrl == 1'b1 && ioRead == 1'b1) begin
            switchData <= switches[15:0];
        end
        else begin
            switchData <= switchData[15:0];
        end
    end
end

endmodule
