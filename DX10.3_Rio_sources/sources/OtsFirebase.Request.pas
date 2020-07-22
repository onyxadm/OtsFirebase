unit OtsFirebase.Request;

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
  OtsFirebase.Constantes,
//  jsonadapter,

  REST.Client,
  REST.Types,
  REST.HttpClient,
  Data.DB,
  Soap.EncdDecd,
  IPPeerClient,
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
  TTokenType = (Simple, Basic, Bearer);

  TResource = class(TRESTRequest)
  private
    FRESTClient    : TRESTClient;
    FRESTResponse  : TRESTResponse;
//    FContent       : TJSONObject;
    FResourceParams: TArrString;
    FLogin         : string;
    FPassword      : string;
    FToken         : string;
    FTokenParam    : string;
    FTokenType     : TTokenType;
    FAutoIncremento: Boolean;
    FQueryParams   : TDictionary<string, string>;
    FResponseCode  : Integer;
    FSetPretty     : Boolean;
    FResponseTime  : TTime;

    function Execute(AMethod: TRESTRequestMethod): string; overload;
    function EncodeQueryParams(): string;
    function EncodeResourceParams(): string;
    function EncodeToken(): string;
    function GetResponseJson: TJSONValue;
    function GetResponseCode: Integer;
    function GetResponseTime: TTime;
    function GetResponseHeader(const Header: string): string;
    function GetResponseError: string;
  public
    constructor Create(URL: string = ''); overload;
    destructor Destroy; override;

    function Accept(AcceptType: String = ''): TResource;
    function AcceptEncoding(AcceptEncodingType: String = ''): TResource;
    /// <summary>
    /// Utilizado apenas no consumo do Google Firebase com POST.
    /// </summary>
    function AutoIncremento(): TResource;
    function SetUrl(AURL: string): TResource;
    function ContentType(AContentType: String = ''; ToHeader: Boolean = False): TResource;
    function Header(Name: string; Value: string; Kind: TRESTRequestParameterKind = pkHTTPHEADER;
      Options: TRESTRequestParameterOptions = []): TResource;
    function Param(Name: string; Value: string; Kind: TRESTRequestParameterKind = pkGETorPOST;
      Options: TRESTRequestParameterOptions = []; ContentType: TRESTContentType = TRESTContentType.ctNone): TResource;
    function URLSegment(Name, Value: string): TResource;
    function QueryParams(AParam, AValue: string): TResource;
    function Resource(AResource: TArrString): TResource; overload;
    function Resource(AResource: string): TResource; overload;
    function SetCredentials(const ALogin, APassword: String): TResource;
    /// <summary>
    /// Definindo o tipo de Token [AType]:
    /// Simple: do tipo que é usado na url;
    /// Basic ou Bearer: do tipo que é usado no Header codificado para Base64;
    /// AParamName: Valor padrão: 'auth' e é usado apenas no modo Simple
    /// </summary>
    function Token(AToken: string; AType: TTokenType; AParamName: string = 'auth'): TResource;
    function BodyClear(): TResource;
    function Body(Content: TJSONObject): TResource; overload;
    function Body(Content: TStream; AContentType: TRESTContentType = TRESTContentType.ctNone): TResource; overload;
    function Body(Content: string; AContentType: TRESTContentType = TRESTContentType.ctNone): TResource; overload;
    function Body(const Name: string; const StreamContent: TStream; const Kind: TRESTRequestParameterKind = pkREQUESTBODY;
       const Options: TRESTRequestParameterOptions = [poDoNotEncode]; ContentType: TRESTContentType = TRESTContentType.ctNone): TResource; overload;
    function Body(const Name: string; const StringContent: string; const Kind: TRESTRequestParameterKind = pkREQUESTBODY;
       const Options: TRESTRequestParameterOptions = [poDoNotEncode]; ContentType: TRESTContentType = TRESTContentType.ctNone): TResource; overload;

    {$IF COMPILERVERSION > 31}
    function AddFile(const AName: string; const FileName: TFileName; const AKind: TRESTRequestParameterKind = pkFILE;
        const AOptions: TRESTRequestParameterOptions = [poDoNotEncode]; AContentType: TRESTContentType = ctMULTIPART_FORM_DATA): TResource;
    {$ENDIF}

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

    property ResponseJson: TJSONValue read GetResponseJson;
    property ResponseCode: Integer read GetResponseCode;
    property ResponseTimeOut: TTime read GetResponseTime;
    property ResponseHeader[const Header: string]: string read GetResponseHeader;
    property ResponseError: string read GetResponseError;

    function ContentRequest(Content: TJSONObject; AMethod: TRESTRequestMethod): string;

    function Get(Content: TJSONObject = nil): string; overload;
    function GetJSONObject(Content: TJSONObject = nil): TJSONObject; overload;
    function GetJSONObject(out AValue: string): TJSONObject; overload;
    function GetJSONArray(): TJSONArray;

    function Post(): string; overload;
    function Post(NotUse: Integer): TJSONObject; overload;
    function Post(Content: string): string; overload;
    function Post(Content: TJSONObject): string; overload;
    function Post(Content: string; var ResultString: string): TJSONObject; overload;
    function Post(Content: TJSONObject; var ResultString: string): TJSONObject; overload;

    function Put(Content: string): string; overload;
    function Put(Content: TJSONObject): string; overload;
    function Put(Content: TJSONObject; var ResultString: string): TJSONObject; overload;

    function Patch(): string; overload;
    function Patch(NotUse: Integer): TJSONObject; overload;
    function Patch(Content: string): string; overload;
    function Patch(Content: TJSONObject): string; overload;
    function Patch(Content: string; var ResultString: string): TJSONObject; overload;
    function Patch(Content: TJSONObject; var ResultString: string): TJSONObject; overload;

    procedure Delete();

    procedure ToDataSet(ADataSet: TDataSet; APath: string = '');
  end;

  TRESTResponseHelper = class helper for TRESTResponse
  public
    function ContentAsJsonObject: TJSONObject;
    function ContentAsJsonArray: TJSONArray;
  end;

