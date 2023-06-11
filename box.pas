unit box;

interface

uses SysUtils, AdTapi, timez;

type
  actions =
  (
    acGetOpen,
    acGetTime,
    acGetId,
    acGetStatus,
    acGetSummer,
    acGetWinter,
    acGetConstant17,
    acGetConstant18,
    acGetConstant19,
    acGetConstant20,
    acGetConstant21,
    acGetConstant22,

    acGetTrans,
    acGetPulse,
    acGetGraph6,

    acGetEngAbs,
    acGetEngAbsTar,
    acGetEngMon,
    acGetEngMonTar,
    acGetEngDay,
    acGetEngDayTar,

    acGetCntDay1,
    acGetCntDay2,
    acGetCntMon1,
    acGetCntMon2,

    acGetCntDayTar,
    acGetCntMonTar,
    acGetCalc1,

    acGetGraph1,
    acGetEvents1,
    acGetEvents2,
    acGetEvents3,

    acGetCurrentA0,
    acGetCurrentA1,
    acGetCurrentA2,
    acGetCurrentA3,
    acGetCurrentA4,
    acGetCurrentA5,

    acGetCurrentB0,
    acGetCurrentB1,
    acGetCurrentB2,
    acGetCurrentB3,
    acGetCurrentB4,
    acGetCurrentB5,

    acNone,
    acGetOpen2,
    acGetTime20,
    acGetSetup2,
    acGetTime21,

    acGetTime22,
    acGetStatus2,
    acGetSummer2,
    acGetWinter2,
    acSetSummer,
    acSetWinter,
    acSetSummerDef,
    acSetWinterDef,

    acTransit,

    acUniOpen,
    acUniTransit
  );

  querys = record
    Action:     actions;
    cwOut:      word;
    cwIn:       word;
    bNumber:    byte;
  end;

procedure BoxCreate;
procedure BoxRun;
procedure BoxRead;
procedure BoxShow(ac: actions);

var
  cwConnect:  longword;
  tiCurr:     times;

implementation

uses main, support, progress, 
get_open, get_time, get_id, get_status,
get_koeffs,
get_engabs, get_engmon, get_engday,
get_engabstar, get_engmontar, get_engdaytar,
get_cntday1, get_cntday2, get_cntmon1, get_cntmon2,
get_cntdaytar, get_cntmontar, get_calc1,
get_graph, get_constants,
get_events1, get_events2, get_events3,
get_current_a, get_current_b,
get_summer, get_winter,
get_open2, get_time20, get_setup2, get_time21,
get_time22, get_status2, get_summer2, get_winter2, set_summer, set_winter,
set_summer_def, set_winter_def,
uni_open, uni_transit
;

var
  BoxStart:   TDateTime;
  iwBox:      word;

procedure BoxCreate;
var
  i:  word;
