`timescale 1ns / 1ps
module ALU_testbench();
  reg [3:0] a,b;
  reg [2:0] sel;
  reg cin;
  wire [3:0] result,NZCV;
  reg [3:0] expected_result,expected_NZCV;
  
  ALU ALU_DUT (a,b,sel,cin,result,NZCV);
  
  task arithmetic_test;
        input [3:0] test_a;
        input [3:0] test_b;
        input [2:0] test_sel;
        input test_cin;
    	input [3:0] expected_result;
   		input [3:0] expected_flags;
        begin
            a=test_a; b=test_b; sel=test_sel; cin=test_cin;
          
            #10;
          
        	if (result!==expected_result || NZCV!==expected_flags) begin
              $display("Output: (%b,%b) || Expected: (%b,%b) || verdict: failed", 
                         result, NZCV, expected_result, expected_flags);
              $display("\n Wrong answer on a=%4b ,b=%4b ,sel=%3b ,cin=%b",a,b,sel,cin);
              $finish;
            end else begin
              $display("Output: (%b,%b) || Expected: (%b,%b) || verdict: passed", 
                         result, NZCV, expected_result, expected_flags);
            end
        end
    endtask
    
  
    task logical_test;
        input [3:0] test_a;
        input [3:0] test_b;
        input [2:0] test_sel;
    	input [3:0] expected_result;
   		input [3:0] expected_flags;
        begin
            a=test_a; b=test_b; sel=test_sel; cin=1'b0 ;
          
            #10;
          
        	if (result!==expected_result || NZCV!==expected_flags) begin
              $display("Output: (%b,%b) || Expected: (%b,%b) || verdict: failed", 
                         result, NZCV, expected_result, expected_flags);
              $display("\n Wrong answer on a=%4b ,b=%4b ,sel=%3b ,cin=%b",a,b,sel,cin);
              $finish;
            end else begin
              $display("Output: (%b,%b) || Expected: (%b,%b) || verdict: passed", 
                         result, NZCV, expected_result, expected_flags);
            end
        end
    endtask
    
  initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, ALU_testbench);
    
    $display("\n[000] ADDITION");
        arithmetic_test(4'b0001, 4'b0001, 3'b000, 1'b0, 4'b0010, 4'b0000);
        arithmetic_test(4'b0011, 4'b0010, 3'b000, 1'b0, 4'b0101, 4'b0000);
        arithmetic_test(4'b0111, 4'b0110, 3'b000, 1'b0, 4'b1101, 4'b1001);
        arithmetic_test(4'b1111, 4'b1101, 3'b000, 1'b0, 4'b1100, 4'b1010);
        arithmetic_test(4'b1110, 4'b1000, 3'b000, 1'b0, 4'b0110, 4'b0011);
        arithmetic_test(4'b1011, 4'b0011, 3'b000, 1'b0, 4'b1110, 4'b1000);
        arithmetic_test(4'b0111, 4'b0111, 3'b000, 1'b0, 4'b1110, 4'b1001);
        arithmetic_test(4'b1000, 4'b1000, 3'b000, 1'b0, 4'b0000, 4'b0111);
    
   		$display("\n[001] SUBTRACTION");
        arithmetic_test(4'b0011, 4'b0010, 3'b001, 1'b1, 4'b0001, 4'b0010);
        arithmetic_test(4'b0101, 4'b0101, 3'b001, 1'b1, 4'b0000, 4'b0110);
        arithmetic_test(4'b0111, 4'b1011, 3'b001, 1'b1, 4'b1100, 4'b1001);
        arithmetic_test(4'b1000, 4'b0001, 3'b001, 1'b1, 4'b0111, 4'b0011);
        
        $display("\n[010] BITWISE AND");
        logical_test(4'b1100, 4'b1010, 3'b010, 4'b1000, 4'b1000);
        logical_test(4'b0101, 4'b0010, 3'b010, 4'b0000, 4'b0100);

        $display("\n[011] BITWISE OR");
        logical_test(4'b1000, 4'b0101, 3'b011, 4'b1101, 4'b1000);
        logical_test(4'b0000, 4'b0000, 3'b011, 4'b0000, 4'b0100);

        $display("\n[100] BITWISE XOR");
        logical_test(4'b1111, 4'b1010, 3'b100, 4'b0101, 4'b0000);
        logical_test(4'b0110, 4'b0110, 3'b100, 4'b0000, 4'b0100);

        $display("\n[101] BITWISE NOT");
        logical_test(4'b0000, 4'b1010,3'b101, 4'b1111, 4'b1000);
        logical_test(4'b1111, 4'b0101, 3'b101, 4'b0000, 4'b0100);
        logical_test(4'b1010, 4'b1111, 3'b101, 4'b0101, 4'b0000);

        $display("\n[110] LOGICAL SHIFT LEFT (LSL)");
        logical_test(4'b0011, 4'b0001, 3'b110, 4'b0110, 4'b0000);
        logical_test(4'b0101, 4'b0001, 3'b110, 4'b1010, 4'b1000);
        logical_test(4'b1000, 4'b0001, 3'b110, 4'b0000, 4'b0100);

   		$display("\n[111] LOGICAL SHIFT RIGHT (LSR)");
        logical_test(4'b0110, 4'b0001, 3'b111, 4'b0011, 4'b0000);
        logical_test(4'b1010, 4'b0001, 3'b111, 4'b0101, 4'b0000);
        logical_test(4'b0001, 4'b0001, 3'b111, 4'b0000, 4'b0100);
        $display("\nAll test cases passed");
    end
endmodule