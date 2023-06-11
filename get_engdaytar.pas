unit get_engdaytar;

interface

uses kernel;

procedure BoxGetEngDayTar;
procedure ShowGetEngDayTar;

var
  mpdwEngDayTar:   array[0..3,0..TARIFFS] of longword; 

implementation

uses SysUtils, support, soutput, progress, borders, box, realz, timez, calendar, get_koeffs;

const
  quGetEngDayTar: querys = (Action: acGetEngDayTar; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  ibDay,bTar:     byte;

procedure QueryGetEngDayTar;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(2);
  PushByte(((ibDay xor $FF) + 1) mod $100);
  PushByte(bTar);
  PushByte(0);
  Query(quGetEngDayTar, True);
end;

procedure ClearGetEngDayTar;
var
  i:  byte;
begin
  for i := 0 to 3 do
    mpdwEngDayTar[i][0] := 0;
end;

procedure BoxGetEngDayTar;
begin
  if TestDays then begin
    ClearGetEngDayTar;

    AddInfo('');
    AddInfo('Энергия по суткам (по тарифам)');

    ibDay := ibMinDay;
    bTar := 1;
    QueryGetEngDayTar;
  end;
end;

procedure ShowGetEngDayTar;
var
  dwT:  longword;
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do begin
    dwT := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;
    mpdwEngDayTar[i][bTar] := dwT;
    Inc(mpdwEngDayTar[i][0], mpdwEngDayTar[i][bTar]);
  end;  

  ShowProgress(ibDay,ibMaxDay); 
  
  Inc(bTar);
  if (bTar <= TARIFFS) then
    QueryGetEngDayTar
  else begin  
    AddInfo('');
    AddInfo('');
    AddInfo('Импульсы по суткам (по тарифам): '+PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-ibDay)),GetColWidth));

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do s := s + PackStrR(IntToStr(mpdwEngDayTar[i][j]),GetColWidth);
      s := s + PackStrR(IntToStr(mpdwEngDayTar[i][0]),GetColWidth);
      AddInfo(s);
    end;

    AddInfo('');
    AddInfo('Энергия по суткам (по тарифам): '+PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-ibDay)),GetColWidth));

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do s := s + Reals2StrR(mpdwEngDayTar[i][j]*kE);
      s := s + Reals2StrR(mpdwEngDayTar[i][0]*kE);
      AddInfo(s);
    end;

    bTar := 1;
    Inc(ibDay);
    if (ibDay <= ibMaxDay) then begin
      ClearGetEngDayTar;
      QueryGetEngDayTar;
    end
    else
      BoxRun;
  end;
end;

end.

