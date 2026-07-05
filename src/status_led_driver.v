module status_led_driver(input tick_1s,
                         input tick_1min,
                         input [5:0] sec_count,
                         input [2:0] weekday,
                         output [15:0] led    // 확인용 LED
                        );
    assign led[0]    = tick_1s;    // 1 Clock 폭 Tick
    assign led[1]    = tick_1min;  // 1 Clock 폭 Tick
    assign led[7:2]  = sec_count;  // 내부 초 Count 표시
    assign led[14:8] = 7'b0000001 << weekday; // 요일 One-hot 표시
endmodule
