module mem_saida_seq(
    input [18:0] endereco,
    input clk,
    input reset,
    input [1:0] control,
    output reg [23:0] data_out,
    output reg [17:0] score,
    output reg [3:0] level
);

    // Memória de 3 bits por pixel (640x480 pixels)
    reg [2:0] memoria_fundo [0:640*480-1];
    reg [2:0] memoria_carro [0:72*84-1];
    reg [2:0] memoria_oponente [0:72*84-1];

    // Coordenadas do jogador e do oponente
    reg [9:0] carro_x;
    reg [8:0] carro_y;
    reg [9:0] oponente_x;
    reg [8:0] oponente_y;

    // Gerador de números pseudo-aleatórios usando Xorshift
    reg [31:0] rng;

    // Fios para coordenadas X e Y
    wire [9:0] x;
    wire [8:0] y;

    assign x = endereco % 640;
    assign y = endereco / 640;

    // Renderiza as cores com base em transparência e prioridade de jogador -> oponente -> fundo
    always @(*) begin
        // Inicializa a saída com o fundo
        case (memoria_fundo[endereco])
            3'b001: data_out = 24'h00FF00; // Verde (grama)
            3'b010: data_out = 24'h404040; // Cinza (pista)
            3'b011: data_out = 24'hFFFFFF; // Branco (faixa)
            default: data_out = 24'h000000; // Preto
        endcase

        // Verifica se o pixel pertence ao jogador
        if ((x >= carro_x && x < carro_x + 72) && (y >= carro_y && y < carro_y + 84)) begin
            integer endereco_carro;
            endereco_carro = (y - carro_y) * 72 + (x - carro_x);
            if (memoria_carro[endereco_carro] != 3'b111) begin
                case (memoria_carro[endereco_carro])
                    3'b101: data_out = 24'h0000FF; // Vermelho (jogador)
                    3'b000: data_out = 24'h000000; // Preto
                    3'b011: data_out = 24'hFFFFFF; // Branco
                    default: data_out = 24'h000000; // Preto
                endcase
            end
        end else if ((x >= oponente_x && x < oponente_x + 72) && (y >= oponente_y && y < oponente_y + 84)) begin
            integer endereco_oponente;
            endereco_oponente = (y - oponente_y) * 72 + (x - oponente_x);
            if (memoria_carro[endereco_oponente] != 3'b111) begin
                if ((oponente_x > 162) && (oponente_x < 265)) begin
                    case (memoria_carro[endereco_oponente])
                        3'b101: data_out = 24'h00B0FF; // Laranja (oponente)
                        3'b000: data_out = 24'h000000; // Preto
                        3'b011: data_out = 24'hFFFFFF; // Branco
                        default: data_out = 24'h000000; // Preto
                    endcase
                end else if ((oponente_x > 267) && (oponente_x < 373)) begin
                    case (memoria_carro[endereco_oponente])
                        3'b101: data_out = 24'hFF0000; // Azul (oponente)
                        3'b000: data_out = 24'h000000; // Preto
                        3'b011: data_out = 24'hFFFFFF; // Branco
                        default: data_out = 24'h000000; // Preto
                    endcase
                end else begin
                    case (memoria_carro[endereco_oponente])
                        3'b101: data_out = 24'h00FF00; // Verde (oponente)
                        3'b000: data_out = 24'h000000; // Preto
                        3'b011: data_out = 24'hFFFFFF; // Branco
                        default: data_out = 24'h000000; // Preto
                    endcase
                end
            end
        end
    end

    // Inicialização
    initial begin
        $readmemb("background.txt", memoria_fundo);
        $readmemb("car_sprite.txt", memoria_carro);
        $readmemb("car_sprite.txt", memoria_oponente);
        carro_x = 284;
        carro_y = 380;
        oponente_x = 284;
        oponente_y = 0;
        rng = 32'hACE1; // Seed inicial para RNG
    end

    // RNG baseado em Xorshift
    always @(posedge clk or posedge reset) begin
        if (reset)
            rng <= 32'hACE1; // Seed de reset
        else
            rng <= {rng[30:0], rng[31] ^ rng[21] ^ rng[1] ^ rng[0]}; // Xorshift PRNG
    end

    // Movimento do jogador
    always @(posedge clk or posedge reset) begin
        if (reset)
            carro_x <= 284;
        else if (!colisao) begin
            case (control)
                2'b10: if (carro_x + 72 < 478) carro_x <= carro_x + 5; // Direita
                2'b01: if (carro_x > 163) carro_x <= carro_x - 5; // Esquerda
            endcase
        end
    end

    // Movimento do oponente
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            oponente_y <= 0;
            oponente_x <= 284;
        end else if (!colisao) begin
            if (oponente_y < 480) begin
                case (level)
                    4'b1000: oponente_y <= oponente_y + 6;
                    4'b1100: oponente_y <= oponente_y + 8;
                    4'b1110: oponente_y <= oponente_y + 11;
                    4'b1111: oponente_y <= oponente_y + 14;
                endcase
            end else begin
                // Reseta o oponente e incrementa o score
                oponente_y <= 0;
                oponente_x <= 178 + (rng[15:0] % 3) * 106; // Alinha com as pistas
            end
        end
    end

    // Colisão
    reg colisao;

    always @(posedge clk or posedge reset) begin
        if (reset)
            colisao <= 0;
        else
            colisao <= (oponente_y + 84 > 380) &&
                       ((carro_x <= oponente_x && oponente_x < carro_x + 72) ||
                       (oponente_x <= carro_x && carro_x < oponente_x + 72));
    end
	 
	 // Sistema de pontuação e dificuldade
	 always @(posedge clk or posedge reset) begin
			 if (reset) begin
				  score <= 18'b0;
				  level <= 4'b1000;
			 end else if (score == 18'b111111111111111111) begin
				  if (level < 4'b1111)
						level <= {1'b1, level[3:1]};
				  score <= 18'b0;
			 end else if (!colisao && (oponente_y >= 480)) score <= {1'b1, score[17:1]};
	 end

endmodule
