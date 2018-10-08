module SORT(
  // Input signals
  clk,
  rst_n,
  in_valid1,
  in_valid2,
  in,
  mode,
  op,
  // Output signals
  out_valid,
  out
);
//---------------------------------------------------------------------
//   INPUT AND OUTPUT DECLARATION                         
//---------------------------------------------------------------------
input clk;
input rst_n;
input in_valid1;
input in_valid2;
input mode;
input [1:0]op;
input [4:0]in;
output reg out_valid;
output reg [4:0]out;
//---------------------------------------------------------------------
// PARAMETER DECLARATION
//---------------------------------------------------------------------
parameter IDLE=0;
parameter GET=1;
parameter DO_STACK=2;
parameter DO_QUEUE=3;
parameter SORT=4;
parameter OUTPUT=5;	
//---------------------------------------------------------------------
//   WIRE AND REG DECLARATION                             
//---------------------------------------------------------------------
reg [3:0]current_state,next_state;
reg getmode;
reg [3:0]count,count2;
reg [4:0]ans[0:9];
reg check;
reg [4:0]check3;
reg [3:0] a,b;
reg [4:0]a1,a2,a3,a4,a5,a6,a7,a8,a9,a10;
//---------------------------------------------------------------------
//   Finite-State Mechine                                          
//---------------------------------------------------------------------
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		current_state<=IDLE;
	else
		current_state<=next_state;
end
always@(*) begin
	case(current_state)
		IDLE:
			next_state<=GET;
		GET:begin
			if(getmode==0&&op==0&&in_valid1)
				next_state<=DO_STACK;
			else if(getmode==1&&op==0&&in_valid1)
				next_state<=DO_QUEUE;
			else if(op==2&&in_valid1)
				next_state<=SORT;
			else
				next_state<=GET;	
		end
		DO_STACK:begin
			if(op==2&&in_valid1)
				next_state<=SORT;
			else if(op==0&&in_valid1)
				next_state<=DO_STACK;
			else
				next_state<=GET;
		end
		DO_QUEUE:begin
			if(op==2&&in_valid1)
				next_state<=SORT;
			else if(op==0&&in_valid1)
				next_state<=DO_QUEUE;
			else
				next_state<=GET;
		end
		SORT:begin
			if(check3==count-1)
				next_state<=OUTPUT;
			else
				next_state<=SORT;
		end
		OUTPUT:begin
			if(count2==9)
				next_state<=IDLE;
			else
				next_state<=OUTPUT;	
		end
		default:next_state<=IDLE;
	endcase
end	
//---------------------------------------------------------------------
//   Design Description                                          
//---------------------------------------------------------------------
/*always@(*) begin
	if(!rst_n) begin
		a1=0;	a2=0;	a3=0;
		a4=0;	a5=0;	a6=0;
		a7=0;	a8=0;	a9=0;
		a10=0;
	end
	else begin
		a1=ans[0];
		a2=ans[1];
		a3=ans[2];
		a4=ans[3];
		a5=ans[4];
		a6=ans[5];
		a7=ans[6];
		a8=ans[7];
		a9=ans[8];
		a10=ans[9];
	end
end*/

always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		getmode<=0;
	else if(in_valid2)
		getmode<=mode;
	else
		getmode<=getmode;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		check3<=0;
	else if(current_state==SORT)
		check3<=check3+1;
	else
		check3<=0;
