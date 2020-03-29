`timescale  1ps / 1ps

module frequencyDividerTest;   

// frequencyDivider Parameters
parameter PERIOD = 2        ;
parameter P  = 32'd1;    

// frequencyDivider Inputs    
reg   clk_in                               = 0 ;
reg   rst                                  = 1 ;

// frequencyDivider Outputs
wire  clk_out                              ;


initial
begin
    forever #(PERIOD/2)  clk_in=~clk_in;
end


frequencyDivider #(
    .P ( P )
    )
 u_frequencyDivider (
    .clk_in                  ( clk_in    ),
    .rst                     ( rst       ),

    .clk_out                 ( clk_out   )
);

initial
begin
    #2 rst=1'b0;
    #100 $finish;
end

endmodule