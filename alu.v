module alu(
input [7:0] a,
input [7:0] b,
input cy_in,
input [3:0] alu_opr,
output reg [7:0] result,
output reg s,
output reg z,
output reg ac,
output reg p,
output reg cy
);

//opcode declaration
localparam alu_add  = 4'b0000;
localparam alu_adc  = 4'b0001;
localparam alu_sub  = 4'b0010;
localparam alu_sbb  = 4'b0011;
localparam alu_ana  = 4'b0100;
localparam alu_ora  = 4'b0101;
localparam alu_xra  = 4'b0110;
localparam alu_cmp  = 4'b0111;
localparam alu_inr  = 4'b1000;
localparam alu_dcr  = 4'b1001;
localparam alu_rlc  = 4'b1010;
localparam alu_rrc  = 4'b1011;
localparam alu_ral  = 4'b1100;
localparam alu_rar  = 4'b1101;
localparam alu_cma  = 4'b1110;
localparam alu_cmc  = 4'b1111;

reg [8:0] temp;
reg [4:0] lower_temp;

//implementaion of operations

always @(*) begin

	result=8'h00;
	s=1'b0;
	z=1'b0;
	ac=1'b0;
	p=1'b0;
	cy=1'b0;
	temp=9'h000;
	lower_temp=5'h00;

	case(alu_opr)

		alu_add:
		begin
			temp={1'b0,a}+{1'b0,b};
			result=temp[7:0];
			cy=temp[8];
			s=result[7];
			z=(result==8'h00);
			p=~^result;
			lower_temp={1'b0,a[3:0]}+{1'b0,b[3:0]};
			ac=lower_temp[4];
		end

		alu_adc:
		begin
			temp={1'b0,a}+{1'b0,b}+{8'b0,cy_in};
			result=temp[7:0];
			cy=temp[8];
			s=result[7];
			z=(result==8'h00);
			p=~^result;
			lower_temp={1'b0,a[3:0]}+{1'b0,b[3:0]}+{4'b0,cy_in};
			ac=lower_temp[4];
		end

		alu_sub:
		begin
			result=a-b;
			cy=({1'b0,a}<({1'b0,b}));
			s=result[7];
			z=(result==8'h00);
			p=~^result;
			ac=(a[3:0]<b[3:0]);
		end

		alu_sbb:
		begin
			result=a-b-{7'b0,cy_in};
			cy=({1'b0,a}<({1'b0,b}+{8'b0,cy_in}));
			s=result[7];
			z=(result==8'h00);
			p=~^result;
			ac=({1'b0,a[3:0]}<({1'b0,b[3:0]}+{4'b0,cy_in}));
		end

		alu_ana:
		begin
			result=a&b;
			s=result[7];
			z=(result==8'h00);
			p=~^result;
			ac=1'b1;
			cy=1'b0;
		end

		alu_ora:
		begin
			result=a|b;
			s=result[7];
			z=(result==8'h00);
			p=~^result;
			ac=1'b0;
			cy=1'b0;
		end

		alu_xra:
		begin
			result=a^b;
			s=result[7];
			z=(result==8'h00);
			p=~^result;
			ac=1'b0;
			cy=1'b0;
		end

		alu_cmp:
		begin
			result=a-b;
			cy=({1'b0,a}<({1'b0,b}));
			s=result[7];
			z=(result==8'h00);
			p=~^result;
			ac=(a[3:0]<b[3:0]);
		end

		alu_inr:
		begin
			result=a+1'b1;
			s=result[7];
			z=(result==8'h00);
			p=~^result;
			lower_temp={1'b0,a[3:0]}+1'b1;
			ac=lower_temp[4];
			cy=cy_in;
		end

		alu_dcr:
		begin
			result=a-1'b1;
			s=result[7];
			z=(result==8'h00);
			p=~^result;
			ac=(a[3:0]==4'h0);
			cy=cy_in;
		end

		alu_rlc:
		begin
			result={a[6:0],a[7]};
			cy=a[7];
		end

		alu_rrc:
		begin
			result={a[0],a[7:1]};
			cy=a[0];
		end

		alu_ral:
		begin
			result={a[6:0],cy_in};
			cy=a[7];
		end

		alu_rar:
		begin
			result={cy_in,a[7:1]};
			cy=a[0];
		end

		alu_cma:
		begin
			result=~a;
			cy=cy_in;
		end

		alu_cmc:
		begin
			result=a;
			cy=~cy_in;
		end

	endcase
end

endmodule
