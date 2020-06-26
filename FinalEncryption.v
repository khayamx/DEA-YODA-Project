`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.06.2020 23:17:00
// Design Name: 
// Module Name: FinalEncryption
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

module FinalEncryption(
input clk, 
input reset, 
input [7:0] lamda,   //(p-1)(q-1)
output reg [7:0] key
    );
    
 reg [7:0] count=0;  
  //checking registers (determine when to move to next state)
  reg chooseE=0;
  reg IsCoprime=0;  //output of CoprimeCheck module sotred here
  reg pickEkey=0;
  reg [7:0] coPrimeValues [200:0]; //max n and p value is 15 thus max no of entries 1-> lamda = (15-1)(15-1) = 196
  reg [7:0] i=1;   //counter for array
  reg [7:0] iPos=0;
  reg [7:0]keyPos=0;
  reg [7:0] temp;
  //integer i;
  reg [4:0] state=0;
  reg populate=1;
  
  reg [7:0] a;
  reg [7:0] b;
  reg [7:0] temp_a;
   always @(posedge clk)
   begin 
   if(reset)
   begin
       populate<=1;
       chooseE<=0;
       i<=0;
       count<=0;
       pickEkey<=0;
       iPos<=0;
       key<=0;
       keyPos<=0;
   end //end reset
     if(populate & lamda>0)
     begin
            a=lamda;
            b=i;
            temp_a=a;
            populate<=0;
            chooseE<=1;
     end
     if(chooseE)
     begin
            
           case(state)
           0:begin
               temp_a=a;
                a=b;
                b=temp_a%b;
                 if(b==0)
                begin
                  state<=1;
                 end
           end  //end state 0
           1:begin
           if(a==1)  //value is coprime
               begin
                coPrimeValues[count] <= i;
                count<=count +1;
                
                end
            if(i==lamda)
            begin
             chooseE<=0;
             iPos<=count; 
             count<=0;
             chooseE<=0;
             pickEkey<=1;
             i=0;
            end
            else
            begin
            i=i+1;
            a=lamda;
            b=i;
            temp_a=a;
            state=0;
            end
           end //end state 1
           endcase;
      
     end //end chooseE
     
   if(pickEkey)
   begin
   if(iPos%2==0)  //if keypos is even
       keyPos=iPos/2;
       else
       begin
       iPos =iPos+1;  //make kPos even if it is odd by +1
       keyPos=iPos/2;
       end 
       key = coPrimeValues[keyPos];
       pickEkey=0;  //stopping this if statement once key is choosen
   end //end pickEkey
   end //end clk
 
endmodule