function StrToJSONObjUTF8(AValue: string): TJSONObject;
function StrToJSONArrayUTF8(AValue: string): TJSONArray;

function checkDelim(const AValue, ADelim: String): String;
function StrToStream(StrData: string): TMemoryStream;
function FileToStream(AFileName: TFileName): TMemoryStream;
procedure JsonToDataset(ADataSet: TDataSet; AJSON: string; APath: string = '');

implementation

{ TResource }

constructor TResource.Create(URL: string = '');
begin
  FRESTClient                     := TRESTClient.Create(URL);
  FRESTClient.RaiseExceptionOn500 := False;

  inherited Create(FRESTClient);

  FRESTClient.AcceptEncoding := 'gzip, deflate, br';
  FRESTResponse              := TRESTResponse.Create(Self);
  FRESTResponse.ContentType  := 'application/json; charset=UTF-8';
  Response                   := FRESTResponse;

  ContentType(MediaType_Json);
  FQueryParams    := TDictionary<string, string>.Create;
  FAutoIncremento := False;
  FSetPretty      := False;
end;

destructor TResource.Destroy;
begin
  FRESTResponse.Free;

  if Assigned(FQueryParams) then
    FQueryParams.Free;

  inherited;
end;

function StrToJSONObjUTF8(AValue: string): TJSONObject;
begin
  Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AValue), 0) as TJSONObject;
end;

function StrToJSONArrayUTF8(AValue: string): TJSONArray;
begin
  Result := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(AValue), 0) as TJSONArray;
end;

function checkDelim(const AValue, ADelim: String): String;
begin
  Result := Trim(AValue);
  if not Trim(Result).isEmpty then
  if RightStr(Result, 1) <> ADelim then
    Result := Result + ADelim;
end;

function StrToStream(StrData: string): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  Result.WriteBuffer(Pointer(StrData)^, Length(StrData));
  Result.Position := 0;