begin
  with frmMain.clbMain do begin
    for i := 1 to Ord(acNone) do Items.Add('?');
    Items[Ord(acGetOpen)]       := 'Открытие канала (с паролем)';
    Items[Ord(acGetTime)]       := 'Время';
    Items[Ord(acGetId)]         := 'Логический номер';
    Items[Ord(acGetStatus)]     := 'Статус';
    Items[Ord(acGetTrans)]      := 'К. трансформации и формат измеряемых величин';
    Items[Ord(acGetPulse)]      := 'К. преобразования';

    Items[Ord(acGetEngAbs)]     := 'Энергия всего';
    Items[Ord(acGetEngAbsTar)]  := 'Энергия всего (по тарифам)';
    Items[Ord(acGetEngMon)]     := 'Энергия по месяцам';
    Items[Ord(acGetEngMonTar)]  := 'Энергия по месяцам (по тарифам)';
    Items[Ord(acGetEngDay)]     := 'Энергия по суткам';
    Items[Ord(acGetEngDayTar)]  := 'Энергия по суткам (по тарифам)';

    Items[Ord(acGetCntDay1)]    := 'Счетчики на начало суток';
    Items[Ord(acGetCntDay2)]    := 'Счетчики на начало суток (в формате с плавающей запятой)';
    Items[Ord(acGetCntMon1)]    := 'Счетчики на начало месяца';
    Items[Ord(acGetCntMon2)]    := 'Счетчики на начало месяца (в формате с плавающей запятой)';
    Items[Ord(acGetCntDayTar)]  := 'Счетчики на начало суток (по тарифам)';
    Items[Ord(acGetCntMonTar)]  := 'Счетчики на начало месяца (по тарифам)';

    Items[Ord(acGetCalc1)]      := 'Счетчики на начало текущих суток (по тарифам) расчетные';
    Items[Ord(acGetGraph6)]     := 'Энергия по получасам x6';
    Items[Ord(acGetGraph1)]     := '*Тестовая функция';  // Энергия по получасам x1
    Items[Ord(acGetConstant17)] := 'Тип прибора';
    Items[Ord(acGetConstant18)] := 'Заводской номер';
    Items[Ord(acGetConstant19)] := 'Дата выпуска';
    Items[Ord(acGetConstant20)] := 'Версия программы';
    Items[Ord(acGetConstant21)] := 'Сетевой адрес';
    Items[Ord(acGetConstant22)] := 'Идентификатор пользователя';
    Items[Ord(acGetEvents1)]    := 'Архив фаз';
    Items[Ord(acGetEvents2)]    := 'Архив состояния прибора';
    Items[Ord(acGetEvents3)]    := 'Архив событий коррекции';
    Items[Ord(acGetSummer)]     := 'Дата перехода на летнее время';
    Items[Ord(acGetWinter)]     := 'Дата перехода на зимнее время';

    Items[Ord(acGetCurrentA0)]   := InfoGetCurrentA(0);
    Items[Ord(acGetCurrentA1)]   := InfoGetCurrentA(1);
    Items[Ord(acGetCurrentA2)]   := InfoGetCurrentA(2);
    Items[Ord(acGetCurrentA3)]   := InfoGetCurrentA(3);
    Items[Ord(acGetCurrentA4)]   := InfoGetCurrentA(4);
    Items[Ord(acGetCurrentA5)]   := InfoGetCurrentA(5);

    Items[Ord(acGetCurrentB0)]   := InfoGetCurrentB(0);
    Items[Ord(acGetCurrentB1)]   := InfoGetCurrentB(1);
    Items[Ord(acGetCurrentB2)]   := InfoGetCurrentB(2);
    Items[Ord(acGetCurrentB3)]   := InfoGetCurrentB(3);
    Items[Ord(acGetCurrentB4)]   := InfoGetCurrentB(4);
    Items[Ord(acGetCurrentB5)]   := InfoGetCurrentB(5);
  end;
end;

procedure BoxRun;
var
  b:  boolean;
