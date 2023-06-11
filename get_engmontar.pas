unit get_engmontar;

interface

uses kernel;

procedure BoxGetEngMonTar;
procedure ShowGetEngMonTar;

var
  mpdwEngMonTar:   array[0..3,0..TARIFFS] of longword; 

implementation

uses SysUtils, support, soutput, progress, borders, box, realz, timez, calendar, get_koeffs;

const
  quGetEngMonTar: querys = (Action: acGetEngMonTar; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  ibMon,bTar:     byte;

procedure QueryGetEngMonTar;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(3);
  PushByte(((ibMon xor $FF) + 1) mod $100);
  PushByte(bTar);
  PushByte(0);
  Query(quGetEngMonTar, True);
end;

procedure ClearGetEngMonTar;
var
  i:  byte;
begin
  for i := 0 to 3 do
    mpdwEngMonTar[i][0] := 0;
end;

procedure BoxGetEngMonTar;
begin
  if TestMonths then begin
    ClearGetEngMonTar;

    AddInfo('');
    AddInfo('Ёнерги€ по мес€цам (по тарифам)');

    ibMon := ibMinMonth;
    bTar := 1;
    QueryGetEngMonTar;
  end;  
end;

procedure ShowGetEngMonTar;
var
  dwT:  longword;
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do begin
    dwT := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;
    mpdwEngMonTar[i][bTar] := dwT;
    Inc(mpdwEngMonTar[i][0], mpdwEngMonTar[i][bTar]);
  end;  

  ShowProgress(ibMon,ibMaxMonth); 
  
  Inc(bTar);
  if (bTar <= TARIFFS) then
    QueryGetEngMonTar
  else begin  
    AddInfo('');
    AddInfo('');
    AddInfo('»мпульсы по мес€цам (по тарифам): '+PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-ibMon)),GetColWidth));

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего (расчет)',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do s := s + PackStrR(IntToStr(mpdwEngMonTar[i][j]),GetColWidth);
      s := s + PackStrR(IntToStr(mpdwEngMonTar[i][0]),GetColWidth);
      AddInfo(s);
    end;

    AddInfo('');
    AddInfo('Ёнерги€ по мес€цам (по тарифам): '+PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-ibMon)),GetColWidth));

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего (расчет)',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do s := s + Reals2StrR(mpdwEngMonTar[i][j]*kE);
      s := s + Reals2StrR(mpdwEngMonTar[i][0]*kE);
      AddInfo(s);
    end;

    bTar := 1;
    Inc(ibMon);
    if (ibMon <= ibMaxMonth) then begin
      ClearGetEngMonTar;
      QueryGetEngMonTar;
    end
    else
      BoxRun;
  end;
end;

end.

