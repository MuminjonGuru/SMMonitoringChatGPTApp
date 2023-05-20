program SMMonitoringAppWithChatGPT;

uses
  System.StartUpCopy,
  FMX.Forms,
  SMMonitoringAppWithChatGPT.uMain
    in 'SMMonitoringAppWithChatGPT.uMain.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;

end.
