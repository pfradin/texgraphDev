unit Unitlog;
{$Mode Delphi}
interface
Const
        OptionLog:boolean=true;

procedure writeLog(const ligne:string);

implementation
{============================== writeLog =====================}
procedure writeLog(const ligne:string);
begin
  if OptionLog then writeln(ligne);
end;
end.
 
