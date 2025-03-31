module Control(
    input wire [5:0] opcode,

    output reg regDst,
    output reg regWrite,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg MemWrite,
    output reg [1:0] ALUOp,
    output reg ALUSrc
); 
// Tentative control signals, need to be adjusted based on the mips instruction set architecture
    always @(*) begin
        case (opcode)
            6'b000000: begin // R-type instructions
                regDst = 1;
                regWrite = 1;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                ALUOp = 2'b10; // ALU operation
                ALUSrc = 0; // Register source
            end
            6'b100011: begin // lw instruction
                regDst = 0;
                regWrite = 1;
                Branch = 0;
                MemRead = 1;
                MemtoReg = 1; // Memory to register
                MemWrite = 0;
                ALUOp = 2'b00; // Load operation
                ALUSrc = 1; // Immediate source
            end
            default: begin // Default case for other instructions
                regDst = 0;
                regWrite = 0;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                ALUOp = 2'b00; // No operation
                ALUSrc = 0; // No immediate source
            end
        endcase
    end
endmodule