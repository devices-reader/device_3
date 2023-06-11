unit get_open2;

interface

uses box;

procedure BoxGetOpen2(ac: actions);
procedure ShowGetOpen2;

implementation

uses SysUtils, support, soutput, timez, get_setup2, get_time20,
set_summer, set_winter, set_summer_def, set_winter_def;

var
  acNext: actions;

const
  quGetOpen2:  querys = (Action: acGetOpen2; cwOut: 4+8+2; cwIn: 2+2+2; bNumber: 0);

procedure QueryGetOpen2(ac: actions);
var
  s:  string;
begin
  acNext := ac;
  
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
    Query(quGetOpen2, True);
  except
    ErrBox('������ �������� ����� ����������� !');
  end;    
end;

procedure BoxGetOpen2(ac: actions);
begin
  AddInfo('');
  AddInfo('�������� ������');
  QueryGetOpen2(ac);
end;

procedure ShowGetOpen2;
var
  i:    byte;
begin
  Stop;
  InitPop(3);

  i := PopByte;
  if i = 0 then begin
    AddInfo('����� ������ �������');
    
    if acNext = acGetSetup2 then 
      BoxGetTime20
    else if acNext = acSetSummer then
      BoxSetSummer
    else if acNext = acSetWinter then
      BoxSetWinter
    else if acNext = acSetSummerDef then
      BoxSetSummerDef
    else if acNext = acSetWinterDef then
      BoxSetWinterDef
    else
      ErrBox('����������� ������ !');
  end  
  else begin
    WrnBox('������ �������� ������ - ��� '+IntToHex(i,2) + ' (������������ ������ ?)');  
  end;  
end;

end.
