`timescale 1ns / 1ps
`include "cpu.v"

module tb();
    reg clk;
    reg rst;
    reg [32767:0] instruction_stream;
    
    cpu cpu_inst(
        .instruction_stream(instruction_stream),
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        rst = 1;
        instruction_stream = {32768{1'b0}}; // all zeros
        
        // Basic setup
        instruction_stream[31:0]   = 32'b001000_00000_00001_0000000000000101; // addi $1, $0, 5
        instruction_stream[63:32]  = 32'b001000_00000_00010_0000000000000010; // addi $2, $0, 2
        instruction_stream[95:64]  = 32'b001000_00000_00011_0000000000000111; // addi $3, $0, 7
        
        // Test branch equal (beq)
        instruction_stream[127:96] = 32'b000100_00001_00001_0000000000000010; // beq $1, $1, 2 (should branch)
        instruction_stream[159:128] = 32'b001000_00000_00100_0000000000001111; // addi $4, $0, 15 (skipped)
        instruction_stream[191:160] = 32'b001000_00000_00100_0000000000001010; // addi $4, $0, 10 (executed)
        
        // Test branch not equal (bne)
        instruction_stream[223:192] = 32'b000101_00001_00010_0000000000000010; // bne $1, $2, 2 (should branch)
        instruction_stream[255:224] = 32'b001000_00000_00101_0000000000000001; // addi $5, $0, 1 (skipped)
        instruction_stream[287:256] = 32'b001000_00000_00101_0000000000000010; // addi $5, $0, 2 (executed)
        
        // Test branch greater than (bgt)
        instruction_stream[319:288] = 32'b000110_00011_00001_0000000000000010; // bgt $3, $1, 2 (should branch)
        instruction_stream[351:320] = 32'b001000_00000_00110_0000000000000001; // addi $6, $0, 1 (skipped)
        instruction_stream[383:352] = 32'b001000_00000_00110_0000000000000011; // addi $6, $0, 3 (executed)
        
        // Test jump
        instruction_stream[415:384] = 32'b000010_00000000000000000000001101; // j 13 (jump to instruction 13)
        instruction_stream[447:416] = 32'b001000_00000_00111_0000000000000001; // addi $7, $0, 1 (skipped)
        // skipped instructions...
        
        // Instruction 13 (address 416)
        instruction_stream[447:416] = 32'b001000_00000_00111_0000000000001101; // addi $7, $0, 13 (executed after jump)
        
        // Test jump and link (jal)
        instruction_stream[479:448] = 32'b000011_00000000000000000000001111; // jal 15
        instruction_stream[511:480] = 32'b001000_00000_01000_0000000000000001; // addi $8, $0, 1 (skipped)
        
        // Instruction 15 (address 480)
        instruction_stream[511:480] = 32'b001000_00000_01000_0000000000001111; // addi $8, $0, 15 (executed after jal)
        
        // Test jr (return from jal)
        instruction_stream[543:512] = 32'b000000_11111_00000_00000_00000_001000; // jr $ra

        #10 
        rst = 0;
        #150 $finish;
    end

    always #5 clk = ~clk;
endmodule
