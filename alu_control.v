module alu_control(
    input wire [5:0] funct,
    input wire [1:0] ALUOp,
    output reg [5:0] alu_control
);
    // ALU control signals
    always @(*) begin
        case(ALUOp)
            2'b00: alu_control = 6'b100000; // ADD
            2'b01: alu_control = 6'b100010; // SUB
            2'b10: begin // R type instruction
                case (funct)
                    6'b100000: alu_control = 6'b100000; // ADD
                    6'b100001: alu_control = 6'b100001; // ADDU
                    6'b100010: alu_control = 6'b100010; // SUB
                    6'b100011: alu_control = 6'b100011; // SUBU
                    6'b011000: alu_control = 6'b011000; // MUL / MULT
                    6'b011001: alu_control = 6'b011001; // MULU / MULTU
                    6'b011100: alu_control = 6'b011100; // MADD
                    6'b011101: alu_control = 6'b011101; // MADDU
                    6'b100100: alu_control = 6'b100100; // AND
                    6'b100101: alu_control = 6'b100101; // OR
                    6'b000000: alu_control = 6'b000000; // SLL
                    6'b000010: alu_control = 6'b000010; // SRL
                    6'b000011: alu_control = 6'b000011; // SRA
                    6'b100110: alu_control = 6'b100110; // XOR
                    6'b101000: alu_control = 6'b101000; // NOT (custom)
                    6'b100111: alu_control = 6'b100111; // NOR
                    6'b101010: alu_control = 6'b101010; // SLT
                    6'b101011: alu_control = 6'b101011; // SLTU
                    6'b010000: alu_control = 6'b010000; // MFHI
                    6'b010010: alu_control = 6'b010010; // MFLO

                    default:   alu_control = 6'b111111; // Invalid operation
                    // Other operations like jr, mflo, mfhi to be added soon

                endcase
            end
            default: alu_control = 4'b1111; // Invalid operation
        endcase
    end
endmodule