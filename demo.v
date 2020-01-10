module demo(output reg [7:0] DATA_R, DATA_G, DATA_B,
								output reg [6:0] d7_1, 
								output reg [2:0] COMM, Life,
								output reg [1:0] COMM_CLK,
								output reg beep,
								output reg EN,
								input CLK, clear, ip0, ip1, ip2, ip3);
	reg [7:0] plate [7:0];
	reg [7:0] people [7:0];
	reg [6:0] seg1, seg2;
	reg [3:0] score_s,score_m;
	reg [3:0] inp, r;
	reg inp0, inp1, inp2, inp3;
	wire A0,B0,C0,D0,E0,F0,G0,
			A1,B1,C1,D1,E1,F1,G1;
	segment7 S0(score_s, A0,B0,C0,D0,E0,F0,G0);
	segment7 S1(score_m, A1,B1,C1,D1,E1,F1,G1);
	wire CLK_div, CLK_mv;
	divfreq div0(CLK, CLK_div);
	divfreq2 div2(CLK, CLK_mv);
	integer a, i, miss, count, count1, randq;

//初始值
	initial
		begin
			score_m = 0;
			score_s = 0;
			beep <= 0;
			randq = (5*randq+3)%16;		//位置&數量  例如 randq = 12 則r[0:3] = 4'b1100
			for(i=0;i<3;i=i+1)					//做的次數為4次
			begin
				if(randq / 2 != 0)
					begin
					r[3-i] = 1'b0;
					end
				randq = randq / 2;
			end
			a = 0;
			miss = 0;
			DATA_R = 8'b11111111;
			DATA_G = 8'b11111111;
			DATA_B = 8'b11111111;
			plate[0] = 8'b11111111;
			plate[1] = 8'b11111111;
			plate[2] = 8'b11111111;
			plate[3] = 8'b11111111;
			plate[4] = 8'b11111111;
			plate[5] = 8'b11111111;
			plate[6] = 8'b11111111;
			plate[7] = 8'b11111111;
			people[0] = 8'b11111111;
			people[1] = 8'b11111111;
			people[2] = 8'b11111111;
			people[3] = 8'b11111111;
			people[4] = 8'b11111111;
			people[5] = 8'b11111111;
			people[6] = 8'b11111111;
			people[7] = 8'b11111111;
			count1 = 0;
		end
	//7段顯示器的視覺暫留
always@(posedge CLK_div)
	begin
		seg1[0] = A0;
		seg1[1] = B0;
		seg1[2] = C0;
		seg1[3] = D0;
		seg1[4] = E0;
		seg1[5] = F0;
		seg1[6] = G0;
		
		seg2[0] = A1;
		seg2[1] = B1;
		seg2[2] = C1;
		seg2[3] = D1;
		seg2[4] = E1;
		seg2[5] = F1;
		seg2[6] = G1;
		
		if(count1 == 0)
			begin
				d7_1 <= seg1;
				COMM_CLK[1] <= 1'b1;
				COMM_CLK[0] <= 1'b0;
				count1 <= 1'b1;
			end
		else if(count1 == 1)
			begin
				d7_1 <= seg2;
				COMM_CLK[1] <= 1'b0;
				COMM_CLK[0] <= 1'b1;
				count1 <= 1'b0;
			end
		
		


	end

	//可失誤次數顯示
always@(posedge CLK_div)
	begin
		if(count >= 7)
			count <= 0;
		else
			count <= count + 1;
		COMM = count;
		EN = 1;
		if(miss < 3)
			begin
				DATA_R <= plate[count];
				DATA_G <= people[count];
				if(miss == 0)
					Life <= 3'b111;
				else if(miss == 1)
					Life <= 3'b110;
				else if(miss == 2)
					Life <= 3'b100;
			end
		else
			begin
				DATA_R <= plate[count];
				DATA_G <= 8'b11111111;
				Life <= 3'b000;
			end
	end
	
		//遊戲
always@(posedge CLK_mv)
	begin
		
		inp0 = ip0;
		inp1 = ip1;
		inp2 = ip2;
		inp3 = ip3;
		if(clear == 1)
			
				begin

					miss = 0;
					a = 0;
					
					randq = randq + 1;
					randq = (5*randq+3)%16;		//位置&數量  例如 randq = 12 則r[0:3] = 4'b1100
					for(i=0;i<3;i=i+1)					//做的次數為4次
					begin
						if(randq / 2 != 0)
							begin
							r[3-i] = 1'b0;
							end
						randq = randq / 2;
					end
					plate[0] = 8'b11111111;		//plate[直行] = {底部~~頂部};
					plate[1] = 8'b11111111;
					plate[2] = 8'b11111111;
					plate[3] = 8'b11111111;
					plate[4] = 8'b11111111;
					plate[5] = 8'b11111111;
					plate[6] = 8'b11111111;
					plate[7] = 8'b11111111;			
				end
