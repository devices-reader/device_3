unit get_engday;

interface

procedure BoxGetEngDay;
procedure ShowGetEngDay;

implementation

uses SysUtils, support, soutput, timez, box, kernel, borders, progress, realz, calendar, get_koeffs, get_graph, main;

const
  quGetEngDay:  querys = (Action: acGetEngDay; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  ibDay:        byte;
  mpdwEngDay:   array[0..3,0..DAYS] of longword; 

procedure QueryGetEngDay;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(2);
  PushByte(((ibDay xor $FF) + 1) mod $100);
  PushByte(0);
  PushByte(0);
  Query(quGetEngDay, True);
end;

procedure BoxGetEngDay;
begin
  if TestDays then begin
    AddInfo('');
    AddInfo('Ёнерги€ по суткам');
    ibDay := ibMinDay;
    QueryGetEngDay;
  end;
end;

procedure ShowGetEngDay;
var
  i,j:  byte;
  s:    string;
  a,b:  longint;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do
    mpdwEngDay[i,ibDay] := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;

  ShowProgress(ibDay,ibMaxDay);  

  Inc(ibDay);
  if ibDay <= ibMaxDay then 
    QueryGetEngDay
  else begin  
    AddInfo('');
    AddInfo('»мпульсы по суткам');

    s := PackStrR('',GetColWidth);
    for j := ibMinDay to ibMaxDay do s := s + PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-j)),GetColWidth);
    AddInfo(s);    
    s := PackStrR('',GetColWidth);
    for j := ibMinDay to ibMaxDay do s := s + PackStrR('сутки -'+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := ibMinDay to ibMaxDay do s := s + PackStrR(IntToStr(mpdwEngDay[i,j]),GetColWidth);
      AddInfo(s);
    end;
    
    AddInfo('');
    AddInfo('Ёнерги€ по суткам');

    s := PackStrR('',GetColWidth);
    for j := ibMinDay to ibMaxDay do s := s + PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-j)),GetColWidth);
    AddInfo(s);    
    s := PackStrR('',GetColWidth);
    for j := ibMinDay to ibMaxDay do s := s + PackStrR('сутки -'+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := ibMinDay to ibMaxDay do s := s + Reals2StrR(mpdwEngDay[i,j]*kE);
      AddInfo(s);
    end;

    if frmMain.clbMain.Checked[Ord(acGetGraph6)] then begin    
      AddInfo('');
      AddInfo('»мпульсы по суткам (интегральные / рассчитанные по получасам)');
      for j := ibMinDay to ibMaxDay do begin
        AddInfo(PackStrR('сутки -'+IntToStr(j),GetColWidth) + PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-j)),GetColWidth));
        for i := 0 to 3 do begin
          s := PackStrR(GetCanalName(i),GetColWidth);
            b := mpdwEngDay[i,j];
            a := mpdwImpCD[i,j];
            s := s + PackStrR(IntToStr(b),GetColWidth) + PackStrR(IntToStr(a),GetColWidth);
            s := s + PackStrR(IntToStr(b-a),GetColWidth);
            if a <> 0 then s := s + Reals2Str(100*(b-a)/a) + ' %' else s := s + '?';
          AddInfo(s);
        end;
      end;
    end;
    
    BoxRun;
  end;
end;

end.
