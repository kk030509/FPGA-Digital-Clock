module clock_counter_hhmm(input clk,                   // 기준 Clock
                          input reset,                 // 동기 Reset
                          input tick_1min,             // 1분 Tick Enable
                          
                          input set_mode,     // 설정 모드 (sw[1])
                          input btnU_pulse,   // 시 증가
                          input btnD_pulse,    // 분 증가
                          input btnL_pulse,
                          input btnR_pulse,
                          
                          output reg [3:0] min_ones,   // 1분 자리, 0~9
                          output reg [3:0] min_tens,   // 10분 자리, 0~5
                          output reg [3:0] hour_ones,  // 1시간 자리
                          output reg [3:0] hour_tens,
                          output tick_1day); // 10시간 자리, 0~2
    wire carry_min_ones; // 1분 자리 Carry 조건
    wire carry_min_tens; // 59분 Carry 조건
    wire _time; // 23:59 조건
    // 현재 시간값 기준 Carry 조건 생성
    assign carry_min_ones = (min_ones == 4'd9);
    assign carry_min_tens = (min_ones == 4'd9) && (min_tens == 4'd5);
    assign last_time = (hour_tens == 4'd2) && (hour_ones == 4'd3) 
    &&(min_tens == 4'd5) && (min_ones== 4'd9);
    //하루 증가하는 경우 틱 발생
    assign tick_1day = last_time && tick_1min;
    // HH:MM Count 증가 블록
    always @(posedge clk) begin
        if (reset) begin
            min_ones  <= 4'd0; // 1분 자리 초기화
            min_tens  <= 4'd0; // 10분 자리 초기화
            hour_ones <= 4'd0; // 1시간 자리 초기화
            hour_tens <= 4'd0; // 10시간 자리 초기화
        end
        else begin

            if (set_mode) begin
                if (btnU_pulse) begin //시 증가
                    if (hour_tens == 2&& hour_ones ==3) begin //23시에서 00시
                        hour_tens <= 0;
                        hour_ones <= 0;
                    end
                    else if (hour_ones == 9) begin //9시에서 10시
                        hour_ones <= 0;
                        hour_tens <= hour_tens +1;
                    end
                    else begin //나머지
                        hour_ones <= hour_ones +1;
                    end
                end
            
                if (btnR_pulse) begin //분 증가
                    if (min_tens ==5 && min_ones == 9) begin //59분에서 00분
                        min_tens <=0;
                        min_ones <=0;
                    end
                    else if (min_ones == 9)begin //9분에서 10분
                        min_ones <= 0;
                        min_tens <= min_tens +1;
                    end
                    else begin
                        min_ones <= min_ones + 1;
                    end
                end
                if (btnL_pulse) begin
                    if (hour_tens == 0 && hour_ones == 0) begin //00시에서 23시
                        hour_tens <= 2;
                        hour_ones <= 3;   // 00 → 23
                    end
                    else if (hour_ones == 0) begin 
                        hour_ones <= 9;
                        hour_tens <= hour_tens - 1;
                    end
                    else begin
                        hour_ones <= hour_ones - 1;
                    end
                end
                if (btnD_pulse) begin
                    if (min_tens == 0 && min_ones == 0) begin
                        min_tens <= 5;
                        min_ones <= 9;   // 00 → 59
                    end
                    else if (min_ones == 0) begin
                        min_ones <= 9;
                        min_tens <= min_tens - 1;
                    end
                    else begin
                        min_ones <= min_ones - 1;
                    end
                end

            end
            else begin
                if (tick_1min) begin // 1분 Tick에서만 시간 값 변경
                    if (last_time) begin
                        min_ones <= 4'd0; // 23:59 다음 00:00
                        min_tens  <= 4'd0;
                        hour_ones <= 4'd0;
                        hour_tens <= 4'd0;
                    end
                    else begin
                        min_ones <= carry_min_ones ? 4'd0 :min_ones + 1'b1;
                        //min_ones에 캐리 발생하면 0, 아니면 1씩 더하기. 12줄에 min_ones가 9인 경우 캐리발생
                        if (carry_min_ones)
                            min_tens <= (min_tens == 4'd5)? 4'd0 : min_tens + 1'b1;
                            //10의자리는 5넘으면 다시 0으로, 아니면 1씩 더하기
                            if (carry_min_tens) begin //59분일 때 캐리 발생
                                if (hour_ones == 4'd9) begin
                                    hour_ones <= 4'd0;
                                    // 09:59, 19:59 다음 Carry
                                    hour_tens <= hour_tens + 1'b1;
                                end
                                else begin
                                    hour_ones <= hour_ones +1'b1; // 일반 시간 증가
                                end
                        end
                    end
                end
            end
        end
      end
endmodule
