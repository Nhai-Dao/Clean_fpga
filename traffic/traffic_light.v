`timescale 1ns/1ps
module traffic_light (
    input  wire clk,
    input  wire rst_n,
    output reg  red,
    output reg  green,
    output reg  yellow
);

  // ─── State encoding ───────────────────────────
  localparam STATE_RED    = 2'b00;
  localparam STATE_GREEN  = 2'b01;
  localparam STATE_YELLOW = 2'b10;

  // ─── State register + counter ─────────────────
  reg [1:0]  current_state;
  reg [1:0]  next_state;
  reg [11:0] state_timer;  // 12 bit đủ đếm đến 3000

  // ─── Block 1: State Register (D FF) ───────────
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      current_state <= STATE_RED;
      state_timer   <= 0;
    end
    else begin
      if (current_state != next_state) begin
        // Chuyển state → reset state_timer
        current_state <= next_state;
        state_timer   <= 0;
      end
      else begin
        // Giữ state → đếm tiếp
        current_state <= current_state;
        state_timer   <= state_timer + 1;
      end
    end
  end

  // ─── Block 2: Next State Logic (LUT) ──────────
  always @(*) begin
    case (current_state)
      STATE_RED:    next_state = (state_timer >= 3000) ? STATE_GREEN  : STATE_RED;
      STATE_GREEN:  next_state = (state_timer >= 2500) ? STATE_YELLOW : STATE_GREEN;
      STATE_YELLOW: next_state = (state_timer >= 500)  ? STATE_RED    : STATE_YELLOW;
      default:      next_state = STATE_RED;
    endcase
  end

  // ─── Block 3: Output Logic (LUT) ──────────────
  always @(*) begin
    // Default về 0 trước — tránh latch
    red    = 0;
    green  = 0;
    yellow = 0;

    case (current_state)
      STATE_RED:    red    = 1;
      STATE_GREEN:  green  = 1;
      STATE_YELLOW: yellow = 1;
    endcase
  end

endmodule