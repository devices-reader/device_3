unit get_constants;

interface

procedure BoxGetConstant17;
procedure BoxGetConstant18;
procedure BoxGetConstant19;
procedure BoxGetConstant20;
procedure BoxGetConstant21;
procedure BoxGetConstant22;
procedure ShowGetConstant17;
procedure ShowGetConstant18;
procedure ShowGetConstant19;
procedure ShowGetConstant20;
procedure ShowGetConstant21;
procedure ShowGetConstant22;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetConstant17:  querys = (Action: acGetConstant17; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);
  quGetConstant18:  querys = (Action: acGetConstant18; cwOut: 3+3+2; cwIn: 4+10+2; bNumber: 0);
  quGetConstant19:  querys = (Action: acGetConstant19; cwOut: 3+3+2; cwIn: 4+6+2; bNumber: 0);
  quGetConstant20:  querys = (Action: acGetConstant20; cwOut: 3+3+2; cwIn: 4+4+2; bNumber: 0);
  quGetConstant21:  querys = (Action: acGetConstant21; cwOut: 3+3+2; cwIn: 4+1+2; bNumber: 0);
  quGetConstant22:  querys = (Action: acGetConstant22; cwOut: 3+3+2; cwIn: 4+8+2; bNumber: 0);

procedure QueryGetConstant17;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(17);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetConstant17, True);
end;

procedure QueryGetConstant18;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(18);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetConstant18, True);
end;

procedure QueryGetConstant19;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(19);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetConstant19, True);
end;

procedure QueryGetConstant20;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(20);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetConstant20, True);
end;

procedure QueryGetConstant21;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(21);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetConstant21, True);
end;

procedure QueryGetConstant22;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(22);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetConstant22, True);
end;

procedure BoxGetConstant17;
begin
  AddInfo('');
  AddInfo('Тип прибора');
  QueryGetConstant17;
end;

procedure BoxGetConstant18;
begin
  AddInfo('');
  AddInfo('Заводской номер');
  QueryGetConstant18;
end;

procedure BoxGetConstant19;
begin
  AddInfo('');
  AddInfo('Дата выпуска');
  QueryGetConstant19;
end;

procedure BoxGetConstant20;
begin
  AddInfo('');
  AddInfo('Версия программы');
  QueryGetConstant20;
end;

procedure BoxGetConstant21;
begin
  AddInfo('');
  AddInfo('Сетевой адрес');
  QueryGetConstant21;
end;

procedure BoxGetConstant22;
begin
  AddInfo('');
  AddInfo('Идентификатор пользователя');
  QueryGetConstant22;
end;

function GetTextConstant(bSize: byte): string;
var
  i:  byte;
begin
  Result := '';
  for i := 1 to bSize do Result := Result + Chr(PopByte);
end;

procedure ShowGetConstant17;
begin
  Stop;
  InitPop(4);

  AddInfo(GetTextConstant(16));
  
  BoxRun;
end;

procedure ShowGetConstant18;
begin
  Stop;
  InitPop(4);

  AddInfo(GetTextConstant(10));  
  
  BoxRun;
end;

procedure ShowGetConstant19;
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

procedure ShowGetConstant20;
begin
  Stop;
  InitPop(4);

  AddInfo(GetTextConstant(4));  
  AddInfo('функция ''Энергия по получасам x6'' работает начиная с версии программы 2.10');
  
  BoxRun;
end;

procedure ShowGetConstant21;
begin
  Stop;
  InitPop(4);

  AddInfo(IntToStr(PopByte));

  BoxRun;
end;

procedure ShowGetConstant22;
begin
  Stop;
  InitPop(4);

  AddInfo(GetTextConstant(8));  

  BoxRun;
end;

end.
