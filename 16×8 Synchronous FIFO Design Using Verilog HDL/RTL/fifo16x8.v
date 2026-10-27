
module fifo16x8(d_in, clk, rst, re, we, full, d_out, empty);

    input clk, rst, re, we;
    input [7:0] d_in;
    output reg [7:0] d_out;
    output full, empty;

    reg [7:0] mem [15:0];
    reg [4:0] wp, rp;
    integer i;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            for (i = 0; i < 16; i = i + 1)
                mem[i] <= 0;

            wp <= 0;
            rp <= 0;
            d_out <= 0;
        end
        else if (we && !re && !full)
        begin
            mem[wp[3:0]] <= d_in;
            wp <= wp + 1;
        end
        else if (re && !we && !empty)
        begin
            d_out <= mem[rp[3:0]];
            rp <= rp + 1;
        end
    end

    assign full = ((wp[4] != rp[4]) &&
                   (wp[3:0] == rp[3:0])) ? 1'b1 : 1'b0;

    assign empty = (wp == rp) ? 1'b1 : 1'b0;

endmodule
