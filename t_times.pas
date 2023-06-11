unit t_times;

interface

uses SysUtils, timez;

function Str2Times(stT: string): times;

implementation

function Str2Times(stT: string): times;
begin
  with Result do begin
    bHour   := StrToInt(Copy(stT, 1, 2));
    bMinute := StrToInt(Copy(stT, 4, 2));
    bSecond := StrToInt(Copy(stT, 7, 2));

    bDay    := StrToInt(Copy(stT, 10, 2));
    bMonth  := StrToInt(Copy(stT, 13, 2));
    bYear   := StrToInt(Copy(stT, 16, 2));
  end;
end;

end.
