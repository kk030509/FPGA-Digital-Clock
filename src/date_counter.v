module date_counter(input clk,
                    input reset,
                    input tick_1day,
                    input mode_year_set,         // sw[5]
                    input mode_date_set,         // sw[6]
                    input btnU_pulse,
                    input btnD_pulse,
                    input btnL_pulse,
                    input btnR_pulse,
                    output reg [11:0] year,      // 2026
                    output reg [3:0] month_tens,
                    output reg [3:0] month_ones,
                    output reg [3:0] day_tens,
                    output reg [3:0] day_ones,
                    output [2:0] weekday
                    );

    wire [7:0] month = month_tens * 10 + month_ones;
    wire [7:0] day   = day_tens * 10 + day_ones;

    wire is_31, is_30, is_leap_year, last_day;

    // 달력 규칙(월별 일수, 윤년, 말일 판정)은 별도 모듈에서 계산
    calendar_utils u_cal(
        .year(year),
        .month_tens(month_tens), .month_ones(month_ones),
        .day_tens(day_tens), .day_ones(day_ones),
        .is_31(is_31), .is_30(is_30),
        .is_leap_year(is_leap_year), .last_day(last_day)
    );

    // 요일 계산도 별도 모듈에서 처리 (Zeller 공식)
    weekday_calc u_week(
        .year(year),
        .month_tens(month_tens), .month_ones(month_ones),
        .day_tens(day_tens), .day_ones(day_ones),
        .weekday(weekday)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            year       <= 2026;
            month_tens <= 0;
            month_ones <= 5;
            day_tens   <= 2;
            day_ones   <= 7;
            end
            else begin

            //시간 흐르면서 자동으로 하루 증가하는 경우
            if (tick_1day && !mode_year_set && !mode_date_set) begin
                if (last_day) begin //해당 월의 마지막 날인 경우, 일 변경
                    day_tens <= 0; //다시 1일로
                    day_ones <= 1;

                    // month increase
                    if (month == 12) begin //12월달인 경우 1년 추가 후 다시 1월로
                        month_tens <= 0;
                        month_ones <= 1;
                        year       <= year + 1;
                    end
                    else begin
                        if (month_ones == 9) begin //9월에서 10월 넘어가는 경우
                            month_ones <= 0;
                            month_tens <= month_tens + 1;
                        end
                        else begin //나머지 경우들
                            month_ones <= month_ones + 1;
                        end
                    end

                end
                else begin
                    // day +1
                    if (day_ones == 9) begin //9일에서 10일로 넘어가는 날
                        day_ones <= 0;
                        day_tens <= day_tens + 1;
                    end
                    else begin //나머지 날들
                        day_ones <= day_ones + 1;
                    end
                end
            end


            if (mode_year_set) begin //년도 수정
                if (btnU_pulse)
                    year <= year + 1;
                if (btnD_pulse)
                    year <= year - 1;
            end

            if (mode_date_set) begin //월, 일 수정
                if (btnU_pulse) begin//월 증가
                    if (month == 12) begin //12월에서 1월로
                        month_tens <= 0;
                        month_ones <= 1;
                    end
                    else begin
                        if (month_ones == 9) begin //9월에서 10월로
                            month_ones <= 0;
                            month_tens <= month_tens + 1;
                        end
                        else begin
                            month_ones <= month_ones + 1;
                        end
                    end
                end

                if (btnL_pulse) begin //월 감소
                    if (month == 1) begin //1월에서 12월로
                        month_tens <= 1;
                        month_ones <= 2;
                    end
                    else begin
                        if (month_ones == 0) begin //10의자리 바뀌는 경우
                            month_ones <= 9;
                            month_tens <= month_tens - 1;
                        end
                        else begin
                            month_ones <= month_ones - 1;
                        end
                    end
                end


                // 일 변경
                else begin
                if (btnR_pulse) begin
                    if (last_day) begin //30,31일인 경우 1일로
                        day_tens <= 0;
                        day_ones <= 1;
                    end
                    else begin
                        if (day_ones == 9) begin //9에서 10으로
                            day_ones <= 0;
                            day_tens <= day_tens + 1;
                        end
                        else begin
                            day_ones <= day_ones + 1;
                        end
                    end
                end

                if (btnD_pulse) begin
                    if (day == 1) begin //1에서 31일로
                        if ( is_30 == 1 ) begin
                            day_tens <= 3;
                            day_ones <= 0;
                        end
                        else if (is_31 ==1 )begin
                            day_tens <= 3;
                            day_ones <= 1;
                        end
                        else begin
                            if (is_leap_year == 1)begin
                                day_tens <= 2;
                                day_ones <= 9;
                            end
                            else begin
                                day_tens <= 2;
                                day_ones <= 8;
                            end
                        end
                    end
                    else begin
                        if (day_ones == 0) begin
                            day_ones <= 9;
                            day_tens <= day_tens - 1;
                        end
                        else begin
                            day_ones <= day_ones - 1;
                        end
                    end
                end
            end
        end

    end
    end

endmodule
