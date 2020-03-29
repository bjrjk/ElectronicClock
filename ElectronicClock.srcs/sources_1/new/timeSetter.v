module timeSetter(
    input clk,en,btnCh,btnAdd,
    input [5:0] hourIn,minuteIn,secondIn,
    output rst,
    output reg setTypeOut,
    output reg[5:0] hourOut,minuteOut,secondOut
    );

    reg[5:0] hour,minute,second;
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
            if(minuteIn>=6'd59)minute<=6'd0;
            else minute<=minuteIn+1;
            hour<=hourIn;
            second<=6'd0;
        end else if(!btnAdd) begin //设置小时
            if(hourIn>=6'd23)hour<=6'd0;
            else hour<=hourIn+1;
            minute<=minuteIn;
            second<=6'd0;
        end
    end

    always@ (posedge clk_out) //negedge btnCh
        if(!btnCh)setType<=setType+1'b1;

    always@ (*) begin
        if(en) begin
            hourOut=hour;
            minuteOut=minute;
            secondOut=second;
            setTypeOut=setType;
        end else begin
            hourOut=6'bzzzzzz;
            minuteOut=6'bzzzzzz;
            secondOut=6'bzzzzzz;
            setTypeOut=1'bz;
        end
    end 
endmodule
