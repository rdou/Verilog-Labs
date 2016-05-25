`timescale 1ns/10ps

module D3D(
    input clk,
    input rst_n,
    input digit,
  	output reg result);
    
    parameter ZERO = 2'b00;
    parameter ONE  = 2'b01;
    parameter TWO  = 2'b10;

   	reg[1:0] state, next; 

    always @(posedge clk) begin
        if (!rst_n) 
            state <= ZERO;
        else 
            state <= next;
    end
    
    always @(posedge clk) begin
      	if (!rst_n) 
            result <= 2'b0;
        else begin
            result <= 2'b0;

            case (state)
                ONE :
                    if (digit)
                        result <= 1'b1;

                default:
                    result <= 1'b0;
            endcase
        end
    end

    always @(state or digit) begin
        case (state)
            ZERO:
                if (!digit) 
                    next = ZERO;
                else 
                    next = ONE;

            ONE :
                if (!digit) 
                    next = TWO;
                else 
                    next = ZERO;
            
            TWO :
                if (!digit) 
                    next = ONE;
                else 
                    next = TWO;
        endcase
    end
endmodule 
