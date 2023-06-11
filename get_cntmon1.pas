unit get_cntmon1;

interface

procedure BoxGetCntMon1;
procedure ShowGetCntMon1;

implementation

uses SysUtils, support, soutput, timez, box, kernel, borders, progress, realz, calendar, get_koeffs, main;

const
  quGetCntMon1:  querys = (Action: acGetCntMon1; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  ibMon:        byte;
  mpdwCntMon1:  array[0..3,0..MONTHS] of longword; 

procedure QueryGetCntMon1;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(43);
  PushByte(((ibMon xor $FF) + 1) mod $100);
  PushByte(0);
  PushByte(0);
  Query(quGetCntMon1, True);
end;

procedure BoxGetCntMon1;
begin
  if TestMonths then begin
    AddInfo('');
    AddInfo('—четчики на начало мес€ца');
    ibMon := ibMinMonth;
    QueryGetCntMon1;
  end;
end;

procedure ShowGetCntMon1;
var
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do
    mpdwCntMon1[i,ibMon] := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;

  ShowProgress(ibMon,ibMaxMonth);  

  Inc(ibMon);
  if ibMon <= ibMaxMonth then 
    QueryGetCntMon1
  else begin  
    AddInfo('');
    AddInfo('»мпульсы на начало мес€ца');

    s := PackStrR('',GetColWidth);
    for j := ibMinMonth to ibMaxMonth do s := s + PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-j)),GetColWidth);
    AddInfo(s);
    s := PackStrR('',GetColWidth);
    for j := ibMinMonth to ibMaxMonth do s := s + PackStrR('мес€ц -'+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := ibMinMonth to ibMaxMonth do s := s + PackStrR(IntToStr(mpdwCntMon1[i,j]),GetColWidth);
      AddInfo(s);
    end;

    AddInfo('');
    AddInfo('—четчики на начало мес€ца');

    s := PackStrR('',GetColWidth);
    for j := ibMinMonth to ibMaxMonth do s := s + PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-j)),GetColWidth);
    AddInfo(s);
    s := PackStrR('',GetColWidth);
    for j := ibMinMonth to ibMaxMonth do s := s + PackStrR('мес€ц -'+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := ibMinMonth to ibMaxMonth do s := s + Reals2StrR(mpdwCntMon1[i,j]*kE);
      AddInfo(s);
    end;

    BoxRun;
  end;
end;

end.