begin
 with frmMain do begin
  with clbMain do  while (iwBox < Items.Count) do begin
    if Checked[iwBox] then begin
      case iwBox of
        Ord(acGetOpen):       begin BoxGetOpen;       Inc(iwBox); exit; end;
        Ord(acGetTime):       begin BoxGetTime;       Inc(iwBox); exit; end;
        Ord(acGetId):         begin BoxGetId;         Inc(iwBox); exit; end;
        Ord(acGetStatus):     begin BoxGetStatus;     Inc(iwBox); exit; end;
        Ord(acGetTrans):      begin BoxGetTrans;      Inc(iwBox); exit; end;
        Ord(acGetPulse):      begin BoxGetPulse;      Inc(iwBox); exit; end;

        Ord(acGetEngAbs):     begin BoxGetEngAbs;     Inc(iwBox); exit; end;
        Ord(acGetEngAbsTar):  begin BoxGetEngAbsTar;  Inc(iwBox); exit; end;
        Ord(acGetEngMon):     begin BoxGetEngMon;     Inc(iwBox); exit; end;
        Ord(acGetEngMonTar):  begin BoxGetEngMonTar;  Inc(iwBox); exit; end;
        Ord(acGetEngDay):     begin BoxGetEngDay;     Inc(iwBox); exit; end;
        Ord(acGetEngDayTar):  begin BoxGetEngDayTar;  Inc(iwBox); exit; end;

        Ord(acGetCntDay1):    begin BoxGetCntDay1;    Inc(iwBox); exit; end;
        Ord(acGetCntDay2):    begin BoxGetCntDay2;    Inc(iwBox); exit; end;
        Ord(acGetCntMon1):    begin BoxGetCntMon1;    Inc(iwBox); exit; end;
        Ord(acGetCntMon2):    begin BoxGetCntMon2;    Inc(iwBox); exit; end;
        Ord(acGetCntDayTar):  begin BoxGetCntDayTar;  Inc(iwBox); exit; end;
        Ord(acGetCntMonTar):  begin BoxGetCntMonTar;  Inc(iwBox); exit; end;

        Ord(acGetCalc1):      begin BoxGetCalc1;      Inc(iwBox); exit; end;
        Ord(acGetGraph6):     begin BoxGetGraph6;     Inc(iwBox); exit; end;
        Ord(acGetGraph1):     begin BoxGetGraph1;     Inc(iwBox); exit; end;
        Ord(acGetConstant17): begin BoxGetConstant17; Inc(iwBox); exit; end;
        Ord(acGetConstant18): begin BoxGetConstant18; Inc(iwBox); exit; end;
        Ord(acGetConstant19): begin BoxGetConstant19; Inc(iwBox); exit; end;
        Ord(acGetConstant20): begin BoxGetConstant20; Inc(iwBox); exit; end;
        Ord(acGetConstant21): begin BoxGetConstant21; Inc(iwBox); exit; end;
        Ord(acGetConstant22): begin BoxGetConstant22; Inc(iwBox); exit; end;
        Ord(acGetEvents1):    begin BoxGetEvents1;    Inc(iwBox); exit; end;
        Ord(acGetEvents2):    begin BoxGetEvents2;    Inc(iwBox); exit; end;
        Ord(acGetEvents3):    begin BoxGetEvents3;    Inc(iwBox); exit; end;

        Ord(acGetCurrentA0):  begin BoxGetCurrentA(0); Inc(iwBox); exit; end;
        Ord(acGetCurrentA1):  begin BoxGetCurrentA(1); Inc(iwBox); exit; end;
        Ord(acGetCurrentA2):  begin BoxGetCurrentA(2); Inc(iwBox); exit; end;
        Ord(acGetCurrentA3):  begin BoxGetCurrentA(3); Inc(iwBox); exit; end;
        Ord(acGetCurrentA4):  begin BoxGetCurrentA(4); Inc(iwBox); exit; end;
        Ord(acGetCurrentA5):  begin BoxGetCurrentA(5); Inc(iwBox); exit; end;

        Ord(acGetCurrentB0):  begin BoxGetCurrentB(0); Inc(iwBox); exit; end;
        Ord(acGetCurrentB1):  begin BoxGetCurrentB(1); Inc(iwBox); exit; end;
        Ord(acGetCurrentB2):  begin BoxGetCurrentB(2); Inc(iwBox); exit; end;
        Ord(acGetCurrentB3):  begin BoxGetCurrentB(3); Inc(iwBox); exit; end;
        Ord(acGetCurrentB4):  begin BoxGetCurrentB(4); Inc(iwBox); exit; end;
        Ord(acGetCurrentB5):  begin BoxGetCurrentB(5); Inc(iwBox); exit; end;

        Ord(acGetSummer):     begin BoxGetSummer;     Inc(iwBox); exit; end;
        Ord(acGetWinter):     begin BoxGetWinter;     Inc(iwBox); exit; end;
        else ErrBox('Ошибка при задании списка запросов !');
      end;
    end;
    Inc(iwBox);
  end;

  AddInfo(' ');
    AddInfo('');
  AddInfo('Начало опроса: '+Times2Str(ToTimes(BoxStart)));
  AddInfo('Конец опроса:  '+Times2Str(ToTimes(Now)));
  AddInfo('Длительность опроса:'+DeltaTimes2Str(ToTimes(BoxStart)));
{
  b := False;
  if (TapiDevice.TapiState = tsConnected) and (chbCancelCall.Checked) then begin
    b := True;
    btbCancelCallClick(nil);
  end;

  if b then begin
    AddInfo(' ');
    AddInfo('Cоединение: ' + IntToStr(timNow.Interval * cwConnect div 1000) + ' секунд');
  end;
}
    AddInfo(' ');
    AddInfo('Опрос успешно завершен: '+mitVersion.Caption);

    ShowProgress(-1, 1);
  end;
end;

