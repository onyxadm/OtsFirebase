unit OtsFirebase.Integration;

{
  Projeto.: OtsFirebase ® - Componente de Conexão e Consumo do Google Firebase
  Data....: 09/12/2018 16:03
  Autor...: Marivaldo Santos
  Empresa.: ONYX Tecnologia em Softwares ®
  Site....: www.onyxsistemas.com
  Licença.: Privada e protegida - © Todos os direitos reservados.
  email...: admin@onyxsistemas.com
  Fones...: 063 98421-4630 / 99215-6054
  Objetivo: Facilitar o uso do OtsFirebase em Run-Time.
}

{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CODE OFF}
{$WARNINGS OFF}

interface

uses
  System.SysUtils,
  OtsFirebase.Util
  {$IFDEF MSWINDOWS}
    ,
  Vcl.Forms
  {$ELSE}
    ,
  FMX.Forms
  {$ENDIF}
    ;

type
  TFirebase = class(TOtsFirebase)
  strict private
    class var FInstance: TFirebase;
  public
    constructor Create();
    constructor CreatePrivate();
    class function GetInstance(): TFirebase;
    class procedure FreeInstance();
  end;

function Firebase(API_KEY: string; PROJECT_ID: string): TFirebase; overload;
function Firebase(): TFirebase; overload;

implementation

{ TFirebase }

constructor TFirebase.Create();
begin
  raise Exception.Create('Utilize o GetInstance');
end;

constructor TFirebase.CreatePrivate();
begin
  inherited Create(Application);
end;

class function TFirebase.GetInstance(): TFirebase;
begin
  if not(Assigned(FInstance)) then
  begin
    FInstance := TFirebase.CreatePrivate();
  end;

  Result := FInstance;
end;

class procedure TFirebase.FreeInstance();
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
  end;
end;

function Firebase(API_KEY: string; PROJECT_ID: string): TFirebase;
begin
  Result := TFirebase.GetInstance();
  Result.API(API_KEY, PROJECT_ID);
end;

function Firebase(): TFirebase;
begin
  Result := TFirebase.GetInstance();
end;

end.
