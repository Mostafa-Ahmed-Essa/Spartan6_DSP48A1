module DSP_tb();

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

reg [17:0] A,B,D;
reg [47:0]C,PCIN;
reg [7:0]OPMODE;
reg CLK,CARRYIN;
reg [17:0] BCIN;
reg RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,RSTOPMODE,RSTP;
reg CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP;

reg past_value_1_pcout ;
reg past_value_1_p ;
reg past_value_1_carryout ;
reg past_value_1_carryoutf ;

wire  [35:0]M;
wire  [47:0]P,PCOUT;
wire  [17:0]BCOUT;
wire CARRYOUT,CARRYOUTF;

DSP #(.A0REG(0),.B0REG(0),.A1REG(1),.B1REG(1),.CREG(1),.DREG(1),.MREG(1),.PREG(1),.CARRYINREG(1),.OPMODEREG(1),.CARRYOUTREG(1),
.CARRYINSEL("OPMODE5"),.B_INPUT("DIRECT"),.RSTTYPE("SYNC"))
DUT (A,B,C,D,CARRYIN,CLK,OPMODE,CEA,CEB,CEC,CECARRYIN,CED,CEM,CEOPMODE,CEP,RSTA,RSTB,RSTC,RSTCARRYIN,RSTD,RSTM,
RSTOPMODE,RSTP,PCIN,CARRYOUT,CARRYOUTF,M,P,BCOUT,BCIN,PCOUT);

initial begin
    CLK=0;
    forever begin
        #1 CLK=~CLK;
    end
end

initial begin
    $display("======================Test_rst======================");
    RSTA=1;RSTB=1;RSTC=1;RSTCARRYIN=1;
    RSTD=1;RSTM=1;RSTOPMODE=1;RSTP=1;
    repeat(2)begin
    A=$random;B=$random;C=$random;
    D=$random;CARRYIN=$random;
    CEA=$random;CEB=$random;CEC=$random;
    CECARRYIN=$random;CED=$random;CEM=$random;
    CEOPMODE=$random;CEP=$random;
    OPMODE=$random;
    @(negedge CLK);
    if (P !== 0 || PCOUT !== 0 || CARRYOUT !== 0 || CARRYOUTF !== 0 || BCOUT !== 0 || M !== 0) $display("Error at -----(TEST_RESET)----- at time : %0t", $time);
    else $display("CORRECT at -----(TEST_RESET)----- ");
    #1;
    end
    $display("======================Test_rst======================");
    seperator();


    $display("======================PATH____1======================");
    RSTA=0;RSTB=0;RSTC=0;RSTCARRYIN=0;
    RSTD=0;RSTM=0;RSTOPMODE=0;RSTP=0;
    CEA=1;CEB=1;CEC=1;
    CECARRYIN=1;CED=1;CEM=1;
    CEOPMODE=1;CEP=1;
    OPMODE=8'b11011101;
    repeat(1)begin
    A=18'd20;B=18'd10;C=48'd350;
    D=18'd25;CARRYIN=$random;
    PCIN=$random;BCIN=$random;
    @(negedge CLK);
    @(negedge CLK);
    @(negedge CLK);
    @(negedge CLK);
    if (P !== 48'd50 || PCOUT !== 48'd50 || CARRYOUT !== 0 || CARRYOUTF !== 0 || BCOUT !== 18'd15 || M !== 36'd300) $display("Error at -----(PATH____1)----- at time : %0t", $time);
    else $display("CORRECT at -----(PATH____1)----- ");
    #1;
    end
    $display("======================PATH____1======================");
    seperator();  

    $display("======================PATH____2======================");
    RSTA=0;RSTB=0;RSTC=0;RSTCARRYIN=0;
    RSTD=0;RSTM=0;RSTOPMODE=0;RSTP=0;
    CEA=1;CEB=1;CEC=1;
    CECARRYIN=1;CED=1;CEM=1;
    CEOPMODE=1;CEP=1;
    OPMODE=8'b00010000;
    repeat(1)begin
    A=18'd20;B=18'd10;C=48'd350;
    D=18'd25;CARRYIN=$random;
    PCIN=$random;BCIN=$random;
    @(negedge CLK);
    @(negedge CLK);
    @(negedge CLK);

    assign past_value_1_p=P;
    assign past_value_1_pcout=PCOUT;
    assign past_value_1_carryout=CARRYOUT;
    assign past_value_1_carryoutf=CARRYOUTF;

    if (P !== 0 || PCOUT !== 0 || CARRYOUT !== 0 || CARRYOUTF !== 0 || BCOUT !== 18'd35 || M !== 36'd700) $display("Error at -----(PATH____2)----- at time : %0t", $time);
    else $display("CORRECT at -----(PATH____2)----- ");
    #1;
    end
    $display("======================PATH____2======================");
    seperator(); 

    $display("======================PATH____3======================");
    RSTA=0;RSTB=0;RSTC=0;RSTCARRYIN=0;
    RSTD=0;RSTM=0;RSTOPMODE=0;RSTP=0;
    CEA=1;CEB=1;CEC=1;
    CECARRYIN=1;CED=1;CEM=1;
    CEOPMODE=1;CEP=1;
    OPMODE=8'b00001010;
    repeat(1)begin
    A=18'd20;B=18'd10;C=48'd350;
    D=18'd25;CARRYIN=$random;
    PCIN=$random;BCIN=$random;
    @(negedge CLK);
    @(negedge CLK);
    @(negedge CLK);
    if (P !== past_value_1_p || PCOUT !== past_value_1_pcout || CARRYOUT !== past_value_1_carryout || CARRYOUTF !== past_value_1_carryoutf || BCOUT !== 18'd10 || M !== 36'd200) 
    $display("Error at -----(PATH____3)----- at time : %0t", $time);
    else $display("CORRECT at -----(PATH____3)----- ");
    #1;
    end
    $display("======================PATH____3======================");
    seperator(); 

    $display("======================PATH____4======================");
    RSTA=0;RSTB=0;RSTC=0;RSTCARRYIN=0;
    RSTD=0;RSTM=0;RSTOPMODE=0;RSTP=0;
    CEA=1;CEB=1;CEC=1;
    CECARRYIN=1;CED=1;CEM=1;
    CEOPMODE=1;CEP=1;
    OPMODE=8'b10100111;
    repeat(1)begin
    A=18'd5;B=18'd6;C=48'd350;
    D=18'd25;CARRYIN=$random;
    PCIN=3000;BCIN=$random;
    @(negedge CLK);
    @(negedge CLK);
    @(negedge CLK);
    if (P !== 48'hfe6fffec0bb1 || PCOUT !== 48'hfe6fffec0bb1 || CARRYOUT !== 1 || CARRYOUTF !== 1 || BCOUT !== 18'd6 || M !== 36'd30)
     $display("Error at -----(PATH____4)----- at time : %0t", $time);
    else $display("CORRECT at -----(PATH____4)----- ");
    #1;
    end
    $display("======================PATH____4======================");
    seperator(); 

    $stop;
end

task seperator();begin
$display("=====================================================================");
end
endtask

endmodule