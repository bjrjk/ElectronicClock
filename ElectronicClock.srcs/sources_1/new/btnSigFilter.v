module btnSigFilter(
    input clk,btnIn,
    output btnOut
    );

    reg r1,r2,r3;
    frequencyDivider #(
        .P ( 32'd500_000 ) //100Hz
        )
    insFrequencyDivider (
        .clk_in                  ( clk    ),
        .clk_out                 ( clk_out   )
    );

    always@ (posedge clk_out) begin
        r1<=btnIn;
        r2<=r1;
        r3<=r2;
    end

    assign btnOut = !(!r1 && !r2 && r3);

endmodule
