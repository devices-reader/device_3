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
    'Состояние фазы А',
    'Состояние фазы В',
    'Состояние фазы С',
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
    'Аппаратная ошибка',
    'Сбой часов реального времени',
    'Резерв',
    'Поврежден файл калибровки',
    'Помехи в сети',
    'Резерв',
    'Резерв',
    'Резерв',
    'Ошибка обмена с DSP',
    'Ошибка DSP',
    'Резерв',
    'Неисправно EEPROM1',
    'Неисправно EEPROM2',
    'Резерв',
    'Неисправно ПЗУ',
    'Неисправно ОЗУ'
  );

  mpEvents3: array[1..16] of string = (
    'Открытие крышки счетчика',
    'Закрытие крышки счетчика',
    'Корректировка времени кнопками',
    'Корректировка времени по каналам связи',
    'Изменение тарифного расписания',
    'Изменение расписания выходных дней',
    'Изменение даты переключения сезонов',
    'Изменение констант',
    'Изменение параметров телеметрии',
    'Изменение режима',
    'Изменение пароля',
    'Обнуление энергии',
    'Обнуление максимальной мощности',
    'Обнуление срезов',
    'Изменение администратора',
    'Сканирование пароля'
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
