program Compare;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  Unit_TScan in 'Unit_TScan.pas',
  Unit_TSettings in 'Unit_TSettings.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Compare';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.