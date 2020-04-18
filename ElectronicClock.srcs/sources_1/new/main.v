`include "include.v"

module main(
    input clk,btn1,btn2,btn3,
    output [7:0] LED,LED2,
    output [7:0] Select,
    output wire Alarmer
    );

    wire wBtn1,wBtn2,wBtn3;
    btnSigFilter insBtnSigFilter1(
    .clk(clk),
    .btnIn(btn1),
    .btnOut(wBtn1)
    );
    btnSigFilter insBtnSigFilter2(
    .clk(clk),
    .btnIn(btn2),
    .btnOut(wBtn2)
    );
    btnSigFilter insBtnSigFilter3(
    .clk(clk),
    .btnIn(btn3),
    .btnOut(wBtn3)
    );

    reg[3:0] enView=4'b0001;
    reg[1:0] viewMode=2'b00;
    always@ (negedge wBtn1) begin
        enView<={enView[2:0],enView[3]};
        viewMode<=viewMode+2'b01;
    end

    wire [4:0] wNumA,wNumB,wNumC,wNumD,wNumE,wNumF,wNumG,wNumH;
    multiLED insMultiLED(  //Dynamic LED Displayer
        .clk_in(clk),
        .rst(1'b0),
        .LED(LED),
        .LED2(LED2),
        .Select(Select),
        .NumA(viewMode),
        .NumB(wNumB),
        .NumC(wNumC),
        .NumD(wNumD),
        .NumE(wNumE),
        .NumF(wNumF),
        .NumG(wNumG),
        .NumH(wNumH)
    );

    wire [5:0] wLocalTimeHourOut,wLocalTimeMinuteOut,wLocalTimeSecondOut;
    wire [5:0] wAlarmHourOut,wAlarmMinuteOut,wAlarmSecondOut;
    wire wLocalTimeRst,wLocalTimeRstAlarm;
    wire [5:0] wTimeSetterHour,wTimeSetterMinute,wTimeSetterSecond;
    wire [5:0] wAlarmSetterHour,wAlarmSetterMinute,wAlarmSetterSecond;
    localTime insLocalTime( //Local Time Counter & Controller for View 1
    .clk(clk),
    .rst(wLocalTimeRst),
    .rstAlarm(wLocalTimeRstAlarm),
    .hourIn(wTimeSetterHour),
    .minuteIn(wTimeSetterMinute),
    .secondIn(wTimeSetterSecond),
    .hourAlarmIn(wAlarmSetterHour),
    .minuteAlarmIn(wAlarmSetterMinute),
    .secondAlarmIn(wAlarmSetterSecond),
    .hour(wLocalTimeHourOut),
    .minute(wLocalTimeMinuteOut),
    .second(wLocalTimeSecondOut),
    .hourAlarm(wAlarmHourOut),
    .minuteAlarm(wAlarmMinuteOut),
    .secondAlarm(wAlarmSecondOut),
    .AlarmLED(wNumB),
    .Alarmer(Alarmer)
    );

    timeViewer insTimeViewer4LocalTime( //View 1
    .en(enView[0]),
    .mode(1'b0),
    .modeSetType(1'b0),
    .hourIn(wLocalTimeHourOut),
    .minuteIn(wLocalTimeMinuteOut),
    .secondIn(wLocalTimeSecondOut),
    .hour1(wNumC),
    .hour2(wNumD),
    .minute1(wNumE),
    .minute2(wNumF),
    .second1(wNumG),
    .second2(wNumH)
    );

    wire [5:0] wStopWatchMinute,wStopWatchSecond,wStopWatchMiliSecond;
    stopWatch insStopWatch( //Controller for View 4
    .en(enView[3]),
    .clk(clk),
    .btnSP(wBtn2),
    .btnClr(wBtn3),
    .minuteOut(wStopWatchMinute),
    .secondOut(wStopWatchSecond),
    .miliSecondOut(wStopWatchMiliSecond)
    );

    timeViewer insTimeViewer4StopWatch( //View 4
    .en(enView[3]),
    .mode(1'b0),
    .modeSetType(1'b0),
    .hourIn(wStopWatchMinute),
    .minuteIn(wStopWatchSecond),
    .secondIn(wStopWatchMiliSecond),
    .hour1(wNumC),
    .hour2(wNumD),
    .minute1(wNumE),
    .minute2(wNumF),
    .second1(wNumG),
    .second2(wNumH)
    );

    wire wTimeSetterSetType;
    timeSetter insTimeSetter4LocalTime( //Controller for View 2
    .clk(clk),
    .en(enView[1]),
    .btnCh(wBtn2),
    .btnAdd(wBtn3),
    .hourIn(wLocalTimeHourOut),
    .minuteIn(wLocalTimeMinuteOut),
    .secondIn(wLocalTimeSecondOut),
    .rst(wLocalTimeRst),
    .setTypeOut(wTimeSetterSetType),
    .hourOut(wTimeSetterHour),
    .minuteOut(wTimeSetterMinute),
    .secondOut(wTimeSetterSecond)
    );

    wire wAlarmSetterSetType;
    timeSetter insTimeSetter4Alarm( //Controller for View 3
    .clk(clk),
    .en(enView[2]),
    .btnCh(wBtn2),
    .btnAdd(wBtn3),
    .hourIn(wAlarmHourOut),
    .minuteIn(wAlarmMinuteOut),
    .secondIn(wAlarmSecondOut),
    .rst(wLocalTimeRstAlarm),
    .setTypeOut(wAlarmSetterSetType),
    .hourOut(wAlarmSetterHour),
    .minuteOut(wAlarmSetterMinute),
    .secondOut(wAlarmSetterSecond)
    );

    
    timeViewer insTimeViewer4LocalTimeChange( //View 2
    .en(enView[1]),
    .mode(1'b1),
    .modeSetType(wTimeSetterSetType),
    .hourIn(wTimeSetterHour),
    .minuteIn(wTimeSetterMinute),
    .secondIn(wTimeSetterSecond),
    .hour1(wNumC),
    .hour2(wNumD),
    .minute1(wNumE),
    .minute2(wNumF),
    .second1(wNumG),
    .second2(wNumH)
    );

    timeViewer insTimeViewer4Alarm( //View 3
    .en(enView[2]),
    .mode(1'b1),
    .modeSetType(wAlarmSetterSetType),
    .hourIn(wAlarmSetterHour),
    .minuteIn(wAlarmSetterMinute),
    .secondIn(wAlarmSetterSecond),
    .hour1(wNumC),
    .hour2(wNumD),
    .minute1(wNumE),
    .minute2(wNumF),
    .second1(wNumG),
    .second2(wNumH)
    );
   
endmodule
