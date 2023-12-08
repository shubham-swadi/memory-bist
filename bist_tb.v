`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2023 21:42:38
// Design Name: 
// Module Name: bist_controller_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bist_tb();
reg clk;
reg reset;
reg bist_en;
reg go_bist;
wire cmp_out, test_pattern_gen_en, cmp_en;
wire [7:0] data_out, bistd_in, interface_data_out;
wire [5:0] i;
wire [3:0] cs;
wire [4:0] read_addr_out, write_addr_out, bistread_addr_in, bistwrite_addr_in;
wire bistwrite_en_in, bistread_en_in, write_en_out, read_en_out;

bist b1(clk, bist_en, reset, go_bist, cmp_out,cmp_en, data_out, bist_done, i ,cs, test_pattern_gen_en, 
read_addr_out, write_addr_out, bistread_addr_in, bistwrite_addr_in, bistd_in, interface_data_out, bistwrite_en_in, bistread_en_in, write_en_out, read_en_out);

always  #5 clk = ~clk;

initial begin
clk  = 1;
reset = 1;
go_bist =0 ;
bist_en = 0 ;
#10;
reset = 0;
go_bist =1 ;
bist_en = 1 ;

#20000;

reset = 1;
end

initial #250000 $finish;
endmodule


