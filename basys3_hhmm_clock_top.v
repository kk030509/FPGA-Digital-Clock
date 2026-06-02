module basys3_hhmm_clock_top(input clk,           // Basys3 100MHz Clock
                             input btnC,          // Reset 버튼
                             input [15:0] sw,     // sw[0]: Enable
                            
                             input btnU,
                             input btnD,
                             input btnL,
                             input btnR,
                             output [15:0] led,   // 확인용 LED
                             output [6:0] seg,    // Segment 출력, Active-Low 
                             output [3:0] an, // Digit 선택, Active-Low 
                             output dp,
                             output [6:0] led_ext);
    wire tick_1s; // 1초 Tick
    wire tick_1min; // 1분 Tick
    wire tick_1day; // 하루 Tick
    wire [2:0] weekday;

    wire [5:0] sec_count; // 내부 초 Count
    wire [3:0] min_ones; // 1분 자리
    wire [3:0] min_tens; // 10분 자리
    wire [5:0] min = min_tens * 10 + min_ones;

    wire [3:0] hour_ones; // 1시간 자리
    wire [3:0] hour_tens; // 10시간 자리
    wire [1:0] digit_sel; // 현재 선택 Digit
    wire [3:0] current_digit; // 현재 표시 Digit
    wire dp_state; // 1Hz Duty 50% dp 신호

    wire [3:0] disp_hour_ones; //12-24 전환 1의자리
    wire [3:0] disp_hour_tens; //12-24 전환 10의자리

    reg btnU_d, btnD_d, btnL_d, btnR_d;
    always @(posedge clk) begin
        btnU_d <= btnU;
        btnD_d <= btnD;
        btnL_d <= btnL;
        btnR_d <= btnR;
    end
    wire [11:0] year;
    wire [3:0] mt, mo, dt, do;
    wire [3:0] y3, y2, y1, y0;
    assign y3 = year / 1000;
    assign y2 = (year % 1000) / 100;
    assign y1 = (year % 100) / 10;
    assign y0 = year % 10;

    wire btnU_pulse = btnU & ~btnU_d;
    wire btnD_pulse = btnD & ~btnD_d;
    wire btnL_pulse = btnL & ~btnL_d;
    wire btnR_pulse = btnR & ~btnR_d;

    wire [4:0] hour_24 = hour_tens *10 + hour_ones;
    wire [4:0] hour_12;
    assign hour_12 = (hour_24 ==0) ? 12 : (hour_24>12) ? hour_24 - 12 : hour_24;
    assign disp_hour_tens = sw[2] ? (hour_12 / 10) : hour_tens;
    assign disp_hour_ones = sw[2] ? (hour_12 % 10) : hour_ones;
    //요일 
    assign led_ext = 7'b0000001 << weekday;
    //날짜
    assign tick_1day = (hour_24 == 23 && min == 59 && tick_1min);

    // LED 확인 신호
    assign led[0]    = tick_1s; // 1 Clock 폭 Tick
    assign led[1]    = tick_1min; // 1 Clock 폭 Tick
    assign led[7:2]  = sec_count; // 내부 초 Count 표시
    assign led[15:8] = 8'd0; // 미사용 LED 0 고정
    // 시와 분 사이 dp만 1Hz Duty 50% 점멸
    assign dp = (sw[3]) ? 1'b1 :(digit_sel == 2'd2) ? (sw[1] ? 1'b0 : dp_state): 1'b1;

    wire [3:0] d0, d1, d2, d3;
    assign d0 = (sw[3]) ? y0 :(sw[4]) ? do :min_ones;
    assign d1 = (sw[3]) ? y1 :(sw[4]) ? dt :min_tens;
    assign d2 = (sw[3]) ? y2 : (sw[4]) ? mo : disp_hour_ones;
    assign d3 = (sw[3]) ? y3 : (sw[4]) ? mt :disp_hour_tens;

    // 1초 Tick 생성 모듈
    clock_divider_1s u_divider(
    .clk(clk),
    .reset(btnC),
    .enable(sw[0]),
    .tick_1s(tick_1s)
    );
    // 60초 Counter 모듈
    second_counter_60 u_second(
    .clk(clk),
    .reset(btnC),
    .tick_1s(tick_1s),
    .tick_1min(tick_1min),
    .sec_count(sec_count)
    );
    // HH:MM Counter 모듈
    clock_counter_hhmm u_clock(
    .clk(clk),
    .reset(btnC),
    .tick_1min(tick_1min),

    .set_mode(sw[1]),
    .btnU_pulse(btnU_pulse),
    .btnD_pulse(btnD_pulse),
    .btnL_pulse(btnL_pulse),
    .btnR_pulse(btnR_pulse),

    .min_ones(min_ones),
    .min_tens(min_tens),
    .hour_ones(hour_ones),
    .hour_tens(hour_tens)
    );
    // dp 1Hz Duty 50% Blink 모듈
    dp_blink_1hz u_dp_blink(
    .clk(clk),
    .reset(btnC),
    .enable(sw[0]),
    .dp_state(dp_state)
    );
    // FND Scan Counter 모듈
    fnd_scan_counter u_scan(
    .clk(clk),
    .reset(btnC),
    .digit_sel(digit_sel)
    );
    // FND Digit 선택 모듈
    fnd_mux_4digit u_mux(
    .digit0(d0),
    .digit1(d1),
    .digit2(d2),
    .digit3(d3),
    .digit_sel(digit_sel),
    .current_digit(current_digit),
    .an(an)
    );
    // FND Segment Decoder 모듈
    fnd_decoder u_decoder(
    .bcd(current_digit),
    .seg(seg)
    );
    //날짜세기
    date_counter u_date (
    .clk(clk),
    .reset(btnC),
    .tick_1day(tick_1day),
    .weekday(weekday),

    .mode_year_set(sw[5]),
    .mode_date_set(sw[6]),
    .btnU_pulse(btnU_pulse),
    .btnD_pulse(btnD_pulse),
    .btnL_pulse(btnL_pulse),
    .btnR_pulse(btnR_pulse),

    .year(year),
    .month_tens(mt),
    .month_ones(mo),
    .day_tens(dt),
    .day_ones(do)
);
endmodule