end;

function FileToStream(AFileName: TFileName): TMemoryStream;
begin
  Result := TMemoryStream.Create;
  Result.LoadFromFile(AFileName);
  Result.Position := 0;
end;

function TResource.Execute(AMethod: TRESTRequestMethod): string;
var
  vURL, vParams, vEncodedCredentials: string;
  vTime: TTime;
begin
  Result := '';
  Method := AMethod;

  vTime   := Now;
  vURL    := FRESTClient.BaseURL;
  vParams := EncodeResourceParams() + EncodeToken() + EncodeQueryParams();
  if not Trim(vParams).isEmpty then
    vURL := checkDelim(FRESTClient.BaseURL, '/');

  if not Trim(FLogin).isEmpty and (Params.IndexOf(AUTHORIZATION_STR) = -1) and (FTokenType = Simple) then
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
  end;

  FRESTClient.BaseURL := vURL + vParams;

  try
    try
      inherited Execute;
    except
      // any kind of server/protocol error
      on E: EHTTPProtocolException do
      begin
        Result := Response.Content;
      end;
      // Unknown error, might even be on the client side. raise it!
      on E: Exception do
      begin
        Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes('Erro retornado.' + E.Message), 0).ToJSON;
      end;
    end;
  finally
    FResponseTime := (Now - vTime);
    FResponseCode := Response.StatusCode;

    if Assigned(Response.JSONValue) then
      Result := Response.JSONValue.ToString
    else
    if (FResponseCode > 300) and not Trim(Response.ErrorMessage).isEmpty then
      Result := Response.ErrorMessage;
  end;
end;

function TResource.Accept(AcceptType: String = ''): TResource;
begin
  if Trim(AcceptType).isEmpty then
    AcceptType := MediaType_Json;

  FRESTClient.Accept := AcceptType;
  Result             := Self;
end;

function TResource.AcceptEncoding(AcceptEncodingType: String = ''): TResource;
begin
  if Trim(AcceptEncodingType).isEmpty then
    AcceptEncodingType := MediaType_Json;

  FRESTClient.AcceptEncoding := AcceptEncodingType;
  Result                     := Self;
end;

function TResource.SetUrl(AURL: string): TResource;
begin
  FRESTClient.BaseURL := Trim(AURL);
  Result              := Self;
end;

function TResource.ContentType(AContentType: String = ''; ToHeader: Boolean = False): TResource;
begin
  if Trim(AContentType).isEmpty then
    AContentType := MediaType_Json;

  FRESTClient.ContentType := AContentType;
  Result                  := Self;

  if ToHeader and not Trim(AContentType).isEmpty then
    Result.Header(sContentType, AContentType);
end;

function TResource.SetCredentials(const ALogin, APassword: String): TResource;
begin
  FLogin     := ALogin;
  FPassword  := APassword;
  FTokenType := TTokenType.Simple;
  Result     := Self;
end;

function TResource.Header(Name: string; Value: string; Kind: TRESTRequestParameterKind = pkHTTPHEADER;
  Options: TRESTRequestParameterOptions = []): TResource;
begin
  { 'Accept-Encoding', 'gzip' }
  Result := Self;

  if not Trim(Name).isEmpty then
    Result.Params.AddItem(Name, Value, Kind, Options);
end;

function TResource.Param(Name: string; Value: string; Kind: TRESTRequestParameterKind = pkGETorPOST;
  Options: TRESTRequestParameterOptions = []; ContentType: TRESTContentType = TRESTContentType.ctNone): TResource;
begin
  Result := Self;

  if not Trim(Name).isEmpty and not Trim(Value).isEmpty then
    Result.Params.AddItem(Name, Value, Kind, Options, ContentType);
end;

function TResource.URLSegment(Name, Value: string): TResource;
begin
  Result := Self;

  if not Trim(Name).isEmpty and not Trim(Value).isEmpty then
    Result.Params.AddUrlSegment(Name, Value);
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

