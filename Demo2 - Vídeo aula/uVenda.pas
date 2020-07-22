unit uVenda;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  cxGraphics,
  cxControls,
  cxLookAndFeels,
  cxLookAndFeelPainters,
  cxStyles,
  dxSkinsCore,
  dxSkinSevenClassic,
  dxSkinsDefaultPainters,
  dxSkinWhiteprint,
  cxCustomData,
  cxFilter,
  cxData,
  cxDataStorage,
  cxEdit,
  cxNavigator,
  dxDateRanges,
  Data.DB,
  cxDBData,
  cxDBLookupComboBox,
  cxGridCustomTableView,
  cxGridTableView,
  cxGridDBTableView,
  MemDS,
  DBAccess,
  Uni,
  UniProvider,
  InterBaseUniProvider,
  Vcl.StdCtrls,
  cxGridLevel,
  cxClasses,
  cxGridCustomView,
  cxGrid,
  Vcl.ExtCtrls, cxCurrencyEdit, System.JSON;

type
  TfrmVenda = class(TForm)
    pTopo: TPanel;
    gridVendaDBTableView1: TcxGridDBTableView;
    gridVendaLevel1: TcxGridLevel;
    gridVenda: TcxGrid;
    gridVenda_item: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    pControls: TPanel;
    gridVenda_Pgto: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    bGerar: TButton;
    bCancelar: TButton;
    Conexao: TUniConnection;
    Provider: TInterBaseUniProvider;
    Produtos: TUniQuery;
    Pessoas: TUniQuery;
    FormaPgto: TUniQuery;
    Venda: TUniQuery;
    Item: TUniQuery;
    Pgto: TUniQuery;
    dsProdutos: TDataSource;
    dsPessoas: TDataSource;
    dsFormaPgto: TDataSource;
    dsVenda: TDataSource;
    dsItem: TDataSource;
    dsPgto: TDataSource;
    gridVendaDBTableView1ID: TcxGridDBColumn;
    gridVendaDBTableView1DATA_CADASTRO: TcxGridDBColumn;
    gridVendaDBTableView1SUBTOTAL: TcxGridDBColumn;
    gridVendaDBTableView1DESCONTO: TcxGridDBColumn;
    gridVendaDBTableView1ACRESCIMO: TcxGridDBColumn;
    gridVendaDBTableView1TOTAL: TcxGridDBColumn;
    gridVendaDBTableView1ID_CLIENTE: TcxGridDBColumn;
    cxGridDBTableView1ID: TcxGridDBColumn;
    cxGridDBTableView1ID_VENDA: TcxGridDBColumn;
    cxGridDBTableView1ID_PRODUTO: TcxGridDBColumn;
    cxGridDBTableView1UN: TcxGridDBColumn;
    cxGridDBTableView1QUANTIDADE: TcxGridDBColumn;
    cxGridDBTableView1UNITARIO: TcxGridDBColumn;
    cxGridDBTableView1SUBTOTAL: TcxGridDBColumn;
    cxGridDBTableView1DESCONTO: TcxGridDBColumn;
    cxGridDBTableView1ACRESCIMO: TcxGridDBColumn;
    cxGridDBTableView1TOTAL: TcxGridDBColumn;
    cxGridDBTableView2ID: TcxGridDBColumn;
    cxGridDBTableView2ID_VENDA: TcxGridDBColumn;
    cxGridDBTableView2ID_FORMA_PGTO: TcxGridDBColumn;
    cxGridDBTableView2VALOR: TcxGridDBColumn;
    gridVendaDBTableView1TOTAL_PAGO: TcxGridDBColumn;
    gridVendaDBTableView1TROCO: TcxGridDBColumn;
    pGrid: TPanel;
    pMemo: TPanel;
    Splitter1: TSplitter;
    mVenda: TMemo;
    mJson: TMemo;
    Splitter2: TSplitter;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ConexaoAfterConnect(Sender: TObject);
    procedure cxGridDBTableView1ID_PRODUTOPropertiesValidate(Sender: TObject; var DisplayValue: Variant;
      var ErrorText: TCaption; var Error: Boolean);
    procedure VendaAfterPost(DataSet: TDataSet);
    procedure ItemAfterPost(DataSet: TDataSet);
    procedure PgtoAfterPost(DataSet: TDataSet);
    procedure bGerarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmVenda: TfrmVenda;

implementation

{$R *.dfm}

uses DataSetConverter4D.Helper;

procedure TfrmVenda.bGerarClick(Sender: TObject);
var
  JsonVenda: TJSONObject;
  JsonItems: TJSONArray;
  JsonPgtos: TJSONArray;
begin
  JsonVenda := venda.AsJSONObject;
  JsonItems := item.AsJSONArray;
  JsonPgtos := Pgto.AsJSONArray;

  JsonVenda.AddPair(TJSONPair.Create('itens', JsonItems));
  JsonVenda.AddPair(TJSONPair.Create('pgtos', JsonPgtos));

  mVenda.Text := JsonVenda.ToJSON;

(*
    {"venda": .... {"itens": [{}, {}]}, {"pagamentos": [{}, {}]}}
*)
end;

procedure TfrmVenda.ConexaoAfterConnect(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to ComponentCount -1 do
  begin
    if (Components[i] is TUniQuery) then
      (Components[i] as TUniQuery).Open;
  end;
end;

procedure TfrmVenda.cxGridDBTableView1ID_PRODUTOPropertiesValidate(Sender: TObject; var DisplayValue: Variant;
  var ErrorText: TCaption; var Error: Boolean);
begin
  if Produtos.Locate('NOME', VarToStr(DisplayValue), [loPartialKey]) then
  begin
    Item.FieldByName('ID_PRODUTO').AsInteger := Produtos.FieldByName('ID').AsInteger;
    Item.FieldByName('QUANTIDADE').AsFloat   := 1;
    Item.FieldByName('UNITARIO').AsFloat     := Produtos.FieldByName('VENDA').AsFloat;
    Item.FieldByName('DESCONTO').AsFloat     := 0;
    Item.FieldByName('ACRESCIMO').AsFloat    := 0;
  end;
end;

procedure TfrmVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Conexao.Disconnect;
end;

procedure TfrmVenda.FormShow(Sender: TObject);
begin
  Conexao.Connect;
end;

procedure TfrmVenda.ItemAfterPost(DataSet: TDataSet);
begin
  Item.Refresh;
  Venda.Refresh;
end;

procedure TfrmVenda.PgtoAfterPost(DataSet: TDataSet);
begin
  Pgto.Refresh;
  Venda.Refresh;
end;

procedure TfrmVenda.VendaAfterPost(DataSet: TDataSet);
begin
  Venda.Refresh;
end;

end.
