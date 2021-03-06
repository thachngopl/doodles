unit Unit1;
interface
uses
  Classes, Controls, Forms, Math, SysUtils, Windows, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    procedure OnIdle(Sender: TObject; var Done: Boolean);
  end;

const
      FPS_INTERVAL      =    1000;

var
  Form1: TForm1;
  ExeDir:string;
  fPaused:Boolean;

  OldTimeFPS,OldFrameTimes,FrameTime,FrameCount:cardinal;


implementation
{$R *.DFM}
uses Unit_Render, Unit_Objects;


procedure TForm1.FormCreate(Sender: TObject);
begin
  Randomize;

  ExeDir := ExtractFilePath(Application.ExeName);

  fRender := TRender.Create(Panel1.Handle, Handle, ClientWidth, ClientHeight);
  fObjectCollection := TKObjectCollection.Create;

  Application.OnIdle := OnIdle;
  Form1.FormResize(Self);
end;


procedure TForm1.OnIdle(Sender: TObject; var Done: Boolean);
begin //Counting FPS
  if not Form1.Active then exit;

  FrameTime := GetTickCount-OldTimeFPS;
  OldTimeFPS := GetTickCount;
  if FrameTime>1000 then FrameTime:=1000;
  inc(OldFrameTimes,FrameTime);
  inc(FrameCount);
  if OldFrameTimes>=FPS_INTERVAL then begin
    Caption := floattostr(RoundTo(1000/(OldFrameTimes/FrameCount),-2))+' fps';
    OldFrameTimes:=0; FrameCount:=0;
  end; //FPS calculation complete

  if not fPaused then
  fRender.Render;
  Done := false;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  fObjectCollection.Free;
  fRender.Free;
end;


procedure TForm1.FormResize(Sender: TObject);
begin
  if fRender=nil then exit;
  fRender.SetArea(ClientWidth, ClientHeight);
end;


procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  fRender.MouseDown(Button, Shift, X, Y);
end;


procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  fRender.MouseMove(Shift, X, Y);
end;


procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then fObjectCollection.Change;
  if Button = mbRight then fRender.ChangeBackground;
  if Button = mbMiddle then fPaused := not fPaused;
end;


end.

