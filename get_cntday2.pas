unit get_cntday2;

interface

procedure BoxGetCntDay2;
procedure ShowGetCntDay2;

implementation

uses SysUtils, support, soutput, timez, box, kernel, borders, progress, realz, calendar, main;

const
  quGetCntDay2:  querys = (Action: acGetCntDay2; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  ibDay:        byte;
  mpreCntDay2:  array[0..3,0..DAYS] of single;

procedure QueryGetCntDay2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(4);
  PushByte(42);
  PushByte(((ibDay xor $FF) + 1) mod $100);
  PushByte(0);
  PushByte(0);
  Query(quGetCntDay2, True);
end;

procedure BoxGetCntDay2;
begin
  if TestDays then begin
    AddInfo('');
    AddInfo('—четчики на начало суток (в формате с плавающей зап€той)');
    ibDay := ibMinDay;
    QueryGetCntDay2;
  end;
end;

procedure ShowGetCntDay2;
var
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do
    mpreCntDay2[i,ibDay] := PopReals3;

  ShowProgress(ibDay,ibMaxDay);  

  Inc(ibDay);
  if ibDay <= ibMaxDay then 
    QueryGetCntDay2
  else begin  
    AddInfo('');

    s := PackStrR('',GetColWidth);
    for j := ibMinDay to ibMaxDay do s := s + PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-j)),GetColWidth);
    AddInfo(s);    
    s := PackStrR('',GetColWidth);
    for j := ibMinDay to ibMaxDay do s := s + PackStrR('сутки -'+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := ibMinDay to ibMaxDay do s := s + Reals2StrR(mpreCntDay2[i,j]);
      AddInfo(s);
    end;
    
    BoxRun;
  end;
end;

end. 
