unit get_engabstar;

interface

uses kernel;

procedure BoxGetEngAbsTar;
procedure ShowGetEngAbsTar;

var
  mpdwEngAbsTar:   array[0..3,0..TARIFFS] of longword;

implementation

uses SysUtils, support, soutput, progress, box, realz, get_koeffs;

const
  quGetEngAbsTar:  querys = (Action: acGetEngAbsTar; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  bTar:            byte;

procedure QueryGetEngAbsTar;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(1);
  PushByte(0);
  PushByte(bTar);
  PushByte(0);
  Query(quGetEngAbsTar, True);
end;

procedure ClearGetEngAbsTar;
var
  i:  byte;
begin
  for i := 0 to 3 do
    mpdwEngAbsTar[i][0] := 0;
end;

procedure BoxGetEngAbsTar;
begin
  ClearGetEngAbsTar;
  
  bTar := 1;
  QueryGetEngAbsTar;
end;

procedure ShowGetEngAbsTar;
var
  dwT:  longword;
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do begin
    dwT := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;
    mpdwEngAbsTar[i][bTar] := dwT;
    Inc(mpdwEngAbsTar[i][0], mpdwEngAbsTar[i][bTar]);
  end;

  ShowProgress(bTar-1,TARIFFS);

  Inc(bTar);
  if (bTar <= TARIFFS) then
    QueryGetEngAbsTar
  else begin
    AddInfo('');
    AddInfo('');
    AddInfo('Импульсы всего (по тарифам)');

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do s := s + PackStrR(IntToStr(mpdwEngAbsTar[i][j]),GetColWidth);
      s := s + PackStrR(IntToStr(mpdwEngAbsTar[i][0]),GetColWidth);
      AddInfo(s);
    end;

    AddInfo('');
    AddInfo('Энергия всего (по тарифам)');

    s := PackStrR('',GetColWidth);
    for j := 1 to TARIFFS do s := s + PackStrR('тариф '+IntToStr(j),GetColWidth);
    s := s + PackStrR('всего',GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := 1 to TARIFFS do s := s + Reals2StrR(mpdwEngAbsTar[i][j]*kE);
      s := s + Reals2StrR(mpdwEngAbsTar[i][0]*kE);
      AddInfo(s);
    end;

    BoxRun;
  end;
end;

end.

