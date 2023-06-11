unit get_summer2;

interface

procedure BoxGetSummer2;
procedure ShowGetSummer2;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetSummer2:  querys = (Action: acGetSummer2; cwOut: 3+3+2; cwIn: 4+6+2; bNumber: 0);

procedure QueryGetSummer2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(27);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetSummer2, True);
end;

procedure BoxGetSummer2;
begin
  AddInfo('');
  AddInfo('Дата перехода на летнее время');
  QueryGetSummer2;
end;

procedure ShowGetSummer2;
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
