module reg_mux(data,enable,rst,CLK,data_reg,REG);
parameter WIDTH=18;
parameter RST="SYNC";


input [WIDTH-1:0]data;
input CLK,rst,enable;
input REG;
output [WIDTH-1:0]data_reg;
reg [WIDTH-1:0]internal;

assign data_reg=(REG)?internal:data;

generate
        if(RST=="ASYNC")begin
            always@(posedge CLK or posedge rst)begin
                if(rst) internal<=0;
                else internal<=data;
            end
        end

        if(RST=="SYNC") begin
            always@(posedge CLK )begin
                if(rst) internal<=0;
                else internal<=data;
            end
        end
endgenerate


endmodule
