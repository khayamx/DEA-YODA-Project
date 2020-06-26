`timescale 1ns / 1ps

module tb_top;


//inputs
reg CLK100MHZ;
reg BTNstart;

//outputs
wire [15:0]LED;

 
 //other var
 
reg [19:0]CLKcycles;

//uut
DEA U0 (.CLK100MHZ(CLK100MHZ),.BTNstart(BTNstart),.LED(LED));


//init
initial begin
//setup
    CLK100MHZ<=0;
    BTNstart<=0;
    CLKcycles<= 0;
    //BTNreset<=0;
    
//display & monitor
    $display ("[simulation Time] CLK100MHZ   BTNstart  LED CLKcycles");
    $monitor( " %t ns              %b           %b       %b      %d",
    $time, CLK100MHZ ,BTNstart ,LED, CLKcycles);
    
   
    #1000
    BTNstart<=1; #700 //high for 700ns

    BTNstart<=0; //button no longer pressed
  
   
   
end//end initial

always begin
    #5 CLK100MHZ<=~CLK100MHZ; //100MHz clock => period 10ns => half cycle 5ns
end

always @(posedge CLK100MHZ) begin
    
        CLKcycles<=CLKcycles + 1'b1;
    
end


endmodule
