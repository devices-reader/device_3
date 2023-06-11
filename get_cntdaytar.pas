unit get_cntdaytar;

interface

uses kernel;

procedure BoxGetCntDayTar;
procedure ShowGetCntDayTar;

var
  mpdwCntDayTar:   array[0..3,0..TARIFFS] of longword; 

implementation

uses SysUtils, support, soutput, progress, borders, box, realz, timez, calendar, get_koeffs;

const
  quGetCntDayTar: querys = (Action: acGetCntDayTar; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  ibDay,bTar:     byte;

procedure QueryGetCntDayTar;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(42);
  PushByte(((ibDay xor $FF) + 1) mod $100);
  PushByte(bTar);
  PushByte(0);
  Query(quGetCntDayTar, True);
end;

procedure ClearGetCntDayTar;
var
  i:  byte;
begin
  for i := 0 to 3 do
    mpdwCntDayTar[i][0] := 0;
end;

procedure BoxGetCntDayTar;
begin
  if TestDays then begin
    ClearGetCntDayTar;

    AddInfo('');
    AddInfo('Счетчики на начало суток (по тарифам)');

    ibDay := ibMinDay;
    bTar := 1;
    QueryGetCntDayTar;
  end;  
end;

procedure ShowGetCntDayTar;
var
  dwT:  longword;
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do begin
    dwT := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;
    mpdwCntDayTar[i][bTar] := dwT;
    Inc(mpdwCntDayTar[i][0], mpdwCntDayTar[i][bTar]);
  end;  

  ShowProgress(ibDay,ibMaxDay); 
  
  Inc(bTar);
  if (bTar <= TARIFFS) then
    QueryGetCntDayTar
  else begin  
    AddInfo('');
    AddInfo('');
    AddInfo('Импульсы на начало суток(по тарифам): '+PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-ibDay)),GetColWidth));

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do s := s + PackStrR(IntToStr(mpdwCntDayTar[i][j]),GetColWidth);
      s := s + PackStrR(IntToStr(mpdwCntDayTar[i][0]),GetColWidth);
      AddInfo(s);
    end;

    AddInfo('');
    AddInfo('Счетчики на начало суток (по тарифам): '+PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-ibDay)),GetColWidth));

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do s := s + Reals2StrR(mpdwCntDayTar[i][j]*kE);
      s := s + Reals2StrR(mpdwCntDayTar[i][0]*kE);
      AddInfo(s);
    end;

    bTar := 1;
    Inc(ibDay);
    if (ibDay <= ibMaxDay) then begin
      ClearGetCntDayTar;
      QueryGetCntDayTar;
    end
    else
      BoxRun;
  end;
end;

end.

