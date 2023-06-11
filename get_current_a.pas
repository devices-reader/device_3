unit get_current_a;

interface

uses box;

function InfoGetCurrentA(i: byte): string;
procedure BoxGetCurrentA(i: byte);
procedure ShowGetCurrentA(i: byte);

implementation

uses SysUtils, support, soutput, realz, crc;

const
  quGetCurrentA0: querys = (Action: acGetCurrentA0; cwOut: 3+3+2; cwIn: 4+4*4+2; bNumber: 0);
  quGetCurrentA1: querys = (Action: acGetCurrentA1; cwOut: 3+3+2; cwIn: 4+4*4+2; bNumber: 0);
  quGetCurrentA2: querys = (Action: acGetCurrentA2; cwOut: 3+3+2; cwIn: 4+3*4+2; bNumber: 0);
  quGetCurrentA3: querys = (Action: acGetCurrentA3; cwOut: 3+3+2; cwIn: 4+3*4+2; bNumber: 0);
  quGetCurrentA4: querys = (Action: acGetCurrentA4; cwOut: 3+3+2; cwIn: 4+3*4+2; bNumber: 0);
  quGetCurrentA5: querys = (Action: acGetCurrentA5; cwOut: 3+3+2; cwIn: 4+1*4+2; bNumber: 0);

  mpsPhases:  array[0..3] of string = ('всего', 'фаза 1', 'фаза 2', 'фаза 3');
  mpsNames:   array[0..5] of string = ('Р, Вт', 'Q, ВAP', 'U, В' , 'I, А', 'cos Ф', 'f, Гц');

function GetMinIndex(i: byte): byte;
begin
  case i of
    0: Result := 0;
    1: Result := 0;
    2: Result := 1;
    3: Result := 1;
    4: Result := 1;
    5: Result := 0;
    else raise Exception.Create('');
  end;
end;

function GetMaxIndex(i: byte): byte;
begin
  case i of
    0: Result := 4;
    1: Result := 4;
    2: Result := 4;
    3: Result := 4;
    4: Result := 4;
    5: Result := 1;
    else raise Exception.Create('');
  end;
end;

function GetCode(i: byte): byte;
begin
  case i of
    0: Result := 8;
    1: Result := 9;
    2: Result := 10;
    3: Result := 11;
    4: Result := 12;
    5: Result := 13;
    else raise Exception.Create('');
  end;
end;

function InfoGetCurrentA(i: byte): string;
begin
  Result := 'Мгновенный парамер: ' + mpsNames[i] + ' (без учета К. трансформации)';
end;

function GetCurrentQuery(i: byte): querys;
begin
  case i of
    0: Result := quGetCurrentA0;
    1: Result := quGetCurrentA1;
    2: Result := quGetCurrentA2;
    3: Result := quGetCurrentA3;
    4: Result := quGetCurrentA4;
    5: Result := quGetCurrentA5;
    else raise Exception.Create('');
  end;
end;

procedure QueryGetCurrent(i: byte);
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(GetCode(i));
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(GetCurrentQuery(i), True);
end;

procedure BoxGetCurrentA(i: byte);
begin
  AddInfo('');
  AddInfo(InfoGetCurrentA(i));

  QueryGetCurrent(i);
end;

procedure ShowGetCurrentA(i: byte);
var
  j:  byte;
begin
  Stop;
  InitPop(4);

  for j := GetMinIndex(i) to GetMaxIndex(i)-1 do
    AddInfo(PackStrR(mpsPhases[j] ,GetColWidth) + Reals2Str(PopReals3));

  BoxRun;
end;

end.

