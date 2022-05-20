`timescale 1ns / 1ps

module key_debounce(clk, rst, key, key_posedge);

    input clk, rst, key;
    output key_posedge;

    reg key_value;
    reg key_flag;

    assign key_posedge = key_flag & (~key_value);

    reg key_reg;
    reg [19:0] delay_cnt;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            key_reg <= 1'b1;
            delay_cnt <= 20'd0;
        end
        else begin
            key_reg <= key;
            if (key != key_reg)
                delay_cnt <= 20'd1000_000;
            else begin
                if (delay_cnt > 20'd0)
                    delay_cnt <= delay_cnt - 1'b1;
                else
                    delay_cnt <= 20'd0;
            end
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            key_value <= 1'b1;
            key_flag <= 1'b0;
        end
        else begin
            if (delay_cnt == 20'd1) begin
                key_flag <= 1'b1;
                key_value <= key;
            end
            else begin
                key_flag <= 1'b0;
                key_value <= key_value;
            end
        end
    end

endmodule
