module DSP(A,B,C,D,CARRYIN,CLK,OPMODE,
CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,
RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP
,PCIN,CARRYOUT,CARRYOUTF,M,P,BCOUT,BCIN,PCOUT);

parameter A0REG=0;
parameter B0REG=0;
parameter A1REG=1;
parameter B1REG=1;
parameter CREG=1;
parameter DREG=1;
parameter MREG=1;
parameter PREG=1;
parameter CARRYINREG=1;
parameter OPMODEREG=1;
parameter CARRYOUTREG=1;

parameter CARRYINSEL="OPMODE5";

parameter B_INPUT="DIRECT";

parameter RSTTYPE="SYNC";

input [17:0] A,B,D;
input [47:0]C,PCIN;
input [7:0]OPMODE;
input CLK,CARRYIN;
input [17:0] BCIN;
input RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
input CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP;
output  [35:0]M;
output  [47:0]P,PCOUT;
output  [17:0]BCOUT;
output CARRYOUT,CARRYOUTF;


wire [17:0]A0_reg,B0_reg,D0_reg,A1_reg;
wire [17:0] B_selected;
wire [47:0]C0_reg; 
wire [7:0] opmode_reg;

wire [17:0]first_adder_reg;
reg [17:0] first_adder;

wire [35:0]multibly_reg;
reg [35:0]multibly;

wire carryin_reg;
reg carryin;

wire carryout_reg;
reg carryout;

wire [47:0] second_adder_reg;
reg [47:0] second_adder; 

reg [47:0]x,z;


assign B_selected=(B_INPUT=="DIRECT")?B:(B_INPUT=="CASCADE")?BCOUT:0;
reg_mux  #(.WIDTH(18),.RST(RSTTYPE)) A0 (.data(A),.enable(CEA),.rst(RSTA),.CLK(CLK),.REG(A0REG),.data_reg(A0_reg));
reg_mux  #(.WIDTH(18),.RST(RSTTYPE))  B0 (.data(B_selected), .enable(CEB), .rst(RSTB), .CLK(CLK),.REG(B0REG), .data_reg(B0_reg));
reg_mux  #(.WIDTH(48),.RST(RSTTYPE)) C0 (.data(C),.enable(CEC),.rst(RSTC),.CLK(CLK),.REG(CREG),.data_reg(C0_reg));
reg_mux  #(.WIDTH(18),.RST(RSTTYPE)) D0 (.data(D),.enable(CED),.rst(RSTD),.CLK(CLK),.REG(DREG),.data_reg(D0_reg));
reg_mux  #(.WIDTH(8),.RST(RSTTYPE)) opmode(.data(OPMODE),.enable(CEOPMODE),.rst(RSTOPMODE),.CLK(CLK),.REG(OPMODEREG),.data_reg(opmode_reg));

always@(*)begin
        case(opmode_reg[4])
            0:first_adder=B0_reg;
            1:begin 
                if(opmode_reg[6]) first_adder=D0_reg-B0_reg; 
                else first_adder=D0_reg+B0_reg; 
            end
        endcase
    end

reg_mux  #(.WIDTH(18),.RST(RSTTYPE)) B1 (.data(first_adder),.enable(CEB),.rst(RSTB),.CLK(CLK),.REG(B1REG),.data_reg(first_adder_reg));
reg_mux  #(.WIDTH(18),.RST(RSTTYPE)) A1 (.data(A0_reg),.enable(CEA),.rst(RSTA),.CLK(CLK),.REG(A1REG),.data_reg(A1_reg));

assign BCOUT=first_adder_reg;

always@(*)begin
 multibly=first_adder_reg*A1_reg;
end
reg_mux  #(.WIDTH(36),.RST(RSTTYPE)) multiblication (.data(multibly),.enable(CEM),.rst(RSTM),.CLK(CLK),.REG(MREG),.data_reg(multibly_reg));
assign M=multibly_reg;

always@(*)begin
    case(CARRYINSEL)
        "OPMODE5":carryin=opmode_reg[5];
        "CARRYIN":carryin=CARRYIN;
        default :carryin=0;
    endcase
end
reg_mux  #(.WIDTH(1),.RST(RSTTYPE)) carry_in (.data(carryin),.enable(CECARRYIN),.rst(RSTCARRYIN),.CLK(CLK),.REG(CARRYINREG),.data_reg(carryin_reg));


always@(*)begin
    case(opmode_reg[1:0])
        2'b00:x=0;
        2'b01:x=multibly_reg;
        2'b10:x=PCOUT;
        2'b11:x={D0_reg[11:0],A1_reg,first_adder_reg};
    endcase
end

always@(*)begin
    case(opmode_reg[3:2])
        2'b00:z=0;
        2'b01:z=PCIN;
        2'b10:z=PCOUT;
        2'b11:z=C0_reg;    
    endcase
end

always@(*)begin
    case(opmode_reg[7])
        1:{carryout,second_adder}=z-(x+carryin_reg);
        0:{carryout,second_adder}=z+x+carryin_reg;
    endcase
end

assign PCOUT=P;
assign CARRYOUTF=CARRYOUT;

reg_mux  #(.WIDTH(48),.RST(RSTTYPE)) secondadder (.data(second_adder),.enable(CEP),.rst(RSTP),.CLK(CLK),.REG(PREG),.data_reg(second_adder_reg));
reg_mux  #(.WIDTH(1),.RST(RSTTYPE)) carryingout (.data(carryout),.enable(CECARRYIN),.rst(RSTCARRYIN),.CLK(CLK),.REG(CARRYOUTREG),.data_reg(carryout_reg));

assign P=second_adder_reg;
assign CARRYOUT=carryout_reg;

endmodule


   

