`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Khaya
// 
// Create Date: 10.06.2020 12:23:12
// Design Name: 
// Module Name: DigitConverter
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


module DigitConverter(
    
    input [7:0] data, 
    output reg[3:0] hund,
    output reg[3:0] tens,
    output reg[3:0] units
    );
    
    reg [7:0]temp;
    reg [7:0]TenAndUnit;
    reg [7:0]hundredR;
    reg [7:0]tenR;
    reg [7:0]unitR;
    
    always@(*) begin//purely combinational
    //get hundreds
        hundredR <= data/100;
        hund <= hundredR[3:0];//reduce it size 
        
    //get tens
        TenAndUnit<=data%100;
        tenR <= TenAndUnit/10;
        tens <= tenR[3:0];
    //get units
        unitR <= data%10;
        units <= unitR[3:0];
    end


    
endmodule
