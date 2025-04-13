module alu_control(
    input wire [5:0] funct,
    input wire [1:0] ALUOp,
    output reg [5:0] alu_control
);
    // ALU control signals
    always @(*) begin
        case(ALUOp)
            2'b00: alu_control = 4'b0010; // ADD
            2'b01: alu_control = 4'b0110; // SUB
            2'b10: begin // R type instruction
                case (funct)
                    6'b100000: alu_control = 4'b0010; // ADD
                    6'b100001: alu_control = 4'b0010; // ADDU
                    6'b100010: alu_control = 4'b0110; // SUB
                    6'b100011: alu_control = 4'b0110; // SUBU
                    6'b001000: alu_control = 4'b0010; // ADDI
                    6'b001001: alu_control = 4'b0010; // ADDIU
                    6'b011100: alu_control = 4'b1000; // MADD
                    6'b011101: alu_control = 4'b1001; // MADDU
                    6'b011000: alu_control = 4'b1010; // MUL
                    6'b100100: alu_control = 4'b0000; // AND
                    6'b100101: alu_control = 4'b0001; // OR
                    6'b001100: alu_control = 4'b0000; // ANDI
                    6'b001101: alu_control = 4'b0001; // ORI
                    6'b011111: alu_control = 4'b1100; // NOT
                    6'b001110: alu_control = 4'b1101; // XORI
                    6'b100110: alu_control = 4'b1101; // XOR
                    6'b000000: alu_control = 4'b1110; // SLL
                    6'b000010: alu_control = 4'b1111; // SRL
                    6'b000011: alu_control = 4'b1110; // SLA
                    6'b000100: alu_control = 4'b1111; // SRA
                    // Other operations like jr, mflo, mfhi to be added soon
                    default:   alu_control = 4'b1111; // Invalid operation
                endcase
            end
            default: alu_control = 4'b1111; // Invalid operation
        endcase
    end
endmodule