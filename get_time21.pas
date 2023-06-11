unit get_time21;

interface

procedure BoxGetTime21;
procedure ShowGetTime21;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetTime21:  querys = (Action: acGetTime21; cwOut: 3+3+2; cwIn: 4+6+2; bNumber: 0);

procedure QueryGetTime21;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(32);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetTime21, True);
end;

procedure BoxGetTime21;
begin
  AddInfo('');
  AddInfo('Время после коррекции');
  QueryGetTime21;
end;

procedure ShowGetTime21;
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
  
  AddInfo('');
  InfBox('Установка времени - проведена успешно')
end;

end.
