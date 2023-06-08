module ALU_PROJECT_GROUP5(A,B,OPCODE,CLK,RST,C,ZF,SF,CF);
    
    //input
	input [3:0] A,B;
	input [2:0] OPCODE;
	input CLK;
	input RST;
	
	
	
	//output
	output reg [3:0]C;
	output reg CF,SF,ZF;
	
	
	reg [3:0] current, next;
	reg [1:0] b1,b2,b3,b4;
	
	
	parameter xor_s0 = 3'b000, xor_s1=3'b001, xor_s2=3'b010, xor_s3=3'b011, xor_s4=3'b100;
	
	parameter add_s0 = 3'b000, add_s1=3'b001, add_s2=3'b010, add_s3=3'b011, add_s4=3'b100;
	
	parameter xnor_s0 = 3'b000, xnor_s1=3'b001, xnor_s2=3'b010, xnor_s3=3'b011, xnor_s4=3'b100;
	
	parameter sub_s0 = 3'b000, sub_s1=3'b001, sub_s2=3'b010, sub_s3=3'b011, sub_s4=3'b100;
	
	
	
	always @(posedge CLK)begin
	
	//xor
	   if (OPCODE == 3'b001)begin
			current = next;
			case(current)
				xor_s0: next = xor_s1;
				xor_s1: next = xor_s2;
				xor_s2: next = xor_s3;
				xor_s3: next = xor_s4;
				xor_s4: next = xor_s0;
			endcase
		end
	//add
	    if (OPCODE == 3'b010)begin
			current = next;
			case(current)
				add_s0: next = add_s1;
				add_s1: next = add_s2;
				add_s2: next = add_s3;
				add_s3: next = add_s4;
				add_s4: next = add_s0;
					
			endcase
		end
	//xnor	
		if (OPCODE == 3'b011)begin
			current = next;
			case(current)
				xnor_s0: next = xnor_s1;
				xnor_s1: next = xnor_s2;
				xnor_s2: next = xnor_s3;
				xnor_s3: next = xnor_s4;
				xnor_s4: next = xnor_s0;
					
			endcase
		end
	//sub	
		if (OPCODE == 3'b100)begin
			current = next;
			case(current)
				sub_s0: next = sub_s1;
				sub_s1: next = sub_s2;
				sub_s2: next = sub_s3;
				sub_s3: next = sub_s4;
				sub_s4: next = sub_s0;
					
			endcase
		end
	
	end
		
	always @(current)begin
	CF = 0;
    //reset
	if (OPCODE == 3'b000)begin
					
		 C[0]= C[0];
		 C[1]= C[1];  
	     C[2]= C[2];
		 C[3]= C[3];	
		 
		 SF = 0;
		 ZF = 0;			
	end
	
	//xor
	if (OPCODE == 3'b001)begin
		case(current)			
			xor_s1: C[0]= A[0]^B[0];
			xor_s2: C[1]= A[1]^B[1];  
			xor_s3: C[2]= A[2]^B[2];
			xor_s4: C[3]= A[3]^B[3];	
		endcase				
		
		SF = C[3];
		if (C == 4'b0000)
			ZF = 1;
		else
			ZF = 0;
	end
	
	//add
	
	if (OPCODE == 3'b010)begin
		case(current)
			add_s1:begin
				b1=A[0]+B[0];
				C[0]=b1[0];
			end
			add_s2:begin
				b2=A[1]+B[1]+b1[1];
				C[1]=b2[0];
			end
			add_s3:begin
				b3=A[2]+B[2]+b2[1];
				C[2]=b3[0];
			end
			add_s4:begin
				b4=A[3]+B[3]+b3[1];
				C[3]=b4[0];
			end
		endcase
		CF = b4[1];
		SF = C[3];
		if (C == 4'b0000)begin
			ZF = 1;
		end
		else
			ZF = 0;
	 end
	
	
	
	//xnor
	
	if (OPCODE == 3'b011)begin
		case(current)
			xnor_s1: C[0]= ~(A[0] ^ B[0]);
			xnor_s2: C[1]= ~(A[1] ^ B[1]);
			xnor_s3: C[2]= ~(A[2] ^ B[2]);
			xnor_s4: C[3]= ~(A[3] ^ B[3]);
		endcase	
		SF = C[3];
		if (C == 4'b0000)
			ZF = 1;
		else
			ZF = 0;
	end
	
	//sub
	if (OPCODE == 3'b100)begin
		case(current)
			sub_s1: C[0] = 0~^B[0];
			sub_s2: C[1] = 0~^B[1];
			sub_s3: C[2] = 0~^B[2];
			sub_s4:	C[3] = 0~^B[3];
		endcase
		
		case(current)
			sub_s1:begin
				b1=A[0]+C[0]+1;
				C[0]=b1[0];
			end
			sub_s2:begin
				b2=A[1]+C[1]+b1[1];
				C[1]=b1[0];
			end
			sub_s3:begin
				b3=A[2]+C[2]+b2[1];
				C[2]=b3[0];
			end
			sub_s4:begin
				b4=A[3]+C[3]+b3[1];
				C[3]=b4[0];
			end
		endcase
		
		CF = b4[1];
		SF = C[3];
		if (C== 4'b0000)
			ZF = 1;
		else		
			ZF = 0;
	end
	end
	endmodule
	