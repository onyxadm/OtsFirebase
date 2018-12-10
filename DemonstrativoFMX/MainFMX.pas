unit MainFMX;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.ScrollBox,
  FMX.Memo,
  FMX.StdCtrls,
  FMX.Layouts,
  FMX.Controls.Presentation,
  FMX.Edit,

  System.JSON,
  Rest.JSON,
  OtsFirebase.Util;

type
  TForm2 = class(TForm)
    edtEmail: TEdit;
    Layout1: TLayout;
    Label1: TLabel;
    Layout2: TLayout;
    edtNode: TEdit;
    Label2: TLabel;
    Layout3: TLayout;
    edtProjectId: TEdit;
    Label3: TLabel;
    Layout5: TLayout;
    edtPassword: TEdit;
    Label5: TLabel;
    bGetDocument: TButton;
    bLoginUser: TButton;
    Layout6: TLayout;
    lbResp: TLabel;
    memoResp: TMemo;
    OtsFirebase: TOtsFirebase;
    edtApiKey: TEdit;
    Label6: TLabel;
    noAuth: TCheckBox;
    bLogout: TButton;
    bCreateUser: TButton;
    Layout4: TLayout;
    edtUrlRequest: TEdit;
    Label4: TLabel;
    btnExecute: TButton;
    procedure bLogoutClick(Sender: TObject);
    procedure bCreateUserClick(Sender: TObject);
    procedure bLoginUserClick(Sender: TObject);
    procedure bGetDocumentClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.fmx}

procedure TForm2.bCreateUserClick(Sender: TObject);
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

  memoResp.Text := Obj.ToJSON;

  Time2 := Now - Time1;

  lbResp.Text := 'Resposta em: ' + FormatDateTime('hh:mm:ss:zzz', Time2);
end;

procedure TForm2.bLoginUserClick(Sender: TObject);
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

  memoResp.Text := Obj.ToJSON;

  Time2 := Now - Time1;

  lbResp.Text := 'Resposta em: ' + FormatDateTime('hh:mm:ss:zzz', Time2);
end;

procedure TForm2.bLogoutClick(Sender: TObject);
begin
  OtsFirebase.Auth(edtEmail.Text, edtPassword.Text)
      .Logout(OtsFirebase.FAuth); //  Realizo a saida da conexão com a base de dados,
                                  //  dessa forma posso obter um novo Token autenticando novamente
                                  //  ****** ESTE NÃO RETORNA NADA - NÃO TEM NECESSIDADE ******
  memoResp.Text := '';
end;

procedure TForm2.bGetDocumentClick(Sender: TObject);
var
  Time1, Time2: TTime;
begin
  Time1 := Now;

  memoResp.Text := '';

  if noAuth.isChecked then
  begin

    //Consumindo um projeto Firebase sem autenticação, projeto com regras de segurança aberta

    memoResp.Text := OtsFirebase
                        .API(edtProjectId.Text)
                        .Database
                        .Resource([edtNode.Text])
                        .Get()
                        .ToJSON;

  end else
  begin

    //Autenticando e consumindo um Firebase

    OtsFirebase.API(edtApiKey.Text, edtProjectId.Text);

    memoResp.Text := OtsFirebase //.API(edtApiKey.Text, edtProjectId.Text)
                        .Auth(edtEmail.Text, edtPassword.Text)
                        .Database
                        .Resource([edtNode.Text])
                        .Get()
                        .ToJSON;
  end;

  Time2 := Now - Time1;

  lbResp.Text := 'Resposta em: ' + FormatDateTime('hh:mm:ss:zzz', Time2);
end;

procedure TForm2.btnExecuteClick(Sender: TObject);
var
  Time1, Time2: TTime;
begin
  Time1 := Now;

  memoResp.Text := OtsFirebase.Request(edtUrlRequest.Text).Get().ToJSON;

  Time2 := Now - Time1;

  lbResp.Text := 'Resposta em: ' + FormatDateTime('hh:mm:ss:zzz', Time2);
end;

end.
