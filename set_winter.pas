unit set_winter;

interface

uses timez;

procedure BoxSetWinter;
procedure ShowSetWinter;

implementation

uses SysUtils, support, soutput, box, get_winter2;

const
  quSetWinter:  querys = (Action: acSetWinter; cwOut: 4+6+2; cwIn: 2+2+2; bNumber: 0);

procedure QuerySetWinter;
var
  ti: times;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(16);
  PushByte(28);
  PushByte(2);

  with ti do begin
    bHour   := 3;
    bMinute := 0;
    bSecond := 0;
    bDay    := 25;
    bMonth  := 10;
    bYear   := 99;

    PushByte(bSecond);
    PushByte(bMinute);
    PushByte(bHour);
    PushByte(bDay);
    PushByte(bMonth);
    PushByte(bYear);
  end;

  AddInfo('время установки:  ' + Times2Str(ti));

  Query(quSetWinter, True);
end;

procedure BoxSetWinter;
begin
  AddInfo('');
  AddInfo('Установка времени перехода на зимнее время');
  QuerySetWinter;
end;

procedure ShowSetWinter;
var
  i:    byte;
begin
  Stop;
  InitPop(3);

  i := PopByte;
  if i = 0 then
    BoxGetWinter2
  else begin
    WrnBox('Ошибка операции - код '+IntToHex(i,2));
  end;
end;

end.

