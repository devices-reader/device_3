unit get_graph;

interface

procedure BoxGetGraph6;
procedure BoxGetGraph1;
procedure ShowGetGraph6;
procedure ShowGetGraph1;
procedure CalcGetGraph;

const  
  ITEMS = 200;
  
var
  mpdwImpCD:    array[0..4-1,0..ITEMS-1] of longword;
  mpdwImpCM:    array[0..4-1,1..12] of longword;

implementation

uses SysUtils, Classes, support, soutput, timez, realz, box, borders, progress, calendar, main, get_koeffs;

const
  quGetGraph6:  querys = (Action: acGetGraph6; cwOut: 3+3+2; cwIn: 4+8*6+2; bNumber: 0);
  quGetGraph1:  querys = (Action: acGetGraph1; cwOut: 3+3+2; cwIn: 4+8+2; bNumber: 0);
  
var
  tiGraph:      times;
  mpwGraph:     array[0..4,0..6-1] of word;
  ibDay,ibBlk:  byte;

  mpdwImpCA:    array[0..4-1] of longword;
  mpstImpD:     array[0..ITEMS-1] of string;

  mpboImpCM:    array[0..4-1,1..12] of boolean;

function GetGraphDay: string;
begin
  Result := PackStrR('сутки -'+IntToStr(ibDay),GetColWidth) + Times2StrDay(DayIndexToDate(DateToDayIndex(tiGraph))); 
end;

procedure QueryGetGraph6;
begin
//  frmMain.AddTerminal('query m='+IntToStr(tiGraph.bMonth)+' d='+IntToStr(tiGraph.bDay)+' x='+IntToStr(ibBlk*6), clGray);
  AddInfo('');

  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(40);
  PushByte(tiGraph.bMonth);
  PushByte(tiGraph.bDay);
  PushByte(ibBlk*6);
  Query(quGetGraph6, True);
end;

procedure QueryGetGraph6Full;
begin
  AddInfo('');
  AddInfo('Ёнерги€ за ' + GetGraphDay);
  mpstImpD[ibDay] := GetGraphDay;
  QueryGetGraph6;
end;

procedure QueryGetGraph1;
begin
  InitPushZero;
  PushByte(GetDeviceAddr);
  PushByte(3);
  PushByte(36);
  PushByte(tiGraph.bMonth);
  PushByte(tiGraph.bDay);
  PushByte(ibBlk*1);
  Query(quGetGraph1, True);
end;

procedure QueryGetGraph1Full;
begin
  AddInfo('');
  AddInfo('Ёнерги€ за сутки -' + Int2Str(ibDay) + '  ' + Times2StrDay(DayIndexToDate(DateToDayIndex(tiGraph))));   
  mpstImpD[ibDay] := 'сутки -' + Int2Str(ibDay) + '  ' + Times2StrDay(DayIndexToDate(DateToDayIndex(tiGraph))); 
  QueryGetGraph1;
end;    

procedure BoxGetGraph6;
var
  c:  byte;
begin
  if TestDays2 then begin
    AddInfo('');
    AddInfo('Ёнерги€ по получасам x6');
    
    ibBlk := 0; 
    ibDay := ibMinDay;

    tiGraph := ToTimes(Now);
    with tiGraph do begin
      bSecond := 0;
      bMinute := 0;
      bHour := 0;
    end;

    tiGraph := DayIndexToDate(DateToDayIndex(tiGraph)-ibDay);
    
    for c := 0 to 3 do mpdwImpCD[c,ibDay] := 0;
    QueryGetGraph6Full;
  end;
end;

procedure BoxGetGraph1;
var
  c:  byte;
begin
  if TestDays2 then begin
    AddInfo('');
    AddInfo('Ёнерги€ по получасам x1');
    
    ibBlk := 10; 
    ibDay := ibMinDay;

    tiGraph := ToTimes(Now);
    with tiGraph do begin
      bSecond := 0;
      bMinute := 0;
      bHour := 0;
    end;

    tiGraph := DayIndexToDate(DateToDayIndex(tiGraph)-ibDay);
    
    for c := 0 to 3 do mpdwImpCD[c,ibDay] := 0;
    QueryGetGraph1Full;
  end;
end;

procedure CalcGetGraph;
var
  l:    TStringList;
  tiT:  times;
  x:    word;
  y,z:  byte;
  c:    byte;
  s,r:  string;
