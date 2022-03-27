//By            : Zhengsen Fu
//Last Updated  : Jun 25 2020
//
//Module Summary:
//    A flex counter taking parametrized number of bits.
//
//Parameter:
//    NUM_BITS  - Number of bits that defines maximum count and rollover value
//Inputs:
//    clear         - Synchronize reset signal
//    count_enable  - Enable signal. Counter keeps counting up if this signal is on
//    rollover_val  - Maximum counting value of the counter
//Outputs:
//    count_out     - Current counting value. Reset to 0. Rollover to 1. 
//    rollover_flag - This signal is on when count_out == rollover_val
module flex_counter #(parameter NUM_BITS = 4) (counter_if.counter fc_if);
    reg [NUM_BITS - 1:0] next_count;
    reg next_flag;

    always_ff @ (posedge fc_if.clk, negedge fc_if.n_rst) begin
        if (fc_if.n_rst == 0) begin
            fc_if.count_out <= 0;
            fc_if.rollover_flag <= 0;
        end else begin
            fc_if.count_out <= next_count;
            fc_if.rollover_flag <= next_flag;
        end
    end

    always_comb begin
        if(fc_if.clear) begin
            next_count = 0;
        end
        else if(fc_if.count_enable) begin
            if(fc_if.rollover_val == fc_if.count_out) begin
                next_count = 1;
            end
            else begin
                next_count = fc_if.count_out + 1;
            end
        end
        else begin
            next_count = fc_if.count_out;
        end
    end

    always_comb begin
        if(fc_if.clear) 
            next_flag = 0;
        else if(fc_if.rollover_val == next_count) begin
            next_flag = 1;
        end
        else begin
            next_flag = 0;
        end
    end



endmodule


