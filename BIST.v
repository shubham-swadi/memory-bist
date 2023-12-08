`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.10.2023 13:10:48
// Design Name: 
// Module Name: controller_bist
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

module bist(clk, bist_en, reset, go_bist, cmp_out, cmp_en1, data_out, bist_done, i ,cs,test_pattern_gen_en, 
read_addr_out0, write_addr_out0, bistread_addr_in,
 bistwrite_addr_in, bistd_in, interface_data_out0, bistwrite_en_in, bistread_en_in, write_en_out0, read_en_out0);
input clk;
input bist_en;
input reset;
input go_bist;
output cmp_out, test_pattern_gen_en, cmp_en1;
output [7:0]data_out;
output bist_done;
output [4:0] read_addr_out0, write_addr_out0, bistread_addr_in, bistwrite_addr_in;
output [7:0] bistd_in, interface_data_out0;
output bistwrite_en_in, bistread_en_in, write_en_out0, read_en_out0;
output [3:0] cs;
output [5:0] i;


wire go_bist, test_pattern_gen_en, genone, genzero, cmp_en, cmp_en0, cmp_en1;
wire interface_sel;
wire [7:0] bistd_in, interface_data_out, interface_data_out0;
wire [4:0] bistread_addr_in, bistwrite_addr_in, read_addr_out, write_addr_out;
wire bistwrite_en_in, bistread_en_in, write_en_out, read_en_out;
wire [7:0] data_out;
wire [4:0]read_addr_out0, write_addr_out0 ;
wire write_en_out0, read_en_out0;

controller_bist c0(clk, bist_en, reset, go_bist, test_pattern_gen_en, genone, genzero,   
interface_sel , bist_done, cmp_en, bistread_en_in, bistwrite_en_in, bistread_addr_in, bistwrite_addr_in, i, cs);

memory_array m0(clk, read_addr_out0, write_addr_out0, interface_data_out, write_en_out0, read_en_out0, data_out); 

interface i0(interface_sel, 0, bistd_in, interface_data_out, 0, bistread_addr_in, 0, bistwrite_addr_in, 0, bistwrite_en_in, 
0, bistread_en_in, write_en_out, read_en_out, write_addr_out, read_addr_out);

test_pattern_gen p0(test_pattern_gen_en, clk, genzero , genone, bistd_in);

comparator cmp0(clk, data_out, interface_data_out0, cmp_en1, cmp_out, go_bist);


dff d1(clk,write_addr_out,write_addr_out0);
dff d2(clk,write_en_out,write_en_out0);
dff d3(clk,interface_data_out, interface_data_out0);
dff d4(clk,read_en_out,read_en_out0);
dff d5(clk,read_addr_out,read_addr_out0);
dff d6(clk,cmp_en,cmp_en0);
dff d7(clk,cmp_en0,cmp_en1);



endmodule


module controller_bist(clk, bist_en, reset, go_bist, test_pattern_gen_en, genone, genzero,   
interface_sel , bist_done, cmp_en, bist_read_en, bist_write_en, bistread_addr_in, bistwrite_addr_in, i, cs);
input clk;
input reset;
input bist_en;
input go_bist;
output reg test_pattern_gen_en;// siganl to generate test pattern
output reg genone, genzero;
output reg interface_sel;// selcting bist data
output reg bist_read_en;
output reg bist_write_en;
output reg [4:0] bistwrite_addr_in;
output reg [4:0] bistread_addr_in;
output reg cmp_en;// signal to compare_en
output reg bist_done;
output reg [5:0] i;
output [3:0] cs;

// March Y algorithm {w0, (r0 w1 r1) inc, (r1 w0 r0) dec, r0}

parameter init = 4'b0000;// initial
parameter w0 = 4'b0001;// write 0
parameter r0inc = 4'b0010;// read 0 inc
parameter w1inc = 4'b0011;
parameter r1inc = 4'b0100;
parameter r1dec = 4'b0101;
parameter w0dec = 4'b0110;
parameter r0dec = 4'b0111;
parameter r0 = 4'b1000;// read 0
parameter nop = 4'b1001;

reg [3:0]cs, ns, ps; 
 // flag register for address to increment or decrement

always @(posedge clk, reset)
begin
    if (reset == 1)
    begin
    cs <= init;
    end
    else if (bist_en == 1 & go_bist == 1)
    begin
    cs <= ns;
    interface_sel = 1;
end

end


always @(posedge clk,cs)
begin
case (cs)
init : begin
    test_pattern_gen_en = 0;
    cmp_en =0;
    bist_read_en =0;
    bist_write_en = 0;
    bistwrite_addr_in = 0;
    bistread_addr_in = 0;
    bist_done =0;
    genone = 0;
    genzero = 0;
    ns = w0;
    ps = cs;
    i = 0; 
    end
    
w0 : begin
    test_pattern_gen_en = 1;
    cmp_en =0;
    bist_read_en =0;
    bist_write_en = 1;
    bistwrite_addr_in = i;
    bistread_addr_in = i;
    bist_done =0;
    genone = 0;
    genzero = 1;
    ps = cs;
    if (i<31)
    begin
    i = i+1;
    ns = w0;
    end
    else if (i == 31)
    begin
    ns = nop;
    end
    end

r0inc : begin
    test_pattern_gen_en = 1;
    cmp_en = 1;
    bist_read_en =1;
    bist_write_en = 0;
    bistwrite_addr_in = i;
    bistread_addr_in = i;
    bist_done =0;
    genone = 0;
    genzero = 1;
    ns = w1inc;
    ps = cs;
    end

w1inc : begin
    test_pattern_gen_en = 1;
    cmp_en = 0;
    bist_read_en =0;
    bist_write_en = 1;
    bistwrite_addr_in = i;
    bistread_addr_in = i;
    bist_done =0;
    genone = 1;
    genzero = 0;
    ns = r1inc;
    ps = cs;
    end
    
r1inc : begin
    test_pattern_gen_en = 1;
    cmp_en =1;
    bist_read_en =1;
    bist_write_en = 0;
    bist_done =0;
    bistwrite_addr_in = i;
    bistread_addr_in = i;
    genone = 1;
    genzero = 0;
    if (i<31 && ps!=r1inc)
    begin
    i = i+1;
    ns = r0inc;
    end
    else if(i==31)
    ns = nop;
    ps = cs;
    end
    
    
r1dec :
    begin
    test_pattern_gen_en = 1;
    cmp_en =1;
    bist_read_en =1;
    bist_write_en = 0;
    bistwrite_addr_in = i;
    bistread_addr_in = i;
    bist_done =0;
    genone = 1;
    genzero = 0;
    ns = w0dec;
    ps = cs;
    end

w0dec :
    begin
    test_pattern_gen_en = 1;
    cmp_en =0;
    bist_read_en =0;
    bist_write_en = 1;
    bistwrite_addr_in = i;
    bistread_addr_in = i;
    bist_done =0;
    genone = 0;
    genzero = 1;
    ns = r0dec;
    ps = cs;
    end 

r0dec :
    begin
    test_pattern_gen_en = 1;
    cmp_en =1;
    bist_read_en =1;
    bist_write_en = 0;
    bistwrite_addr_in = i;
    bistread_addr_in = i;
    bist_done =0;
    genone = 0;
    genzero = 1;
    if (i>0 && ps!=r0dec)
    begin
    i = i-1;
    ns = r1dec;
    end
    else if(i==0)
    ns = nop;
    ps = cs;
    end

    
r0 : begin
    test_pattern_gen_en = 1; 
    cmp_en =1;
    bist_read_en =1;
    bist_write_en = 0;
    bistwrite_addr_in = i;
    bistread_addr_in = i;
    bist_done =0;
    genone = 0;
    genzero = 1;
    ps = cs;
    if (i<31)
    begin
    i = i+1;
    ns = r0;
    end
    else if (i==31)
    begin
    ns = init;
    i =0;
    bist_done = 1;
    end
    end 
    
nop : begin
    test_pattern_gen_en <= 0;
    cmp_en <=0;
    bist_read_en <=0;
    bist_write_en <= 0;
    bist_done <=0;
    bistwrite_addr_in = 0;
    bistread_addr_in = 0;
    bist_done =0;
    genone = 0;
    genzero = 0;
    ps <= cs;
    if(ps == w0)
    begin 
    i=0;
    ns = r0inc;
    end
    else if (ps == r1inc)
    begin 
    i=31;
    ns = r1dec;
    end
    else if (ps == r0dec )
    begin 
    i=0;
    ns = r0;
    end
    else if (ps == r0)
    ns = init; 
    end 
endcase

end

endmodule

module memory_array(
    input clk,           // Clock input
    input [4:0] addr, // 5-bit address input for read (to address 32 words)
    input [4:0] addw, // 5-bit address input for write (to address 32 words)
    input [7:0] data_in, // 8-bit data input
    input write_enable,  // Write enable signal
    input read_enable,   // Read enable signal
    output reg [7:0] mem_data_out // 8-bit data output
);

// Declare a 32x8 memory array (32 words of 8 bits each)
reg [7:0] memory[0:31];

// Address for shadow read by flipping the LSB of addw
//assign shadow_addr = {addw[4:1], ~addw[0]};

always @(posedge clk) begin
    // Metastability
    
        if (read_enable && write_enable) begin
            if (addr != addw)
            begin
            mem_data_out <= memory[addr];
            memory[addw] <= data_in;
            end
            else
            mem_data_out <= 'bxxxxxxxx; 
            
        end
    
    else begin
        // Read operation
        if (read_enable) begin
            mem_data_out <= memory[addr];
        end
    
        // Write operation
        if (write_enable) begin
            memory[addw] <= data_in;
            
            // Shadow read operation
            //mem_data_out = memory[shadow_addr];
        end
    end
end

endmodule

module interface(sel, d_in, bistd_in, interface_data_out, read_addr_in, bistread_addr_in, write_addr_in, bistwrite_addr_in, write_en_in, bistwrite_en_in, 
read_en_in, bistread_en_in, write_en_out, read_en_out, write_addr_out, read_addr_out);
input sel;
input [7:0] d_in;// nop (normal operation)
input [7:0] bistd_in;// from test_pattern_gen
input [4:0] read_addr_in;//nop
input [4:0] bistread_addr_in;// from test_addr_gen
input [4:0] write_addr_in;//nop
input [4:0] bistwrite_addr_in;// from test_addr_gen
input write_en_in;//nop
input bistwrite_en_in;// from controller
input read_en_in;//nop
input bistread_en_in;// from controller
output reg write_en_out;
output reg read_en_out;
output reg [4:0] read_addr_out;
output reg [4:0] write_addr_out;
output reg [7:0] interface_data_out;

always @(*)
begin
if (sel==0)
begin
write_en_out <= write_en_in ;
read_en_out <= read_en_in ;
read_addr_out <= read_addr_in;
write_addr_out <= write_addr_in;
interface_data_out <= d_in;
end

else
begin
write_en_out <= bistwrite_en_in  ;
read_en_out <= bistread_en_in ;
read_addr_out <= bistread_addr_in;
write_addr_out <= bistwrite_addr_in;
interface_data_out <= bistd_in;

end
end

endmodule


module comparator(clk, mem_data, test_data, cmp_en, cmp_out, go_bist);
input clk;
input [7:0] mem_data;
input [7:0] test_data;
input cmp_en;
output reg cmp_out;
output reg go_bist;

always @(posedge clk)
begin
if (!cmp_en)
begin
go_bist = 1;
cmp_out = 0;
end
else
begin
if (mem_data == test_data)
begin
go_bist = 1;
cmp_out = 1;
end  
else
begin
go_bist = 0;
cmp_out = 0;
end
end
end
endmodule


module test_pattern_gen(en,clk, genzero , genone, data_in);
    input genzero ,genone,clk, en;
    output reg [7:0] data_in;
    always@(posedge clk)
    begin
    if (en)
    begin
    if (genzero & !genone)
    data_in = 8'b00000000;
    if (!genzero & genone)
    data_in = 8'b11111111;
    end 
    end
endmodule

module dff(clk,d,q);
input [7:0]d;  
input clk;  
output reg [7:0] q; 
always @(posedge clk) 
begin
q = d; 
end 
endmodule 
//module test_address_gen(en ,clk, addr_sel, write_address, read_address);
///*parameter init = 4'b0000;// initial
//parameter w0 = 4'b0001;// write 0
//parameter r0inc = 4'b0010;
//parameter w1inc = 4'b0011;
//parameter r1inc = 4'b0100;

//parameter r1dec = 4'b0101;
//parameter w0dec = 4'b0110;
//parameter r0dec = 4'b0111;

//parameter r0 = 4'b1000;// read 0
//parameter nop = 4'b1001;

//if sel = 000 then keep address same
//if sel = 001 then address is 0 
//if sel = 010 then address is 31
//if sel = 011 then adresss is incremented by 1
//if sel = 100 then then adresss is decremented by 1*/

//input en;
//input clk;
//input [2:0] addr_sel;
//output reg [4:0] write_address;
//output reg [4:0] read_address;


//always @(posedge clk, addr_sel)
//if (en)
//begin
//if (addr_sel == 0)
//begin
//write_address <= write_address;
//read_address <= read_address;
//end
//else if (addr_sel == 1)
//begin
//write_address <= 0;
//read_address <= 0;
//end 
//else if (addr_sel == 2)
//begin
//write_address <= 31;
//read_address <= 31;
//end 
//else if (addr_sel == 3)
//begin
//write_address <= write_address+1;
//read_address <= read_address+1;
//end   
//else if (addr_sel == 4)
//begin
//write_address <= write_address-1;
//read_address <= read_address-1;
//end 


//end
    
//endmodule
    
    



