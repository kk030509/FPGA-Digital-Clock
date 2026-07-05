module dp_blink_1hz(input clk,        // 100MHz 기준 Clock
                    input reset,      // 동기 Reset
                    input enable,     // Blink 동작 허용
                    output dp_state); // dp 출력, Active-Low
    reg [25:0] count_blink; // 0.5초 Count용
    reg blink; // 0.5초마다 반전되는 내부상태
    // 1Hz Duty 50% Blink 생성 블록
    always @(posedge clk) begin
        if (reset) begin
            count_blink <= 26'd0; // Counter 초기화
            blink       <= 1'b0; // 초기 dp는 꺼짐
        end
        else begin
            if (enable) begin // Enable 상태에서만 Blink
                if (count_blink == 26'd49_999_999) begin
                count_blink <= 26'd0; // 0.5초 도달후 초기화
                blink <= ~blink; // 0.5초마다 상태 반전
            end
            else begin
                count_blink <= count_blink + 1'b1;
                // Clock Count 증가
            end
        end
        else begin
        count_blink <= 26'd0; // 정지 시 Count 초기화
        blink <= 1'b0; // dp 꺼짐 상태
    end
    end
    end
    assign dp_state = ~blink; // Active-Low, blink = 1dl면 dp 켜짐
endmodule
