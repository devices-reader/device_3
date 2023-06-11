unit get_calc1;

interface

uses kernel;

procedure BoxGetCalc1;
procedure ShowGetCalc1;

implementation

uses SysUtils, support, soutput, progress, borders, box, realz, timez, calendar, get_koeffs, get_engabstar;

const
  quCalc1: querys = (Action: acGetCalc1; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  ibDay,bTar:     byte;
  mpdwEngDayTar:  array[0..3,0..TARIFFS] of longword;

procedure QueryGetCalc1;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(2);
  PushByte(((ibDay xor $FF) + 1) mod $100);
  PushByte(bTar);
  PushByte(0);
  Query(quCalc1, True);
end;

procedure ClearGetCalc1;
var
  i:  byte;
begin
  for i := 0 to 3 do
    mpdwEngDayTar[i][0] := 0;
end;

procedure BoxGetCalc1;
begin
  ClearGetCalc1;
  
  AddInfo('');
  AddInfo('—четчики на начало текущих суток (по тарифам) расчетные');

  ibDay := 0;
  bTar := 1;
  QueryGetCalc1;
end;

procedure ShowGetCalc1;
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

  ShowProgress(bTar-1,TARIFFS);
  
  Inc(bTar);
  if (bTar <= TARIFFS) then
    QueryGetCalc1
  else begin
    AddInfo('');
    AddInfo('');
    AddInfo('»мпульсы за текущие сутки (по тарифам): '+PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-ibDay)),GetColWidth));

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
    AddInfo('Ёнерги€ за текущие сутки (по тарифам): '+PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-ibDay)),GetColWidth));

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


    AddInfo('');
    AddInfo('');
    AddInfo('»мпульсы на начало текущих суток (по тарифам): '+PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-ibDay)),GetColWidth));

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do begin
        dwT := mpdwEngAbsTar[i][j] - mpdwEngDayTar[i][j];
        s := s + PackStrR(IntToStr(dwT),GetColWidth);
      end;
      dwT := mpdwEngAbsTar[i][0] - mpdwEngDayTar[i][0];
      s := s + PackStrR(IntToStr(dwT),GetColWidth);
      AddInfo(s);
    end;

    AddInfo('');
    AddInfo('—четчики на начало текущих суток (по тарифам): '+PackStrR(Times2StrDay(DayIndexToDate(DateToDayIndex(tiCurr)-ibDay)),GetColWidth));

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do begin
        dwT := mpdwEngAbsTar[i][j] - mpdwEngDayTar[i][j];
        s := s + Reals2StrR(dwT*kE);
      end;
      dwT := mpdwEngAbsTar[i][0] - mpdwEngDayTar[i][0];
      s := s + Reals2StrR(dwT*kE);
      AddInfo(s);
    end;

    BoxRun;
  end;
end;

end.

