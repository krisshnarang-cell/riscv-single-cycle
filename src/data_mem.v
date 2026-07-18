module data_memory(
    input [31:0] addr,
    input [31:0] dmem_write_data,
    input MemRead,
    input MemWrite,
    input clk,
    output [31:0] read_data
);

reg [31:0] mem [31:0];

assign read_data = mem[addr[6:2]];

always @(posedge clk) begin
    if(MemWrite) begin
        mem[addr[6:2]] <= dmem_write_data;
    end
end
endmodule