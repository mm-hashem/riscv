module testbench
    import definitions_pkg::*; ();

    timeunit 1ns/1ns;

    logic   clk_i, rst_i;
    word_st pc_init_i;

    always #5 clk_i = ~clk_i;

    rv32i rv32i_inst (.*);

    initial begin: init
        clk_i <= 0;

        rst_i <= 1;
        pc_init_i <= 32'sh0;
        repeat (3) @(posedge clk_i);
        rst_i <= 0;
        pc_init_i <= 32'sh1000;
        repeat (10) @(posedge clk_i);
        $stop;
    end: init
    
endmodule: testbench