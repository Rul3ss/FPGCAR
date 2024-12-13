module memoria(
    input [18:0] endereco,
    output reg [2:0] dado_fundo,
    output reg [2:0] dado_carro,
    output reg [2:0] dado_oponente1,
    output reg [2:0] dado_oponente2,
    output reg [2:0] dado_oponente3
);
    reg [2:0] memoria_fundo [0:640*480-1];
    reg [2:0] memoria_carro [0:72*84-1];
    reg [2:0] memoria_oponente1 [0:72*84-1];
    reg [2:0] memoria_oponente2 [0:72*84-1];
    reg [2:0] memoria_oponente3 [0:72*84-1];

    initial begin
        $readmemb("background.txt", memoria_fundo);
        $readmemb("car_sprite.txt", memoria_carro);
        $readmemb("car_sprite.txt", memoria_oponente1);
        $readmemb("car_sprite.txt", memoria_oponente2);
        $readmemb("car_sprite.txt", memoria_oponente3);
    end

    always @(*) begin
        dado_fundo = memoria_fundo[endereco];
        dado_carro = memoria_carro[endereco % (72 * 84)];
        dado_oponente1 = memoria_oponente1[endereco % (72 * 84)];
        dado_oponente2 = memoria_oponente2[endereco % (72 * 84)];
        dado_oponente3 = memoria_oponente3[endereco % (72 * 84)];
    end
endmodule
