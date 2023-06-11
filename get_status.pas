unit get_status;

interface

procedure BoxGetStatus;
procedure ShowGetStatus;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetStatus:  querys = (Action: acGetStatus; cwOut: 3+3+2; cwIn: 4+4+2; bNumber: 0);

procedure QueryGetStatus;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(33);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetStatus, True);
end;

procedure BoxGetStatus;
begin
  AddInfo('');
  AddInfo('������');
  QueryGetStatus;
end;

procedure ShowGetStatus;
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
    then s := '����'
  else if i = 1
    then s := '����'
  else
    s := '?';

  AddInfo('�����:            ' + s);

  BoxRun;
end;

end.
