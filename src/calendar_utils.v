module calendar_utils(input [11:0] year,
                      input [3:0] month_tens,
                      input [3:0] month_ones,
                      input [3:0] day_tens,
                      input [3:0] day_ones,
                      output is_31,          // 31일까지 있는 달인지
                      output is_30,          // 30일까지 있는 달인지
                      output is_leap_year,   // 윤년인지
                      output last_day);      // 오늘이 그 달의 마지막 날인지
    wire [7:0] month = month_tens * 10 + month_ones;
    wire [7:0] day   = day_tens * 10 + day_ones;

    // 31일인 달
    assign is_31 =
        (month == 1)||(month == 3)||(month == 5)||(month == 7)||
        (month == 8)||(month == 10)||(month == 12);
    // 30일인 달
    assign is_30 =
        (month == 4)||(month == 6)||(month == 9)||(month == 11);

    // 윤년 계산 (4의 배수이면서 100의 배수가 아니거나, 400의 배수)
    assign is_leap_year =
        (year % 4 == 0 && year % 100 != 0) ||
        (year % 400 == 0);

    // 오늘이 해당 월의 마지막 날인지 판정 (2월은 윤년 여부에 따라 28/29일)
    assign last_day =
        (is_31 && day == 31) ||
        (is_30 && day == 30) ||
        (month == 2 && day == (is_leap_year ? 29 : 28));
endmodule
