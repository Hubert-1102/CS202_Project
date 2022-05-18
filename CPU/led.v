`timescale 1ns / 1ps

module led(clock, reset, LEDCtrl, ioWrite, write_data, ledAddr, leds, submit);

input clock, reset, LEDCtrl, ioWrite;
input[15:0] write_data;
input[1:0] ledAddr;      // 判断当前输出的是编号还是数字 2'b00 2'b01 2'b10
output[23:0] leds;
input submit;

reg[23:0] ledData;

assign leds = ledData;

always @(posedge clock or posedge reset) begin
    if (reset == 1'b1 || submit == 1'b0) begin
        ledData <= 24'h000000;
    end
    else begin
        if (LEDCtrl == 1'b1 && ioWrite == 1'b1) begin
            if (ledAddr == 2'b00 || ledAddr == 2'b01) begin
                ledData <= {ledData[23:16], write_data[15:0]};
            end
            else begin
                ledData <= {write_data[7:0], ledData[15:0]};
            end
        end
        else begin
            ledData <= ledData;
        end
    end
end

endmodule
