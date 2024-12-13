module controle_carro(
    input clk,
    input reset,
    input [1:0] control,
    output reg [9:0] carro_x,
    output reg [8:0] carro_y
);
    initial begin
        carro_x = 240;
        carro_y = 380;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            carro_x <= 240;
        end else begin
            case (control)
                2'b10: if (carro_x + 72 < 477) carro_x <= carro_x + 5;
                2'b01: if (carro_x > 163) carro_x <= carro_x - 5;
                default: carro_x <= carro_x;
            endcase
        end
    end
endmodule
