module second_counter_60(input clk,                         // 기준 Clock
                         input reset,                       // 동기 Reset
                         input tick_1s,                     // 1초 Tick Enable
                         output reg tick_1min,              // 60초마다 1 Clock 동안 1 
                         output reg [5:0] sec_count);
    // 60초 Count 및 1분 Tick 생성 블록
    always @(posedge clk) begin
        if (reset) begin
            sec_count <= 6'd0; // 초 Count 초기화
            tick_1min <= 1'b0; // 1분 Tick 초기화
        end
        else begin
            tick_1min <= 1'b0; // Tick 기본값은 0
            if (tick_1s) begin // 1초 Tick에서만 증가
                if (sec_count == 6'd59) begin
                    sec_count <= 6'd0; // 59초 다음 0초
                    tick_1min <= 1'b1; // 1 Clock 폭 1분 Tick 발생
                end
                else begin
                    sec_count <= sec_count + 1'b1; // 초Count 증가
                end
            end
        end
    end
endmodule
