//////////////////////////////////////////////////////////////////////////////////
// From Prac 4
//////////////////////////////////////////////////////////////////////////////////


module Debounce(
    input clk, 
    input Button,
    output reg out 
);

reg previous_state;
reg [24:0]Count; //assume count is null on FPGA configuration

//--------------------------------------------
always @(posedge clk) begin  	//activates every clock edge
 //previous_state <= Button;		// localise the reset signal
   if (Button && Button != previous_state && &Count) begin		// reset block
    out <= 1'b1;					// reset the output to 1
	 Count <= 0;
	 previous_state <= 1;
  end 
  else if (Button && Button != previous_state) begin
	 out <= 1'b0;
	 Count <= Count + 1'b1;
  end 
  else begin
	 out <= 1'b0;
	 previous_state <= Button;
  end

end //always
 //--------------------------------------------
endmodule
//---------------------------------------------
