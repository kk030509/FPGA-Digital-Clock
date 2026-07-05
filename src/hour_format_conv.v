module hour_format_conv(input [3:0] hour_tens,
                        input [3:0] hour_ones,
                        input format_12h,          // sw[2]: 1이면 12시간제 표시
                        output [4:0] hour_24,       // 0~23 값 (다른 모듈에서 재사용 가능)
                        output [3:0] disp_hour_tens,
                        output [3:0] disp_hour_ones);
    wire [4:0] hour_12;
    assign hour_24 = hour_tens * 10 + hour_ones;
    // 0시->12, 13~23시->1~11시로 변환
    assign hour_12 = (hour_24 == 0) ? 12 : (hour_24 > 12) ? hour_24 - 12 : hour_24;
    assign disp_hour_tens = format_12h ? (hour_12 / 10) : hour_tens; //십의자리는 나눈 값
    assign disp_hour_ones = format_12h ? (hour_12 % 10) : hour_ones; //일의자리는 나머지
endmodule
