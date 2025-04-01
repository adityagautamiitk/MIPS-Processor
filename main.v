`timescale 1ns / 1ps
`include "control.v"
`include "alu.v"
`include "pc.v"
`include "register_file.v"
`include "alu_control.v"
`include "data_memory.v"


module cpu(
    input wire [32767:0] instruction_stream,
    input wire clk,
    input wire rst
);

    wire [31:0] instruction_memory[1023:0];
    generate
        for (genvar i = 0; i < 1024; i = i + 1) begin : gen_loop
            assign instruction_memory[i] = instruction_stream[i*32 +: 32];
        end
    endgenerate

    // PC wires
    wire [9:0] cur_addr;
    wire [9:0] next_addr;

    // Control wires
    wire regDst;
    wire regWrite;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire MemWrite;
    wire [1:0] ALUOp;
    wire ALUSrc;

    // Register file wires
    wire [31:0] write_data_reg;
    wire [31:0] read_data_reg_1;
    wire [31:0] read_data_reg_2;

    // ALU wires
    wire [31:0] alu_result;
    wire [3:0] alu_control;
    wire zero;

    // Data memory wires
    wire [31:0] memory_address = alu_result;
    wire [31:0] write_data_memory;
    wire [31:0] read_data_memory;

    // Other wires
    wire [31:0] signextended_15_0 = {{16{instruction_memory[cur_addr][15]}}, instruction_memory[cur_addr][15:0]};

    // assignments
    assign write_data_reg = MemtoReg == 1 ? read_data_memory : memory_address;
    assign memory_address = alu_result;
    assign write_data_memory = read_data_reg_2;
    assign next_addr = (Branch & zero) == 1? cur_addr + 1 + signextended_15_0 : cur_addr + 1 ;

    pc pc_inst(
        .clk(clk),
        .rst(rst),
        .pc_in(next_addr),
        .pc_out(cur_addr)
    );

    control control_inst(
        .opcode(instruction_memory[cur_addr][31:26]),
        .regDst(regDst),
        .regWrite(regWrite),
        .Branch(Branch),
        .MemRead(MemRead),
        .MemtoReg(MemtoReg),
        .MemWrite(MemWrite),
        .ALUOp(ALUOp),
        .ALUSrc(ALUSrc)
    );


    register_file register_file_inst(
        .clk(clk),
        .rst(rst),
        .read_reg_1(instruction_memory[cur_addr][25:21]),
        .read_reg_2(instruction_memory[cur_addr][20:16]),
        .write_reg(RegDst == 1 ? instruction_memory[cur_addr][15:11] : instruction_memory[cur_addr][20:16]),
        .write_data_reg(write_data_reg),
        .regWrite(regWrite),
        .read_data_reg_1(read_data_reg_1),
        .read_data_reg_2(read_data_reg_2)
    );

    

    alu_control alu_control_inst(
        .ALUOp(ALUOp),
        .funct(instruction_memory[cur_addr][5:0]),
        .alu_control(alu_control)
    );

    

    alu alu_inst(
        .alu_control(alu_control),
        .a(read_data_reg_1),
        .b(ALUSrc == 1 ? signextended_15_0 : read_data_reg_2),
        .result(alu_result),
        .zero(zero)
    );



    data_memory data_memory_inst(
        .clk(clk),
        .memWrite(MemWrite),
        .memRead(MemRead),
        .address(memory_address),
        .write_data_memory(write_data_memory),
        .read_data_memory(read_data_memory)
    );

endmodule