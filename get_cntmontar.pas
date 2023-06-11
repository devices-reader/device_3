unit get_cntmontar;

interface

uses kernel;

procedure BoxGetCntMonTar;
procedure ShowGetCntMonTar;

var
  mpdwCntMonTar:   array[0..3,0..TARIFFS] of longword; 

implementation

uses SysUtils, support, soutput, progress, borders, box, realz, timez, calendar, get_koeffs;

const
  quGetCntMonTar: querys = (Action: acGetCntMonTar; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  ibMon,bTar:     byte;

procedure QueryGetCntMonTar;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(43);
  PushByte(((ibMon xor $FF) + 1) mod $100);
  PushByte(bTar);
  PushByte(0);
  Query(quGetCntMonTar, True);
end;

procedure ClearGetCntMonTar;
var
  i:  byte;
begin
  for i := 0 to 3 do
    mpdwCntMonTar[i][0] := 0;
end;

procedure BoxGetCntMonTar;
begin
  if TestMonths then begin
    ClearGetCntMonTar;

    AddInfo('');
    AddInfo('Счетчики на начало месяца (по тарифам)');

    ibMon := ibMinMonth;
    bTar := 1;
    QueryGetCntMonTar;
  end;
end;

procedure ShowGetCntMonTar;
var
  dwT:  longword;
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do begin
    dwT := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;
    mpdwCntMonTar[i][bTar] := dwT;
    Inc(mpdwCntMonTar[i][0], mpdwCntMonTar[i][bTar]);
  end;  

  ShowProgress(ibMon,ibMaxMonth); 
  
  Inc(bTar);
  if (bTar <= TARIFFS) then
    QueryGetCntMonTar
  else begin  
    AddInfo('');
    AddInfo('');
    AddInfo('Импульсы на начало месяца (по тарифам): '+PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-ibMon)),GetColWidth));

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do s := s + PackStrR(IntToStr(mpdwCntMonTar[i][j]),GetColWidth);
      s := s + PackStrR(IntToStr(mpdwCntMonTar[i][0]),GetColWidth);
      AddInfo(s);
    end;

    AddInfo('');
    AddInfo('Счетчики на начало месяца (по тарифам): '+PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-ibMon)),GetColWidth));

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do s := s + Reals2StrR(mpdwCntMonTar[i][j]*kE);
      s := s + Reals2StrR(mpdwCntMonTar[i][0]*kE);
      AddInfo(s);
    end;

    bTar := 1;
    Inc(ibMon);
    if (ibMon <= ibMaxMonth) then begin
      ClearGetCntMonTar;
      QueryGetCntMonTar;
    end
    else
      BoxRun;
  end;
end;

end.

