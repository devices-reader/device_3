unit get_current_b;

interface

uses box;

function InfoGetCurrentB(i: byte): string;
procedure BoxGetCurrentB(i: byte);
procedure ShowGetCurrentB(i: byte);

implementation

uses SysUtils, support, soutput, realz, crc;

const
  quGetCurrentB0: querys = (Action: acGetCurrentB0; cwOut: 3+3+2; cwIn: 4+4*4+2; bNumber: 0);
  quGetCurrentB1: querys = (Action: acGetCurrentB1; cwOut: 3+3+2; cwIn: 4+4*4+2; bNumber: 0);
  quGetCurrentB2: querys = (Action: acGetCurrentB2; cwOut: 3+3+2; cwIn: 4+3*4+2; bNumber: 0);
  quGetCurrentB3: querys = (Action: acGetCurrentB3; cwOut: 3+3+2; cwIn: 4+3*4+2; bNumber: 0);
  quGetCurrentB4: querys = (Action: acGetCurrentB4; cwOut: 3+3+2; cwIn: 4+3*4+2; bNumber: 0);
  quGetCurrentB5: querys = (Action: acGetCurrentB5; cwOut: 3+3+2; cwIn: 4+1*4+2; bNumber: 0);

  mpsPhases:  array[0..3] of string = ('всего', 'фаза 1', 'фаза 2', 'фаза 3');
  mpsNames:   array[0..5] of string = ('Р, единицы измерения мощности', 'Q, единицы измерения мощности', 'U, единицы измерения напряжения' , 'I, единицы измерения тока', 'cos Ф', 'f, Гц');

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

function InfoGetCurrentB(i: byte): string;
begin
  Result := 'Мгновенный парамер: ' + mpsNames[i] + ' (с учетом К. трансформации)';
end;

function GetCurrentQuery(i: byte): querys;
begin
  case i of
    0: Result := quGetCurrentB0;
    1: Result := quGetCurrentB1;
    2: Result := quGetCurrentB2;
    3: Result := quGetCurrentB3;
    4: Result := quGetCurrentB4;
    5: Result := quGetCurrentB5;
    else raise Exception.Create('');
  end;
end;

procedure QueryGetCurrent(i: byte);
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(4);
  PushByte(GetCode(i));
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(GetCurrentQuery(i), True);
end;

procedure BoxGetCurrentB(i: byte);
begin
  AddInfo('');
  AddInfo(InfoGetCurrentB(i));

  QueryGetCurrent(i);
end;

procedure ShowGetCurrentB(i: byte);
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

