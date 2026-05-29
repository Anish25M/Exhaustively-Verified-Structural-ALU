`timescale 1ns / 1ps

module ALU (input [3:0] a,b,
            input [2:0] sel,
            input cin,
            output [3:0] result,NZCV);
  
  wire [3:0] mathresult,bitand,bitor,bitxor,bitnot,Lshift,Rshift;
  wire N,Z,C_ar,V_ar,C,V;
  arithmetic arithmetic_unit(a,b,cin,sel,mathresult,C_ar,V_ar);
  
  logical logical_unit(a,b,bitand,bitor,bitxor,bitnot,Lshift,Rshift);
  
  mux81 mux_unit(mathresult,
                 bitand,bitor,bitxor,bitnot,Lshift,Rshift,
                 sel,result);
  
  assign N=result[3];
  assign Z= (result==4'b0000)?1'b1:1'b0;
  assign {C,V}=((sel == 3'b000)||(sel == 3'b001))?{C_ar,V_ar}:{1'b0, 1'b0};
  assign NZCV={N,Z,C,V};
  
endmodule
  

module logical (input [3:0] a,b,
                     output [3:0] bitand,bitor,bitxor,bitnot,Lshift,Rshift);
  assign {bitand,bitor,bitxor,bitnot}={a&b,a|b,a^b,~a};
  assign Lshift = {a[2],a[1],a[0],1'b0};
  assign Rshift = {1'b0,a[3],a[2],a[1]};
endmodule


module arithmetic(input [3:0] a,b,
                       input c0,
                       input [2:0] sel,
                       output [3:0] netsum,
                       output c,v);
  wire [3:0] bnew;
  assign bnew= b ^ {4{sel[0]}};
  wire c1,c2,c3;
  wire s4,s1,s2,s3;
  fulladder add0(a[0],bnew[0],c0,c1,s1);
  fulladder add1(a[1],bnew[1],c1,c2,s2);
  fulladder add2(a[2],bnew[2],c2,c3,s3);
  fulladder add3(a[3],bnew[3],c3,c,s4);
  assign netsum={s4,s3,s2,s1};
  assign v=c3^c;
endmodule


module fulladder(input a,b,cin,
                 output cout,sum);
  assign cout= (a & b) | (b & cin) | (cin & a);
  assign sum= a^b^cin;
endmodule


module mux81(input [3:0] mathresult,bitand,bitor,bitxor,bitnot,Lshift,Rshift,
             input[2:0] sel,
             output reg [3:0] out);
  always @(*) begin
    case(sel)
      3'b000:out=mathresult;
      3'b001:out=mathresult;
      3'b010:out=bitand;
      3'b011:out=bitor;
      3'b100:out=bitxor;
      3'b101:out=bitnot;
      3'b110:out=Lshift;
      default: out=Rshift;
    endcase
  end
endmodule