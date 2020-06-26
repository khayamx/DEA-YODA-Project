`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.06.2020 21:03:05
// Design Name: 
// Module Name: random_no_generator
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


module random_no_generator(
input clk,
input reset, 
input [7:0] message,   //encrypted message so that you can use the last value in count
output reg [7:0] n,
output reg [7:0] lamda
 );
reg [3:0] outp;
reg [3:0] outq;
reg [3:0]start=0;
reg [7:0] count =0;  //check if count should be this big
reg calc =0;
reg random=1;
reg [3:0]rand=0;  // max random no =15 and 15 x 15 = 255 -> within 8 bits
reg [7:0] Np=0;  //need to change to first index in message
reg [7:0] Nq =0; //this equal first index (Np) in message + 5
wire rand4;
assign rand4 = rand[0]^rand[1]; //want rand4 to be continuously monitored and chnaged



always@(posedge clk)
begin
 if(reset)
 begin
 rand<=4'd0;
 count<=6'd0;
 start<=1;
 calc<=0;
 end
 else if (random)
     begin
     rand<=4'b1000;
     start<=1;
     Np <= message[7:0];   //making the message value = the number count must go up to
     Nq = Np + 5;  // deetermining q value be 5 clock cycles after p is determined 
     // check for non blocking -> needs to occurr after Np is populated
     end
if(start==4'd1)
   begin    
     rand[0]<=rand[1];
     rand[1]<=rand[2];
     rand[2]<=rand[3];
     rand[3]<=rand4;
     count<=count+1;
     if(count == Np)
     begin
        outp <= rand;
     end
     if(count==Nq)  // when it reaches this count the generation process must stop
      begin
       outq = rand;
       n = outp * outq; 
       lamda = (outp-1)*(outq-1);  //check that this works
       start<=0;
       count<=0;
       random<=0;
      end
  end

end  //end random


endmodule
