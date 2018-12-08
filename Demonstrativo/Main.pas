unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.JSON, OtsFirebase.Util;

type
  TfrmMain = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbResp: TLabel;
    Label8: TLabel;
    edtEmail: TEdit;
    edtPassword: TEdit;
    memoToken: TMemo;
    bLoginUser: TButton;
    memoResp: TMemo;
    edtApiKey: TEdit;
    edtProjectId: TEdit;
    edtNode: TEdit;
    bGetDocument: TButton;
    bCreateUser: TButton;
    bLogout: TButton;
    OtsFirebase: TOtsFirebase;
    procedure bCreateUserClick(Sender: TObject);
    procedure bLoginUserClick(Sender: TObject);
    procedure bLogoutClick(Sender: TObject);
    procedure bGetDocumentClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.bCreateUserClick(Sender: TObject);
var
  Time1, Time2: TTime;
  Obj         : TJSONObject;
begin
  Time1 := Now;

  { Nota: Não é necessário ficar passando os parâmetros do Projeto: GOOGLE_API_KEY, GOOGLE_PROJECT_ID

    Basta fazer o seguinte:
    *************************************************************************************************

    OtsFirebase.API_KEY    := MINHA_API_KEY;
    OtsFirebase.PROJECT_ID := MEU_PROJECT_ID;

    *************************************************************************************************


    Dessa forma sua chamada ficaria assim:

    OtsFirebase.Auth(USUARIO, SENHA, CRIA_OU_NAO_UM_NOVO_USUARIO)...                       }



  Obj := OtsFirebase.API(edtApiKey.Text, edtProjectId.Text)
            .Auth(edtEmail.Text, edtPassword.Text, TRUE)  // TRUE parâmetro opcional para criar um usuário
            .ToJSONObject(OtsFirebase.FAuth); // ----> Apenas porque quero o próprio Objeto como JSON

  memoToken.Lines.Clear;
  if UpperCase(Obj.ToJSON).Contains('IDTOKEN') then
    memoToken.Lines.Add(Obj.Values['idToken'].Value);

  memoResp.Text := Obj.ToJSON;

  Time2 := Now - Time1;

  lbResp.Caption := 'Resposta em: ' + FormatDateTime('hh:mm:ss:zzz', Time2);
end;

procedure TfrmMain.bLoginUserClick(Sender: TObject);
var
  Time1, Time2: TTime;
  Obj         : TJSONObject;
begin
  Time1 := Now;

  { Nota: Não é necessário ficar passando os parâmetros do Projeto: GOOGLE_API_KEY, GOOGLE_PROJECT_ID

    Basta fazer o seguinte:
    *************************************************************************************************

    OtsFirebase.API_KEY    := MINHA_API_KEY;
    OtsFirebase.PROJECT_ID := MEU_PROJECT_ID;

    *************************************************************************************************


    Dessa forma sua chamada ficaria assim:

    OtsFirebase.Auth(USUARIO, SENHA, CRIA_OU_NAO_UM_NOVO_USUARIO)...                       }

  memoResp.Text := '';

  Obj := OtsFirebase.API(edtApiKey.Text, edtProjectId.Text)
            .Auth(edtEmail.Text, edtPassword.Text) // SEM O TRUE esta chamada serve para autenticar um usuário na base
            .ToJSONObject(OtsFirebase.FAuth); // ----> Apenas porque quero o próprio Objeto como JSON

  memoToken.Lines.Clear;
  if UpperCase(Obj.ToJSON).Contains('IDTOKEN') then
    memoToken.Lines.Add(Obj.Values['idToken'].Value);

  memoResp.Text := Obj.ToJSON;

  Time2 := Now - Time1;

  lbResp.Caption := 'Resposta em: ' + FormatDateTime('hh:mm:ss:zzz', Time2);
end;

procedure TfrmMain.bLogoutClick(Sender: TObject);
begin
  OtsFirebase.Auth(edtEmail.Text, edtPassword.Text)
      .Logout(OtsFirebase.FAuth); //  Realizo a saida da conexão com a base de dados,
                                  //  dessa forma posso obter um novo Token autenticando novamente
                                  //  ****** ESTE NÃO RETORNA NADA - NÃO TEM NECESSIDADE ******
  memoToken.Text := '';
  memoResp.Text  := '';
end;

procedure TfrmMain.bGetDocumentClick(Sender: TObject);
var
  Time1, Time2: TTime;
begin
  Time1 := Now;

  memoResp.Text := '';

  OtsFirebase.API(edtApiKey.Text, edtProjectId.Text);

  with OtsFirebase //.API(edtApiKey.Text, edtProjectId.Text)
          .Auth(edtEmail.Text, edtPassword.Text)
          .Database
          .Resource([edtNode.Text])
          .Get()
  do
  begin

    memoResp.Text := ToJSON;

  end;

  Time2 := Now - Time1;

  lbResp.Caption := 'Resposta em: ' + FormatDateTime('hh:mm:ss:zzz', Time2);
end;

end.
