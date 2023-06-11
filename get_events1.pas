unit get_events1;

interface

procedure BoxGetEvents1;
procedure ShowGetEvents1;

implementation

uses SysUtils, support, soutput, timez, box, kernel, borders, progress, t_events;

const
  quGetEvents1:  querys = (Action: acGetEvents1; cwOut: 3+3+2; cwIn: 4+9+2; bNumber: 0);

type
  Events1 = record
    tiSelf:     times;
    wSelf:      word;
    bSelf:      byte;
  end;

var
  ibEvn:        byte;
  mpEnents:     array[0..31] of Events1;

procedure QueryGetEvents1;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(14);
  PushByte(((ibEvn xor $FF) + 1) mod $100);
  PushByte(0);
  PushByte(0);
  Query(quGetEvents1, True);
end;

procedure BoxGetEvents1;
begin
  if TestDays then begin
    AddInfo('');
    AddInfo('Архив фаз');
    ibEvn := 0;
    QueryGetEvents1;
  end;
end;


procedure ShowGetEvents1;
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
    AddInfoAll(TEvents1(mpEnents[ibEvn].wSelf));
  end;

  ShowProgress(ibEvn,32);

  Inc(ibEvn);
  if ibEvn < 32 then
    QueryGetEvents1
  else begin
    BoxRun;
  end;
end;

end.
