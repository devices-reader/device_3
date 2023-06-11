unit get_events2;

interface

procedure BoxGetEvents2;
procedure ShowGetEvents2;

implementation

uses SysUtils, support, soutput, timez, box, kernel, borders, progress, t_events;

const
  quGetEvents2:  querys = (Action: acGetEvents2; cwOut: 3+3+2; cwIn: 4+9+2; bNumber: 0);

type
  Events2 = record
    tiSelf:     times;
    wSelf:      word;
    bSelf:      byte;
  end;

var
  ibEvn:        byte;
  mpEnents:     array[0..31] of Events2;

procedure QueryGetEvents2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(15);
  PushByte(((ibEvn xor $FF) + 1) mod $100);
  PushByte(0);
  PushByte(0);
  Query(quGetEvents2, True);
end;

procedure BoxGetEvents2;
begin
  if TestDays then begin
    AddInfo('');
    AddInfo('Архив состояния прибора');
    ibEvn := 0;
    QueryGetEvents2;
  end;
end;


procedure ShowGetEvents2;
var
  s:  string;
begin
  Stop;
  InitPop(4);

  with mpEnents[ibEvn] do begin
    tiSelf := PopTimes;
    wSelf := PopByte + PopByte*$100;
    bSelf := PopByte;

    s := PackStrR(IntToStr(ibEvn),GetColWidth);
    s := s + PackStrR(Times2Str(mpEnents[ibEvn].tiSelf),GetColWidth*2);
    s := s + PackStrR(IntToHex(mpEnents[ibEvn].wSelf,4),GetColWidth);
    s := s + PackStrR(IntToHex(mpEnents[ibEvn].bSelf,2),GetColWidth);
    AddInfo(s);
    AddInfoAll(TEvents2(mpEnents[ibEvn].wSelf));
  end;

  ShowProgress(ibEvn,32);

  Inc(ibEvn);
  if ibEvn < 32 then
    QueryGetEvents2
  else begin
    BoxRun;
  end;
end;

end.
