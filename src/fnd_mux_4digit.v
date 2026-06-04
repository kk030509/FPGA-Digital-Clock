module fnd_mux_4digit(input [3:0] digit0,                    // 1분 자리
                      input [3:0] digit1,                    // 10분 자리
                      input [3:0] digit2,                    // 1시간 자리
                      input [3:0] digit3,                    // 10시간 자리
                      input [1:0] digit_sel,                 // 현재 선택 Digit
                      output reg [3:0] current_digit,        // Decoder로 보낼 BCD 값 
                      output reg [3:0] an);
    // 선택된 Digit과 an 출력 블록
    always @(*) begin
        current_digit = 4'd0; // 기본 표시값
        an            = 4'b1111; // 기본은 모든 Digit OFF
        case (digit_sel)
            2'd0: begin
                current_digit = digit0; // 1분 자리 선택
                an            = 4'b1110; // 오른쪽 1번째 Digit ON
            end
            2'd1: begin
                current_digit = digit1; // 10분 자리 선택
                an            = 4'b1101; // 오른쪽 2번째 Digit ON
            end
            2'd2: begin
                current_digit = digit2; // 1시간 자리 선택
                an = 4'b1011; // 오른쪽 3번째 Digit ON
            end
            2'd3: begin
                current_digit = digit3; // 10시간 자리 선택
                an = 4'b0111; // 오른쪽 4번째 Digit ON
            end
        endcase
    end
endmodule
