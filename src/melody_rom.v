module melody_rom(input [4:0] step,          // 몇 번째 음인지 (0 ~ NUM_NOTES-1)
                  output reg [31:0] half_period); // 그 음의 반주기 Clock 수 (0=쉼표/무음)

    // CLK_FREQ = 100MHz(Basys3) 기준, half_period = CLK_FREQ / (주파수 * 2)
    localparam C4 = 32'd190_840; // 262Hz  도
    localparam D4 = 32'd170_068; // 294Hz  레
    localparam E4 = 32'd151_515; // 330Hz  미
    localparam F4 = 32'd143_266; // 349Hz  파 (이번 곡에서는 안 씀)
    localparam G4 = 32'd127_551; // 392Hz  솔
    localparam A4 = 32'd113_636; // 440Hz  라
    localparam REST = 32'd0;      // 쉼표(무음)

    // "학교종이 땡땡땡" 계이름: 솔솔라라 솔솔미 / 솔솔미미레 / 솔솔라라 솔솔미 / 솔미레미도
    always @(*) begin
        case (step)
            5'd0:  half_period = G4; // 솔
            5'd1:  half_period = G4; // 솔
            5'd2:  half_period = A4; // 라
            5'd3:  half_period = A4; // 라
            5'd4:  half_period = G4; // 솔
            5'd5:  half_period = G4; // 솔
            5'd6:  half_period = E4; // 미
            5'd7:  half_period = G4; // 솔
            5'd8:  half_period = G4; // 솔
            5'd9:  half_period = E4; // 미
            5'd10: half_period = E4; // 미
            5'd11: half_period = D4; // 레
            5'd12: half_period = G4; // 솔
            5'd13: half_period = G4; // 솔
            5'd14: half_period = A4; // 라
            5'd15: half_period = A4; // 라
            5'd16: half_period = G4; // 솔
            5'd17: half_period = G4; // 솔
            5'd18: half_period = E4; // 미
            5'd19: half_period = G4; // 솔
            5'd20: half_period = E4; // 미
            5'd21: half_period = D4; // 레
            5'd22: half_period = E4; // 미
            5'd23: half_period = C4; // 도
            default: half_period = REST;
        endcase
    end
endmodule

