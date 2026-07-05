//버튼 4개 동기화, 엣지(펄스) 검출
module btn_edge_detect(input clk,          // 기준 Clock
                       input btnU,
                       input btnD,
                       input btnL,
                       input btnR,
                       output btnU_pulse,   // 상승 Edge에서 1 Clock 폭 Pulse
                       output btnD_pulse,
                       output btnL_pulse,
                       output btnR_pulse);
    reg btnU_d, btnD_d, btnL_d, btnR_d;
    // 버튼 입력 1clk 지연 (Edge 검출용)
    always @(posedge clk) begin
        btnU_d <= btnU;
        btnD_d <= btnD;
        btnL_d <= btnL;
        btnR_d <= btnR;
    end
    // 이전값이 0, 현재값이 1인 순간만 1 Clock Pulse 발생
    assign btnU_pulse = btnU & ~btnU_d;
    assign btnD_pulse = btnD & ~btnD_d;
    assign btnL_pulse = btnL & ~btnL_d;
    assign btnR_pulse = btnR & ~btnR_d;
endmodule
