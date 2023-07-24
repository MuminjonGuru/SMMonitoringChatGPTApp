unit SMMonitoringAppWithChatGPT.uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants
, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, FMX.StdCtrls, FMX.Controls.Presentation, FMX.Edit,
  FMX.Objects, FMX.Layouts, FMX.MultiView
, REST.Types
, REST.Client
, Data.Bind.Components, Data.Bind.ObjectScope
, System.Net.URLClient
, System.Net.HttpClient
, System.Net.HttpClientComponent;

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
    LytResultBottom: TLayout;
    BtnShare: TButton;
    BtnCopy: TButton;
    RESTClient1: TRESTClient;
    RESTResponse1: TRESTResponse;
    RESTRequest1: TRESTRequest;
    StyleBook1: TStyleBook;
    Layout1: TLayout;
    BtnCheckKeywords: TButton;
    Layout2: TLayout;
    BtnSentimentAnalysis: TButton;
    RESTRequest2: TRESTRequest;
    RESTClient2: TRESTClient;
    RESTResponse2: TRESTResponse;
    procedure BtnFetchClick(Sender: TObject);
    procedure BtnProcessClick(Sender: TObject);
    procedure BtnCheckKeywordsClick(Sender: TObject);
    procedure BtnSentimentAnalysisClick(Sender: TObject);
  private
    { Private declarations }
    FKeywords: String;
    FSentiment: String;
  public
    { Public declarations }
  end;

const
  OPENAI_API_KEY = '';
  APILAYER_API_KEY = '';

var
  FormMain: TFormMain;

implementation

{$R *.fmx}

uses
  System.Threading, System.JSON;

procedure TFormMain.BtnFetchClick(Sender: TObject);
begin
  // // check for tick for automated processing
  // if CheckBox1.IsChecked then
  // begin
  // // 0) fetch content
  // // 1) start the analysis
  // // 2) show the response on MemoResult
  // end
  // else
  // begin
  // // 0) just fetch content
  // // 1) put it on the MemoContent
  // end;
end;

procedure TFormMain.BtnProcessClick(Sender: TObject);
var
  Prompt: String;
  LClient: TNetHTTPClient;
  LRequest: TNetHTTPRequest;
  LResponse: IHTTPResponse;
  LBody: TStringStream;
  LJsonBody: TJSONObject;
begin

  // create a prompt template
  Prompt := Format
    ('The text: { %s } was analyzed. Here is the keyword analysis result: { %s }. And Sentiment analysis result: { %s }. What insights can we draw from this complete text using these keywords and sentiment analysis',
    [MemoContent.Text, FKeywords, FSentiment]);

  LClient := TNetHTTPClient.Create(nil);
  LRequest := TNetHTTPRequest.Create(nil);

  try
    LRequest.Client := LClient;

    LRequest.MethodString := 'POST';
    LRequest.URL := 'https://api.openai.com/v1/completions';
    LRequest.Accept := 'application/json';
    LRequest.CustomHeaders['Content-Type'] := 'application/json';
    LRequest.CustomHeaders['Authorization'] := 'Bearer ' + OPENAI_API_KEY;

    LJsonBody := TJSONObject.Create;
    try
      LJsonBody.AddPair('model', 'text-davinci-003');
      LJsonBody.AddPair('prompt', Prompt + '\n\nQ:');
      LJsonBody.AddPair('temperature', TJSONNumber.Create(0));
      LJsonBody.AddPair('max_tokens', TJSONNumber.Create(100));
      LJsonBody.AddPair('top_p', TJSONNumber.Create(1));
      LJsonBody.AddPair('frequency_penalty', TJSONNumber.Create(0));
      LJsonBody.AddPair('presence_penalty', TJSONNumber.Create(0));
      LJsonBody.AddPair('stop', TJSONArray.Create(TJSONString.Create('\n')));

      LBody := TStringStream.Create(LJsonBody.ToString, TEncoding.UTF8);
      try
        LResponse := LRequest.Post(LRequest.URL, LBody);

        if LResponse.StatusCode = 200 then
        begin
          // ShowMessage('Request was successful.');
          MemoResult.Lines.Add(LResponse.ContentAsString(TEncoding.UTF8));
        end
        else
          ShowMessage('Request failed. Status: ' +
            LResponse.StatusCode.ToString);
      finally
        LBody.Free;
      end;
    finally
      LJsonBody.Free;
    end;
  finally
    LRequest.Free;
    LClient.Free;
  end;

end;

procedure TFormMain.BtnCheckKeywordsClick(Sender: TObject);
begin
  RESTClient1.ResetToDefaults;
  RESTClient1.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  RESTClient1.AcceptCharset := 'utf-8, *;q=0.8';
  RESTClient1.BaseURL := 'https://api.apilayer.com/keyword';
  RESTClient1.ContentType := 'application/json';

  RESTRequest1.ClearBody;
  RESTRequest1.Params.Clear;

  // API acc. key
  RESTRequest1.Params.AddItem;
  RESTRequest1.Params.Items[0].Kind := pkHTTPHEADER;
  RESTRequest1.Params.Items[0].Name := 'apikey';
  RESTRequest1.Params.Items[0].Value := APILAYER_API_KEY;
  RESTRequest1.Params.Items[0].Options := [poDoNotEncode];

  // set the url for checking
  RESTRequest1.Params.AddItem;
  RESTRequest1.Params.Items[1].Kind := pkREQUESTBODY;
  RESTRequest1.Params.Items[1].Name := 'body';
  RESTRequest1.Params.Items[1].Value := MemoContent.Text;
  // sample body inserted
  RESTRequest1.Params.Items[1].ContentTypeStr := CONTENTTYPE_TEXT_PLAIN;

  RESTRequest1.Execute;

  // keyword analysis result
  MemoResult.Lines.Add(RESTResponse1.Content);

  FKeywords := RESTResponse1.Content;
end;

procedure TFormMain.BtnSentimentAnalysisClick(Sender: TObject);
var
  LClient: TNetHTTPClient;
  LRequest: TNetHTTPRequest;
  LResponse: IHTTPResponse;
  LBody: TStringStream;
begin
  LClient := TNetHTTPClient.Create(nil);
  LRequest := TNetHTTPRequest.Create(nil);

  try
    LRequest.Client := LClient;

    LRequest.MethodString := 'POST';
    LRequest.URL := 'https://api.apilayer.com/sentiment/analysis';
    LRequest.CustomHeaders['apikey'] := APILAYER_API_KEY;

    // Assuming that you have your content as string
    LBody := TStringStream.Create('body text content comes here',
      TEncoding.UTF8);
    try
      LResponse := LRequest.Post(LRequest.URL, LBody);

      if LResponse.StatusCode = 200 then
      begin
        // ShowMessage('Request was successful.')
        MemoResult.Lines.Add(LResponse.ContentAsString(TEncoding.UTF8));
        FSentiment := LResponse.ContentAsString(TEncoding.UTF8)
      end
      else
        ShowMessage('Request failed. Status: ' + LResponse.StatusCode.ToString);
    finally
      LBody.Free;
    end;
  finally
    LRequest.Free;
    LClient.Free;
  end;
end;

end.
