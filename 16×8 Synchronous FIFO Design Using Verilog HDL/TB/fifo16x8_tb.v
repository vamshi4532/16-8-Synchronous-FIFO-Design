
module fifo16x8_tb;

    reg clk, rst, re, we;
    reg [7:0] d_in;
    wire [7:0] d_out;
    wire full, empty;

    parameter clock = 10;
    integer j, k;

    fifo16x8 DUT(d_in, clk, rst, re, we, full, d_out, empty);

    always #(clock/2) clk = ~clk;

    task initialize;
    begin
        clk = 0;
        rst = 0;
        re = 0;
        we = 0;
        d_in = 0;
    end
    endtask

    task reset;
    begin
        @(negedge clk);
        rst = 1'b1;

        @(negedge clk);
        rst = 1'b0;
    end
    endtask

    task write(input [7:0] b);
    begin
        @(negedge clk);
        we = 1'b1;
        re = 1'b0;
        d_in = b;

        @(negedge clk);
        we = 1'b0;
    end
    endtask

    task read;
    begin
        @(negedge clk);
        re = 1'b1;
        we = 1'b0;

        @(negedge clk);
        re = 1'b0;
    end
    endtask

    initial
    begin
        $monitor("time=%0t rst=%b we=%b re=%b d_in=%h d_out=%h full=%b empty=%b",
                 $time, rst, we, re, d_in, d_out, full, empty);

        initialize;
        reset;

        // Write
        for (j = 0; j < 16; j = j + 1)
        begin
            write(j);
        end

        // Check full flag
        #1;
        $display("After 16 writes: full=%b empty=%b", full, empty);

        // Read
        for (k = 0; k < 16; k = k + 1)
        begin
            read;
        end

        // Check empty flag
        #1;
        $display("After 16 reads: full=%b empty=%b", full, empty);

        #10;
        $finish;
    end

endmodule