function TResource.Token(AToken: string; AType: TTokenType; AParamName: string = 'auth'): TResource;
begin
  Result := Self;

  if not Trim(AToken).isEmpty then
  case AType of
    Simple:
      begin
        FTokenParam := AParamName;
        FToken      := AToken;
      end;
  else
    begin
      case AType of
        Basic:
          if not AToken.Contains('Basic') then
            AParamName := 'Basic ';

        Bearer:
          if not AToken.Contains('Bearer') then
            AParamName := 'Bearer ';
      end;

      Result.AddParameter(AUTHORIZATION_STR, AParamName + AToken, pkHTTPHEADER, [poDoNotEncode]);
      FTokenType := AType;
    end;
  end;
end;

function TResource.BodyClear(): TResource;
begin
  Result := Self;
  Result.ClearBody;
end;

function TResource.Body(Content: TJSONObject): TResource;
begin
  Result := Self;

  if Assigned(Content) and (Content.Count > 0) then
    Result.AddBody(Content);
end;

function TResource.Body(Content: TStream; AContentType: TRESTContentType = TRESTContentType.ctNone): TResource;
begin
  Result := Self;

  if Assigned(Content) then
  begin
    Content.Position := 0;
    Result.AddBody(Content, AContentType);
  end;
end;

function TResource.Body(Content: string; AContentType: TRESTContentType = TRESTContentType.ctNone): TResource;
begin
  Result := Self;

  if not Trim(Content).isEmpty then
  begin
    Result.AddBody(Content, AContentType);
  end;
end;

function TResource.Body(const Name: string; const StreamContent: TStream; const Kind: TRESTRequestParameterKind = pkREQUESTBODY;
    const Options: TRESTRequestParameterOptions = [poDoNotEncode]; ContentType: TRESTContentType = TRESTContentType.ctNone): TResource;
begin
  Result := Self;

  if Assigned(StreamContent) then
  begin
    StreamContent.Position := 0;
    Result.Params.AddItem(Name, StreamContent, Kind, Options, ContentType);
  end;
end;

function TResource.Body(const Name: string; const StringContent: string; const Kind: TRESTRequestParameterKind = pkREQUESTBODY;
    const Options: TRESTRequestParameterOptions = [poDoNotEncode]; ContentType: TRESTContentType = TRESTContentType.ctNone): TResource;
begin
  Result := Self;

  if not Trim(StringContent).isEmpty then
  begin
    Result.Params.AddItem(Name, StringContent, Kind, Options, ContentType);
  end;
end;

{$IF COMPILERVERSION > 31}
function TResource.AddFile(const AName: string; const FileName: TFileName; const AKind: TRESTRequestParameterKind = pkFILE;
    const AOptions: TRESTRequestParameterOptions = [poDoNotEncode]; AContentType: TRESTContentType = ctMULTIPART_FORM_DATA): TResource;
begin
  Result := Self;

  if not Trim(FileName).isEmpty and FileExists(FileName) then
  begin
    Result
      .Accept('*/*')
      .ContentType(ContentTypeToString(AContentType), True);

    (Result as TRESTRequest).Accept         := FRESTClient.Accept;
    (Result as TRESTRequest).AcceptEncoding := FRESTClient.AcceptEncoding;

    with Result.Params.AddItem do
    begin
      Kind        := AKind;
      Name        := AName;
      Value       := FileName;
      Options     := AOptions;
      ContentType := AContentType;
    end;
  end;
end;
{$ENDIF}

function TResource.AutoIncremento(): TResource;
begin
  FAutoIncremento := True;
  Result          := Self;
end;

function TResource.ContentRequest(Content: TJSONObject; AMethod: TRESTRequestMethod): string;
begin
  if Assigned(Content) and (Content.Count > 0) then
  begin
    AddBody(Content);
  end;

  Result := Execute(AMethod);
end;

function TResource.Get(Content: TJSONObject = nil): string;
begin
  if Assigned(Content) and (Content.Count > 0) then
  begin
    AddBody(Content);
  end;

  Result := Execute(TRESTRequestMethod.rmGET);
