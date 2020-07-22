program Venda2Firebase;

uses
  Vcl.Forms,
  uVenda in 'uVenda.pas' {frmVenda},
  DataSetConverter4D.Helper in 'JSON\DataSetConverter4D.Helper.pas',
  DataSetConverter4D.Impl in 'JSON\DataSetConverter4D.Impl.pas',
  DataSetConverter4D in 'JSON\DataSetConverter4D.pas',
  DataSetConverter4D.Util in 'JSON\DataSetConverter4D.Util.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmVenda, frmVenda);
  Application.Run;
end.
