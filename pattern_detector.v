`timescale 1ns/10ps

// This is a Mealy machine - output values are determined 
// both by its current state and the current inputs. 
module DUT(
    input clk,
    input rst_n,
    input data_in,
    output done);
    
    parameter IDLE   = 3'b000;
    parameter S_1    = 3'b001;
    parameter S_10   = 3'b010;
    parameter S_101  = 3'b011;
    parameter S_1011 = 3'b100;
    
  	reg[2:0] state, next;
    reg done;

    always @(posedge clk) begin
        if (!rst_n) 
            state <= IDLE;
        else 
            state <= next; 
    end
     
    always @(posedge clk) begin
        if (!rst_n) 
            done <= 1'b0;
        else 
            done <= 1'b0;
            
            if (state == S_1011 && data_in == 1'b0) 
                done <= 1'b1; 
    end
    
    always @(state or data_in) begin
        case (state)
            IDLE   :
                if (data_in)
                    next = S_1;     
            S_1    :
                if (!data_in) 
                    next = S_10; 
            S_10   :
                if (data_in)
                    next = S_101;
                else 
                    next = IDLE;
            S_101  :
                if (data_in)
                    next = S_1011;
                else 
                    next = S_10; 

            S_1011 :
                if (data_in)
                    next = S_1;
                else
                    next = IDLE;
        endcase
    end        
endmodule
