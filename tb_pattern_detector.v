interface DUT_IF(input bit clk);
    logic rst_n;
    logic data_in;
    logic done;
endinterface

class transaction;
    rand logic data_in;    
endclass

module top();
    parameter CYCLE = 10;
    bit clk = 1;

    DUT_IF dut_if(clk);
    
    TEST test(dut_if, clk);
    DUT dut(.clk(clk), 
            .rst_n(dut_if.rst_n),
            .data_in(dut_if.data_in),
            .done(dut_if.done)); 

    initial begin
      	$dumpfile("dump.vcd");
      	$dumpvars;
    end

    initial begin
        clk <= 0;
        forever #(CYCLE / 2) clk = ~clk;
    end
endmodule

program automatic TEST(DUT_IF dut_if, input bit clk);
    transaction tr;
    
    task reset();
        dut_if.rst_n = 0; 
        repeat (3) @(posedge clk);
        dut_if.rst_n = 1; 
    endtask    
    
    task random_test();
        int i;

        for (i = 0; i < 100; i++) begin 
            @(posedge clk);
            tr = new();
            tr.randomize();
            dut_if.data_in = tr.data_in;
        end
    endtask    
    
    task corner_case();
        int i;

        dut_if.rst_n = 0;
        @(posedge clk);
        dut_if.rst_n = 1;
        dut_if.data_in = 1;
          
        @(posedge clk);
        dut_if.data_in = 0;
        @(posedge clk);
        dut_if.data_in = 1;
        @(posedge clk);
        dut_if.data_in = 1;
        @(posedge clk);
        dut_if.data_in = 0;
        repeat (5) @(posedge clk);
    endtask
    
    task run();
      	fork 
        	reset();
            random_test();
        join
        corner_case();
        $finish;
    endtask
  
  	initial begin
        run();
    end
endprogram
