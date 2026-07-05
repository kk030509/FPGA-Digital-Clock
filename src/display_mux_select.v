module display_mux_select(input mode_year,      // sw[3]: 연도 표시 모드 (최우선)
                          input mode_date,      // sw[4]: 날짜 표시 모드
                          input set_mode,       // sw[1]: 시간 설정 모드 (dp Blink 정지용)
                          input [1:0] digit_sel,
                          input dp_state,        // 1Hz Duty 50% Blink 상태

                          input [3:0] min_ones, min_tens,
                          input [3:0] disp_hour_ones, disp_hour_tens,
                          input [3:0] day_ones, day_tens,
                          input [3:0] month_ones, month_tens,
                          input [3:0] y0, y1, y2, y3,

                          output [3:0] d0, d1, d2, d3,
                          output dp);
    // 우선순위: 연도 표시 > 날짜 표시 > 시:분 표시
    assign d0 = mode_year ? y0 : mode_date ? day_ones   : min_ones;
    assign d1 = mode_year ? y1 : mode_date ? day_tens   : min_tens;
    assign d2 = mode_year ? y2 : mode_date ? month_ones : disp_hour_ones;
    assign d3 = mode_year ? y3 : mode_date ? month_tens : disp_hour_tens;

    // 시:분 표시일 때만 가운데 dp를 1Hz로 Blink, 그 외에는 항상 꺼짐(Active-Low라 1)
    assign dp = 
        (mode_year) ? 
                1'b1 : 
                ((digit_sel == 2'd2) ? 
                    (set_mode ? 1'b0 : dp_state)
              : 1'b1);
endmodule
