module Control(
    input wire [5:0] opcode,

    output wire regDst,
    output wire regWrite,
    output wire Branch,
    output wire MemRead,
    output wire MemtoReg,
    output wire MemWrite,
    output wire [1:0] ALUOp,
    output wire ALUSrc
); 
// Tentative control signals, need to be adjusted based on the mips instruction set architecture
    assign regDst = (opcode == 6'b000000) ? 1 : 0;
    assign regWrite = (opcode == 6'b000000 || opcode == 6'b100011) ? 1 : 0;
    assign Branch = (opcode == 6'b000100) ? 1 : 0;
    assign MemRead = (opcode == 6'b100011) ? 1 : 0;
    assign MemtoReg = (opcode == 6'b100011) ? 1 : 0;
    assign MemWrite = (opcode == 6'b101011) ? 1 : 0;
    assign ALUOp = (opcode == 6'b000000) ? 2'b10 : 
                   (opcode == 6'b100011 || opcode == 6'b101011) ? 2'b00 : 
                   (opcode == 6'b000100) ? 2'b01 : 
                   2'b00;
    assign ALUSrc = (opcode == 6'b001000 || opcode == 6'b100011 || opcode == 6'b101011) ? 1 : 0;
endmodule