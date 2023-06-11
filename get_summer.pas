unit get_summer;

interface

procedure BoxGetSummer;
procedure ShowGetSummer;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetSummer:  querys = (Action: acGetSummer; cwOut: 3+3+2; cwIn: 4+6+2; bNumber: 0);

procedure QueryGetSummer;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(27);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetSummer, True);
end;

procedure BoxGetSummer;
begin
  AddInfo('');
  AddInfo('Дата перехода на летнее время');
  QueryGetSummer;
end;

procedure ShowGetSummer;
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
