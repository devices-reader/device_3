unit set_summer_def;

interface

procedure BoxSetSummerDef;
procedure ShowSetSummerDef;

implementation

uses SysUtils, support, soutput, box, get_summer2;

const
  quSetSummerDef:  querys = (Action: acSetSummerDef; cwOut: 4+2; cwIn: 2+2+2; bNumber: 0);

procedure QuerySetSummerDef;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(30);
  PushByte(27);
  PushByte(0);

  Query(quSetSummerDef, True);
end;

procedure BoxSetSummerDef;
begin
  AddInfo('');
  AddInfo('Разрешение автоматического перехода на летнее время');
  QuerySetSummerDef;
end;

procedure ShowSetSummerDef;
var
  i:    byte;
begin
  Stop;
  InitPop(3);

  i := PopByte;
  if i = 0 then
    BoxGetSummer2
  else begin
    WrnBox('Ошибка операции - код '+IntToHex(i,2));
  end;
end;

end.

