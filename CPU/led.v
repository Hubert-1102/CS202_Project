`timescale 1ns / 1ps

module led(clock, reset, LEDCtrl, ioWrite, write_data, leds);

input clock, reset, LEDCtrl, ioWrite;
input[15:0] write_data;
output[23:0] leds;

reg[23:0] ledData;

assign leds = ledData;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        ledData <= 24'h000000;
    end
    else begin
        if (LEDCtrl && ioWrite) begin
            ledData <= {ledData[23:16], write_data};
        end
        else begin
            ledData <= ledData;
        end
    end
end

endmodule
