module handshake(
    input clk,
    input rst_n,

    //interface of source
    input valid_s,
    input [7:0] data_s,
    output ready_s,

    //interface of destination
    input ready_d,
    output valid_d,
    output [7:0] data_d
);

reg valid_tmp;
reg [7:0] data_tmp;
reg ready_s;
wire store;
reg data_d;
reg valid_d;

assign store = valid_s && ~ready_d && ready_s;

always@(posedge clk) begin
    if(!rst_n)
    valid_tmp <= 1'b0;
    else 
    valid_tmp <= valid_tmp ? ~ready_d : store;
end

always@(posedge clk)begin
    if(!rst_n)
    data_tmp <= 8'b0;
    else 
    data_tmp <= store? data_s : data_tmp;
end

always@(posedge clk)begin
    if(!rst_n)
    ready_s <= 1'b1;
    else
    ready_s <= (ready_d) || ((!valid_tmp) && (!store));  //这次没存 而且上次也没存
end

always@(posedge clk)begin
    if(!rst_n)
    valid_d <= 1'b0;
    else if(ready_s && valid_s)
    valid_d <= valid_s;
end

always@(posedge clk)begin
    if(!rst_n)
    data_d <= 8'b0;
    else if(valid_s==1'b0)
    data_d <= data_d;
    else 
    data_d <= ready_s ? data_s : data_tmp;
end

endmodule