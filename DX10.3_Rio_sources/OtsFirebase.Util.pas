unit OtsFirebase.Util;

{
  Projeto.: OtsFirebase ® - Componente de Conexão e Consumo do Google Firebase
  Data....: 28/07/2018 14:53
  Autor...: Marivaldo Santos
  Empresa.: ONYX Tecnologia em Softwares ®
  Site....: www.onyxsistemas.com
  Licença.: Privada e protegida - © Todos os direitos reservados.
  email...: admin@onyxsistemas.com
}

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARNINGS OFF}

interface

uses
  OtsFirebase.Auth,
  OtsFirebase.Request,
  OtsFirebase.Constantes,

  // DesignEditors,
  // DesignIntf,
  Data.DB,
  System.Classes,
  System.SysUtils,
  System.StrUtils,
  System.JSON,
  System.UITypes
  {$IFDEF MSWINDOWS}
    ,
  Winapi.Windows,
  Vcl.Forms
  {$ELSE}
    ,
  FMX.Forms,
  FMX.Dialogs
  {$ENDIF}
    ;

{
  1.0.2.3
    + Recurses added
    = Valid datetime token expire
    + Timeout property

  1.0.2.2
    + Bearer Token;
    + Body em Get's;

}

resourcestring
  _FBusiness = 'ONYX Sistemas';
  _FEmail = 'suporte@onyxsistemas.com';
  _FSite = 'https://www.onyxsistemas.com';

const
  sAPI_DEVELOPER = '© ONYX Sistemas ';
  sVERSION_BUILD = '1.0.2.3 ';
  sLAST_MODIFY   = '05/08/2021';

type
  {$IFDEF RTL230_UP}
  [ComponentPlatformsAttribute(pidWin32 or pidWin64 or pidAndroid)]
  {$ENDIF RTL230_UP}

  TOtsFirebase = class(TComponent)
  private
    FAPI_KEY       : string;
    FPROJECT_ID    : string;
    FOldPassword   : string;
    FOldApiKey     : string;
    FOldProjectId  : string;
    procedure SET_API_KEY(const Value: string);
    procedure SET_PROJECT_ID(const Value: string);
  protected
    function GetAbout(): string; virtual;
  public
    FAuth: TAuthUser;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function API(GOOGLE_API_KEY, GOOGLE_PROJECT_ID: string): TOtsFirebase; overload;
    function API(GOOGLE_PROJECT_ID: string): TAuthUser; overload;

    function Logout(): TOtsFirebase;

    function Auth(Email, Password: string; CreateAccount: Boolean = False): TAuthUser;
    function NoAuth(GOOGLE_API_KEY, GOOGLE_PROJECT_ID: string): TResource;

    function Request(ABaseUrl: string = ''; AToken: string = ''): TResource;

    property API_KEY: string read FAPI_KEY write SET_API_KEY;
    property PROJECT_ID: string read FPROJECT_ID write SET_PROJECT_ID;
  published
    property About: string read GetAbout stored False;
  end;

  THelperJSON = class helper for TJSONString
  public
    procedure ToDataset(ADataSet: TDataSet);
  end;

procedure AboutDialog(ClassName: string);
procedure Register;

implementation

{$J+}
{$R OtsFirebase.dcr}

procedure AboutDialog(ClassName: string);
var
  MsgText: String;
