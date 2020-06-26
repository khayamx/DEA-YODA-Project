`timescale 1ns / 1ps

module Top(
    //inputs for as buttons handling
    input CLK100MHZ, 
//    input BTNreset,
   input BTNstart,
    //output displays
    output  [7:0] SevenSegment,
    output  [3:0] SegmentDrivers,
    //progress bar
    output reg [15:0] LED
    );
    
   // reg reset; //uncomment for testbench only
    //BUTTON SETUP 
//    add wires
    wire reset;
    wire start;
//    Delay_Reset Reset(CLK100MHZ,BTNreset,reset);
    Debounce DebounceStart(CLK100MHZ, BTNstart ,start);

    //internal registers for encryption
    wire [7:0]mod; 
    reg ena_w = 1;
    wire [7:0]lambda;
    wire [7:0] ekey;

    
    //Encryption instantiation 
     reg [7:0] firstelement;  //need to code as first element in array
     reg [10:0] enc =0;
     
    random_no_generator random1(CLK100MHZ, reset, firstelement, mod, lambda);
    FinalEncryption encrypt(CLK100MHZ, reset, lambda, ekey);
    
     // Memory IO
    reg ena = 1;
    reg wea = 0;
    reg [7:0] addra=0; //0;
      reg [7:0] count =0;
    reg [7:0] dina=0; //We're not putting data in, so we can leave this unassigned
    wire[7:0] douta;
         
//     //INSTANTIATE MEM BLOCK 
     blk_mem_gen_0 BRAM (
     .clka(CLK100MHZ),// input wire clka          
     .ena(ena),       // input wire ena           
     .wea(wea),       // input wire [0 : 0] wea   
     .addra(addra),   // input wire [0 : 0] addra 
     .dina(dina),     // input wire [7 : 0] dina  
     .douta(douta)    //output wire [7 : 0] douta 
     );

//BRAM to write CIPHER TEXT to
    reg wea_w = 1;
    reg [7:0] addra_w=0; //0
    reg [7:0] dina_w; // putting data in
    wire [7:0] douta_w;
    
//instantiate write block
    blk_mem_gen_1 BRAMwrite (
      .clka(CLK100MHZ),    // input wire clka
      .ena(ena_w),      // input wire ena
      .wea(wea_w),      // input wire [0 : 0] wea
      .addra(addra_w),  // input wire [7 : 0] addra
      .dina(dina_w),    // input wire [7 : 0] dina
      .douta(douta_w)  // output wire [7 : 0] douta
       );
       
 
    
    //other int reg
    reg[7:0] DispRead;//DISPLAY on SS
    reg[7:0] DispWrite;//WRITE CIPHER TEXT

   
   //easy to change data for test bench testing.
   //remove comments for test bench
//   integer j ;
//   
//   reg [7:0] mem [0:max-1];

//for data transfer from BRAM
    parameter max=30;//adjustable for specific size of data
    reg [7:0] dataArr [0:max-1];
    reg [7:0] EncryptdataArr [0:max-1];
    
    //case reigsters
    //states
    reg GetEncrypt =0;
    reg Populate =0;
    reg DoEncrypt =0;
    reg DoWrite =0;
    reg Done = 0;
    //for progress bar
    integer i=0;
//    reg [7:0] count25;
//    reg [7:0] count50;
//    reg [7:0] count75;
   
   //------------------------------SS display Setup-----------------------------------------
   //SS and Digit registers
   wire  [3:0]D0;
   wire  [3:0]D1;
   wire  [3:0]D2;
  
   reg [3:0] Dss0;
   reg [3:0] Dss1;
   reg [3:0] Dss2;
   reg [3:0] Dss3;
   
   //init digit converter
    DigitConverter DigitsRead(
    DispRead, 
    D2, D1, D0); //hundreds, tens, units
    
    
    //SS DRIVER
    SS_Driver SS_Driver1(
		CLK100MHZ, reset,
		Dss3, Dss2, Dss1, Dss0,  //digits to send to driver
		SegmentDrivers, SevenSegment
	);
	
	//DISPLAY SPEED
    parameter speed = 10000;//100000000
    reg [29:0] countDisp = 30'd0;
    reg StartDisp;
    reg [7:0] addrSHOW=0;

   
   
    //------------------------------End SS SETUP---------------------------------------------------------------------
    
 always @ (posedge BTNstart)begin
    Populate<=1;
    //GetEncrypt<=1;
 end
    //for testing, moved to test bench
  //reg [19:0]CLKcycles=0;
 always @(posedge CLK100MHZ)begin
 //CLKcycles<=CLKcycles + 1'b1;
 //generate values uncomment for testbench
//for (j=0; j<max; j=j+1)begin
//        mem[j]<=j;
//     end
 
  LED[0]<=1'b1;
  if(reset)
  begin
  GetEncrypt<=0;
  DoEncrypt<=0;
  LED<=0;
  addra<=0;
  //firstelement<=0;
  count<=0;
  addra_w<=0;
  Done <= 0;
  end //end reset
  
  
  if(Populate)
    begin //first state is to populate
      LED[2]<=1'b1;
      //DispRead <= douta;//formatted and sent to SS display
      dataArr[addra] <= douta;   //populating arry
      // dataArr[addr] <= mem[addr]; 
       addra<= addra +1;
       
      if (addra>max)  //NOTE fix the first two digits in the array
      begin
       Populate<=0;
       GetEncrypt<=1;
       count <= addra;
      end 
    end //Populate
    
    if(GetEncrypt)
    begin
    LED[3]<=1'b1;
   firstelement<=8'd123;//used to generate key
    if(lambda>=0 &mod>=0 & ekey>=0 )
    begin
      GetEncrypt<=0;    
      DoEncrypt<=1;
    end  //if
    end // Encrypt
    
    if(DoEncrypt)
    begin
    LED[4]<=1'b1;
//    count25  <= (0.25*count);
//    count50  <= ceiling(0.5*count);
//    count75  <= ceiling(0.75*count);
    
//    count25  <= count*1/4;
//    count50  <= count*1/2;
//    count75  <= 3/4*count;
 
    for (i=0; i<max; i=i+1)   //this should be done in parallel
    begin
         EncryptdataArr[i]<= dataArr[i]+ekey%mod;
        //EncryptdataArr[i]<= mem[i]+ekey%mod;
        
//        if(i>=count25)
//        begin
//            LED[0]<=1;
//            LED[1]<=1;
//            LED[2]<=1;
//            LED[3]<=1;   
//        end
//        if(i >= count50)
//        begin
//            LED[4]<=1;
//            LED[5]<=1;
//            LED[6]<=1;
//            LED[7]<=1;  
//        end
//         if(i >= count75)
//        begin
//            LED[8]<=1;
//            LED[9]<=1;
//            LED[10]<=1;
//            LED[11]<=1;  
//        end
        
//         if(i >= count)
//        begin
//            LED[12]<=1;
//            LED[13]<=1;
//            LED[14]<=1;
//            LED[15]<=1;  
//        end
       
    end     
        DoEncrypt<=0;  //after forloop finished this if statement must end
        DoWrite<=1;
        
    end //DoEncrypt
     
    
    if(DoWrite)//start 
    begin
    LED[6]<=1'b1;
    //write cipher text to BRAM
    if (addra_w<=count)begin
        dina_w <= EncryptdataArr[addra_w];
        addra_w <= addra_w +1;
    end //if
    StartDisp<=1; //start writing to ss display
    //done
    Done<=1;
    DoWrite<=0;
    end//end DoWrite state
    
   //done state
   if (Done)begin
        LED<=16'b1111111111111111;
   end//end done
   
   //WRITE CIPHER TEXT TO SS DISPLAY
    Dss2<=D2;  Dss1<=D1;  Dss0<=D0;
    if (StartDisp)begin
        countDisp <= countDisp + 1'b1; //start counting
        if(countDisp == speed)begin
            countDisp <= 0;
            DispRead <= EncryptdataArr[addrSHOW];
            addrSHOW <= addrSHOW +1;
        end//end count ==speed
    end//end display state
    
    end//end always block
 
endmodule

