unit SMMonitoringAppWithChatGPT.uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.Objects, FMX.Layouts, FMX.MultiView;

type
  TFormMain = class(TForm)
    EdtURL: TEdit;
    BtnFetch: TButton;
    TBTop: TToolBar;
    LblManually: TLabel;
    MemoContent: TMemo;
    LblTop: TLabel;
    CheckBox1: TCheckBox;
    BtnProcess: TButton;
    Rectangle1: TRectangle;
    LblResult: TLabel;
    MemoResult: TMemo;
    SBDark: TStyleBook;
    LytResultBottom: TLayout;
    BtnShare: TButton;
    BtnCopy: TButton;
    SBLight: TStyleBook;
    MultiView1: TMultiView;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    BtnMasterDrawer: TButton;
    procedure BtnMasterDrawerClick(Sender: TObject);
    procedure BtnFetchClick(Sender: TObject);
    procedure BtnProcessClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  OPENAI_API_KEY = '';
  KEYWORDEXTRACTION_API_KEY = 'QdSe87VnIPlTkpLrS5i46iVl8XJqlDlf';
  SENTIMENTANALYSIS_API_KEY = 'QdSe87VnIPlTkpLrS5i46iVl8XJqlDlf';

var
  FormMain: TFormMain;

implementation

{$R *.fmx}

procedure TFormMain.BtnFetchClick(Sender: TObject);
begin
  // check for tick for automated processing
  if CheckBox1.IsChecked then
  begin
    // 0) fetch content
    // 1) start the analysis
    // 2) show the response on MemoResult
  end
  else
  begin
    // 0) just fetch content
    // 1) put it on the MemoContent
  end;
end;

procedure TFormMain.BtnMasterDrawerClick(Sender: TObject);
begin
  MultiView1.ShowMaster;
end;

procedure TFormMain.BtnProcessClick(Sender: TObject);
begin
  // create a JSON using given data
  // --> could be from MemoContent
  // ---> or directly from Response
end;

end.
