unit sinput;

interface

procedure PostInputComPort;
procedure PostInputSocket(s: string);

procedure SaveOut(wSize: word);
procedure LoadOut(wSize: word);

var
  cbMaxRepeat,
  cbCurRepeat:  byte;

const
  REPEATS = 50;
    
implementation

uses SysUtils, Graphics, support, soutput, main, terminal, crc, box;

procedure SaveOut(wSize: word);
var
  i:  word;
begin
  cbCurRepeat := 0;
  if wSize > 0 then
    for i := 0 to wSize-1 do mpbOutSave[i] := mpbOut[i];  
end;

procedure LoadOut(wSize: word);
var
  i:  word;
begin
  if wSize > 0 then
    for i := 0 to wSize-1 do mpbOut[i] := mpbOutSave[i];  
end;

procedure RepeatAction;
begin
  if (cbCurRepeat < REPEATS) then 
    with frmMain do begin
      Inc(cbCurRepeat);
      Inc(cbMaxRepeat); ShowRepeat;
      AddInfo('������: ' + IntToStr(cbCurRepeat) + ' �� ' + IntToStr(REPEATS));
      LoadOut(quCurr.cwOut);  
      Query(quCurr, False);
    end;
end;

procedure BadSizeBox(wSize1,wSize2: word);
begin
  AddInfo('������������ ����� ������: ' + IntToStr(wSize1) + ' ������ ' + IntToStr(wSize2) + ' ����');
  RepeatAction; 
end;

procedure OtherActions(cwIn: word);
begin
  if cwIn <> quCurr.cwIn then
    BadSizeBox(cwIn,quCurr.cwIn)
  else begin
    cbCurRepeat := 0;
    BoxShow(quCurr.Action);
  end;  
end;

function Checksum(mpbT: array of byte; wSize: word): boolean;
var
  i:  word;
begin
  if wSize < 2 then 
    Result := False
  else begin
    i := CRC16(mpbIn,wSize-2);
    Result := (i mod $100 = mpbT[wSize-2]) and (i div $100 = mpbT[wSize-1])
  end;
end;

function ChecksumUni(mpbT: array of byte; wSize: word): boolean;
var
  i:  word;
begin
  if wSize < 2 then
    Result := False
  else begin
    Result := CRC16(mpbIn,wSize) = 0;
  end;
end;

procedure PostInputComPort;
var
  i,wSize:  word;
begin
  with frmMain,ComPort do begin

    wSize := InBuffUsed;
    GetBlock(mpbIn, wSize);
    ShowInData(wSize);

    if quCurr.Action in [acUniOpen,acUniTransit] then begin
      if wSize = 0 then
        ErrBox('��� ������ �� ���������� !')
      else if not ChecksumUni(mpbIn,wSize)
        then ErrBox('������ ����������� ����� !')
      else
        OtherActions(wSize);
        
      exit;
    end;

    if frmMain.rgrTransit.ItemIndex = 1 then begin
      if (wSize = 0) then begin end
      else
      if (wSize <= 7) then begin
        AddInfo('������ �������: ����� ����� ������');
        RepeatAction;
      end  
      else
      if (wSize = 0) or (CRC16(mpbIn,wSize) <> 0) then begin
        AddInfo('������ �������: ��� ������');
        RepeatAction;
      end  
      else if quCurr.Action <> acNone then begin
        for i := 0 to wSize-7 do mpbIn[i] := mpbIn[i+5];
        wSize := wSize-7;
        quCurr.cwIn := quCurr.cwIn-7;
        ShowInData(wSize);
      end;
    end;
    
    ShowTimeout;

    if quCurr.Action = acNone then begin
    end
    
    else if quCurr.Action = acTransit then begin
      ShowTransit;
    end

    else if (wSize = 0) and (cbCurRepeat < REPEATS) then begin
      AddTerminal('��� ������ !', clGray);
      RepeatAction;
    end
    else if (wSize <> quCurr.cwIn) and (cbCurRepeat < REPEATS) then begin
      AddTerminal('������������ ����� !', clGray);
      RepeatAction;
    end
    else if not Checksum(mpbIn,wSize) and (cbCurRepeat < REPEATS) then begin
      AddTerminal('������ ����������� ����� !' ,clGray);
      RepeatAction;
    end

    else begin
      if wSize = 0 then
        ErrBox('��� ������ �� ���������� !')
      else if not Checksum(mpbIn,wSize)
        then ErrBox('������ ����������� ����� !')
      else
        OtherActions(wSize);
    end;
  end;
end;

procedure PostInputSocket(s: string);
var
  i,wSize:  word;
begin
  with frmMain do begin
    wSize := Length(s);
    AddTerminal('// ������� � ������: ' + IntToStr(wSize) + ' ����',clGray);

    if wSize = 0 then exit;
    for i := 0 to Length(s) - 1 do  mpbIn[i] := Ord(s[i+1]);

    ShowInData(wSize);

    if quCurr.Action in [acUniOpen,acUniTransit] then begin
      if wSize = 0 then
        ErrBox('��� ������ �� ���������� !')
      else if not ChecksumUni(mpbIn,wSize)
        then ErrBox('������ ����������� ����� !')
      else
        OtherActions(wSize);

      exit;
    end;

    if frmMain.rgrTransit.ItemIndex = 1 then begin
      if (wSize = 0) then begin end
      else
      if (wSize <= 7) then begin
        AddInfo('������ �������: ����� ����� ������');
        RepeatAction;
      end
      else
      if (wSize = 0) or (CRC16(mpbIn,wSize) <> 0) then begin
        AddInfo('������ �������: ��� ������');
        RepeatAction;
      end
      else if quCurr.Action <> acNone then begin
        for i := 0 to wSize-7 do mpbIn[i] := mpbIn[i+5];
        wSize := wSize-7;
        quCurr.cwIn := quCurr.cwIn-7;
        ShowInData(wSize);
      end;
    end;

    ShowTimeout;

    if quCurr.Action = acNone then begin
    end

    else if quCurr.Action = acTransit then begin
      ShowTransit;
    end

    else if (wSize = 0) and (cbCurRepeat < REPEATS) then begin
      AddTerminal('��� ������ !', clGray);
      RepeatAction;
    end
    else if (wSize <> quCurr.cwIn) and (cbCurRepeat < REPEATS) then begin
      AddTerminal('������������ ����� !', clGray);
      RepeatAction;
    end
    else if not Checksum(mpbIn,wSize) and (cbCurRepeat < REPEATS) then begin
      AddTerminal('������ ����������� ����� !' ,clGray);
      RepeatAction;
    end

    else begin
      if wSize = 0 then
        ErrBox('��� ������ �� ���������� !')
      else if not Checksum(mpbIn,wSize)
        then ErrBox('������ ����������� ����� !')
      else
        OtherActions(wSize);
    end;
  end;
end;

end.

