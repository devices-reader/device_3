unit get_cntday1;

interface

procedure BoxGetCntDay1;
procedure ShowGetCntDay1;

implementation

uses SysUtils, support, soutput, timez, box, kernel, borders, progress, realz, calendar, get_koeffs, main;

const
  quGetCntDay1:  querys = (Action: acGetCntDay1; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  ibDay:        byte;
  mpdwCntDay1:  array[0..3,0..DAYS] of longword;

procedure QueryGetCntDay1;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(42);
  PushByte(((ibDay xor $FF) + 1) mod $100);
  PushByte(0);
  PushByte(0);
  Query(quGetCntDay1, True);
end;

procedure BoxGetCntDay1;
begin
  if TestDays then begin
    AddInfo('');
    AddInfo('—четчики на начало суток');
    ibDay := ibMinDay;
    QueryGetCntDay1;
  end;
end;

procedure ShowGetCntDay1;
var
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do
    mpdwCntDay1[i,ibDay] := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;

  ShowProgress(ibDay,ibMaxDay);  

  Inc(ibDay);
  if ibDay <= ibMaxDay then 
    QueryGetCntDay1
  else begin  
    AddInfo('');
    AddInfo('»мпульсы на начало суток');

    s := PackStrR('',GetColWidth);
    for j := ibMinDay to ibMaxDay do s := s + PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-j)),GetColWidth);
    AddInfo(s);    
    s := PackStrR('',GetColWidth);
    for j := ibMinDay to ibMaxDay do s := s + PackStrR('сутки -'+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := ibMinDay to ibMaxDay do s := s + PackStrR(IntToStr(mpdwCntDay1[i,j]),GetColWidth);
      AddInfo(s);
    end;
    
    AddInfo('');
    AddInfo('—четчики на начало суток');

    s := PackStrR('',GetColWidth);
    for j := ibMinDay to ibMaxDay do s := s + PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-j)),GetColWidth);
    AddInfo(s);    
    s := PackStrR('',GetColWidth);
    for j := ibMinDay to ibMaxDay do s := s + PackStrR('сутки -'+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := ibMinDay to ibMaxDay do s := s + Reals2StrR(mpdwCntDay1[i,j]*kE);
      AddInfo(s);
    end;
    
    BoxRun;
  end;
end;

end. 
