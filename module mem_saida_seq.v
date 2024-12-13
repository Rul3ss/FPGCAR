module mem_saida_seq(
    input [18:0] endereco,
    input clk,
    input reset,
    input [1:0] control,
    output [23:0] data_out
);
    wire [2:0] fundo, jogador, oponente1, oponente2, oponente3;
    wire [9:0] carro_x, oponente1_x, oponente2_x, oponente3_x;
    wire [8:0] carro_y, oponente1_y, oponente2_y, oponente3_y;

    memoria mem_inst(endereco, fundo, jogador, oponente1, oponente2, oponente3);
    controle_carro jogador_ctrl(clk, reset, control, carro_x, carro_y);
    controle_oponentes op_ctrl(clk, reset, oponente1_x, oponente1_y, oponente2_x, oponente2_y, oponente3_x, oponente3_y);

    renderizacao render_inst(
        endereco % 640, endereco / 640,
        fundo, jogador, oponente1, oponente2, oponente3,
        data_out
    );
endmodule
