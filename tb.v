`timescale 1ns / 1ps
`include "cpu.v"
//`include "register_file.v"
module tb();
    reg clk;
    reg rst;
    reg [32767:0] instruction_stream;
    wire [31:0] debug_reg1;
    cpu cpu_inst(
        .instruction_stream(instruction_stream),
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 0;
        rst = 1;
        instruction_stream = {32768{1'b0}}; // all zeros
        instruction_stream[31:0]  = 32'b001000_00000_00001_0000000000000010; // addi $1, $0, 1
        instruction_stream[63:32] = 32'b000000_00001_00001_00001_00000_100000; // add $1, $1, $1
        instruction_stream[95:64] = 32'b001000_00000_00010_0000000000000111; // addi $2, $0, 1

        // multiply register $1 and $2
        instruction_stream[127:96] = 32'b000000_00001_00010_00000_00000_011000; // mul $3, $1, $2
        // store lo in $3
        instruction_stream[159:128] = 32'b000000_00000_00000_00011_00000_010010; // mflo $3
        //instruction_stream[127:96] = 32'b000000_00001_00001_00001_00000_100000; // add $1, $1, $1
        #10 
        rst = 0;
        #100 $finish;
    end

    always #5 clk = ~clk;
endmodule
