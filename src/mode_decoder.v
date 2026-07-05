module mode_decoder(input sw_enable,     // sw[0]: 시계 동작(Enable)
                    input sw_date_disp,  // sw[1]: 날짜 표시
                    input sw_year_disp,  // sw[2]: 연도 표시
                    input sw_set,        // sw[3]: 설정 모드 (다른 스위치와 조합)
                    output time_set_mode, // sw[0] & sw[3] -> 시간 설정
                    output date_set_mode, // sw[1] & sw[3] -> 날짜 설정
                    output year_set_mode);// sw[2] & sw[3] -> 연도 설정
    // 표시 중인 대상(sw_enable/date/year)과 설정 스위치(sw_set)를
    // AND 조합해서 "지금 무엇을 설정할지"를 하나로 결정
    assign time_set_mode = sw_enable    & sw_set;
    assign date_set_mode = sw_date_disp & sw_set;
    assign year_set_mode = sw_year_disp & sw_set;
endmodule
