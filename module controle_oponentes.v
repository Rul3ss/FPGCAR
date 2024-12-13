module controle_oponentes(
    input clk,
    input reset,
    output reg [9:0] oponente1_x,
    output reg [8:0] oponente1_y,
    output reg [9:0] oponente2_x,
    output reg [8:0] oponente2_y,
    output reg [9:0] oponente3_x,
    output reg [8:0] oponente3_y
);
    initial begin
        oponente1_x = 178; oponente1_y = 150;
        oponente2_x = 284; oponente2_y = 0;
        oponente3_x = 391; oponente3_y = 340;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            oponente1_y <= 150;
            oponente2_y <= 0;
            oponente3_y <= 340;
        end else begin
            oponente1_y <= (oponente1_y < 480) ? oponente1_y + 7 : 0;
            oponente2_y <= (oponente2_y < 480) ? oponente2_y + 7 : 0;
            oponente3_y <= (oponente3_y < 480) ? oponente3_y + 7 : 0;
        end
    end
endmodule
