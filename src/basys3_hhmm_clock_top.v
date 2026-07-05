module basys3_hhmm_clock_top(input clk,           // Basys3 100MHz Clock
                             input btnC,          // Reset 버튼
                             // sw[0]: 시계 시작(Enable)   sw[1]: 날짜 표시
                             // sw[2]: 연도 표시           sw[3]: 설정 모드 (0/1/2번과 조합)
                             // sw[4]: 12시간제 변환
                             input [15:0] sw,

                             input btnU,
                             input btnD,
                             input btnL,
                             input btnR,
                             output [15:0] led,   // 확인용 LED
                             output [6:0] seg,    // Segment 출력, Active-Low
                             output [3:0] an,     // Digit 선택, Active-Low
                             output dp,
                             output buzzer);       // 피에조 부저 출력 (매시 50분 종소리)

    // ---------------- 내부 신호 선언 ----------------
    wire tick_1s, tick_1min, tick_1day;
    wire [5:0] sec_count;
    wire [3:0] min_ones, min_tens, hour_ones, hour_tens;
    wire [1:0] digit_sel;
    wire [3:0] current_digit;
    wire dp_state;

    wire btnU_pulse, btnD_pulse, btnL_pulse, btnR_pulse;

    wire [4:0] hour_24;
    wire [3:0] disp_hour_ones, disp_hour_tens;

    wire [11:0] year;
    wire [3:0] month_tens, month_ones, day_tens, day_ones;
    wire [2:0] weekday;
    wire [3:0] y3, y2, y1, y0;

    wire [3:0] d0, d1, d2, d3;

    wire time_set_mode, date_set_mode, year_set_mode;

    wire ring_trigger;

    // ---------------- 0. 스위치 조합으로 설정 모드 판별 ----------------
    mode_decoder u_mode(
        .sw_enable(sw[0]), .sw_date_disp(sw[1]), .sw_year_disp(sw[2]), .sw_set(sw[3]),
        .time_set_mode(time_set_mode), .date_set_mode(date_set_mode), .year_set_mode(year_set_mode)
    );

    // ---------------- 1. 버튼 Edge 검출 ----------------
    btn_edge_detect u_btn(
        .clk(clk),
        .btnU(btnU), .btnD(btnD), .btnL(btnL), .btnR(btnR),
        .btnU_pulse(btnU_pulse), .btnD_pulse(btnD_pulse),
        .btnL_pulse(btnL_pulse), .btnR_pulse(btnR_pulse)
    );

    // ---------------- 2. 1초/1분 Tick 생성 ----------------
    clock_divider_1s u_divider(
        .clk(clk), .reset(btnC), .enable(sw[0]),
        .tick_1s(tick_1s)
    );
    second_counter_60 u_second(
        .clk(clk), .reset(btnC), .tick_1s(tick_1s),
        .tick_1min(tick_1min), .sec_count(sec_count)
    );

    // ---------------- 3. HH:MM 시각 Counter ----------------
    clock_counter_hhmm u_clock(
        .clk(clk), .reset(btnC), .tick_1min(tick_1min),
        .set_mode(time_set_mode),
        .btnU_pulse(btnU_pulse), .btnD_pulse(btnD_pulse),
        .btnL_pulse(btnL_pulse), .btnR_pulse(btnR_pulse),
        .min_ones(min_ones), .min_tens(min_tens),
        .hour_ones(hour_ones), .hour_tens(hour_tens),
        .tick_1day(tick_1day)   // 모듈이 계산한 tick_1day를 그대로 사용 (top에서 재계산 X)
    );

    // ---------------- 4. 12/24시 표시 변환 ----------------
    hour_format_conv u_hour_fmt(
        .hour_tens(hour_tens), .hour_ones(hour_ones),
        .format_12h(sw[4]),
        .hour_24(hour_24),
        .disp_hour_tens(disp_hour_tens), .disp_hour_ones(disp_hour_ones)
    );

    // ---------------- 5. 날짜/요일 Counter ----------------
    date_counter u_date(
        .clk(clk), .reset(btnC), .tick_1day(tick_1day),
        .weekday(weekday),
        .mode_year_set(year_set_mode), .mode_date_set(date_set_mode),
        .btnU_pulse(btnU_pulse), .btnD_pulse(btnD_pulse),
        .btnL_pulse(btnL_pulse), .btnR_pulse(btnR_pulse),
        .year(year),
        .month_tens(month_tens), .month_ones(month_ones),
        .day_tens(day_tens), .day_ones(day_ones)
    );

    // ---------------- 6. 연도 BCD 변환 ----------------
    year_to_bcd u_year_bcd(
        .year(year),
        .y3(y3), .y2(y2), .y1(y1), .y0(y0)
    );

    // ---------------- 7. dp 1Hz Blink ----------------
    dp_blink_1hz u_dp_blink(
        .clk(clk), .reset(btnC), .enable(sw[0]),
        .dp_state(dp_state)
    );

    // ---------------- 8. 표시 모드 선택 (시간/날짜/연도) ----------------
    display_mux_select u_disp_sel(
        .mode_year(sw[2]), .mode_date(sw[1]), .set_mode(time_set_mode),
        .digit_sel(digit_sel), .dp_state(dp_state),
        .min_ones(min_ones), .min_tens(min_tens),
        .disp_hour_ones(disp_hour_ones), .disp_hour_tens(disp_hour_tens),
        .day_ones(day_ones), .day_tens(day_tens),
        .month_ones(month_ones), .month_tens(month_tens),
        .y0(y0), .y1(y1), .y2(y2), .y3(y3),
        .d0(d0), .d1(d1), .d2(d2), .d3(d3),
        .dp(dp)
    );

    // ---------------- 9. FND Scan / Mux / Decoder ----------------
    fnd_scan_counter u_scan(
        .clk(clk), .reset(btnC), .digit_sel(digit_sel)
    );
    fnd_mux_4digit u_mux(
        .digit0(d0), .digit1(d1), .digit2(d2), .digit3(d3),
        .digit_sel(digit_sel), .current_digit(current_digit), .an(an)
    );
    fnd_decoder u_decoder(
        .bcd(current_digit), .seg(seg)
    );

    // ---------------- 10. 확인용 LED / 요일 LED ----------------
    status_led_driver u_led(
        .tick_1s(tick_1s), .tick_1min(tick_1min),
        .sec_count(sec_count), .weekday(weekday),
        .led(led)
    );

    // ---------------- 11. 매시 50분 종소리 ----------------
    bell_trigger u_bell_trig(
        .clk(clk), .reset(btnC), .tick_1min(tick_1min),
        .min_tens(min_tens), .min_ones(min_ones),
        .ring_trigger(ring_trigger)
    );
    melody_player u_melody(
        .clk(clk), .reset(btnC),
        .play_trigger(ring_trigger),
        .pwm_out(buzzer)
    );

endmodule
