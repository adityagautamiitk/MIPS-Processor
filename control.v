module control(
    input wire [5:0] opcode,

    output reg regDst,
    output reg regWrite,
    output reg Branch,
    output reg MemRead,
    output reg MemtoReg,
    output reg MemWrite,
    output reg [4:0] ALUOp,
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
                ALUOp = 5'b00010; // ALU operation
                ALUSrc = 0; // Register source
            end
            6'b100011: begin // lw instruction
                regDst = 0;
                regWrite = 1;
                Branch = 0;
                MemRead = 1;
                MemtoReg = 1; // Memory to register
                MemWrite = 0;
                ALUOp = 5'b00000; // Load operation
                ALUSrc = 1; // Immediate source
            end
            //  addi
            6'b001000: begin // addi instruction
                regDst = 0;
                regWrite = 1;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                ALUOp = 5'b00011; // ALU operation
                ALUSrc = 1; // Immediate source
            end
            //andi
            6'b001100: begin // andi instruction
                regDst = 0;
                regWrite = 1;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                ALUOp = 5'b00100; // ALU operation
                ALUSrc = 1; // Immediate source
            end
            //ori
            6'b001101: begin // ori instruction
                regDst = 0;
                regWrite = 1;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                ALUOp = 5'b00101; // ALU operation
                ALUSrc = 1; // Immediate source
            end
            // xori
            6'b001110: begin // xori instruction
                regDst = 0;
                regWrite = 1;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                ALUOp = 5'b00110; // ALU operation
                ALUSrc = 1; // Immediate source
            end
            //slti
            6'b001010: begin // slti instruction
                regDst = 0;
                regWrite = 1;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                ALUOp = 5'b00111; // ALU operation
                ALUSrc = 1; // Immediate source
            end
            // seq
            6'b011000: begin // seq instruction
                regDst = 0;
                regWrite = 1;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                ALUOp = 5'b01001; // ALU operation
                ALUSrc = 1; // Immediate source
            end
            default: begin // Default case for other instructions
                regDst = 0;
                regWrite = 0;
                Branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                ALUOp = 5'b01111; // No operation
                ALUSrc = 0; // No immediate source
            end

        endcase
    end
endmodule