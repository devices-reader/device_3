unit get_status2;

interface

procedure BoxGetStatus2;
procedure ShowGetStatus2;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetStatus2:  querys = (Action: acGetStatus2; cwOut: 3+3+2; cwIn: 4+4+2; bNumber: 0);

procedure QueryGetStatus2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(33);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetStatus2, True);
end;

procedure BoxGetStatus2;
begin
  AddInfo('');
  AddInfo('Статус');
  QueryGetStatus2;
end;

procedure ShowGetStatus2;
var
  i: byte;
  s:  string;
begin
  Stop;
  InitPop(4);

  PopByte;
  PopByte;
  i := PopByte;

  if i = 0
    then s := 'зима'
  else if i = 1
    then s := 'лето'
  else
    s := '?';

  AddInfo('сезон:            ' + s);

  AddInfo('');
  InfBox('Операция успешно завершена')
end;

end.
