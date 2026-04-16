// Data flip-flop with enable and synchronous reset
module dff #(
    parameter WIDTH
) (
    input  logic             clk_i, rst_i, en_i,
    input  logic [WIDTH-1:0] d_i,
    output logic [WIDTH-1:0] q_o
);

    always_ff @(posedge clk_i) begin
        if      (rst_i) q_o <= '0;
        else if (en_i)  q_o <= d_i; 
    end
    
endmodule : dff