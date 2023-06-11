unit get_time22;

interface

procedure BoxGetTime22;
procedure ShowGetTime22;

implementation

uses SysUtils, support, soutput, timez, box, get_status2;

const
  quGetTime22:  querys = (Action: acGetTime22; cwOut: 3+3+2; cwIn: 4+6+2; bNumber: 0);

procedure QueryGetTime22;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(32);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetTime22, True);
end;

procedure BoxGetTime22;
begin
  AddInfo('');
  AddInfo('Время');
  QueryGetTime22;
end;

procedure ShowGetTime22;
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

  AddInfo('время счетчика:   ' + Times2Str(tiT));
  AddInfo('время компьютера: ' + Times2Str(ToTimes(Now)));
  AddInfo('разница:          ' + DeltaTimes2Str(tiT));
  
  BoxGetStatus2;
end;

end.
