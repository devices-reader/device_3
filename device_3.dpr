program device_3;

{%ToDo 'device_3.todo'}

uses
  Forms,
  Windows,
  basic in 'basic.pas' {frmBasic},
  main in 'main.pas' {frmMain},
  box in 'box.pas',
  crc in 'crc.pas',
  kernel in 'kernel.pas',
  ports in 'ports.pas',
  progress in 'progress.pas',
  sinput in 'sinput.pas',
  soutput in 'soutput.pas',
  support in 'support.pas',
  terminal in 'terminal.pas',
  timez in 'timez.pas',
  realz in 'realz.pas',
  calendar in 'calendar.pas',
  borders in 'borders.pas',
  get_time in 'get_time.pas',
  get_koeffs in 'get_koeffs.pas',
  get_engmon in 'get_engmon.pas',
  get_engabs in 'get_engabs.pas',
  get_engday in 'get_engday.pas',
  get_graph in 'get_graph.pas',
  get_constants in 'get_constants.pas',
  ok in 'ok.pas' {frmOK},
  yesno in 'yesno.pas' {frmYesNo},
  setup2 in 'setup2.pas' {frmSetup2},
  get_open2 in 'get_open2.pas',
  get_setup2 in 'get_setup2.pas',
  get_time21 in 'get_time21.pas',
  get_time20 in 'get_time20.pas',
  get_id in 'get_id.pas',
  get_open in 'get_open.pas',
  t_events in 't_events.pas',
  get_events3 in 'get_events3.pas',
  get_events1 in 'get_events1.pas',
  get_events2 in 'get_events2.pas',
  get_cntday1 in 'get_cntday1.pas',
  get_cntday2 in 'get_cntday2.pas',
  get_cntmon1 in 'get_cntmon1.pas',
  get_cntmon2 in 'get_cntmon2.pas',
  get_summer in 'get_summer.pas',
  get_winter in 'get_winter.pas',
  get_time22 in 'get_time22.pas',
  get_summer2 in 'get_summer2.pas',
  get_winter2 in 'get_winter2.pas',
  set_summer in 'set_summer.pas',
  set_winter in 'set_winter.pas',
  t_times in 't_times.pas',
  set_summer_def in 'set_summer_def.pas',
  set_winter_def in 'set_winter_def.pas',
  get_status in 'get_status.pas',
  get_status2 in 'get_status2.pas',
  get_engabstar in 'get_engabstar.pas',
  get_engmontar in 'get_engmontar.pas',
  get_engdaytar in 'get_engdaytar.pas',
  get_calc1 in 'get_calc1.pas',
  get_cntdaytar in 'get_cntdaytar.pas',
  get_cntmontar in 'get_cntmontar.pas',
  uni_open in 'uni_open.pas',
  uni_transit in 'uni_transit.pas',
  get_current_a in 'get_current_a.pas',
  get_current_b in 'get_current_b.pas';

{$R *.RES}

var
  hMutex: THandle;

begin
  hMutex := CreateMutex(nil, True, 'device_3');
  if GetLastError <> 0 then
  begin
    WrnBox('Программа ''device_3'' уже запущена !');
    ReleaseMutex(hMutex);
    Exit;
  end;

  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;

  ReleaseMutex(hMutex);
  if GetLastError <> 0 then ;
end.
