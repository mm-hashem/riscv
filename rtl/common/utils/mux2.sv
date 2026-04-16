module mux2
    import types_pkg::*;
#(
    parameter type type_t = xlen_st
)
(
    input  type_t i0, i1,
    input  logic   sel,
    output type_t y
);

    always_comb begin
        unique case (sel)
            1'b0   : y = i0;
            1'b1   : y = i1;
            default: y = 'x;
        endcase
    end
    
endmodule