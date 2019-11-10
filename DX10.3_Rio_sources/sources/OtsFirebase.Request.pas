unit OtsFirebase.Request;

{
  Projeto.: OtsFirebase ® - Componente de Conexão e Consumo do Google Firebase
  Data....: 28/07/2018 14:53
  Autor...: Marivaldo Santos
  Empresa.: ONYX Tecnologia em Softwares ®
  Site....: www.onyxsistemas.com
  Licença.: Privada e protegida - © Todos os direitos reservados.
  email...: admin@onyxsistemas.com
  Fones...: 063 98421-4630 / 99215-6054
}

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARNINGS OFF}

interface

uses
  OtsFirebase.Constantes,

  Data.DB,
  Soap.EncdDecd,
  IPPeerClient,
  REST.Client,
  REST.Types,
  REST.JSON,
  REST.Response.Adapter,
  System.JSON,
  System.SysUtils,
  System.StrUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.NetConsts,
  System.NetEncoding,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Generics.Collections;

type
  TResource = class(TRESTRequest)
  private
    FRESTClient    : TRESTClient;
    FRESTResponse  : TRESTResponse;
    FContent       : TJSONObject;
    FResourceParams: TArrString;
    FLogin         : string;
    FPassword      : string;
    FToken         : string;
    FTokenParam    : string;
    FAutoIncremento: Boolean;
    FQueryParams   : TDictionary<string, string>;
    FResponseCode  : Integer;
    FSetPretty     : Boolean;

    function Execute(AMethod: TRESTRequestMethod): string; overload;
    function EncodeQueryParams(): string;
    function EncodeResourceParams(): string;
    function EncodeToken(): string;
    function GetResponseCode: Integer;
    function GetResponseHeader(const Header: string): string;
    function GetContent: TJSONObject;
  public
    constructor Create(URL: string = ''); overload;
    destructor Destroy; override;

    function Accept(AcceptType: String = ''): TResource;
    /// <summary>
    /// Utilizado apenas no consumo do Google Firebase com POST.
    /// </summary>
    function AutoIncremento(): TResource;
    function SetUrl(AURL: string): TResource;
    function ContentType(ContentType: String = ''): TResource;
    function Header(Name: string; Value: string; Kind: TRESTRequestParameterKind = pkHTTPHEADER; Options: TRESTRequestParameterOptions = [])
      : TResource;
    function Param(Name: string; Value: string; Kind: TRESTRequestParameterKind = pkGETorPOST; Options: TRESTRequestParameterOptions = [])
      : TResource;
    function URLSegment(Name, Value: string): TResource;
    function QueryParams(AParam, AValue: string): TResource;
    function Resource(AResource: TArrString): TResource; overload;
    function Resource(AResource: string): TResource; overload;
    function SetCredentials(const ALogin, APassword: String): TResource;
    function Token(AToken: String; AParamName: string = 'auth'): TResource;
    function TokenAuthBasic(ATokenBase64: string): TResource;

    { Filtros firebase }
    /// <summary>
    /// Utilizado apenas no consumo do Google Firebase com GET.
    /// </summary>
    function filterBy(Key: string): TResource;
    /// <summary>
    /// Utilizado apenas no consumo do Google Firebase com GET.
    /// </summary>
    function startAt(Value: string): TResource;
    /// <summary>
    /// Utilizado apenas no consumo do Google Firebase com GET.
    /// </summary>
    function equalTo(Value: string): TResource;
    /// <summary>
    /// Utilizado apenas no consumo do Google Firebase com GET.
    /// Formato: 3ms, 3s ou 3min
    /// Valor padrão: 3s
    /// Caso não seja especificado, o timeout máximo de 15min será aplicado.
    /// </summary>
    function timeOut(Value: string = '3s'): TResource;

    property ResponseCode: Integer read GetResponseCode;
    property ResponseHeader[const Header: string]: string read GetResponseHeader;

    function ContentRequest(Content: TJSONObject; AMethod: TRESTRequestMethod): string;
    function Get(): string; overload;
    function GetJSONObject(): TJSONObject; overload;
    function GetJSONObject(out AValue: string): TJSONObject; overload;

    function Post(Content: string): String; overload;
    function Post(Content: TJSONObject): String; overload;
    function Post(Content: TJSONObject; var ResultString: string): TJSONObject; overload;

    function Put(Content: string): string; overload;
    function Put(Content: TJSONObject): string; overload;
    function Put(Content: TJSONObject; var ResultString: string): TJSONObject; overload;

    function Patch(Content: string): string; overload;

    procedure Delete();

    procedure ToDataSet(ADataSet: TDataSet);
  end;

function checkDelim(const AValue, ADelim: String): String;
function ObtemValue(JSON, Value: string): string;
procedure JsonToDataset(ADataSet: TDataSet; AJSON: string);

