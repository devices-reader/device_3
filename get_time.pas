unit get_time;

interface

procedure BoxGetTime;
procedure ShowGetTime;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetTime:  querys = (Action: acGetTime; cwOut: 3+3+2; cwIn: 4+6+2; bNumber: 0);

procedure QueryGetTime;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(32);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetTime, True);
end;

procedure BoxGetTime;
begin
  AddInfo('');
  AddInfo('Время');
  QueryGetTime;
end;

procedure ShowGetTime;
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
  
  BoxRun;
end;

end.
