unit set_summer;

interface

uses timez;

procedure BoxSetSummer;
procedure ShowSetSummer;

implementation

uses SysUtils, support, soutput, box, get_summer2;

const
  quSetSummer:  querys = (Action: acSetSummer; cwOut: 4+6+2; cwIn: 2+2+2; bNumber: 0);

procedure QuerySetSummer;
var
  ti: times;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(16);
  PushByte(27);
  PushByte(2);

  with ti do begin
    bHour   := 2;
    bMinute := 0;
    bSecond := 0;
    bDay    := 26;
    bMonth  := 3;
    bYear   := 0;

    PushByte(bSecond);
    PushByte(bMinute);
    PushByte(bHour);
    PushByte(bDay);
    PushByte(bMonth);
    PushByte(bYear);
  end;

  AddInfo('время установки:  ' + Times2Str(ti));
  
  Query(quSetSummer, True);
end;

procedure BoxSetSummer;
begin
  AddInfo('');
  AddInfo('Установка времени перехода на летнее время');
  QuerySetSummer;
end;

procedure ShowSetSummer;
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

