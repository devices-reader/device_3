unit t_events;

interface

uses Classes;

function TEvents1(w: word): TStringList;
function TEvents2(w: word): TStringList;
function TEvents3(w: word): TStringList;

implementation

uses SysUtils, support;

const
  mpEvents1: array[1..16] of string = (
    '��������� ���� �',
    '��������� ���� �',
    '��������� ���� �',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?'
  );

  mpEvents2: array[1..16] of string = (
    '���������� ������',
    '���� ����� ��������� �������',
    '������',
    '��������� ���� ����������',
    '������ � ����',
    '������',
    '������',
    '������',
    '������ ������ � DSP',
    '������ DSP',
    '������',
    '���������� EEPROM1',
    '���������� EEPROM2',
    '������',
    '���������� ���',
    '���������� ���'
  );

  mpEvents3: array[1..16] of string = (
    '�������� ������ ��������',
    '�������� ������ ��������',
    '������������� ������� ��������',
    '������������� ������� �� ������� �����',
    '��������� ��������� ����������',
    '��������� ���������� �������� ����',
    '��������� ���� ������������ �������',
    '��������� ��������',
    '��������� ���������� ����������',
    '��������� ������',
    '��������� ������',
    '��������� �������',
    '��������� ������������ ��������',
    '��������� ������',
    '��������� ��������������',
    '������������ ������'
  );

function TEvents1(w: word): TStringList;
var
  s:  string;
  i:  byte;
begin
  Result := TStringList.Create;
  for i := 16 downto 1 do begin
    if (w and ($8000 shr (16 - i))) <> 0 then begin
      s := mpEvents1[i];
      Result.Add(s);
    end;
  end;
end;

function TEvents2(w: word): TStringList;
var
  s:  string;
  i:  byte;
begin
  Result := TStringList.Create;
  for i := 16 downto 1 do begin
    if (w and ($8000 shr (16 - i))) <> 0 then begin
      s := mpEvents2[i];
      Result.Add(s);
    end;
  end;
end;


function TEvents3(w: word): TStringList;
var
  s:  string;
  i:  byte;
begin
  Result := TStringList.Create;
  for i := 16 downto 1 do begin
    if (w and ($8000 shr (16 - i))) <> 0 then begin
      s := mpEvents3[i];
      Result.Add(s);
    end;
  end;
end;

end.
