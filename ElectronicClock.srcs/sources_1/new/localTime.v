`include "include.v"

module localTime(
    input clk,rst,rstAlarm,
    input [5:0] hourIn,minuteIn,secondIn,
    input [5:0] hourAlarmIn,minuteAlarmIn,secondAlarmIn,
    output reg[5:0] hour=6'd0,minute=6'd0,second=6'd0,
    output reg[5:0] hourAlarm=6'd0,minuteAlarm=6'd0,secondAlarm=6'd0,
    output reg[4:0] AlarmLED=`LED_NAN,
    output wire Alarmer
    );

    reg[6:0] miliSecond=7'd0;
    wire clk_out;
    reg AlarmReg=1'b0;
    assign Alarmer=AlarmReg & clk_out;

    frequencyDivider #(
        .P ( 32'd500_000 ) //100Hz
        )
    insFrequencyDivider (
        .clk_in                  ( clk    ),
        .clk_out                 ( clk_out   )
    );

    always@ (posedge clk_out) begin
        if(rstAlarm) begin
            hourAlarm<=hourAlarmIn;
            minuteAlarm<=minuteAlarmIn;
            secondAlarm<=secondAlarmIn;
        end
        if(hourAlarm==hour&&minuteAlarm==minute) begin
            if(second%2==0) begin
                AlarmLED<=`LED_ALARM;
                AlarmReg<=1'b1;
            end
            else begin
                AlarmLED<=`LED_NAN;
                AlarmReg<=1'b0;
            end
        end else begin
                AlarmLED<=`LED_NAN;
                AlarmReg<=1'b0;
        end
    end

    always@ (posedge clk_out) begin
        if(rst) begin
            hour<=hourIn;
            minute<=minuteIn;
            second<=secondIn;
            miliSecond<=7'd0;
        end else begin
            if(miliSecond>=7'd99) begin
                miliSecond<=7'd0;
                if(second>=6'd59) begin
                    second<=6'd0;
                    if(minute>=6'd59) begin
                        minute<=6'd0;
                        if(hour>=5'd23) hour<=6'd0;
                        else hour<=hour+6'd1;
                    end else minute<=minute+6'd1;
                end else second<=second+6'd1;
            end else miliSecond<=miliSecond+7'd1;
        end
    end

endmodule
