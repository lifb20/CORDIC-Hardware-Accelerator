module CORDIC_Stage (
	input clk,
	input rst,
	input sign_in,
	input USE_SIN_in,
	input [7:0] ite,
	input [32:0] arctan_in_1,
	input [32:0] arctan_in_2,
	input [32:0] target_in,
	input [32:0] curr_angle_in,
	input [32:0] x_in,
	input [32:0] y_in,
	output sign_out,
	output USE_SIN_out,
	output [32:0] curr_angle_out,
	output [32:0] x_out,
	output [32:0] y_out,
	output [32:0] target_out
	);
	
	//Register Initialisations
	reg sign;
	reg [32:0] x[0:1];
	reg [32:0] y[0:1];
	//Used as temps for bit inversions or shifts
	reg [32:0] y_tmp[0:3];
	reg [32:0] x_tmp[0:3];
	//Number of shifts required: 2^i
	reg [3:0] count[0:1];
	reg [32:0] current_angle[0:1];
	//Temp value that allows use to convert arctan(1/2^i) to 2's complement
	reg [32:0] atan[0:1];

	
	always @(posedge clk) begin
			
			sign = sign_in;
			
			//Bit inversions and shifts to avoid using multiplication
			//for negative numbers
			count[0] = ite[7:4];
			y_tmp[0] = sign ? y_in : ~y_in+1;
			y_tmp[1] = {y_tmp[0][32], y_tmp[0][31:0]>>count[0]};
			x_tmp[0] = sign ? x_in : ~x_in+1;
			x_tmp[1] = {x_tmp[0][32], x_tmp[0][31:0]>>count[0]};
			
			//Calculate x and y using only addition
			x[0] = x_in + y_tmp[1];
			y[0] = x_tmp[1] + y_in;
			
			//Make atan negative if sign is negative
			atan[0] = sign ? arctan_in_1 : ~arctan_in_1+1;
			
			//Find current angle without multiplication
			current_angle[0] = curr_angle_in + atan[0];
			
			//Determines next sign
			if (current_angle[0] > target_in) begin
				sign = 1'b0;
			end
			else begin
				sign = 1'b1;
			end
			
			//Repeats the above
			
			count[1] = ite[3:0];
			y_tmp[2] = sign ? y[0] : ~y[0]+1;
			y_tmp[3] = {y_tmp[2][32], y_tmp[2][31:0]>>count[1]};
			x_tmp[2] = sign ? x[0] : ~x[0]+1;
			x_tmp[3] = {x_tmp[2][32], x_tmp[2][31:0]>>count[1]};
			
			x[1] = x[0] + y_tmp[3];
			y[1] = x_tmp[3] + y[0];
			
			atan[1] = sign ? arctan_in_2 : ~arctan_in_2+1;
			current_angle[1] = current_angle[0] + atan[1];
			
			if (current_angle[1] > target_in) begin
				sign = 1'b0;
			end
			else begin
				sign = 1'b1;
			end
			
	end
		
	assign sign_out = sign;
	assign curr_angle_out = current_angle[1];
	assign x_out = x[1];
	assign y_out = y[1];
	assign USE_SIN_out = USE_SIN_in;
	assign target_out = target_in;
			
endmodule