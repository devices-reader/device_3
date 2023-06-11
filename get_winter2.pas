unit get_winter2;

interface

procedure BoxGetWinter2;
procedure ShowGetWinter2;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetWinter2:  querys = (Action: acGetWinter2; cwOut: 3+3+2; cwIn: 4+6+2; bNumber: 0);

procedure QueryGetWinter2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(28);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetWinter2, True);
end;

procedure BoxGetWinter2;
begin
  AddInfo('');
  AddInfo('Дата перехода на зимнее время');
  QueryGetWinter2;
end;

procedure ShowGetWinter2;
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

  AddInfo('');
  InfBox('Операция успешно завершена')
end;

end.
