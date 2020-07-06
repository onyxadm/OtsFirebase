unit Unit1;

interface

uses
  OtsFirebase.Util,

  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    pControls: TPanel;
    bDelete: TButton;
    bPut: TButton;
    bPost: TButton;
    bGet: TButton;
    bPatch: TButton;
    pFundo: TPanel;
    edtHost: TEdit;
    mStatus: TMemo;
    mResp: TMemo;
    procedure bGetClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bPostClick(Sender: TObject);
  private
    vHost: TOtsFirebase;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.bGetClick(Sender: TObject);
begin
  with vHost.Request(edtHost.Text) do
  begin
    mResp.Text   := SetCredentials('OtsFirebase', '123456').Get();
    mStatus.Text := 'Código: ' + ResponseCode.ToString +sLineBreak+
                    'Tempo:  ' + TimeToStr(ResponseTimeOut);
  end;
end;

procedure TForm1.bPostClick(Sender: TObject);
begin
  with vHost.Request(edtHost.Text) do
  begin
    mResp.Text   := SetCredentials('OtsFirebase', '123456').Post('{"teste": "OtsFirebase"}');
    mStatus.Text := 'Código: ' + ResponseCode.ToString +sLineBreak+
                    'Tempo:  ' + TimeToStr(ResponseTimeOut);
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  vHost.Free;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  vHost := TOtsFirebase.Create(Self);
end;

end.
