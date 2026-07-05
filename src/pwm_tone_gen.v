module pwm_tone_gen(input clk,
                    input reset,
                    input note_on,             // 0이면 무음, 1이면 소리 재생
                    input [31:0] half_period,  // 반주기 Clock 수 (0이면 무음)
                    output reg pwm_out);
    reg [31:0] cnt;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cnt     <= 0;
            pwm_out <= 1'b0;
        end
        else if (!note_on || half_period == 0) begin
            // 무음 구간이거나 쉼표인 경우 Toggle 정지
            cnt     <= 0;
            pwm_out <= 1'b0;
        end
        else begin
            // half_period Clock마다 출력을 반전 -> 사각파 생성
            if (cnt >= half_period - 1) begin
                cnt     <= 0;
                pwm_out <= ~pwm_out;
            end
            else begin
                cnt <= cnt + 1'b1;
            end
        end
    end
endmodule
