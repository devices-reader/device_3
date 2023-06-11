unit set_winter_def;

interface

procedure BoxSetWinterDef;
procedure ShowSetWinterDef;

implementation

uses SysUtils, support, soutput, box, get_winter2;

const
  quSetWinterDef:  querys = (Action: acSetWinterDef; cwOut: 4+2; cwIn: 2+2+2; bNumber: 0);

procedure QuerySetWinterDef;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(30);
  PushByte(28);
  PushByte(0);

  Query(quSetWinterDef, True);
end;

procedure BoxSetWinterDef;
begin
  AddInfo('');
  AddInfo('Разрешение автоматического перехода на зимнее время');
  QuerySetWinterDef;
end;

procedure ShowSetWinterDef;
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

