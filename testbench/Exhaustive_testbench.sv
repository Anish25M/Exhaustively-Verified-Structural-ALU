`timescale 1ns / 1ps
module ALU_testbench();
  
  // inputs
  reg signed [3:0] a,b;
  reg [2:0] sel;
  reg cin;
  
  //outputs of DUT
  wire [3:0] result,NZCV;
  
  //outputs of golden model
  reg [3:0] expected_result,expected_NZCV;
  reg N,Z,C,V;
  
  //DUT
  ALU ALU_DUT (a,b,sel,cin,result,NZCV);
  int i,j,z;
  
  //Golden model
  always @(*) begin
    {C,V}={2{1'b0}};
    case(sel)
      3'b000: begin
        {C,expected_result}= {1'b0,a}+{1'b0,b};
        if(a+b<8 && -9<a+b) begin
          V=1'b0;
        end else begin
          V=1'b1;
        end
      end
      3'b001: begin
        {C, expected_result} = {1'b0, a} + {1'b0, ~b} + 1'b1;
        if(a-b<8 && -9<a-b) begin
          V=1'b0;
        end else begin
          V=1'b1;
        end
      end
      3'b010: expected_result= a&b;
      3'b011: expected_result= a|b;
      3'b100: expected_result= a^b;
      3'b101: expected_result= ~a;
      3'b110: expected_result= {a[2],a[1],a[0],1'b0};
      3'b111: expected_result={1'b0,a[3],a[2],a[1]};
        

    endcase
    Z= (expected_result==4'b0000)?1'b1:1'b0;
    N= expected_result[3];
    expected_NZCV={N,Z,C,V};
  end
  
  
 //Stimulus
  initial begin
   
    for(i=-8; i<8; i++) begin
      for (j=-8; j<8; j++) begin
        for (z=0;z<8;z++) begin
          a=i; b=j; sel=z;
          case(z) 
            3'b001: cin=1'b1;
            default: cin=1'b0;
          endcase
          #10;
          //scoreboard
          if((expected_result != result) || (expected_NZCV != NZCV) ) begin
            $display("Wrong answer on a=%4b,b=%4b,sel=%3b,cin=%b"
                     ,a,b,sel,cin);
            $display("expected: (%4b,%4b), Got: (%4b,%4b)",
                     expected_result,expected_NZCV,result,NZCV);
            $finish;
          end
        end
      end
    end
    $display("All testcases passed");
  end
endmodule