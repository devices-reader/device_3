unit uni_open;

interface

function InfoUniOpen: string;
procedure BoxUniOpen;
procedure ShowUniOpen;

implementation

uses SysUtils, support, soutput, timez, box, main;

const
  quUniOpen:  querys = (Action: acUniOpen; cwOut: 6+8+4; cwIn: 6+1+9; bNumber: $E0);

function InfoUniOpen: string;
begin
  Result := '�������� ������';
end;

procedure QueryUniOpen;
var
  s:  string;
begin
    s := frmMain.medUniPassword.Text;
    AddInfo(PackStrR('������:', GetColWidth) + s);
    if Length(s) <> 8 then raise Exception.Create('����� ������ ������ ���� 8 �������� !');

    InitPush(6);
    PushByte(Ord(s[1]));
    PushByte(Ord(s[2]));
    PushByte(Ord(s[3]));
    PushByte(Ord(s[4]));
    PushByte(Ord(s[5]));
    PushByte(Ord(s[6]));
    PushByte(Ord(s[7]));
    PushByte(Ord(s[8]));
    QueryUni(quUniOpen);
end;

procedure BoxUniOpen;
begin
  AddInfo('');
  AddInfo('');
  AddInfo(InfoUniOpen);
  AddInfo('');
  QueryUniOpen;
end;

procedure ShowUniOpen;
var
  i:    byte;
begin
  Stop;
  InitPop(6);

  i := PopByte;
  if i = 6 then
    AddInfo('����� ������ �������')
  else if i = 7 then
    WrnBox('������������ ������')
  else
    WrnBox('������ ������ - ��� '+IntToStr(i));
end;

end.
