unit set_summer_default;

interface

uses timez;

procedure BoxSetSummerDeafult;
procedure ShowSetSummerDeafult;

var
  tiSummer: times;

implementation

uses SysUtils, support, soutput, box, get_summer2;

const
  quSetSummerDeafult:  querys = (Action: acSetSummerDef; cwOut: 4+6+2; cwIn: 2+2+2; bNumber: 0);

procedure QuerySetSummerDeafult;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(16);
  PushByte(27);
  PushByte(2);

  with tiSummer do begin
    PushByte(bSecond);
    PushByte(bMinute);
    PushByte(bHour);
    PushByte(bDay);
    PushByte(bMonth);
    PushByte(bYear);
  end;

  AddInfo('время установки:  ' + Times2Str(tiSummer));
  
  Query(quSetSummerDeafult, True);
end;

procedure BoxSetSummerDeafult;
begin
  AddInfo('');
  AddInfo('Установка времени перехода на летнее время');
  QuerySetSummerDeafult;
end;

procedure ShowSetSummerDeafult;
var
  i:    byte;
begin
  Stop;
  InitPop(3);

  i := PopByte;
  if i = 0 then
    BoxGetSummer2
  else begin
    WrnBox('Ошибка установки времени - код '+IntToHex(i,2));
  end;
end;

end.