implementation

{ TResource }

constructor TResource.Create(URL: string = '');
begin
  FRESTClient                     := TRESTClient.Create(URL);
  FRESTClient.RaiseExceptionOn500 := False;

  inherited Create(FRESTClient);

  FRESTResponse             := TRESTResponse.Create(Self);
  FRESTResponse.ContentType := MediaType_Json;
  Response                  := FRESTResponse;

  ContentType(MediaType_Json);
  FQueryParams    := TDictionary<string, string>.Create;
  FAutoIncremento := False;
  FSetPretty      := False;
end;

destructor TResource.Destroy;
begin
  FRESTClient.Free;
  FRESTResponse.Free;

  if Assigned(FQueryParams) then
    FQueryParams.Free;

  inherited;
end;

function checkDelim(const AValue, ADelim: String): String;
begin
  Result := Trim(AValue);
  if not Trim(Result).isEmpty then
    if RightStr(Result, 1) <> ADelim then { Tem delimitador no final ? }
      Result := Result + ADelim;
end;

function TResource.Execute(AMethod: TRESTRequestMethod): string;
var
  vURL, vParams, vEncodedCredentials: string;
begin
  Result := '';
  Method := AMethod;

  vURL    := FRESTClient.BaseURL;
  vParams := EncodeResourceParams() + EncodeToken() + EncodeQueryParams();
  if not Trim(vParams).isEmpty then
    vURL := checkDelim(FRESTClient.BaseURL, '/');

  if not Trim(FLogin).isEmpty and (Params.IndexOf(AUTHORIZATION_STR) = -1) then
  begin
    vEncodedCredentials := EncodeString(Format('%s:%s', [FLogin, FPassword]));
    AddAuthParameter(AUTHORIZATION_STR, 'Basic ' + vEncodedCredentials, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
  end;

  if AMethod <> rmGET then
  begin
    { Id increment person to Google Firebase }
    if (AMethod = rmPOST) and Trim(FRESTClient.BaseURL).Contains(_FIREBASE_DOMAIN_URL) then
      if not FAutoIncremento then
        Method := TRESTRequestMethod.rmPUT;

    if Assigned(FContent) and (GetContent.Count > 0) then
    begin
      AddBody(GetContent);
    end;
  end;

  FRESTClient.BaseURL := vURL + vParams;

  try
    try
      inherited Execute;
    except
      on E: Exception do
      begin
        raise Exception.Create(pChar('Erro retornado.' + ^M + E.Message));
      end;
    end;
  finally
    FResponseCode := Response.StatusCode;

    if Assigned(Response.JSONValue) then
      Result := Response.JSONValue.ToString;
  end;
end;

function TResource.GetContent: TJSONObject;
begin
  Result := FContent;
end;

function TResource.Accept(AcceptType: String = ''): TResource;
begin
  if Trim(AcceptType).isEmpty then
    AcceptType := MediaType_Json;

  FRESTClient.Accept := AcceptType;
  Result             := Self;
end;

function TResource.SetUrl(AURL: string): TResource;
begin
  FRESTClient.BaseURL := Trim(AURL);
  Result              := Self;
end;

function TResource.ContentType(ContentType: String = ''): TResource;
begin
  if Trim(ContentType).isEmpty then
    ContentType := MediaType_Json;

  FRESTClient.ContentType := ContentType;
  Result                  := Self;
end;

function TResource.SetCredentials(const ALogin, APassword: String): TResource;
begin
  FLogin    := ALogin;
  FPassword := APassword;
  Result    := Self;
end;

function TResource.Header(Name: string; Value: string; Kind: TRESTRequestParameterKind = pkHTTPHEADER;
  Options: TRESTRequestParameterOptions = []): TResource;
begin
  { 'Accept-Encoding', 'gzip' }
  Result := Self;

  if not Trim(Name).isEmpty and not Trim(Value).isEmpty then
    Result.AddParameter(Name, Value, Kind, Options);
end;

function TResource.Param(Name: string; Value: string; Kind: TRESTRequestParameterKind = pkGETorPOST;
  Options: TRESTRequestParameterOptions = []): TResource;
begin
  Result := Self;

  if not Trim(Name).isEmpty and not Trim(Value).isEmpty then
    Result.AddParameter(Name, Value, Kind, Options);
end;

function TResource.URLSegment(Name, Value: string): TResource;
begin
  Result := Self;

  if not Trim(Name).isEmpty and not Trim(Value).isEmpty then
    Param(Name, Value, TRESTRequestParameterKind.pkURLSEGMENT);
end;

function TResource.Resource(AResource: TArrString): TResource;
begin
  Result                 := Self;
  Result.FResourceParams := AResource;
end;

function TResource.Resource(AResource: string): TResource;
begin
  Result                            := Self;
  (Result as TRESTRequest).Resource := AResource;
end;

function TResource.Token(AToken: String; AParamName: string = 'auth'): TResource;
begin
  FTokenParam := AParamName;
  FToken      := AToken;
  Result      := Self;
end;

function TResource.TokenAuthBasic(ATokenBase64: string): TResource;
begin
  Result := Self;

  if not Trim(ATokenBase64).isEmpty then
  begin
    Header(AUTHORIZATION_STR, 'Basic ' + ATokenBase64, pkHTTPHEADER, [poDoNotEncode]);
  end;
end;

function TResource.AutoIncremento(): TResource;
begin
  FAutoIncremento := True;
  Result          := Self;
end;

function TResource.ContentRequest(Content: TJSONObject; AMethod: TRESTRequestMethod): string;
begin
  FContent := Content;
  Result   := Execute(AMethod);
end;

function TResource.Get(): string;
begin
  Result := Execute(TRESTRequestMethod.rmGET);
end;

function TResource.GetJSONObject(): TJSONObject;
var
  AValue: string;
begin
  Result := TJSONObject.Create;
  AValue := Execute(TRESTRequestMethod.rmGET);

  if not Trim(AValue).isEmpty and (AValue <> 'null') then
    Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(AValue), 0) as TJSONObject;
