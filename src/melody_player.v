module melody_player #(
    parameter NUM_NOTES       = 24,          // melody_rom에 들어있는 음 개수 (학교종 = 24음)
    parameter NOTE_LEN_CYCLES = 32'd15_000_000, // 한 음의 재생 길이 (100MHz 기준 0.15초)
    parameter GAP_CYCLES      = 32'd1_500_000   // 음과 음 사이 끊어주는 짧은 무음 (0.015초)
)(
    input clk,
    input reset,
    input play_trigger,   // bell_trigger의 1clk Pulse, 곡 재생 시작 신호
    output pwm_out         // 부저로 나가는 사각파
);
    localparam IDLE = 2'd0, PLAY_NOTE = 2'd1, GAP = 2'd2;
    reg [1:0]  state;
    reg [4:0]  step;
    reg [31:0] timer;
    reg        note_on;
    wire [31:0] half_period;

    melody_rom u_rom(.step(step), .half_period(half_period));
    pwm_tone_gen u_tone(
        .clk(clk), .reset(reset),
        .note_on(note_on), .half_period(half_period),
        .pwm_out(pwm_out)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state   <= IDLE;
            step    <= 0;
            timer   <= 0;
            note_on <= 1'b0;
        end
        else begin
            case (state)
                // 대기 상태, play_trigger 오면 첫 음부터 재생 시작
                IDLE: begin
                    note_on <= 1'b0;
                    if (play_trigger) begin
                        step    <= 0;
                        timer   <= 0;
                        note_on <= 1'b1;
                        state   <= PLAY_NOTE;
                    end
                end

                // 현재 step의 음을 NOTE_LEN_CYCLES 동안 재생
                PLAY_NOTE: begin
                    note_on <= 1'b1;
                    if (timer >= NOTE_LEN_CYCLES - 1) begin
                        timer   <= 0;
                        note_on <= 1'b0;
                        state   <= GAP;
                    end
                    else begin
                        timer <= timer + 1'b1;
                    end
                end

                // 음 사이 짧은 끊김(Articulation) 구간
                GAP: begin
                    note_on <= 1'b0;
                    if (timer >= GAP_CYCLES - 1) begin
                        timer <= 0;
                        if (step == NUM_NOTES - 1) begin
                            state <= IDLE;          // 마지막 음까지 다 재생함
                        end
                        else begin
                            step    <= step + 1'b1;
                            note_on <= 1'b1;
                            state   <= PLAY_NOTE;
                        end
                    end
                    else begin
                        timer <= timer + 1'b1;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end
endmodule