begin
  MsgText := 'O componente ' + ClassName + ' v' + sVERSION_BUILD + ' é Shareware!' + ^M +
    'Para utiliza-lo livremente você deve adquiri-lo junto ao fornecedor abaixo!' + ^M + ^M + 'ONYX Tecnologia em Softwares' + ^M +
    '[ Simplicidade e Segurança ]' + ^M + 'Site: ' + _FSite + ^M + 'e-mail: ' + _FEmail + ^M;

  {$IFDEF MSWINDOWS}
  Application.Messagebox(PChar(MsgText), PChar(_FBusiness), MB_OK + MB_IconInformation);
  {$ELSE}
  MessageDlg(MsgText, TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
  {$ENDIF}
end;

procedure Register;
begin
  RegisterComponents(_FBusiness, [TOtsFirebase]);
end;

{ TOtsFirebase }

constructor TOtsFirebase.Create(AOwner: TComponent);
const
  bShareware: string = 'Registered';
begin
  inherited Create(AOwner);

  FAuth    := TAuthUser.Create;
  API_AUTH := FAuth;

  // mensagem shareware
  if Trim(bShareware).isEmpty and not(csDesigning in ComponentState) then
  begin
    AboutDialog(ClassName);
    bShareware := '';
  end;
end;

destructor TOtsFirebase.Destroy;
begin
  inherited;
end;

function TOtsFirebase.API(GOOGLE_API_KEY, GOOGLE_PROJECT_ID: string): TOtsFirebase;
begin
  if Trim(GOOGLE_API_KEY).isEmpty then
    raise Exception.Create('API_KEY não informado.')
  else
    API_KEY := GOOGLE_API_KEY;

  if Trim(GOOGLE_PROJECT_ID).isEmpty then
    raise Exception.Create('PROJECT_ID não informado.')
  else
    PROJECT_ID := GOOGLE_PROJECT_ID;

  Result := Self;
end;

function TOtsFirebase.Logout(): TOtsFirebase;
begin
  FAuth.Logout(FAuth);
  Result := Self;
end;

function TOtsFirebase.NoAuth(GOOGLE_API_KEY, GOOGLE_PROJECT_ID: string): TResource;
begin
  Result := Logout().API(GOOGLE_API_KEY, GOOGLE_PROJECT_ID).FAuth.Database();
end;

function TOtsFirebase.API(GOOGLE_PROJECT_ID: string): TAuthUser;
begin
  if Trim(GOOGLE_PROJECT_ID).isEmpty then
    raise Exception.Create('PROJECT_ID não informado.')
  else
    PROJECT_ID := GOOGLE_PROJECT_ID;

  Result   := FAuth;
  API_AUTH := FAuth;
end;

function TOtsFirebase.Auth(Email, Password: string; CreateAccount: Boolean = False): TAuthUser;
begin
  if Trim(API_KEY).isEmpty then
    raise Exception.Create('API_KEY não informado.');

  if Trim(PROJECT_ID).isEmpty then
    raise Exception.Create('PROJECT_ID não informado.');

  if Trim(Email).isEmpty or Trim(Password).isEmpty then
    raise Exception.Create('Email ou senha de acesso não informado.');

  if not SameText(Email, API_AUTH.Email) or not SameText(Password, FOldPassword) or not SameText(API_KEY, FOldApiKey) or
    not SameText(PROJECT_ID, FOldProjectId) then
    FAuth.Logout(FAuth);

  FOldPassword  := Password;
  FOldApiKey    := API_KEY;
  FOldProjectId := PROJECT_ID;

  if CreateAccount then
    Result := FAuth.CreateUser(FAuth, Email, Password)
  else
    Result := FAuth.LoginUser(FAuth, Email, Password);

  FAuth    := Result;
  API_AUTH := FAuth;
end;

function TOtsFirebase.GetAbout(): string;
begin
  Result := sVERSION_BUILD + sAPI_DEVELOPER;
end;

procedure TOtsFirebase.SET_API_KEY(const Value: string);
begin
  FAPI_KEY := Value;

  _API_KEY := Value;
end;

procedure TOtsFirebase.SET_PROJECT_ID(const Value: string);
begin
  FPROJECT_ID := Value;

  _PROJECT_ID := Value;
end;

function TOtsFirebase.Request(ABaseUrl: string = ''; AToken: string = ''): TResource;
begin
//  Result := FAuth.Database(ABaseUrl).Token(AToken, Simple);

  Result := FReqResource;

  if not Trim(ABaseUrl).IsEmpty then
    Result.SetUrl(ABaseUrl);

  if not Trim(AToken).IsEmpty then
    Result.Token(AToken, Simple);
end;

{ THelperJSON }

procedure THelperJSON.ToDataset(ADataSet: TDataSet);
begin
  JsonToDataset(ADataSet, Self.ToString);
end;

end.
