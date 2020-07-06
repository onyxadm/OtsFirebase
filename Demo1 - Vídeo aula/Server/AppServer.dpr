program AppServer;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  Horse,
  Horse.BasicAuthentication,
  Horse.Jhonson,
  Horse.HandleException;

var
  App: THorse;

begin
  App := THorse.Create(9000);

  App.Use(Jhonson);
  App.Use(HandleException);

  App.Use(HorseBasicAuthentication(
        function(const AUsername, APassword: string): Boolean
    begin
      Result := AUsername.Equals('OtsFirebase') and APassword.Equals('123456');
    end));

  App.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    begin
      Res.Send('{"result": "Dados retornados com sucesso!"}');
    end);

  App.Post('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      json: TJSONObject;
    begin
      json := Req.Body<TJSONObject>;

      Write('.');
      Write('.');
      Write(json.ToJSON);

      Res.Send('{"result": "Dados recebido com sucesso!", "dados": '+ json.ToJSON +'}');
    end);

  App.Start;

end.
