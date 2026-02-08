module testbench
    import definitions_pkg::*; ();

    timeunit 1ns/1ns;

    logic   clk_i, rst_i;
    word_st pc_init_i;

    always #5 clk_i = ~clk_i;

    word_st regfile_tb [0:31];
    word_st pc_tb;
    logic [7:0] ram[DATA_ORG:DATA_END-1];
    logic mem_write, reg_write;
    word_st mem_data, mem_addr;
    reg_e rd_addr;
    word_st rd_data;
    logic TOHOST;

`ifdef PIPELINE5
    rv32i_pipe rv32i_inst (.*);
    assign pc_tb = testbench.rv32i_inst.pc_ft2dc;

    assign ram = testbench.rv32i_inst.memory_dp_inst.data_ram_inst.ram;
    assign mem_write = testbench.rv32i_inst.memory_dp_inst.data_ram_inst.we_i;
    assign mem_data = testbench.rv32i_inst.memory_dp_inst.data_ram_inst.wd_i;
    assign mem_addr = testbench.rv32i_inst.memory_dp_inst.data_ram_inst.a_i;

    assign regfile_tb = testbench.rv32i_inst.decode_dp_inst.register_file_dc_inst.regfile;
    assign reg_write = testbench.rv32i_inst.decode_dp_inst.register_file_dc_inst.rd_we_i;
    assign rd_addr = testbench.rv32i_inst.decode_dp_inst.register_file_dc_inst.rd_a_i;
    assign rd_data = testbench.rv32i_inst.decode_dp_inst.register_file_dc_inst.rd_d_i;
`elsif PIPELINE3
    rv64i_zba_pipe3 rv64i_zba_pipe3_inst (.*);
    assign pc_tb = testbench.rv64i_zba_pipe3.fetch_inst.pc_ft;

    assign ram = testbench.rv64i_zba_pipe3.stage3_dp_inst.data_ram_s3_inst.ram;
    assign TOHOST = ram['h7F8];
    assign mem_write = testbench.rv64i_zba_pipe3.stage3_dp_inst.data_ram_s3_inst.we_i;
    assign mem_data = testbench.rv64i_zba_pipe3.stage3_dp_inst.data_ram_s3_inst.wd_i;
    assign mem_addr = testbench.rv64i_zba_pipe3.stage3_dp_inst.data_ram_s3_inst.a_i;

    assign regfile_tb = testbench.rv64i_zba_pipe3.decode_dp_inst.register_file_dc_inst.regfile;
    assign reg_write = testbench.rv64i_zba_pipe3.decode_dp_inst.register_file_dc_inst.rd_we_i;
    assign rd_addr = testbench.rv64i_zba_pipe3.decode_dp_inst.register_file_dc_inst.rd_a_i;
    assign rd_data = testbench.rv64i_zba_pipe3.decode_dp_inst.register_file_dc_inst.rd_d_i;
`else
    rv32i_single rv32i_inst (.*);
    assign ram = testbench.rv32i_inst.data_ram_inst.ram;
    assign mem_write = testbench.rv32i_inst.data_ram_inst.we_i;
    assign mem_data = testbench.rv32i_inst.data_ram_inst.wd_i;
    assign mem_addr = testbench.rv32i_inst.data_ram_inst.a_i;

    assign regfile_tb = testbench.rv32i_inst.register_file_inst.regfile;
    assign reg_write = testbench.rv32i_inst.register_file_inst.rd_we_i;
    assign rd_addr = testbench.rv32i_inst.register_file_inst.rd_a_i;
    assign rd_data = testbench.rv32i_inst.register_file_inst.rd_d_i;
`endif

    //always @(pc_tb) $display("[Address 0x%h] [T %0t ns]", pc_tb, $time);

    reg_e   rd_addr_temp;
    word_st rd_data_temp;
    time time_reg;
    always @(posedge clk_i) begin : RegFileMonitor
    fork
        if (reg_write && rd_addr != REG_ZERO) begin
            rd_addr_temp <= rd_addr;
            rd_data_temp <= rd_data;
            time_reg <= $time;
`ifdef PIPELINE3
            @(negedge clk_i);
`else
            @(posedge clk_i);
`endif
            if (regfile_tb[rd_addr_temp] == rd_data_temp)
                $display("[CORRECT]\t[REGFILE MONITOR]\t[T %0t ns]\t%s changed to 0x%x", time_reg, get_reg_name_f(rd_addr_temp), regfile_tb[rd_addr_temp]);
            else
                $display("[WRONG]\t[REGFILE MONITOR]\t[T %0t ns]", time_reg);
        end
    join_none
    end : RegFileMonitor

    word_st mem_data_temp, mem_addr_temp;
    always @(posedge clk_i) begin : RAMMonitor
        if (mem_write) begin
            mem_addr_temp <= mem_addr;
            mem_data_temp <= mem_data;
            @(posedge clk_i);
            if ({ram[mem_addr_temp+3], ram[mem_addr_temp+2], ram[mem_addr_temp+1], ram[mem_addr_temp]} == mem_data_temp)
                $display("[CORRECT]\t[RAM MONITOR]\t\t\t[T %0t ns]\tLocation 0x%x changed to 0x%x", $time, mem_addr_temp, {ram[mem_addr_temp+3], ram[mem_addr_temp+2], ram[mem_addr_temp+1], ram[mem_addr_temp]});
            else
                $display("[WRONG]\t[RAM MONITOR]\t\t[T %0t ns]\tStored wrong value", $time);
        end
    end : RAMMonitor

    integer cycle_num;
    always @(posedge clk_i) begin
        cycle_num++;
    end

    integer data_wr_fh;
    reg_e reg_arr[0:31];

    initial begin: init
        clk_i <= 0;
        rst_i <= 1;
        pc_init_i <= 32'sh0;
        repeat (3) @(posedge clk_i);
        cycle_num = 0;
        rst_i <= 0;
        wait(TOHOST == 1'b1);
        //data_wr_fh = $fopen("data_wr.mem", "w");
        //if (data_wr_fh == 0) begin
        //    $display("Error: Could not open data_wr.mem");
        //end else begin
        //    for (int i = DATA_ORG; i <= DATA_END; i = i + 4)
        //        $fwrite (data_wr_fh, "%0x\n", {ram[i+3], ram[i+2], ram[i+1], ram[i]});
        //        //$writememh(data_wr_fh, ram);
        //end
        repeat(6) @(posedge clk_i);
        $stop;
    end: init
    
endmodule: testbench
`end_keywords