procedure BoxRead;
begin
  with frmMain do begin
    with clbMain do begin
      if Checked[Ord(acGetCalc1)] then begin
        Checked[Ord(acGetEngAbsTar)] := True;
      end;

      if Checked[Ord(acGetEngAbs)] or
         Checked[Ord(acGetEngAbsTar)] or
         Checked[Ord(acGetEngMon)] or
         Checked[Ord(acGetEngMonTar)] or
         Checked[Ord(acGetEngDay)] or
         Checked[Ord(acGetEngDayTar)] or
         Checked[Ord(acGetCntDay1)] or
         Checked[Ord(acGetCntMon1)] or
         Checked[Ord(acGetCntDayTar)] or
         Checked[Ord(acGetCntMonTar)] or
         Checked[Ord(acGetGraph6)] or
         Checked[Ord(acGetGraph1)] then begin
        Checked[Ord(acGetTime)] := True;
        Checked[Ord(acGetTrans)] := True;
        Checked[Ord(acGetPulse)] := True;
      end;

      if Checked[Ord(acGetCntDay2)] or
         Checked[Ord(acGetCntMon2)] then begin
        Checked[Ord(acGetTime)] := True;
      end;

      if Checked[Ord(acGetCurrentB0)] or
         Checked[Ord(acGetCurrentB1)] or
         Checked[Ord(acGetCurrentB2)] or
         Checked[Ord(acGetCurrentB3)] or
         Checked[Ord(acGetCurrentB4)] or
         Checked[Ord(acGetCurrentB5)] then begin
        Checked[Ord(acGetTrans)] := True;
      end;
    end;

    BoxStart := Now;

    AddInfo('');
    AddInfo('');
    AddInfo('Cчетчик: номер '+IntToStr(GetDeviceAddr));

    iwBox := 0;
    BoxRun;
  end;
end;

procedure BoxShow(ac: actions);
begin
  case ac of
    acGetOpen:        ShowGetOpen;
    acGetTime:        ShowGetTime;
    acGetId:          ShowGetId;
    acGetStatus:      ShowGetStatus;
    acGetTrans:       ShowGetTrans;
    acGetPulse:       ShowGetPulse;

    acGetEngAbs:      ShowGetEngAbs;
    acGetEngAbsTar:   ShowGetEngAbsTar;
    acGetEngMon:      ShowGetEngMon;
    acGetEngMonTar:   ShowGetEngMonTar;
    acGetEngDay:      ShowGetEngDay;
    acGetEngDayTar:   ShowGetEngDayTar;

    acGetCntDay1:     ShowGetCntDay1;
    acGetCntDay2:     ShowGetCntDay2;
    acGetCntMon1:     ShowGetCntMon1;
    acGetCntMon2:     ShowGetCntMon2;
    acGetCntDayTar:   ShowGetCntDayTar;
    acGetCntMonTar:   ShowGetCntMonTar;
    acGetCalc1:       ShowGetCalc1;

    acGetGraph6:      ShowGetGraph6;
    acGetGraph1:      ShowGetGraph1;
    acGetConstant17:  ShowGetConstant17;
    acGetConstant18:  ShowGetConstant18;
    acGetConstant19:  ShowGetConstant19;
    acGetConstant20:  ShowGetConstant20;
    acGetConstant21:  ShowGetConstant21;
    acGetConstant22:  ShowGetConstant22;
    acGetEvents1:     ShowGetEvents1;
    acGetEvents2:     ShowGetEvents2;
    acGetEvents3:     ShowGetEvents3;

    acGetCurrentA0:   ShowGetCurrentA(0);
    acGetCurrentA1:   ShowGetCurrentA(1);
    acGetCurrentA2:   ShowGetCurrentA(2);
    acGetCurrentA3:   ShowGetCurrentA(3);
    acGetCurrentA4:   ShowGetCurrentA(4);
    acGetCurrentA5:   ShowGetCurrentA(5);

    acGetCurrentB0:   ShowGetCurrentB(0);
    acGetCurrentB1:   ShowGetCurrentB(1);
    acGetCurrentB2:   ShowGetCurrentB(2);
    acGetCurrentB3:   ShowGetCurrentB(3);
    acGetCurrentB4:   ShowGetCurrentB(4);
    acGetCurrentB5:   ShowGetCurrentB(5);

    acGetSummer:      ShowGetSummer;
    acGetWinter:      ShowGetWinter;

    acGetOpen2:       ShowGetOpen2;
    acGetTime20:      ShowGetTime20;
    acGetSetup2:      ShowGetSetup2;
    acGetTime21:      ShowGetTime21;

    acGetTime22:      ShowGetTime22;
    acGetStatus2:     ShowGetStatus2;
    acGetSummer2:     ShowGetSummer2;
    acGetWinter2:     ShowGetWinter2;
    acSetSummer:      ShowSetSummer;
    acSetWinter:      ShowSetWinter;

    acSetSummerDef:   ShowSetSummerDef;
    acSetWinterDef:   ShowSetWinterDef;

    acUniOpen:        ShowUniOpen;
    acUniTransit:     ShowUniTransit;

  end;
end;

end.
