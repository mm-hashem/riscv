module mux2_xs // xlen_st
    import types_pkg::*;
(
    input  xlen_st i0, i1,
    input  logic   sel,
    output xlen_st y
);

    always_comb begin
        case (sel)
            1'b0   : y = i0;
            1'b1   : y = i1;
            default: y = 'x;
        endcase
    end
    
endmodule