module alu(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire [5:0] alu_control,
    input wire [4:0] shamt,
    input wire [15:0] immediate,
    input wire clk,
    input wire rst,

    output reg [31:0] result,
    output reg zero
);
    reg [31:0] Hi, Lo;
    
    wire [31:0] signExtImmediate = {{16{immediate[15]}}, immediate};
    wire [31:0] zeroExtImmediate = {16'b0, immediate};

        always @(posedge clk or posedge rst) begin
        if (rst) begin
            Hi <= 32'b0;
            Lo <= 32'b0;
        end else begin
            case (alu_control)
                6'b011000: begin // MULT
                    {Hi, Lo} <= $signed(a) * $signed(b);
                end
                6'b011001: begin // MULTU
                    {Hi, Lo} <= a * b;
                end
                6'b011100: begin // MADD
                    {Hi, Lo} <= {Hi, Lo} + ($signed(a) * $signed(b));
                end
                6'b011101: begin // MADDU
                    {Hi, Lo} <= {Hi, Lo} + (a * b);
                end
                default:   ; // No change to Hi/Lo
            endcase
        end
    end

    always @(*) begin
        case (alu_control)
            6'b100000: result = $signed(a) + $signed(b); // ADD
            6'b100001: result = a + b;                   // ADDU
            6'b100010: result = $signed(a) - $signed(b); // SUB
            6'b100011: result = a - b;                   // SUBU
            6'b100100: result = a & b;              // AND
            6'b100101: result = a | b;              // OR
            6'b000000: result = b << shamt;         // SLL identical to SLA
            6'b000010: result = b >> shamt;         // SRL
            6'b000011: result = $signed(b) >>> shamt; // SRA
            6'b100110: result = a ^ b;              // XOR
            6'b101000: result = ~b;                 // NOT (custom)
            6'b100111: result = ~(a | b);           // NOR
            6'b101010: result = ($signed(a) < $signed(b)) ? 1 : 0; // SLT
            6'b101011: result = (a < b) ? 1 : 0;     // SLTU
            6'b010000: result = Hi;                 // MFHI
            6'b010010: result = Lo;                 // MFLO
            6'b101100: result = ($signed(a) == $signed(b)) ? 1 : 0; // SEQ (set if equal)
            
            default:   result = 32'b0;
        endcase
        zero = (result == 0);
    end

endmodule