unit get_time20;

interface

procedure BoxGetTime20;
procedure ShowGetTime20;

implementation

uses SysUtils, support, soutput, timez, box, get_setup2;

const
  quGetTime20:  querys = (Action: acGetTime20; cwOut: 3+3+2; cwIn: 4+6+2; bNumber: 0);

procedure QueryGetTime20;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(32);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetTime20, True);
end;

procedure BoxGetTime20;
begin
  AddInfo('');
  AddInfo('����� �� ���������');
  QueryGetTime20;
end;

procedure ShowGetTime20;
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

  tiCurr := tiT;

  AddInfo('����� ��������:   ' + Times2Str(tiT));
  AddInfo('����� ����������: ' + Times2Str(ToTimes(Now)));
  AddInfo('�������:          ' + DeltaTimes2Str(tiT));
  
  BoxGetSetup2;
end;

end.
