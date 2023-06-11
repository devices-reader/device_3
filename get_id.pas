unit get_id;

interface

procedure BoxGetId;
procedure ShowGetId;

implementation

uses SysUtils, support, soutput, timez, box, get_setup2;

const
  quGetId:  querys = (Action: acGetId; cwOut: 3+3+2; cwIn: 4+1+2; bNumber: 0);

procedure QueryGetId;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(21);
  PushByte(0);
  PushByte(0);
  PushByte(0);
  Query(quGetId, True);
end;

procedure BoxGetId;
begin
  AddInfo('');
  AddInfo('Логический номер');
  QueryGetId;
end;

procedure ShowGetId;
begin
  Stop;
  InitPop(4);

  AddInfo(IntToStr(PopByte));

  BoxRun;
end;

end. 
