unit get_engabs;

interface

procedure BoxGetEngAbs;
procedure ShowGetEngAbs;

implementation

uses SysUtils, support, soutput, timez, box, kernel, borders, progress, realz, get_koeffs;

const
  quGetEngAbs:  querys = (Action: acGetEngAbs; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  mpdwEngAbs:   array[0..3] of longword; 

procedure QueryGetEngAbs;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(1);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetEngAbs, True);
end;

procedure BoxGetEngAbs;
begin
  AddInfo('');
  AddInfo('Ёнерги€ всего');
  QueryGetEngAbs;
end;

procedure ShowGetEngAbs;
var
  i:    byte;
  s:    string;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do
    mpdwEngAbs[i] := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;
  
  AddInfo('');
  AddInfo('»мпульсы всего');

  s := PackStrR('',GetColWidth);
  s := s + PackStrR('всего',GetColWidth);
  AddInfo(s);

  for i := 0 to 3 do begin
    s := PackStrR(GetCanalName(i),GetColWidth);
    s := s + PackStrR(IntToStr(mpdwEngAbs[i]),GetColWidth);
    AddInfo(s);
  end;
    
  AddInfo('');
  AddInfo('Ёнерги€ всего');

  s := PackStrR('',GetColWidth);
  s := s + PackStrR('всего',GetColWidth);
  AddInfo(s);

  for i := 0 to 3 do begin
    s := PackStrR(GetCanalName(i),GetColWidth);
    s := s + Reals2StrR(mpdwEngAbs[i]*kE);
    AddInfo(s);
  end;
    
  BoxRun;
end;

end.

