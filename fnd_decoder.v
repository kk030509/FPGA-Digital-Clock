module fnd_decoder(
    input [3:0] bcd,          // 표시할 BCD 값
    output reg [6:0] seg);
    // BCD 값을 7-Segment 코드로 변환하는 블록
    always @(*) begin
        case (bcd)
            4'd0: seg    = 7'b1000000; // 숫자 0
            4'd1: seg    = 7'b1111001; // 숫자 1
            4'd2: seg    = 7'b0100100; // 숫자 2
            4'd3: seg    = 7'b0110000; // 숫자 3
            4'd4: seg    = 7'b0011001; // 숫자 4
            4'd5: seg    = 7'b0010010; // 숫자 5
            4'd6: seg    = 7'b0000010; // 숫자 6
            4'd7: seg    = 7'b1111000; // 숫자 7
            4'd8: seg    = 7'b0000000; // 숫자 8
            4'd9: seg    = 7'b0010000; // 숫자 9
            default: seg = 7'b1111111; // 예외값은 표시하지 않음
        endcase
    end
endmodule
