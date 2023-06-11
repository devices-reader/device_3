unit get_cntmon2;

interface

procedure BoxGetCntMon2;
procedure ShowGetCntMon2;

implementation

uses SysUtils, support, soutput, timez, box, kernel, borders, progress, realz, calendar, main;

const
  quGetCntMon2:  querys = (Action: acGetCntMon2; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  ibMon:        byte;
  mpreCntMon2:  array[0..3,0..MONTHS] of single;

procedure QueryGetCntMon2;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(4);
  PushByte(43);
  PushByte(((ibMon xor $FF) + 1) mod $100);
  PushByte(0);
  PushByte(0);
  Query(quGetCntMon2, True);
end;

procedure BoxGetCntMon2;
begin
  if TestMonths then begin
    AddInfo('');
    AddInfo('—четчики на начало мес€ца (в формате с плавающей зап€той)');
    ibMon := ibMinMonth;
    QueryGetCntMon2;
  end;
end;

procedure ShowGetCntMon2;
var
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do
    mpreCntMon2[i,ibMon] := PopReals3;

  ShowProgress(ibMon,ibMaxMonth);  

  Inc(ibMon);
  if ibMon <= ibMaxMonth then 
    QueryGetCntMon2
  else begin  
    AddInfo('');

    s := PackStrR('',GetColWidth);
    for j := ibMinMonth to ibMaxMonth do s := s + PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-j)),GetColWidth);
    AddInfo(s);
    s := PackStrR('',GetColWidth);
    for j := ibMinMonth to ibMaxMonth do s := s + PackStrR('мес€ц -'+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := ibMinMonth to ibMaxMonth do s := s + Reals2StrR(mpreCntMon2[i,j]);
      AddInfo(s);
    end;

    BoxRun;
  end;
end;

end.
