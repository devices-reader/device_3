unit get_setup2;

interface

procedure BoxGetSetup2;
procedure ShowGetSetup2;

implementation

uses SysUtils, support, soutput, timez, box, get_open2, get_time21;

const
  quGetSetup2:  querys = (Action: acGetSetup2; cwOut: 4+6+2; cwIn: 2+2+2; bNumber: 0);

procedure QueryGetSetup2;
var
  ti: TDateTime;
  Year,Mon,Day,Hour,Min,Sec,MSec: word;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(16);
  PushByte(32);
  PushByte(2);

  ti := Now;
  DecodeTime(ti, Hour,Min,Sec,MSec);
  DecodeDate(ti, Year,Mon,Day);

  PushByte(Sec);
  PushByte(Min);
  PushByte(Hour);
  PushByte(Day);
  PushByte(Mon);
  PushByte(Year mod 100);

  AddInfo('время установки:  ' + Times2Str(ToTimes(ti)));
  
  Query(quGetSetup2, True);
end;

procedure BoxGetSetup2;
begin
  AddInfo('');
  AddInfo('Установка времени');
  QueryGetSetup2;
end;

procedure ShowGetSetup2;
var
  i:    byte;
begin
  Stop;
  InitPop(3);

  i := PopByte;
  if i = 0 then
    BoxGetTime21
  else begin
    WrnBox('Ошибка операции - код '+IntToHex(i,2));
  end;
end;

end.