end;

function TResource.GetJSONObject(Content: TJSONObject = nil): TJSONObject;
var
  AValue: string;
begin
  if Assigned(Content) and (Content.Count > 0) then
  begin
    AddBody(Content);
  end;

  Result := TJSONObject.Create;
  AValue := Execute(TRESTRequestMethod.rmGET);

  if not Trim(AValue).isEmpty and not MatchStr(AValue, ['', 'null', '{}', '[]']) then
    Result := StrToJSONObjUTF8(AValue);
end;

function TResource.GetJSONObject(out AValue: string): TJSONObject;
begin
  Result := TJSONObject.Create;
  AValue := Execute(TRESTRequestMethod.rmGET);

  if not Trim(AValue).isEmpty and not MatchStr(AValue, ['', 'null', '{}', '[]']) then
    Result := StrToJSONObjUTF8(AValue);
end;

function TResource.GetJSONArray(): TJSONArray;
var
  ResultString: string;
begin
  Result       := TJSONArray.Create;
  ResultString := Execute(TRESTRequestMethod.rmGET);

  if not Trim(ResultString).isEmpty and not MatchStr(ResultString, ['', 'null', '{}', '[]']) then
    Result := StrToJSONArrayUTF8(ResultString);
end;

function TResource.Post(): string;
begin
  Result := Execute(TRESTRequestMethod.rmPOST);
end;

function TResource.Post(NotUse: Integer): TJSONObject;
var
  ResultString: string;
begin
  Result       := TJSONObject.Create;
  ResultString := ContentRequest(nil, TRESTRequestMethod.rmPOST);

  if not Trim(ResultString).isEmpty and not MatchStr(ResultString, ['', 'null', '{}', '[]']) then
    Result := StrToJSONObjUTF8(ResultString);
end;

function TResource.Post(Content: string): string;
var
  vJson: TJSONObject;
begin
  vJson := StrToJSONObjUTF8(Content);
  try
    Result := ContentRequest(vJson, TRESTRequestMethod.rmPOST);
  finally
  end;
end;

function TResource.Post(Content: TJSONObject): string;
begin
  Result := ContentRequest(Content, TRESTRequestMethod.rmPOST);
end;

function TResource.Post(Content: string; var ResultString: string): TJSONObject;
begin
  Result       := TJSONObject.Create;
  ResultString := Post(Content);

  if not Trim(ResultString).isEmpty and not MatchStr(ResultString, ['', 'null', '{}', '[]']) then
    Result := StrToJSONObjUTF8(ResultString);
end;

function TResource.Post(Content: TJSONObject; var ResultString: string): TJSONObject;
begin
  Result       := TJSONObject.Create;
  ResultString := Post(Content);

  if not Trim(ResultString).isEmpty and not MatchStr(ResultString, ['', 'null', '{}', '[]']) then
    Result := StrToJSONObjUTF8(ResultString);
end;

function TResource.Put(Content: string): string;
var
  vJson: TJSONObject;
begin
  vJson := StrToJSONObjUTF8(Content);
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

  if not Trim(ResultString).isEmpty and not MatchStr(ResultString, ['', 'null', '{}', '[]']) then
    Result := StrToJSONObjUTF8(ResultString);
end;

function TResource.Patch(): string;
begin
  Result := Execute(TRESTRequestMethod.rmPATCH);
end;

function TResource.Patch(NotUse: Integer): TJSONObject;
var
  ResultString: string;
begin
  Result       := TJSONObject.Create;
  ResultString := ContentRequest(nil, TRESTRequestMethod.rmPATCH);

  if not Trim(ResultString).isEmpty and not MatchStr(ResultString, ['', 'null', '{}', '[]']) then
    Result := StrToJSONObjUTF8(ResultString);
end;

function TResource.Patch(Content: string): string;
var
  vJson: TJSONObject;
begin
  vJson := StrToJSONObjUTF8(Content);
  try
    Result := ContentRequest(vJson, TRESTRequestMethod.rmPATCH);
  finally
  end;