end;

function TResource.GetJSONObject(out AValue: string): TJSONObject;
begin
  Result := TJSONObject.Create;
  AValue := Execute(TRESTRequestMethod.rmGET);

  if not Trim(AValue).isEmpty and (AValue <> 'null') then
    Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(AValue), 0) as TJSONObject;
end;

function TResource.Post(Content: string): String;
var
  vJson: TJSONObject;
begin
  vJson := TJSONObject.ParseJSONValue(Content) as TJSONObject;
  try
    Result := ContentRequest(vJson, TRESTRequestMethod.rmPOST);
  finally
  end;
end;

function TResource.Post(Content: TJSONObject): String;
begin
  Result := ContentRequest(Content, TRESTRequestMethod.rmPOST);
end;

function TResource.Post(Content: TJSONObject; var ResultString: string): TJSONObject;
begin
  Result       := TJSONObject.Create;
  ResultString := ContentRequest(Content, TRESTRequestMethod.rmPOST);

  if not Trim(ResultString).isEmpty and (ResultString <> 'null') and (ResultString <> '{}') then
    Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(ResultString), 0) as TJSONObject;
end;

function TResource.Put(Content: string): string;
var
  vJson: TJSONObject;
begin
  vJson := TJSONObject.ParseJSONValue(Content) as TJSONObject;
  try
    Result := ContentRequest(vJson, TRESTRequestMethod.rmPUT);
  finally
  end;
end;

function TResource.Put(Content: TJSONObject): string;
begin
  Result := ContentRequest(Content, TRESTRequestMethod.rmPUT);
end;

function TResource.Put(Content: TJSONObject; var ResultString: string): TJSONObject;
begin
  Result       := TJSONObject.Create;
  ResultString := ContentRequest(Content, TRESTRequestMethod.rmPUT);

  if not Trim(ResultString).isEmpty and (ResultString <> 'null') and (ResultString <> '{}') then
    Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(ResultString), 0) as TJSONObject;
end;

function TResource.Patch(Content: string): string;
var
  vJson: TJSONObject;
begin
  vJson := TJSONObject.ParseJSONValue(Content) as TJSONObject;
  try
    Result := ContentRequest(vJson, TRESTRequestMethod.rmPATCH);
  finally
  end;
end;

procedure TResource.Delete();
begin
  Execute(TRESTRequestMethod.rmDELETE);
end;

function TResource.EncodeResourceParams(): string;
var
  i: Integer;
const
  _EXT_JSON = '.json';
begin
  Result   := '';
  for i    := Low(FResourceParams) to High(FResourceParams) do
    Result := checkDelim(Result, '/') + TNetEncoding.URL.Encode(FResourceParams[i]);

  if not Trim(Result).isEmpty and (RightStr(FRESTClient.BaseURL, 1) <> '/') then
    FRESTClient.BaseURL := FRESTClient.BaseURL + '/';

  if not Trim(Result).isEmpty and Trim(FRESTClient.BaseURL).Contains(_FIREBASE_DOMAIN_URL) then
    Result := IfThen(ExtractFileExt(Result) <> _EXT_JSON, Result + _EXT_JSON, Result);
end;

function TResource.EncodeToken(): string;
begin
  if Trim(FToken).isEmpty then
    Result := ''
  else
    Result := '?' + FTokenParam + '=' + TNetEncoding.URL.Encode(FToken);
end;

function TResource.EncodeQueryParams(): string;
var
  Param: TPair<string, string>;
