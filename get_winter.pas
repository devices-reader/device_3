unit get_winter;

interface

procedure BoxGetWinter;
procedure ShowGetWinter;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetWinter:  querys = (Action: acGetWinter; cwOut: 3+3+2; cwIn: 4+6+2; bNumber: 0);

procedure QueryGetWinter;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(28);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetWinter, True);
end;

procedure BoxGetWinter;
begin
  AddInfo('');
  AddInfo('Дата перехода на зимнее время');
  QueryGetWinter;
end;

procedure ShowGetWinter;
var
  tiT:  times;
begin
  Stop;
  InitPop(4);

  with tiT do begin
    bSecond := PopByte;
    bMinute := PopByte;
    bHour   := PopByte;
    bDay    := PopByte;
    bMonth  := PopByte;
    bYear   := PopByte;
  end;

  AddInfo(Times2Str(tiT));

  BoxRun;
end;

end.