////////////////////////////////////////
			//fall object 
			if(miss < 3)
				begin
					if(a == 0)							//a為落下的計數
						begin
							if(r[i] == 1)
										begin
											plate[i+2][a] = 1'b0;
										end
							a = a+1;
						end 
					else if (a > 0 && a <= 7)
						begin

									if(plate[i+2][a-1] == 1'b0)
											begin
												plate[i+2][a-1] = 1'b1;
												plate[i+2][a] = 1'b0;
											end
							a = a+1;
						end//of if
					else if(a == 8) 						//降至底部
						begin
										plate[i+2][a-1] = 1'b1;
								randq = randq + 1;
								randq = (5*randq+3)%16;		//位置&數量  例如 randq = 12 則r[0:3] = 4'b1100
								for(i=0;i<3;i=i+1)					//做的次數為4次
								begin
									if(randq / 2 != 0)
										begin
										r[3-i] = 1'b0;
										end
									randq = randq / 2;
								end
								a = 0;
						end//of else if
/////////////////////////////////////////	
			//按壓顯示		
				if(inp0 == 1)
							begin
								people[0][7]=1'b0;
								people[1][7]=1'b0;
							end
							if(inp1 == 1)
							begin
								people[2][7]=1'b0;
								people[3][7]=1'b0;
							end
							if(inp2 == 1)
							begin
								people[4][7]=1'b0;
								people[5][7]=1'b0;
							end
							if(inp3 == 1)
							begin
								people[6][7]=1'b0;
								people[7][7]=1'b0;
							end
			//判斷是否按在節奏上
				beep <= 0;
				for(i=0;i<=3;i=i+1)
					begin
						if(inp[i] == 1 && plate[i+2][7] == 0)
							begin
								if(score_s >= 9)
									begin
										score_s <= 0;
										score_m <= score_m + 1;
									end
								else
									begin
										score_s <= score_s + 1;
										if(score_m >= 9)
											begin
												score_m <= 0;
											end
									end
							end
						else if(inp[i]==0 &&plate[i+2][7]==0)
							begin
								//beep <= 1;
								miss = miss + 1;
							end
						plate[i+2][7] = 1'b1;
					end//of for
				a = 8;
				end//of if miss
			//game over ---> GG
		else
			begin
				plate[0] = 8'b01111110;
				plate[1] = 8'b10111101;
				plate[2] = 8'b11011011;
				plate[3] = 8'b11101111;
				plate[4] = 8'b11010111;
				plate[5] = 8'b10111011;
				plate[6] = 8'b01111101;
				plate[7] = 8'b11111111;
				people[0] = 8'b11111111;
				people[1] = 8'b11111111;
				people[2] = 8'b11111111;
				people[3] = 8'b11111111;
				people[4] = 8'b11111111;
				people[5] = 8'b11111111;
				people[6] = 8'b11111111;
				people[7] = 8'b11111111;
			end
	end
endmodule


//得分轉7段顯示器
module segment7(input [0:3] ar, output A,B,C,D,E,F,G);

	assign A = ~(ar[0]&~ar[1]&~ar[2] | ~ar[0]&ar[2] | ~ar[1]&~ar[2]&~ar[3] | ~ar[0]&ar[1]&ar[3]),
	       B = ~(~ar[0]&~ar[1] | ~ar[1]&~ar[2] | ~ar[0]&~ar[2]&~ar[3] | ~ar[0]&ar[2]&ar[3]),
			 C = ~(~ar[0]&ar[1] | ~ar[1]&~ar[2] | ~ar[0]&ar[3]),
			 D = ~(ar[0]&~ar[1]&~ar[2] | ~ar[0]&~ar[1]&ar[2] | ~ar[0]&ar[2]&~ar[3] | ~ar[0]&ar[1]&~ar[2]&ar[3] | ~ar[1]&~ar[2]&~ar[3]),
			 E = ~(~ar[1]&~ar[2]&~ar[3] | ~ar[0]&ar[2]&~ar[3]),
			 F = ~(~ar[0]&ar[1]&~ar[2] | ~ar[0]&ar[1]&~ar[3] | ar[0]&~ar[1]&~ar[2] | ~ar[1]&~ar[2]&~ar[3]),
			 G = ~(ar[0]&~ar[1]&~ar[2] | ~ar[0]&~ar[1]&ar[2] | ~ar[0]&ar[1]&~ar[2] | ~ar[0]&ar[2]&~ar[3]);
			 
endmodule


//掉落物&side除頻器
module divfreq2(input CLK, output reg CLK_mv);
  reg [24:0] Count;
  initial
    begin
      CLK_mv = 0;
	 end	
		
  always @(posedge CLK)
    begin
      if(Count > 3500000)
        begin
          Count <= 25'b0;
          CLK_mv <= ~CLK_mv;
        end
      else
        Count <= Count + 1'b1;
    end
endmodule 


//視覺暫留除頻器
module divfreq(input CLK, output reg CLK_div);
  reg [24:0] Count;
  always @(posedge CLK)
    begin
      if(Count > 5000)
        begin
          Count <= 25'b0;
          CLK_div <= ~CLK_div;
        end
      else
        Count <= Count + 1'b1;
    end
endmodule
