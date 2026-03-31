module mux4
    import types_pkg::*;
#(
    parameter type type_t = xlen_st
)
(
    input  type_t      i0, i1, i2, i3,
    input  logic [1:0] sel,
    output type_t      y
);

    always_comb begin
        case (sel)
            2'b00   : y = i0;
            2'b01   : y = i1;
            2'b10   : y = i2;
            2'b11   : y = i3;
            default : y = 'x;
        endcase
    end
    
endmodule