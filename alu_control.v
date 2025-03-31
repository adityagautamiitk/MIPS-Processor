module alu_control(
    input wire [5:0] funct,
    input wire [1:0] ALUOp,
    output reg [3:0] alu_control
);
    // ALU control signals
    always @(*) begin
        case(ALUOp)
            2'b00: alu_control = 4'b0010; // ADD
            2'b01: alu_control = 4'b0110; // SUB
            2'b10: begin
                case (funct)
                    6'b100000: alu_control = 4'b0010; // ADD
                    6'b100010: alu_control = 4'b0110; // SUB
                    6'b100100: alu_control = 4'b0000; // AND
                    6'b100101: alu_control = 4'b0001; // OR
                    default:   alu_control = 4'b1111; // Invalid operation
                endcase
            end
            default: alu_control = 4'b1111; // Invalid operation
        endcase
    end
endmodule