`timescale 1ns/1ps

module tb_date_counter;

    reg clk;
    reg reset;
    reg tick_1day;

    reg mode_year_set;
    reg mode_date_set;

    reg btnU_pulse;
    reg btnD_pulse;
    reg btnL_pulse;
    reg btnR_pulse;

    wire [11:0] year;
    wire [3:0] mt, mo, dt, do;
    wire [2:0] weekday;


    // DUT
    date_counter uut (
        .clk(clk),
        .reset(reset),
        .tick_1day(tick_1day),

        .mode_year_set(mode_year_set),
        .mode_date_set(mode_date_set),

        .btnU_pulse(btnU_pulse),
        .btnD_pulse(btnD_pulse),
        .btnL_pulse(btnL_pulse),
        .btnR_pulse(btnR_pulse),

        .year(year),
        .month_tens(mt),
        .month_ones(mo),
        .day_tens(dt),
        .day_ones(do),
        .weekday(weekday)
    );

    // 클럭 생성 (10ns 주기)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;

        tick_1day = 0;
        mode_year_set = 0;
        mode_date_set = 0;
        btnU_pulse = 0;
        btnD_pulse = 0;
        btnL_pulse = 0;
        btnR_pulse = 0;

        #20;
        reset = 0;

        //하루 증가 테스트
        #20;
        tick_1day = 1;
        #10;
        tick_1day = 0;

        // 년도 증가 테스트, 증가 후 감소
        #20;
        mode_year_set = 1;
        btnU_pulse = 1; #10;
        btnU_pulse = 0;

        #20;
        btnD_pulse = 1; #10;
        btnD_pulse = 0;
        mode_year_set = 0;

        // 월 증가
        #20;
        mode_date_set = 1;
        btnU_pulse = 1; #10;
        btnU_pulse = 0;

        // 일 증가 후 감소
        #20;
        btnR_pulse = 1; #10;
        btnR_pulse = 0;

        #20;
        btnD_pulse = 1; #10;
        btnD_pulse = 0;

        mode_date_set = 0;
        //하루씩 틱 발생시키며 일 증가
        repeat(5) begin
            #20;
            tick_1day = 1; #10;
            tick_1day = 0;
        end
#100;
        $stop;
    end

endmodule
