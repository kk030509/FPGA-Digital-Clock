module weekday_calc(input [11:0] year,
                    input [3:0] month_tens,
                    input [3:0] month_ones,
                    input [3:0] day_tens,
                    input [3:0] day_ones,
                    output reg [2:0] weekday); // 0=일, 1=월, ..., 6=토
    wire [7:0] month = month_tens * 10 + month_ones;
    wire [7:0] day   = day_tens * 10 + day_ones;

    // Zeller 공식용 보정 (1,2월은 전년도의 13,14월로 취급)
    wire [3:0] m = (month < 3) ? month + 12 : month;
    wire [11:0] y = (month < 3) ? year - 1 : year;
    wire [11:0] K = y % 100;
    wire [11:0] J = y / 100;
    wire [3:0] h;
    // h: 0=토, 1=일, ..., 6=금
    assign h = (day + (13*(m+1))/5 + K + (K/4) + (J/4) + 5*J) % 7;

    always @(*) begin
        weekday = (h + 6) % 7; // 0=일요일 기준으로 보정
    end
endmodule