begin
  if (not Assigned(FQueryParams)) or not(FQueryParams.Count > 0) then
    exit('');

  Result := IfThen(FToken.isEmpty, '?', '');

  if (FQueryParams.Count > 0) and Trim(FRESTClient.BaseURL).Contains(_FIREBASE_DOMAIN_URL) and FSetPretty then
    QueryParams('print', 'pretty');

  for Param in FQueryParams do
  begin
    if Result <> '?' then
      Result := Result + '&';

    if Trim(FRESTClient.BaseURL).Contains(_FIREBASE_DOMAIN_URL) then
    begin
      { orderBy must be a valid JSON encoded path
        orderBy deve ser um caminho codificado JSON válido }

      {$IF COMPILERVERSION <= 31}
      Result := Result + Param.Key + '=' + Param.Value;
      {$ENDIF}
      {$IF COMPILERVERSION > 31}
      Result := Result + TNetEncoding.URL.Encode(Param.Key) + '=' + TNetEncoding.URL.Encode(Param.Value);
      {$ENDIF}
    end
    else
      Result := Result + TNetEncoding.URL.Encode(Param.Key) + '=' + TNetEncoding.URL.Encode(Param.Value);
  end;
end;

function TResource.QueryParams(AParam, AValue: string): TResource;
begin
  Result := Self;

  // Ex.: QueryParams('orderBy', '"$key"');

  if Trim(AParam).isEmpty or Trim(AValue).isEmpty then
    exit;

  if not Assigned(FQueryParams) then
    FQueryParams := TDictionary<string, string>.Create;

  FQueryParams.Add(AParam, AValue);
end;

function TResource.GetResponseCode: Integer;
begin
  Result := FResponseCode;
end;

function TResource.GetResponseHeader(const Header: string): string;
begin
  Result := FRESTResponse.Headers.Values[Header];
end;

function ObtemValue(JSON, Value: string): string;
var
  LJSONObject: TJSONObject;

  function TrataObjeto(JObj: TJSONObject): string;
  var
    i, ASize: Integer;
    jPar    : TJSONPair;
  begin
    Result := '';
    ASize  := JObj.Count;

    for i := 0 to ASize - 1 do
    begin
      jPar := JObj.Pairs[i];

      if jPar.JSONValue is TJSONObject then
        Result := TrataObjeto((jPar.JSONValue as TJSONObject))
      else if SameText(Trim(jPar.JSONString.Value), Value) then
      begin
        Result := jPar.JSONValue.Value;
        break;
      end;

      if not Trim(Result).isEmpty then
        break;
    end;
  end;

begin
  LJSONObject := nil;
  try
    LJSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(JSON), 0) as TJSONObject;
    Result      := TrataObjeto(LJSONObject);
  finally
    LJSONObject.Free;
  end;
end;

procedure TResource.ToDataSet(ADataSet: TDataSet);
var
  vJson: string;
begin
  vJson := Self.Get();

  JsonToDataset(ADataSet, vJson);
end;

procedure JsonToDataset(ADataSet: TDataSet; AJSON: string);
var
  JVl  : TJSONValue;
  JObj : TJSONObject;
  vConv: TCustomJSONDataSetAdapter;
begin
  if (AJSON = EmptyStr) then
  begin
    exit;
  end;

  JVl := TJSONObject.ParseJSONValue(AJSON);

  if (JVl is TJSONArray) then
    JObj := (JVl as TJSONArray).Items[0] as TJSONObject
  else
    JObj := JVl as TJSONObject;

  vConv := TCustomJSONDataSetAdapter.Create(Nil);

  try
    vConv.Dataset := ADataSet;
    vConv.UpdateDataSet(JObj);
  finally
    vConv.Free;
    JObj.Free;
  end;
end;

function TResource.filterBy(Key: string): TResource;
begin
  Result := Self;

  if not Trim(Key).isEmpty then
  begin
    FSetPretty := True;
    QueryParams('orderBy', '"' + Key + '"');
  end;
end;

function TResource.startAt(Value: string): TResource;
begin
  Result := Self;

  if not Trim(Value).isEmpty then
  begin
    FSetPretty := True;
    QueryParams('startAt', '"' + Value + '"');
    QueryParams('endAt', '"' + Value + '\uf8ff"');
  end;

  { Referencia: https://firebase.google.com/docs/database/rest/retrieve-data?hl=pt-br#como-filtrar-por-valor }
end;

function TResource.equalTo(Value: string): TResource;
begin
  Result := Self;

  if not Trim(Value).isEmpty then
  begin
    FSetPretty := True;
    QueryParams('equalTo', '"' + Value + '"');
  end;
end;

function TResource.timeOut(Value: string = '3s'): TResource;
begin
  Result := Self;

  if not Trim(Value).isEmpty then
  begin
    FSetPretty := True;
    QueryParams('timeout', Value);
  end;
end;

end.
