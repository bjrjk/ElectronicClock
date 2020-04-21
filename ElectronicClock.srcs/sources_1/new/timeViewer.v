`include "include.v"

module timeViewer(
    input en,mode,
    input [1:0] modeSetType,  //00：分2，01：分1，10：时2，11：时1
    input [6:0] hourIn,minuteIn,secondIn,
    output reg[4:0] hour1,hour2,minute1,minute2,second1,second2
    );

    always@ (*) begin
        if(en) begin
            if(!mode) begin
                hour1=hourIn/10%10;
                hour2=hourIn%10+10;
                minute1=minuteIn/10%10;
                minute2=minuteIn%10+10;
                second1=secondIn/10%10;
                second2=secondIn%10+10;
            end else begin
                if(modeSetType == 2'b00) begin
                    hour1=hourIn/10%10;
                    hour2=hourIn%10;
                    minute1=minuteIn/10%10;
                    minute2=minuteIn%10+10;
                end else if(modeSetType == 2'b01) begin
                    hour1=hourIn/10%10;
                    hour2=hourIn%10;
                    minute1=minuteIn/10%10+10;
                    minute2=minuteIn%10;
                end else if(modeSetType == 2'b10) begin
                    hour1=hourIn/10%10;
                    hour2=hourIn%10+10;
                    minute1=minuteIn/10%10;
                    minute2=minuteIn%10;
                end else if(modeSetType == 2'b11) begin
                    hour1=hourIn/10%10+10;
                    hour2=hourIn%10;
                    minute1=minuteIn/10%10;
                    minute2=minuteIn%10;
                end else begin
                    hour1=hourIn/10%10;
                    hour2=hourIn%10;
                    minute1=minuteIn/10%10;
                    minute2=minuteIn%10;
                end
                second1=`LED_NAN;
                second2=`LED_NAN;
            end
        end else begin
            hour1=5'bzzzzz;
            hour2=5'bzzzzz;
            minute1=5'bzzzzz;
            minute2=5'bzzzzz;
            second1=5'bzzzzz;
            second2=5'bzzzzz;
        end
    end 
endmodule
