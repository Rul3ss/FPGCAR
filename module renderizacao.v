module renderizacao(
    input [9:0] x,
    input [8:0] y,
    input [2:0] fundo,
    input [2:0] jogador,
    input [2:0] oponente1,
    input [2:0] oponente2,
    input [2:0] oponente3,
    output reg [23:0] data_out
);
    always @(*) begin
        if (jogador != 3'b111) begin
            case (jogador)
                3'b101: data_out = 24'h0000FF; // Vermelho
                3'b000: data_out = 24'h000000; // Preto
                default: data_out = 24'hFFFFFF; // Branco
            endcase
        end else if (oponente1 != 3'b111) begin
            case (oponente1)
                3'b101: data_out = 24'h00A5FF; // Ciano
                default: data_out = 24'hFFFFFF;
            endcase
        end else begin
            case (fundo)
                3'b001: data_out = 24'h00FF00; // Verde
                3'b010: data_out = 24'h404040; // Cinza
                default: data_out = 24'h000000; // Preto
            endcase
        end
    end
endmodule
