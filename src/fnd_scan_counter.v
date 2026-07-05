module fnd_scan_counter(input clk,                   // 기준 Clock
                        input reset,                 // 동기 Reset
                        output reg [1:0] digit_sel); // 현재 선택 Digit
    reg [15:0] scan_count;
    always @(posedge clk) begin
        if (reset) begin
            scan_count <= 16'd0; // Scan Count 초기화
            digit_sel  <= 2'd0; // digit0부터
        end
        else begin
            if (scan_count == 16'd49_999) begin
                scan_count <= 16'd0; // Scan 주기 도달
                digit_sel <= digit_sel + 1'b1; // 다음 Digit 선택
            end
            else begin
                scan_count <= scan_count + 1'b1; // Sca n Count 증가
            end
        end
    end
endmodule