end	
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		count<=0;
	else if(current_state==IDLE)
		count<=0;
	else if(op==1&&in_valid1)
		count<=count+1;
	else if(next_state==DO_STACK||next_state==DO_QUEUE)
		count<=count-1;
	/*else if(next_state==DO_QUEUE)
		count<=count-1;*/
	else
		count<=count;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		count2<=0;
	/*else begin
		case(current_state)
			IDLE:
				count2<=0;
			OUTPUT:
				count2<=count2+1;
			default:count2<=count2;
		endcase
	end*/
	/*else if(current_state==IDLE)
		count2<=0;*/
	else if(current_state==OUTPUT)
		count2<=count2+1;
	else
		count2<=0;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		check<=0;
	else if(current_state==SORT&&check==0)
		check<=1;
	else
		check<=0;
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)begin
		//check<=0;
		for(a=0;a<10;a=a+1)
			ans[a]<=0;
	end
	else if(next_state==DO_STACK) begin
		if(count<10)
			ans[count]<=0;
		else
			ans[0]<=ans[0];
	end
	else if(next_state==DO_QUEUE) begin
		for(a=0;a<9;a=a+1) begin
				ans[a]<=ans[a+1];
		end
		ans[count-1]<=0;
	end
	else if(op==1&&in_valid1)begin
                ans[count]<=in;
	end
	else if(current_state==SORT) begin
	//else if(next_state==SORT) begin
		/*case(count)
			2:begin
				for(b=0;b<2;b=b+1)begin
					for(a=0;a<1;a=a+2)begin
						if(ans[a]<ans[a+1])begin
							ans[a]<=ans[a+1];
							ans[a+1]<=ans[a];
						end
					end
				end
			end
			3:begin
				for(b=0;b<3;b=b+1)begin
                                        for(a=0;a<2;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
					for(a=1;a<2;a=a+2)begin
						if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
					end
                                end
                        end

			4:begin
				 for(b=0;b<4;b=b+1)begin
                                        for(a=0;a<3;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                        for(a=1;a<3;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                end

                        end

			5:begin
				 for(b=0;b<5;b=b+1)begin
                                        for(a=0;a<4;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                        for(a=1;a<4;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                end
                        end

			6:begin
				 for(b=0;b<6;b=b+1)begin
                                        for(a=0;a<5;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                        for(a=1;a<5;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                end

                        end
			7:begin
				 for(b=0;b<7;b=b+1)begin
                                        for(a=0;a<6;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                        for(a=1;a<6;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                end
                        end

			8:begin
				 for(b=0;b<8;b=b+1)begin
                                        for(a=0;a<7;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                        for(a=1;a<7;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                end
                        end
			9:begin
				 for(b=0;b<9;b=b+1)begin
                                        for(a=0;a<8;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                        for(a=1;a<8;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                end
                        end
			10:begin
				 for(b=0;b<10;b=b+1)begin
                                        for(a=0;a<9;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                        for(a=1;a<9;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
                                end

			end
		endcase
	end*/			
		if(check==1)begin
			case(count)
				2:begin
					for(a=0;a<1;a=a+2) begin
                                		if(ans[a]<ans[a+1])begin
                                        		ans[a]<=ans[a+1];
                                       			ans[a+1]<=ans[a];
                               			end
					end
				end
				3:begin
                                        for(a=0;a<2;a=a+2)begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
					end
                                end
				4:begin
                                        for(a=0;a<3;a=a+2) begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
					end
                                end
				5:begin
                                        for(a=0;a<4;a=a+2) begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
					end
                                end
				6:begin
                                        for(a=0;a<5;a=a+2) begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
					end
                                end
				7:begin
                                        for(a=0;a<6;a=a+2) begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
					end
                                end
				8:begin
                                        for(a=0;a<7;a=a+2) begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
						end
					end
                                end
				9:begin
                                        for(a=0;a<8;a=a+2) begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
					end
                                end
				10:begin
                                        for(a=0;a<9;a=a+2) begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
					end
                                end
				default:ans[0]<=ans[0];
			endcase
		//check<=0;
		end
		else begin
			case(count)
				3:begin
					for(a=1;a<2;a=a+2) begin
                                               if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                               end
                                        end
				end
				4:begin
                                        for(a=1;a<3;a=a+2) begin
                                               if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                               end
					end
				end
				5:begin
                                        for(a=1;a<4;a=a+2) begin
                                               if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                               end
                                        end
				end
				6:begin
                                        for(a=1;a<5;a=a+2) begin
                                               if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                               end
                                        end
				end
				7:begin
                                        for(a=1;a<6;a=a+2) begin
                                                if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
				end
				8:begin
                                        for(a=1;a<7;a=a+2) begin
                                                if(ans[a]<ans[a+1])begin
                	                                ans[a]<=ans[a+1];
                        	                        ans[a+1]<=ans[a];
                                                end
                                        end
				end
				9:begin
					for(a=1;a<8;a=a+2) begin
						if(ans[a]<ans[a+1])begin
                                                        ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
					end
				end
				10:begin
                                        for(a=1;a<9;a=a+2) begin
                                        	if(ans[a]<ans[a+1])begin
                                	                ans[a]<=ans[a+1];
                                                        ans[a+1]<=ans[a];
                                                end
                                        end
				end
				default:ans[0]<=ans[0];
			endcase
		//check<=1;
		end	
	end
	else if(current_state==OUTPUT) begin
		case(count)
			1:begin	
				for(a=1;a<10;a=a+1)
                			ans[a]<=0;
			end
			2:begin
                        	for(a=2;a<10;a=a+1)
                                	ans[a]<=0;
                        end
			3:begin
                                for(a=3;a<10;a=a+1)
                                	ans[a]<=0;
                        end
			4:begin
                                for(a=4;a<10;a=a+1)
                         	       ans[a]<=0;
                        end
			5:begin
                                for(a=5;a<10;a=a+1)
                                	ans[a]<=0;
                        end
			6:begin
                                for(a=6;a<10;a=a+1)
                                	ans[a]<=0;
                        end
			7:begin
                                for(a=7;a<10;a=a+1)
                              		ans[a]<=0;
                        end
			8:begin
                                for(a=8;a<10;a=a+1)
                                	ans[a]<=0;
                        end
			9:begin
                                /*for(a=9;a<10;a=a+1)
                                ans[a]<=0;*/
				ans[9]<=0;
                        end
			default:ans[0]<=ans[0];
		endcase
	end	
	else
		ans[0]<=ans[0];
end
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		out<=0;
	else if(current_state==OUTPUT) begin
		out<=ans[count2];
	end
	else
		out<=0;
end	
always@(posedge clk or negedge rst_n) begin
	if(!rst_n)
		out_valid<=0;
	else if(current_state==OUTPUT)
		out_valid<=1;
	else
		out_valid<=0;
end




endmodule
