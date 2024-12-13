//module mem_saida_seq(
//    input [18:0] endereco,          // Endereço de memória (para a imagem)
//    input clk,								// Sinal de clock
//    input reset,							// Sinal de reset
//	 input [1:0] control,				// Controle lateral do carro do jogador
//    output reg [23:0] data_out      // Saída de 24 bits para as cores (RGB)
//);
//	 
//    // Memória de 3 bits por pixel (640x480 pixels)
//    reg [2:0] memoria_fundo [0:640*480-1];
//    reg [2:0] memoria_carro [0:72*84-1];     // Carro de 72x84 pixels
//    reg [2:0] memoria_oponente1 [0:72*84-1]; // Carro oponente 1
//    reg [2:0] memoria_oponente2 [0:72*84-1]; // Carro oponente 2
//    reg [2:0] memoria_oponente3 [0:72*84-1]; // Carro oponente 3
//
//    // Localização e controle de movimento do carro
//    reg [9:0] carro_x;   // Coordenada X do carro do jogador (horizontal)
//    reg [8:0] carro_y;   // Coordenada Y do carro do jogador (vertical)
//
//    // Localização dos carros oponentes
//    reg [9:0] oponente1_x; // Coordenada X do oponente 1
//    reg [9:0] oponente2_x; // Coordenada X do oponente 2
//    reg [9:0] oponente3_x; // Coordenada X do oponente 3
//    reg [8:0] oponente1_y; // Coordenada Y do oponente 1
//    reg [8:0] oponente2_y; // Coordenada Y do oponente 2
//    reg [8:0] oponente3_y; // Coordenada Y do oponente 3
//
//    // Fios para coordenadas X e Y
//    wire [9:0] x;
//    wire [8:0] y;
//
//    assign x = endereco % 640;   // Cálculo da posição horizontal
//    assign y = endereco / 640;   // Cálculo da posição vertical
//
//// Atribui as cores com base no fundo, jogador e carros oponentes
//always @(*) begin
//    // Verifica se o pixel pertence ao jogador
//    if ((x >= carro_x && x < carro_x + 72) && (y >= carro_y && y < carro_y + 84)) begin
//        // Endereço do pixel dentro da memória do carro jogador
//        integer endereco_carro;
//        endereco_carro = (y - carro_y) * 72 + (x - carro_x);
//        if (memoria_carro[endereco_carro] == 3'b111) begin
//            // Mantém o fundo visível (transparência)
//            case (memoria_fundo[endereco])
//                3'b001: data_out = 24'h00FF00; // Verde (grama)
//                3'b010: data_out = 24'h404040; // Cinza (pista)
//                3'b011: data_out = 24'hFFFFFF; // Branco (faixa)
//                default: data_out = 24'h000000; // Preto
//            endcase
//        end else begin
//            // Desenha o jogador normalmente (sem transparência)
//            case (memoria_carro[endereco_carro])
//                3'b101: data_out = 24'h0000FF; // Vermelho
//                3'b000: data_out = 24'h000000; // Preto
//                3'b011: data_out = 24'hFFFFFF; // Branco
//                default: data_out = 24'h000000; // Preto
//            endcase
//        end
//    end 
//    // Verifica se o pixel pertence ao primeiro oponente
//    else if ((x >= oponente1_x && x < oponente1_x + 72) && 
//             (y >= oponente1_y && y < oponente1_y + 84)) begin
//        integer endereco_oponente1;
//        // Ajusta o endereço para lidar com coordenadas negativas
//        if (oponente1_y < 0) begin
//            endereco_oponente1 = (y - 0) * 72 + (x - oponente1_x);
//        end else begin
//            endereco_oponente1 = (y - oponente1_y) * 72 + (x - oponente1_x);
//        end
//        // Verifica se o pixel é transparente
//        if (memoria_carro[endereco_oponente1] == 3'b111) begin
//            case (memoria_fundo[endereco])
//                3'b001: data_out = 24'h00FF00; // Verde (grama)
//                3'b010: data_out = 24'h404040; // Cinza (pista)
//                3'b011: data_out = 24'hFFFFFF; // Branco (faixa)
//                default: data_out = 24'h000000; // Preto
//            endcase
//        end else begin
//            // Desenha o carro oponente normalmente
//            case (memoria_carro[endereco_oponente1])
//                3'b101: data_out = 24'h00A5FF; // Ciano
//                3'b000: data_out = 24'h000000; // Preto
//                3'b011: data_out = 24'hFFFFFF; // Branco
//                default: data_out = 24'h000000; // Preto
//            endcase
//        end
//    end 
//    // Verifica se o pixel pertence ao segundo oponente
//    else if ((x >= oponente2_x && x < oponente2_x + 72) && 
//             (y >= oponente2_y && y < oponente2_y + 84)) begin
//        integer endereco_oponente2;
//        if (oponente2_y < 0) begin
//            endereco_oponente2 = (y - 0) * 72 + (x - oponente2_x);
//        end else begin
//            endereco_oponente2 = (y - oponente2_y) * 72 + (x - oponente2_x);
//        end
//        if (memoria_carro[endereco_oponente2] == 3'b111) begin
//            case (memoria_fundo[endereco])
//                3'b001: data_out = 24'h00FF00; // Verde (grama)
//                3'b010: data_out = 24'h404040; // Cinza (pista)
//                3'b011: data_out = 24'hFFFFFF; // Branco (faixa)
//                default: data_out = 24'h000000; // Preto
//            endcase
//        end else begin
//            case (memoria_carro[endereco_oponente2])
//                3'b101: data_out = 24'hFF0000; // Azul
//                3'b000: data_out = 24'h000000; // Preto
//                3'b011: data_out = 24'hFFFFFF; // Branco
//                default: data_out = 24'h000000; // Preto
//            endcase
//        end
//    end 
//    // Verifica se o pixel pertence ao terceiro oponente
//    else if ((x >= oponente3_x && x < oponente3_x + 72) && 
//             (y >= oponente3_y && y < oponente3_y + 84)) begin
//        integer endereco_oponente3;
//        if (oponente3_y < 0) begin
//            endereco_oponente3 = (y - 0) * 72 + (x - oponente3_x);
//        end else begin
//            endereco_oponente3 = (y - oponente3_y) * 72 + (x - oponente3_x);
//        end
//        if (memoria_carro[endereco_oponente3] == 3'b111) begin
//            case (memoria_fundo[endereco])
//                3'b001: data_out = 24'h00FF00; // Verde (grama)
//                3'b010: data_out = 24'h404040; // Cinza (pista)
//                3'b011: data_out = 24'hFFFFFF; // Branco (faixa)
//                default: data_out = 24'h000000; // Preto
//            endcase
//        end else begin
//            case (memoria_carro[endereco_oponente3])
//                3'b101: data_out = 24'h00FF00; // Magenta
//                3'b000: data_out = 24'h000000; // Preto
//                3'b011: data_out = 24'hFFFFFF; // Branco
//                default: data_out = 24'h000000; // Preto
//            endcase
//        end
//    end 
//    // Desenha o fundo caso nenhum carro seja atingido
//    else begin
//        case (memoria_fundo[endereco])
//            3'b001: data_out = 24'h00FF00; // Verde (grama)
//            3'b010: data_out = 24'h404040; // Cinza (pista)
//            3'b011: data_out = 24'hFFFFFF; // Branco (faixa)
//            default: data_out = 24'h000000; // Preto
//        endcase
//    end
//end
//
//
//    // Inicializa a memória com os dados da pista e do carro
//    initial begin
//        // Carrega os dados binários da pista (fundo), do carro e dos oponentes
//        $readmemb("background.txt", memoria_fundo);
//        $readmemb("car_sprite.txt", memoria_carro);
//        $readmemb("car_sprite.txt", memoria_oponente1);
//        $readmemb("car_sprite.txt", memoria_oponente2);
//        $readmemb("car_sprite.txt", memoria_oponente3);
//
//        // Define as localizações iniciais do carro do jogador e dos oponentes
//        carro_x = 284;   // Posição inicial horizontal do carro do jogador
//        carro_y = 380;   // Posição fixa vertical do carro do jogador
//        oponente1_x = 178; // Posição inicial horizontal do oponente 1
//        oponente2_x = 284; // Posição inicial horizontal do oponente 2
//        oponente3_x = 391; // Posição inicial horizontal do oponente 3
//        oponente1_y = 150;  // Começa fora da tela no topo
//        oponente2_y = 0;  // Começa fora da tela no topo
//        oponente3_y = 340;  // Começa fora da tela no topo
//    end
//
//    // Lógica de movimentação vertical dos oponentes
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            // Reset na posição inicial do carro do jogador e oponentes
//            oponente1_y <= 150;
//            oponente2_y <= 0;
//            oponente3_y <= 340;
//        end else begin
//            // Movimentação dos oponentes (descendo)
//            if (oponente1_y < 480) oponente1_y <= oponente1_y + 7;
//            else oponente1_y <= 0; // Reposiciona o oponente no topo
//
//            if (oponente2_y < 480) oponente2_y <= oponente2_y + 7;
//            else oponente2_y <= 0; // Reposiciona o oponente no topo
//
//            if (oponente3_y < 480) oponente3_y <= oponente3_y + 7;
//            else oponente3_y <= 0; // Reposiciona o oponente no topo
//        end
//    end
//
//    // Lógica de movimentação horizontal do carro do jogador
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            // Reset na posição inicial
//            carro_x <= 240;
//        end else begin
//            case (control)
//                2'b10: begin
//                    // Movimento para a direita
//                    if (carro_x + 72 < 477) begin
//                        carro_x <= carro_x + 5;
//                    end
//                end
//                2'b01: begin
//                    // Movimento para a esquerda
//                    if (carro_x > 163) begin
//                        carro_x <= carro_x - 5;
//                    end
//                end
//                default: carro_x <= carro_x;
//            endcase
//        end
//    end
//endmodule
