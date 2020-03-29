module stopWatch(
    input en,clk,btnSP,btnClr,
    output reg[5:0] minuteOut,secondOut,miliSecondOut
    );

    reg[6:0] minute=7'd0,second=7'd0,miliSecond=7'd0;
    reg running=1'b0;
    wire clk_out;

    frequencyDivider #(
        .P ( 32'd500_000 ) //100Hz
        )
    insFrequencyDivider (
        .clk_in                  ( clk    ),
        .clk_out                 ( clk_out   )
    );
    
    always@ (posedge clk_out) begin  //or negedge btnClr
        if(en&&!btnClr) begin
            minute<=7'd0;
            second<=7'd0;
            miliSecond<=7'd0;
        end else begin
            if(running) begin
                if(miliSecond==7'd99) begin
                    miliSecond<=7'd0;
                    if(second==7'd59)begin
                        second<=7'd0;
                        if(minute==7'd99) minute<=7'd0;
                        else minute<=minute+7'd1;
                    end else second<=second+7'd1;
                end else miliSecond<=miliSecond+7'd1;
            end
        end
    end

    always@ (posedge clk_out) //negedge btnSP
        if(en && !btnSP)running<=~running;

    always@ (*) begin
        if(en) begin
            minuteOut=minute;
            secondOut=second;
            miliSecondOut=miliSecond;
        end else begin
            minuteOut=7'bzzzzzz;
            secondOut=7'bzzzzzz;
            miliSecondOut=7'bzzzzzzz;
        end
    end 

endmodule
