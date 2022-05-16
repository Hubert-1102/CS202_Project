`timescale 1ns / 1ps

module switch(clock, reset, SwitchCtrl, ioRead, switches, input_data);

input clock, reset, SwitchCtrl, ioRead;
input[23:0] switches;
output[15:0] input_data;

reg[15:0] switchData;

assign input_data = switchData;

always @(posedge clock or negedge reset) begin
    if (reset) begin
        switchData <= 24'h000000;
    end
    else begin
        if (SwitchCtrl && ioRead) begin
            switchData <= switches[15:0];
        end
        else begin
            switchData <= switchData;
        end
    end
end

endmodule
