unit OtsFirebase.Auth;

{
  Projeto.: Classe de Autenticação com Connection ®
  Data....: 28/07/2018 14:53
  Autor...: Marivaldo Santos
  Empresa.: ONYX Tecnologia em Softwares ®
  Site....: www.onyxsistemas.com
  Licença.: Privada e protegida - © Todos os direitos reservados.
  email...: admin@onyxsistemas.com
}

interface

uses
  OtsFirebase.Request,
  OtsFirebase.Constantes,

  System.Classes,
  System.JSON,
  System.SysUtils,
  System.StrUtils,
  System.Generics.Collections,
  IPPeerClient,
  REST.Client,
  REST.JSON,
  REST.Types
  {$IFDEF MSWINDOWS}
    ,
  Vcl.ExtCtrls,
  Vcl.Forms
  {$ELSE}
    ,
  FMX.ExtCtrls,
  FMX.Forms
  {$ENDIF}
    ;

type
  TAuthUser = class
  private
    FDisplayName   : String;
    FEmail         : String;
    FExpiresIn     : String;
    FExpireDateTime: TDateTime;
    FIdToken       : String;
    FKind          : String;
    FLocalId       : String;
    FRefreshToken  : String;
    FRegistered    : Boolean;
    FAMessage      : String;

    class function FromJsonObj(JsonObj: TJSONObject): TAuthUser;
  public
    constructor Create();

    function ToJSONObject(): TJSONObject;

    function CreateUser(Sender: TAuthUser; Email, Password: string): TAuthUser;
    function LoginUser(Sender: TAuthUser; Email, Password: string): TAuthUser;
    function Logout(Sender: TAuthUser): TAuthUser;

    function Database(ABaseUrl: string = ''): TResource;
    function TokenExpired(ExpireIn: TDateTime): Boolean;

    property displayName: String read FDisplayName write FDisplayName;
    property Email: String read FEmail write FEmail;
    property expiresIn: String read FExpiresIn write FExpiresIn;
    property ExpireDateTime: TDateTime read FExpireDateTime write FExpireDateTime;
    property idToken: String read FIdToken write FIdToken;
    property kind: String read FKind write FKind;
    property localId: String read FLocalId write FLocalId;
    property refreshToken: String read FRefreshToken write FRefreshToken;
    property registered: Boolean read FRegistered write FRegistered;
    property AMessage: String read FAMessage write FAMessage;
  end;

var
  _API_KEY    : string;
  _PROJECT_ID : string;
  API_AUTH    : TAuthUser;
  FReqResource: TResource;

  // 60 segundos em um minuto, 60 minutos em uma hora, 24 horas em um dia
const
  SecondsInADay = 60 * 60 * 24;

implementation

{ TAuthUser }

constructor TAuthUser.Create();
begin
  inherited Create;

  ExpireDateTime := 0;
end;

function TAuthUser.TokenExpired(ExpireIn: TDateTime): Boolean;
var
  FDateTime, FDateTimeOLD: TDateTime;
begin
  FDateTime    := Now;
  FDateTimeOLD := ExpireIn - StrToDateTime('00:14:59');
  Result       := FDateTimeOLD < FDateTime;
end;

function Authentication(Email, Password: string; ACreateAccount: Boolean): TJSONObject;
var
  AResp, AMsg: string;
  RESTRequest: TRESTRequest;
  RESTClient : TRESTClient;
