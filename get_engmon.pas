unit get_engmon;

interface

procedure BoxGetEngMon;
procedure ShowGetEngMon;

implementation

uses SysUtils, support, soutput, timez, box, kernel, borders, progress, realz, calendar, get_koeffs, get_graph, main;

const
  quGetEngMon:  querys = (Action: acGetEngMon; cwOut: 3+3+2; cwIn: 4+16+2; bNumber: 0);

var
  ibMon:        byte;
  mpdwEngMon:   array[0..3,0..MONTHS] of longword; 

procedure QueryGetEngMon;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(3);
  PushByte(((ibMon xor $FF) + 1) mod $100);
  PushByte(0);
  PushByte(0);
  Query(quGetEngMon, True);
end;

procedure BoxGetEngMon;
begin
  if TestMonths then begin
    AddInfo('');
    AddInfo('Ёнерги€ по мес€цам');
    ibMon := ibMinMonth;
    QueryGetEngMon;
  end;
end;

procedure ShowGetEngMon;
var
  i,j:  byte;
  s:    string;
begin
  Stop;
  InitPop(4);

  for i := 0 to 3 do
    mpdwEngMon[i,ibMon] := PopByte + PopByte*$100 + PopByte*$10000 + PopByte*$1000000;

  ShowProgress(ibMon,ibMaxMonth);  

  Inc(ibMon);
  if ibMon <= ibMaxMonth then 
    QueryGetEngMon
  else begin  
    AddInfo('');
    AddInfo('»мпульсы по мес€цам');

    s := PackStrR('',GetColWidth);
    for j := ibMinMonth to ibMaxMonth do s := s + PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-j)),GetColWidth);
    AddInfo(s);    
    s := PackStrR('',GetColWidth);
    for j := ibMinMonth to ibMaxMonth do s := s + PackStrR('мес€ц -'+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := ibMinMonth to ibMaxMonth do s := s + PackStrR(IntToStr(mpdwEngMon[i,j]),GetColWidth);
      AddInfo(s);
    end;
    
    AddInfo('');
    AddInfo('Ёнерги€ по мес€цам');

    s := PackStrR('',GetColWidth);
    for j := ibMinMonth to ibMaxMonth do s := s + PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-j)),GetColWidth);
    AddInfo(s);    
    s := PackStrR('',GetColWidth);
    for j := ibMinMonth to ibMaxMonth do s := s + PackStrR('мес€ц -'+IntToStr(j),GetColWidth);
    AddInfo(s);

    for i := 0 to 3 do begin
      s := PackStrR(GetCanalName(i),GetColWidth);
      for j := ibMinMonth to ibMaxMonth do s := s + Reals2StrR(mpdwEngMon[i,j]*kE);
      AddInfo(s);
    end;
{    
    if frmMain.clbMain.Checked[Ord(acGetGraph6)] then begin    
      AddInfo('');
      AddInfo('»мпульсы по мес€цам (интегральные / рассчитанные по получасам)');
      for j := ibMinMonth to ibMaxMonth do begin
        AddInfo(PackStrR('мес€ц -'+IntToStr(j),GetColWidth) + PackStrR(Times2StrMon(MonIndexToDate(DateToMonIndex(tiCurr)-j)),GetColWidth));
        for i := 0 to 3 do begin
          s := PackStrR(GetCanalName(i),GetColWidth);
            b := mpdwEngMon[i,j];
            a := mpdwImpCM[i,j];
            s := s + PackStrR(IntToStr(b),GetColWidth) + PackStrR(IntToStr(a),GetColWidth);
            s := s + PackStrR(IntToStr(b-a),GetColWidth);
            if a <> 0 then s := s + Reals2Str(100*(b-a)/a) + ' %' else s := s + '?';
          AddInfo(s);
        end;
      end;
    end;
}    
    BoxRun;
  end;
end;

end.
