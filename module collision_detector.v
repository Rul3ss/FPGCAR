//module collision_detector (
//    input [15:0] car1_x,     // Posição X do carro 1
//    input [15:0] car1_y,     // Posição Y do carro 1
//    input [15:0] car2_x,     // Posição X do carro 2
//    input [15:0] car2_y,     // Posição Y do carro 2
//    input [15:0] car_size,   // Tamanho de cada carro (lado do quadrado)
//    output reg collision     // Sinal de colisão
//);
//
//    always @(*) begin
//        // Verificar colisão no eixo X
//        if ((car1_x + car_size > car2_x) && (car2_x + car_size > car1_x)) begin
//            // Verificar colisão no eixo Y
//            if ((car1_y + car_size > car2_y) && (car2_y + car_size > car1_y)) begin
//                collision = 1;  // Colisão detectada
//            end else begin
//                collision = 0;  // Sem colisão
//            end
//        end else begin
//            collision = 0;  // Sem colisão
//        end
//    end
//
//endmodule