begin
  Result                         := nil;
  RESTClient                     := TRESTClient.Create(ifThen(ACreateAccount, GOOGLE_SIGNUP_URL, GOOGLE_PASSWORD_URL));
  RESTClient.RaiseExceptionOn500 := False;
  RESTRequest                    := TRESTRequest.Create(RESTClient);
  RESTRequest.Method             := rmPOST;

  RESTRequest.AddParameter('key', _API_KEY, TRESTRequestParameterKind.pkGETorPOST, [poDoNotEncode]);
  RESTRequest.AddParameter('email', Email, TRESTRequestParameterKind.pkGETorPOST);
  RESTRequest.AddParameter('password', Password, TRESTRequestParameterKind.pkGETorPOST);
  RESTRequest.AddParameter('returnSecureToken', 'true', TRESTRequestParameterKind.pkGETorPOST);
  RESTRequest.SynchronizedEvents := False;

  try
    RESTRequest.Execute;
  finally
    if Assigned(RESTRequest.Response.JSONValue) then
      Result := TJSONObject.ParseJSONValue(RESTRequest.Response.JSONValue.ToString) as TJSONObject;
  end;

  if Assigned(Result) and (Result is TJSONObject) then
  begin
    AResp := Result.ToString;

    if ACreateAccount then
    begin
      if UpperCase(AResp).Contains('EMAIL_EXISTS') then
        AMsg := 'Usuário de acesso já cadastrado.'
      else if UpperCase(AResp).Contains('API KEY NOT VALID') then
        AMsg := 'A API_KEY informada esta incorreta.'
      else if UpperCase(AResp).Contains('PERMISSION DENIED') then
        AMsg := 'Permissão negada.'
      else if UpperCase(AResp).Contains('OPERATION_NOT_ALLOWED') then
        AMsg := 'Operação não permitida.'
      else if UpperCase(AResp).Contains('ERROR') then
        AMsg := AResp;
    end
    else
    begin
      if UpperCase(AResp).Contains('EMAIL_NOT_FOUND') then
        AMsg := 'Usuário de acesso não encontrado.'
      else if UpperCase(AResp).Contains('INVALID_PASSWORD') then
        AMsg := 'A senha do usuário de acesso informado esta incorreta.'
      else if UpperCase(AResp).Contains('USER_DISABLED') then
        AMsg := 'Acesso negado pelo administrador. ' + ^M + '[Usuário desabilitado]'
      else if UpperCase(AResp).Contains('API KEY NOT VALID') then
        AMsg := 'A API_KEY informada esta incorreta.'
      else if UpperCase(AResp).Contains('PERMISSION DENIED') then
        AMsg := 'Permissão negada.'
      else if UpperCase(AResp).Contains('ERROR') then
        AMsg := AResp;
    end;

    Result.AddPair(TJSONPair.Create('AMessage', AMsg));
  end;
end;

function TAuthUser.CreateUser(Sender: TAuthUser; Email, Password: string): TAuthUser;
begin
  Result := Sender.FromJsonObj(Authentication(Email, Password, True));

  if not Trim(Result.idToken).IsEmpty then
    Result.ExpireDateTime := Now + (StrToInt(Result.expiresIn) / SecondsInADay);
end;

function TAuthUser.LoginUser(Sender: TAuthUser; Email, Password: string): TAuthUser;
begin
  if not Sender.registered or TokenExpired(Sender.ExpireDateTime) then
  begin
    Result := TAuthUser.FromJsonObj(Authentication(Email, Password, False));

    if not Trim(Result.idToken).IsEmpty then
      Result.ExpireDateTime := Now + (StrToInt(Result.expiresIn) / SecondsInADay);
  end
  else
    Result := Sender;
end;

function TAuthUser.Logout(Sender: TAuthUser): TAuthUser;
begin
  Sender.displayName    := '';
  Sender.Email          := '';
  Sender.expiresIn      := '';
  Sender.idToken        := '';
  Sender.kind           := '';
  Sender.localId        := '';
  Sender.refreshToken   := '';
  Sender.AMessage       := '';
  Sender.ExpireDateTime := 0;
  Sender.registered     := False;

  API_AUTH.displayName    := '';
  API_AUTH.Email          := '';
  API_AUTH.expiresIn      := '';
  API_AUTH.idToken        := '';
  API_AUTH.kind           := '';
  API_AUTH.localId        := '';
  API_AUTH.refreshToken   := '';
  API_AUTH.AMessage       := '';
  API_AUTH.ExpireDateTime := 0;
  API_AUTH.registered     := False;

  Result := Sender;
end;

function TAuthUser.ToJSONObject(): TJSONObject;
begin
  Result := TJson.ObjectToJsonObject(Self, [joDateIsUTC, joDateFormatISO8601, joIgnoreEmptyStrings, joIgnoreEmptyArrays]);
end;

class function TAuthUser.FromJsonObj(JsonObj: TJSONObject): TAuthUser;
begin
  Result := TJson.JsonToObject<TAuthUser>(JsonObj, [joDateIsUTC, joDateFormatISO8601, joIgnoreEmptyStrings, joIgnoreEmptyArrays]);
end;

function TAuthUser.Database(ABaseUrl: string = ''): TResource;
var
  AUrl, AToken: string;
begin
  Result := TResource.Create(); //FReqResource;

  AUrl := ABaseUrl;
  if Trim(AUrl).isEmpty and not Trim(_PROJECT_ID).isEmpty then
    AUrl := Format(FIREBASE_DATABASE_URL, [_PROJECT_ID]);

  AToken := ifThen(not Trim(API_AUTH.idToken).isEmpty, API_AUTH.idToken, '');

  if not Trim(AUrl).IsEmpty then
    Result.SetUrl(AUrl);

  if not Trim(AToken).IsEmpty then
    Result.Token(AToken, Simple);
end;

initialization
  FReqResource := TResource.Create();
finalization
  FReqResource.Free;

end.
