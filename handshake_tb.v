`timescale 1ns/1ps
`include "handshake.v"
module handshake_tb;
reg        clk;
reg        rst_n;

reg        valid_s;
reg [7:0]  data_s;
wire       ready_s;

reg        ready_d;
wire       valid_d;
wire [7:0] data_d;

handshake test(
    .clk(clk),
    .rst_n(rst_n),
    //interface of source
    .valid_s(valid_s),
    .data_s(data_s),
    .ready_s(ready_s),

    //interface of destination
    .ready_d(ready_d),
    .valid_d(valid_d),
    .data_d(data_d)
);

initial begin
    clk<=1'b0;
    forever 
    #5 clk=~clk;
end

initial begin
    $dumpfile("handshake_wave.vcd");
    $dumpvars;
end

initial begin
    rst_n=1'b0;
    valid_s<=1'b0;
    ready_d<=1'b0;
    #12 
    rst_n<=1'b1;
    #3
    valid_s<=1'b1;   
    data_s<=8'h08;
    #5
    ready_d<=1'b1;
    #5
    data_s<=8'h35;  
    #10
    data_s<=8'hac;
    #10
    data_s<=8'h98;
    ready_d<=1'b0;
    #10
    ready_d<=1'b1;
    data_s<=8'hee;
    #20
    data_s<=8'h98; 
    ready_d<=1'b0; 
    #10
    data_s<=8'h23;
    ready_d<=1'b1;
    #20
    data_s<=8'haa;
    #10
    data_s<=8'hcd;
    #10
    valid_s<=1'b0;
    data_s<=8'hxx;
    #10
    data_s<=8'h4f;
    valid_s<=1'b1;
    #10
    data_s<=8'hac;
    #10
    data_s<=8'hee;
    #3
    ready_d<=1'b0;
    #7
    data_s<=8'h37;
    #4
    ready_d<=1'b1;
    #16
    data_s<=8'h10;
    #50
    $finish;
end

endmodule