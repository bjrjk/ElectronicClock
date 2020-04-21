module timeSetter(
    input clk,en,btnCh,btnAdd,
    input [6:0] hourIn,minuteIn,secondIn,
    output rst,
    output reg setTypeOut,
    output reg[6:0] hourOut,minuteOut,secondOut
    );

    reg[6:0] hour,minute,second;
    reg setType=1'b1;
    
    assign rst= en && (hourIn!=hour||minuteIn!=minute);

    frequencyDivider #(
        .P ( 32'd500_000 ) //100Hz
        )
    insFrequencyDivider (
        .clk_in                  ( clk    ),
        .clk_out                 ( clk_out   )
    );

    always@ (posedge clk_out) begin //negedge btnAdd or posedge en
        if(!en) begin
            hour<=hourIn;
            minute<=minuteIn;
            second<=secondIn;
        end else if(!btnAdd && setType) begin //设置分钟
            if(minuteIn>=7'd59)minute<=7'd0;
            else minute<=minuteIn+1;
            hour<=hourIn;
            second<=7'd0;
        end else if(!btnAdd) begin //设置小时
            if(hourIn>=7'd23)hour<=7'd0;
            else hour<=hourIn+1;
            minute<=minuteIn;
            second<=7'd0;
        end
    end

    always@ (posedge clk_out) //negedge btnCh
        if(en && !btnCh)setType<=setType+1'b1;

    always@ (*) begin
        if(en) begin
            hourOut=hour;
            minuteOut=minute;
            secondOut=second;
            setTypeOut=setType;
        end else begin
            hourOut=7'bzzzzzzz;
            minuteOut=7'bzzzzzzz;
            secondOut=7'bzzzzzzz;
            setTypeOut=1'bz;
        end
    end 
endmodule