end;

function TResource.Patch(Content: TJSONObject): string;
begin
  Result := ContentRequest(Content, TRESTRequestMethod.rmPATCH);
end;

function TResource.Patch(Content: string; var ResultString: string): TJSONObject;
begin
  Result       := TJSONObject.Create;
  ResultString := Patch(Content);

  if not Trim(ResultString).isEmpty and not MatchStr(ResultString, ['', 'null', '{}', '[]']) then
    Result := StrToJSONObjUTF8(ResultString);
end;

function TResource.Patch(Content: TJSONObject; var ResultString: string): TJSONObject;
begin
  Result       := TJSONObject.Create;
  ResultString := Patch(Content);

  if not Trim(ResultString).isEmpty and not MatchStr(ResultString, ['', 'null', '{}', '[]']) then
    Result := StrToJSONObjUTF8(ResultString);
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

function TResource.GetResponseJson: TJSONValue;
begin
  Result := FRESTResponse.JSONValue;
end;

function TResource.GetResponseCode: Integer;
begin
  Result := FResponseCode;
end;

function TResource.GetResponseTime: TTime;
begin
  Result := FResponseTime;
end;

function TResource.GetResponseHeader(const Header: string): string;
begin
  Result := FRESTResponse.Headers.Values[Header];
end;

function TResource.GetResponseError: string;
begin
  Result := FRESTResponse.ErrorMessage;
end;

procedure TResource.ToDataSet(ADataSet: TDataSet; APath: string = '');
var
  vJson: string;
begin
  vJson := Self.Get();

  JsonToDataset(ADataSet, vJson, APath);
end;

procedure JsonToDataset(ADataSet: TDataSet; AJSON: string; APath: string = '');
var
  JVl  : TJSONValue;
  JObj : TJSONObject;
  vConv: TCustomJSONDataSetAdapter;
//  lConv: TJSONDatasetAdapter;
begin
  if (AJSON = EmptyStr) then
  begin
    exit;
  end;

//  lConv := TJSONDatasetAdapter.Create(nil);
//  try
//    lConv.ConvertToDataSet(ADataSet, AJSON, APath);
//  finally
//    lConv.Free;
//  end;
//  exit;

  JVl := TJSONObject.ParseJSONValue(AJSON);

  if (JVl is TJSONArray) then
    JObj := (JVl as TJSONArray).FindValue(APath) as TJSONObject
  else
    JObj := JVl as TJSONObject;

  if not Trim(APath).IsEmpty and Assigned(JObj.FindValue(APath)) then
  begin
    AJSON := JObj.FindValue(APath).ToJSON;
    JVl   := TJSONObject.ParseJSONValue(AJSON);

    if (JVl is TJSONArray) then
      JObj := (JVl as TJSONArray).FindValue(APath) as TJSONObject
    else
      JObj := JVl as TJSONObject;

    AJSON := JObj.ToJSON;
  end;

  vConv := TCustomJSONDataSetAdapter.Create(nil);

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
  if Trim(FRESTClient.BaseURL).Contains(_FIREBASE_DOMAIN_URL) then
  begin
    FSetPretty := True;
    QueryParams('timeout', Value);
  end else
  if StrToIntDef(Value, 0) > 0 then
    (Result as TRESTRequest).Timeout := StrToIntDef(Value, 30000);
end;

{ TRESTResponseHelper }

function TRESTResponseHelper.ContentAsJsonObject: TJSONObject;
begin
  Result := TJSONObject.Create;

  if not Trim(Content).isEmpty and not MatchStr(Content, ['', 'null', '{}', '[]']) then
    Result := StrToJSONObjUTF8(Content);
end;

function TRESTResponseHelper.ContentAsJsonArray: TJSONArray;
begin
  Result := TJSONArray.Create;

  if not Trim(Content).isEmpty and not MatchStr(Content, ['', 'null', '{}', '[]']) then
    Result := StrToJSONArrayUTF8(Content);
end;

end.
