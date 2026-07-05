module year_to_bcd(input [11:0] year,   // 예: 2026
                   output [3:0] y3,     // 천의 자리
                   output [3:0] y2,     // 백의 자리
                   output [3:0] y1,     // 십의 자리
                   output [3:0] y0);    // 일의 자리
    // 나눗셈/나머지로 자리수 분해
    assign y3 = year / 1000;
    assign y2 = (year % 1000) / 100;
    assign y1 = (year % 100) / 10;
    assign y0 = year % 10;
endmodule
