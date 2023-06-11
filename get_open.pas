unit get_open;

interface

procedure BoxGetOpen;
procedure ShowGetOpen;

implementation

uses SysUtils, support, soutput, timez, box;

const
  quGetOpen:  querys = (Action: acGetOpen; cwOut: 4+8+2; cwIn: 2+2+2; bNumber: 0);

procedure QueryGetOpen;
var
  s:  string;
begin
  try
    s := GetDevicePass;
    AddInfo('������: ' + s);
    if Length(s) <> 8 then raise Exception.Create('������������ ����� ������: ���������� 8 �������� !');

    InitPushZero;
    PushByte(GetDeviceAddr);
    PushByte(31);
    PushByte(0);
    PushByte(0);

    PushByte(Ord(s[1]));
    PushByte(Ord(s[2]));
    PushByte(Ord(s[3]));
    PushByte(Ord(s[4]));
    PushByte(Ord(s[5]));
    PushByte(Ord(s[6]));
    PushByte(Ord(s[7]));
    PushByte(Ord(s[8]));
    Query(quGetOpen, True);
  except
    ErrBox('������ �������� ����� ����������� !');
  end;
end;

procedure BoxGetOpen;
begin
  AddInfo('');
  AddInfo('�������� ������ (� �������)');
  QueryGetOpen;
end;

procedure ShowGetOpen;
var
  i:    byte;
begin
  Stop;
  InitPop(3);

  i := PopByte;
  if i = 0 then begin
    AddInfo('����� ������ �������');    
    BoxRun
  end
  else begin
    WrnBox('������ �������� ������ - ��� '+IntToHex(i,2) + ' (������������ ������ ?)');
  end;
end;

end.