begin
  l := TStringList.Create;
      
  AddInfo('');
  for c := 0 to 3 do begin
    mpdwImpCA[c] := 0;
    for z := 1 to 12 do begin
      mpdwImpCM[c,z] := 0;
      mpboImpCM[c,z] := False;
    end;
  end; 
      
  for y := ibMinDay to ibMaxDay do begin
    s := '';
    r := '';
    for c := 0 to 3 do begin
      s := s + PackStrR(IntToStr(mpdwImpCD[c,y]),GetColWidth);
      r := r + Reals2StrR(kE*mpdwImpCD[c,y]);
          
      Inc(mpdwImpCA[c],mpdwImpCD[c,y]);
          
      tiT := DayIndexToDate(DateToDayIndex(tiCurr)-y);
      z := tiT.bMonth;
      Inc(mpdwImpCM[c,z],mpdwImpCD[c,y]);
      mpboImpCM[c,z] := True;
    end;
    AddInfo(PackStrR(mpstImpD[y],GetColWidth*2) + s);
    l.Add(PackStrR(mpstImpD[y],GetColWidth*2) + r);
  end;
  AddInfo(PackLine(GetColWidth*6));
  l.Add(PackLine(GetColWidth*6));

  s := PackStrR('всего:',GetColWidth*2);
  r := PackStrR('всего:',GetColWidth*2);
  for c := 0 to 3 do begin
    s := s + PackStrR(IntToStr(mpdwImpCA[c]),GetColWidth);
    r := r + Reals2StrR(kE*mpdwImpCA[c]);
  end;  
  AddInfo(s);
  l.Add(r);

  AddInfo('');
  for x := 1 to l.Count do AddInfo(l.Strings[x-1]);
  l.Clear;
      
  AddInfo('');
  for z := 1 to 12 do begin
    s := '';
    r := '';
    for c := 0 to 3 do begin
      if mpboImpCM[c,z] then begin
        s := s + PackStrR(IntToStr(mpdwImpCM[c,z]),GetColWidth);
        r := r + Reals2StrR(kE*mpdwImpCM[c,z]);
      end  
      else begin
        s := s + PackStrR('-',GetColWidth);
        r := r + PackStrR('-',GetColWidth);
      end;  
    end;
    AddInfo(PackStrR('мес€ц '+IntToStr(z),GetColWidth*2) + s);
    l.Add(PackStrR('мес€ц '+IntToStr(z),GetColWidth*2) + r);
  end;
  AddInfo(PackLine(GetColWidth*6));
  l.Add(PackLine(GetColWidth*6));

  AddInfo('');
  for x := 1 to l.Count do AddInfo(l.Strings[x-1]);
  l.Free;
end;

procedure ShowGetGraph6;
var
  c,j:  byte;
  s:    string;
  wT:   word;
begin
  Stop;
  InitPop(4);
  
//  frmMain.AddTerminal('read m='+IntToStr(tiGraph.bMonth)+' d='+IntToStr(tiGraph.bDay)+' x='+IntToStr(ibBlk*6), clGray);

  for j := 0 to 5 do begin
    s := '';
    for c := 0 to 3 do begin
      wT := PopByte + PopByte*$100;
      mpwGraph[c,j] := wT;
      Inc(mpdwImpCD[c,ibDay], wT);
      s := s + PackStrR(IntToStr(mpwGraph[c,j]),GetColWidth);
    end;
    AddInfo(PackStrR(Times2Str(HalfIndexToDate(DateToHalfIndex(tiGraph)+ibBlk*6+j)),GetColWidth*2)+s);
  end;  

  ShowProgress(ibDay,ibMaxDay);  

  Inc(ibBlk);
  if ibBlk < 8 then 
    QueryGetGraph6
  else begin    

    AddInfo(PackLine(GetColWidth*6));
    s := PackStrR('всего:',GetColWidth*2);
    for c := 0 to 3 do s := s + PackStrR(IntToStr(mpdwImpCD[c,ibDay]),GetColWidth);
    AddInfo(s);
  
    ibBlk := 0; 
    Inc(ibDay);
    tiGraph := DayIndexToDate(DateToDayIndex(tiGraph)-1);
    if ibDay <= ibMaxDay then begin
      for c := 0 to 3 do mpdwImpCD[c,ibDay] := 0;
      QueryGetGraph6Full;
    end  
    else begin 
      CalcGetGraph;
      BoxRun;
    end;  
  end;
end;

procedure ShowGetGraph1;
var
  c,j:  byte;
  s:    string;
  wT:   word;
begin
  Stop;
  InitPop(4);

  for j := 0 to 1-1 do begin
    s := '';
    for c := 0 to 3 do begin
      wT := PopByte + PopByte*$100;
      mpwGraph[c,j] := wT;
      Inc(mpdwImpCD[c,ibDay], wT);
      s := s + PackStrR(IntToStr(mpwGraph[c,j]),GetColWidth);
    end;
    AddInfo(PackStrR(Times2Str(HalfIndexToDate(DateToHalfIndex(tiGraph)+ibBlk*6+j)),GetColWidth*2)+s);
  end;  

  ShowProgress(ibDay,ibMaxDay);  
  
  Inc(ibBlk);
  if ibBlk < 48 then 
    QueryGetGraph1
  else begin    

    AddInfo(PackLine(GetColWidth*6));
    s := PackStrR('всего:',GetColWidth*2);
    for c := 0 to 3 do s := s + PackStrR(IntToStr(mpdwImpCD[c,ibDay]),GetColWidth);
    AddInfo(s);
  
    ibBlk := 0; 
    Inc(ibDay);
    tiGraph := DayIndexToDate(DateToDayIndex(tiGraph)-1);
    if ibDay <= ibMaxDay then begin
      for c := 0 to 3 do mpdwImpCD[c,ibDay] := 0;
      QueryGetGraph1Full;
    end  
    else begin 
      CalcGetGraph;
      BoxRun;
    end;  
  end;
end;

end.
