unit get_koeffs;

interface

function GetActiveEnergyUnit(i: byte): string;
function GetReactiveEnergyUnit(i: byte): string;
function GetActivePowerUnit(i: byte): string;
function GetReactivePowerUnit(i: byte): string;
function GetVoltageUnit(i: byte): string;
function GetCurrentUnit(i: byte): string;

procedure BoxGetTrans;
procedure ShowGetTrans;

procedure BoxGetPulse;
procedure ShowGetPulse;

var
  kE:     extended;
  uE,uP,uU,uI: byte;

implementation

uses SysUtils, support, soutput, timez, box;

var
  kI,kU:  longword;
  kP:     word;

const
  quGetTrans: querys = (Action: acGetTrans; cwOut: 3+3+2; cwIn: 4+18+2; bNumber: 0);
  quGetPulse: querys = (Action: acGetPulse; cwOut: 3+3+2; cwIn: 4+8+2;  bNumber: 0);

function GetActiveEnergyUnit(i: byte): string;
begin
  case i of
    0: Result := 'Вт·ч';
    1: Result := 'кВт·ч';
    2: Result := 'МВт·ч';
    else Result := '?';
  end;
  Result := IntToStr(i) + ' - ' + Result;
end;

function GetReactiveEnergyUnit(i: byte): string;
begin
  case i of
    0: Result := 'ВAP·ч';
    1: Result := 'кВAP·ч';
    2: Result := 'МВAP·ч';
    else Result := '?';
  end;
  Result := IntToStr(i) + ' - ' + Result;
end;

function GetActivePowerUnit(i: byte): string;
begin
  case i of
    0: Result := 'Вт';
    1: Result := 'кВт';
    2: Result := 'МВт';
    else Result := '?';
  end;
  Result := IntToStr(i) + ' - ' + Result;
end;

function GetReactivePowerUnit(i: byte): string;
begin
  case i of
    0: Result := 'ВAP';
    1: Result := 'кВAP';
    2: Result := 'МВAP';
    else Result := '?';
  end;
  Result := IntToStr(i) + ' - ' + Result;
end;

function GetVoltageUnit(i: byte): string;
begin
  case i of
    0: Result := 'В';
    1: Result := 'кВ';
    else Result := '?';
  end;
  Result := IntToStr(i) + ' - ' + Result;
end;

function GetCurrentUnit(i: byte): string;
begin
  case i of
    0: Result := 'A';
    1: Result := 'кA';
    else Result := '?';
  end;
  Result := IntToStr(i) + ' - ' + Result;
end;

procedure QueryGetTrans;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(34);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetTrans, True);
end;

procedure QueryGetPulse;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(24);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetPulse, True);
end;

procedure BoxGetTrans;
begin
  AddInfo('');
  AddInfo('К. трансформации и формат измеряемых величин');
  QueryGetTrans;
end;

procedure BoxGetPulse;
begin
  AddInfo('');
  AddInfo('К. преобразования');
  QueryGetPulse;
end;

procedure ShowGetTrans;
begin
  Stop;
  InitPop(4);

  kI := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;
  kU := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;

  AddInfo('');
  AddInfo('К. трансформации по току:       ' + IntToStr(kI));
  AddInfo('К. трансформации по напряжению: ' + IntToStr(kU));
  AddInfo('К. трансформации:               ' + IntToStr(kI*kU));

  AddInfo('');
  uE := PopByte;
  AddInfo('Единицы измерения энергии:      ' + GetActiveEnergyUnit(uE));
  AddInfo('Число знаков после запятой:     ' + IntToStr(PopByte));
  AddInfo('Множитель:                      ' + IntToStr(PopByte));

  AddInfo('');
  uP := PopByte;
  AddInfo('Единицы измерения мощности:     ' + GetActivePowerUnit(uP));
  AddInfo('Число знаков после запятой:     ' + IntToStr(PopByte));
  AddInfo('Множитель:                      ' + IntToStr(PopByte));

  AddInfo('');
  uU := PopByte;
  AddInfo('Единицы измерения напряжения:   ' + GetVoltageUnit(uU));
  AddInfo('Число знаков после запятой:     ' + IntToStr(PopByte));

  AddInfo('');
  uI := PopByte;
  AddInfo('Единицы измерения тока:         ' + GetCurrentUnit(uI));
  AddInfo('Число знаков после запятой:     ' + IntToStr(PopByte));

  BoxRun;
end;

procedure ShowGetPulse;
begin
  Stop;
  InitPop(8);

  kP := 1000000 div (PopByte + PopByte*$100);
  kE := kI*kU/kP;

  AddInfo(IntToStr(kP));

  BoxRun;
end;

end.
