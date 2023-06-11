unit get_events3;

interface

procedure BoxGetEvents3;
procedure ShowGetEvents3;

implementation

uses SysUtils, support, soutput, timez, box, kernel, borders, progress, t_events;

const
  quGetEvents3:  querys = (Action: acGetEvents3; cwOut: 3+3+2; cwIn: 4+9+2; bNumber: 0);

type
  Events3 = record
    tiSelf:     times;
    wSelf:      word;
    bSelf:      byte;
  end;

var
  ibEvn:        byte;
  mpEnents:     array[0..31] of Events3;

procedure QueryGetEvents3;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(16);
  PushByte(((ibEvn xor $FF) + 1) mod $100);
  PushByte(0);
  PushByte(0);
  Query(quGetEvents3, True);
end;

procedure BoxGetEvents3;
begin
  if TestDays then begin
    AddInfo('');
    AddInfo('Архив событий коррекции');
    ibEvn := 0;
    QueryGetEvents3;
  end;
end;


procedure ShowGetEvents3;
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
    AddInfoAll(TEvents3(mpEnents[ibEvn].wSelf));
  end;

  ShowProgress(ibEvn,32);

  Inc(ibEvn);
  if ibEvn < 32 then
    QueryGetEvents3
  else begin
    BoxRun;
  end;
end;

end.
