`timescale 1ns / 1ps
`include "control.v"
`include "alu.v"

module pc(
    input wire clk,
    input wire rst,
    input wire [9:0] pc_in,
    output reg [9:0] pc_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc_out <= 32'b0;
        end else begin
            pc_out <= pc_in;
        end
    end
endmodule

module pc_handler(
    input wire [9:0] cur_addr,
    output wire [9:0] next_addr
);
    assign next_addr = cur_addr + 1;
endmodule

module register_file(
    input wire clk,
    input wire rst,
    input wire [4:0] read_reg_1,
    input wire [4:0] read_reg_2,
    input wire [4:0] write_reg,
    input wire [31:0] write_data_reg,
    input wire regWrite,
    output wire [31:0] read_data_reg_1,
    output wire [31:0] read_data_reg_2
);
    reg [31:0] registers[31:0];

    assign read_data_reg_1 = registers[read_reg_1];
    assign read_data_reg_2 = registers[read_reg_2];
    
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end else if (regWrite) begin
            registers[write_reg] <= write_data_reg;
        end
    end
endmodule


module cpu(
    input wire [32767:0] instruction_stream,
    input wire clk,
    input wire rst,
    output wire [31:0] read_data
);
    wire [31:0] instruction_memory[1023:0];
    

    generate
        for (genvar i = 0; i < 1024; i = i + 1) begin : gen_loop
            assign instruction_memory[i] = instruction_stream[i*32 +: 32];
        end
    endgenerate


    wire [9:0] cur_addr;
    wire [9:0] next_addr;
    pc_handler pc_handler(
        .cur_addr(cur_addr),
        .next_addr(next_addr)
    );

    pc pc(
        .clk(clk),
        .rst(rst),
        .pc_in(next_addr),
        .pc_out(cur_addr)
    );

    wire regDst;
    wire regWrite;
    wire Branch;
    wire MemRead;
    wire MemtoReg;
    wire MemWrite;
    wire [1:0] ALUOp;
    wire ALUSrc;

    Control control(
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

    register_file register_file(
        .clk(clk),
        .rst(rst),
        .read_reg_1(instruction_memory[cur_addr][25:21]),
        .read_reg_2(instruction_memory[cur_addr][20:16]),
        .write_reg(RegDst == 1 ? instruction_memory[cur_addr][15:11] : instruction_memory[cur_addr][20:16]),
        .write_data_reg(read_data),
        .regWrite(instruction_memory[cur_addr][31]),
        .read_data_reg_1(read_data),
        .read_data_reg_2(read_data)
    );

endmodule