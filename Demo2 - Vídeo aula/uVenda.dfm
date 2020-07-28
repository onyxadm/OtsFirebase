object frmVenda: TfrmVenda
  Left = 0
  Top = 0
  Caption = 'Venda'
  ClientHeight = 691
  ClientWidth = 1542
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 865
    Top = 41
    Width = 5
    Height = 609
    ExplicitLeft = 1
    ExplicitTop = 1
    ExplicitHeight = 607
  end
  object pTopo: TPanel
    Left = 0
    Top = 0
    Width = 1542
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'VENDA DE PRODUTOS'
    Color = 12673280
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object DBText1: TDBText
      AlignWithMargins = True
      Left = 1224
      Top = 10
      Width = 315
      Height = 28
      Margins.Top = 10
      Align = alRight
      DataField = 'WEB_ID'
      DataSource = dsVenda
    end
  end
  object pControls: TPanel
    Left = 0
    Top = 650
    Width = 1542
    Height = 41
    Align = alBottom
    TabOrder = 1
    object bGerar: TButton
      Left = 395
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Gerar JSON'
      TabOrder = 0
      OnClick = bGerarClick
    end
    object bGerarTodas: TButton
      Left = 476
      Top = 8
      Width = 125
      Height = 25
      Caption = 'Gerar JSON Todas'
      TabOrder = 1
    end
  end
  object pGrid: TPanel
    Left = 0
    Top = 41
    Width = 865
    Height = 609
    Align = alLeft
    TabOrder = 2
    object gridVenda: TcxGrid
      AlignWithMargins = True
      Left = 4
      Top = 11
      Width = 857
      Height = 168
      Margins.Top = 10
      Margins.Bottom = 10
      Align = alTop
      TabOrder = 0
      object gridVendaDBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = False
        Navigator.Buttons.PriorPage.Visible = False
        Navigator.Buttons.Prior.Visible = False
        Navigator.Buttons.Next.Visible = False
        Navigator.Buttons.NextPage.Visible = False
        Navigator.Buttons.Last.Visible = False
        Navigator.Buttons.Insert.Visible = False
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = False
        Navigator.Buttons.Edit.Visible = False
        Navigator.Buttons.Post.Visible = False
        Navigator.Buttons.Cancel.Visible = False
        Navigator.Buttons.Refresh.Visible = False
        Navigator.Buttons.SaveBookmark.Visible = False
        Navigator.Buttons.GotoBookmark.Visible = False
        Navigator.Buttons.Filter.Visible = False
        DataController.DataSource = dsVenda
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'SUBTOTAL'
            Column = gridVendaDBTableView1SUBTOTAL
          end
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'DESCONTO'
            Column = gridVendaDBTableView1DESCONTO
          end
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'ACRESCIMO'
            Column = gridVendaDBTableView1ACRESCIMO
          end
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'TOTAL'
            Column = gridVendaDBTableView1TOTAL
          end
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'TOTAL_PAGO'
            Column = gridVendaDBTableView1TOTAL_PAGO
          end
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'TROCO'
            Column = gridVendaDBTableView1TROCO
          end
          item
            Format = 'Total de vendas: ,0'
            Kind = skCount
            FieldName = 'ID'
            Column = gridVendaDBTableView1ID_CLIENTE
            DisplayText = 'Total de vendas: ,0'
          end>
        DataController.Summary.SummaryGroups = <>
        NewItemRow.InfoText = 'Clique aqui para incluir uma nova venda...'
        NewItemRow.Visible = True
        OptionsBehavior.FocusCellOnTab = True
        OptionsBehavior.FocusFirstCellOnNewRecord = True
        OptionsBehavior.GoToNextCellOnEnter = True
        OptionsCustomize.ColumnMoving = False
        OptionsView.NoDataToDisplayInfoText = '<Nenhum registro foi lan'#231'ado ainda, pressione F2 para incluir>'
        OptionsView.ScrollBars = ssVertical
        OptionsView.ColumnAutoWidth = True
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        object gridVendaDBTableView1ID: TcxGridDBColumn
          DataBinding.FieldName = 'ID'
          Options.Editing = False
          Options.Focusing = False
          Width = 38
        end
        object gridVendaDBTableView1DATA_CADASTRO: TcxGridDBColumn
          Caption = 'DATA'
          DataBinding.FieldName = 'DATA_CADASTRO'
          Options.Editing = False
          Options.Focusing = False
          Width = 71
        end
        object gridVendaDBTableView1ID_CLIENTE: TcxGridDBColumn
          Caption = 'CLIENTE'
          DataBinding.FieldName = 'ID_CLIENTE'
          PropertiesClassName = 'TcxLookupComboBoxProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'NOME'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = dsPessoas
          Width = 303
        end
        object gridVendaDBTableView1SUBTOTAL: TcxGridDBColumn
          DataBinding.FieldName = 'SUBTOTAL'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Options.Editing = False
          Options.Focusing = False
          Width = 71
        end
        object gridVendaDBTableView1DESCONTO: TcxGridDBColumn
          DataBinding.FieldName = 'DESCONTO'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Options.Editing = False
          Options.Focusing = False
          Width = 72
        end
        object gridVendaDBTableView1ACRESCIMO: TcxGridDBColumn
          DataBinding.FieldName = 'ACRESCIMO'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Options.Editing = False
          Options.Focusing = False
          Width = 72
        end
        object gridVendaDBTableView1TOTAL: TcxGridDBColumn
          DataBinding.FieldName = 'TOTAL'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Options.Editing = False
          Options.Focusing = False
          Width = 72
        end
        object gridVendaDBTableView1TOTAL_PAGO: TcxGridDBColumn
          Caption = 'TOTAL PAGO'
          DataBinding.FieldName = 'TOTAL_PAGO'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Options.Editing = False
          Options.Focusing = False
        end
        object gridVendaDBTableView1TROCO: TcxGridDBColumn
          DataBinding.FieldName = 'TROCO'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Options.Editing = False
          Options.Focusing = False
        end
      end
      object gridVendaLevel1: TcxGridLevel
        GridView = gridVendaDBTableView1
      end
    end
    object gridVenda_item: TcxGrid
      AlignWithMargins = True
      Left = 4
      Top = 199
      Width = 857
      Height = 235
      Margins.Top = 10
      Margins.Bottom = 10
      Align = alClient
      TabOrder = 1
      object cxGridDBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = False
        Navigator.Buttons.PriorPage.Visible = False
        Navigator.Buttons.Prior.Visible = False
        Navigator.Buttons.Next.Visible = False
        Navigator.Buttons.NextPage.Visible = False
        Navigator.Buttons.Last.Visible = False
        Navigator.Buttons.Insert.Visible = False
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = False
        Navigator.Buttons.Edit.Visible = False
        Navigator.Buttons.Post.Visible = False
        Navigator.Buttons.Cancel.Visible = False
        Navigator.Buttons.Refresh.Visible = False
        Navigator.Buttons.SaveBookmark.Visible = False
        Navigator.Buttons.GotoBookmark.Visible = False
        Navigator.Buttons.Filter.Visible = False
        DataController.DataSource = dsItem
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'Total de itens: ,0'
            Kind = skCount
            FieldName = 'ID'
            Column = cxGridDBTableView1ID_PRODUTO
            DisplayText = 'Total de itens: ,0'
          end
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'UNITARIO'
            Column = cxGridDBTableView1UNITARIO
          end
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'SUBTOTAL'
            Column = cxGridDBTableView1SUBTOTAL
          end
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'DESCONTO'
            Column = cxGridDBTableView1DESCONTO
          end
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'ACRESCIMO'
            Column = cxGridDBTableView1ACRESCIMO
          end
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'TOTAL'
            Column = cxGridDBTableView1TOTAL
          end>
        DataController.Summary.SummaryGroups = <>
        NewItemRow.InfoText = 'Clique aqui para incluir os produtos...'
        NewItemRow.Visible = True
        OptionsBehavior.FocusCellOnTab = True
        OptionsBehavior.FocusFirstCellOnNewRecord = True
        OptionsBehavior.GoToNextCellOnEnter = True
        OptionsBehavior.FocusCellOnCycle = True
        OptionsCustomize.ColumnMoving = False
        OptionsView.NoDataToDisplayInfoText = '<Nenhum registro foi lan'#231'ado ainda, pressione F2 para incluir>'
        OptionsView.ScrollBars = ssVertical
        OptionsView.ColumnAutoWidth = True
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        object cxGridDBTableView1ID: TcxGridDBColumn
          DataBinding.FieldName = 'ID'
          Options.Editing = False
          Options.Focusing = False
          Width = 45
        end
        object cxGridDBTableView1ID_VENDA: TcxGridDBColumn
          Caption = 'VENDA'
          DataBinding.FieldName = 'ID_VENDA'
          Options.Editing = False
          Options.Focusing = False
          Width = 60
        end
        object cxGridDBTableView1ID_PRODUTO: TcxGridDBColumn
          Caption = 'PRODUTO'
          DataBinding.FieldName = 'ID_PRODUTO'
          PropertiesClassName = 'TcxLookupComboBoxProperties'
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'NOME'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = dsProdutos
          Properties.OnValidate = cxGridDBTableView1ID_PRODUTOPropertiesValidate
          Width = 248
        end
        object cxGridDBTableView1UN: TcxGridDBColumn
          DataBinding.FieldName = 'UN'
          Options.Editing = False
          Options.Focusing = False
          Width = 50
        end
        object cxGridDBTableView1QUANTIDADE: TcxGridDBColumn
          DataBinding.FieldName = 'QUANTIDADE'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 3
          Properties.DisplayFormat = ',0.000;-,0.000'
          Width = 111
        end
        object cxGridDBTableView1UNITARIO: TcxGridDBColumn
          DataBinding.FieldName = 'UNITARIO'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Options.Editing = False
          Options.Focusing = False
          Width = 101
        end
        object cxGridDBTableView1SUBTOTAL: TcxGridDBColumn
          DataBinding.FieldName = 'SUBTOTAL'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Options.Editing = False
          Options.Focusing = False
          Width = 82
        end
        object cxGridDBTableView1DESCONTO: TcxGridDBColumn
          DataBinding.FieldName = 'DESCONTO'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Width = 80
        end
        object cxGridDBTableView1ACRESCIMO: TcxGridDBColumn
          DataBinding.FieldName = 'ACRESCIMO'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Width = 82
        end
        object cxGridDBTableView1TOTAL: TcxGridDBColumn
          DataBinding.FieldName = 'TOTAL'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Options.Editing = False
          Options.Focusing = False
          Width = 80
        end
      end
      object cxGridLevel1: TcxGridLevel
        GridView = cxGridDBTableView1
      end
    end
    object gridVenda_Pgto: TcxGrid
      AlignWithMargins = True
      Left = 4
      Top = 454
      Width = 857
      Height = 144
      Margins.Top = 10
      Margins.Bottom = 10
      Align = alBottom
      TabOrder = 2
      object cxGridDBTableView2: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = False
        Navigator.Buttons.PriorPage.Visible = False
        Navigator.Buttons.Prior.Visible = False
        Navigator.Buttons.Next.Visible = False
        Navigator.Buttons.NextPage.Visible = False
        Navigator.Buttons.Last.Visible = False
        Navigator.Buttons.Insert.Visible = False
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = False
        Navigator.Buttons.Edit.Visible = False
        Navigator.Buttons.Post.Visible = False
        Navigator.Buttons.Cancel.Visible = False
        Navigator.Buttons.Refresh.Visible = False
        Navigator.Buttons.SaveBookmark.Visible = False
        Navigator.Buttons.GotoBookmark.Visible = False
        Navigator.Buttons.Filter.Visible = False
        DataController.DataSource = dsPgto
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = 'Total de pagamentos: ,0'
            Kind = skCount
            FieldName = 'ID'
            Column = cxGridDBTableView2ID_FORMA_PGTO
            DisplayText = 'Total de pagamentos: ,0'
          end
          item
            Format = ',0.00'
            Kind = skSum
            FieldName = 'VALOR'
            Column = cxGridDBTableView2VALOR
          end>
        DataController.Summary.SummaryGroups = <>
        NewItemRow.InfoText = 'Clique aqui para incluir os pagamentos...'
        NewItemRow.Visible = True
        OptionsBehavior.FocusCellOnTab = True
        OptionsBehavior.FocusFirstCellOnNewRecord = True
        OptionsBehavior.GoToNextCellOnEnter = True
        OptionsBehavior.FocusCellOnCycle = True
        OptionsCustomize.ColumnMoving = False
        OptionsView.NoDataToDisplayInfoText = '<Nenhum registro foi lan'#231'ado ainda, pressione F2 para incluir>'
        OptionsView.ScrollBars = ssVertical
        OptionsView.ColumnAutoWidth = True
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        object cxGridDBTableView2ID: TcxGridDBColumn
          DataBinding.FieldName = 'ID'
          Options.Editing = False
          Options.Focusing = False
          Width = 43
        end
        object cxGridDBTableView2ID_VENDA: TcxGridDBColumn
          Caption = 'VENDA'
          DataBinding.FieldName = 'ID_VENDA'
          Options.Editing = False
          Options.Focusing = False
          Width = 52
        end
        object cxGridDBTableView2ID_FORMA_PGTO: TcxGridDBColumn
          Caption = 'FORMA DE PAGAMENTO'
          DataBinding.FieldName = 'ID_FORMA_PGTO'
          PropertiesClassName = 'TcxLookupComboBoxProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.KeyFieldNames = 'ID'
          Properties.ListColumns = <
            item
              FieldName = 'FORMA'
            end>
          Properties.ListOptions.ShowHeader = False
          Properties.ListSource = dsFormaPgto
          Width = 644
        end
        object cxGridDBTableView2VALOR: TcxGridDBColumn
          DataBinding.FieldName = 'VALOR'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00'
          Width = 200
        end
      end
      object cxGridLevel2: TcxGridLevel
        GridView = cxGridDBTableView2
      end
    end
  end
  object pMemo: TPanel
    Left = 870
    Top = 41
    Width = 672
    Height = 609
    Align = alClient
    TabOrder = 3
    object Splitter2: TSplitter
      Left = 1
      Top = 289
      Width = 670
      Height = 5
      Cursor = crVSplit
      Align = alTop
      ExplicitTop = 337
    end
    object mVenda: TMemo
      Left = 1
      Top = 294
      Width = 670
      Height = 314
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object mJson: TMemo
      Left = 1
      Top = 1
      Width = 670
      Height = 288
      Align = alTop
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Consolas'
      Font.Style = []
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object Conexao: TUniConnection
    ProviderName = 'InterBase'
    Port = 3050
    Database = 
      'C:\Users\onyxa\OneDrive\Documentos\Embarcadero\Studio\Projects\V' +
      'ideo Aula OtsFirebase\FMX\DATA.FDB'
    Username = 'sysdba'
    Server = '127.0.0.1'
    LoginPrompt = False
    AfterConnect = ConexaoAfterConnect
    Left = 96
    Top = 64
    EncryptedPassword = '92FF9EFF8CFF8BFF9AFF8DFF94FF9AFF86FF'
  end
  object Provider: TInterBaseUniProvider
    Left = 96
    Top = 120
  end
  object Produtos: TUniQuery
    Connection = Conexao
    SQL.Strings = (
      'select * from produtos order by nome')
    Options.RequiredFields = False
    Left = 128
    Top = 272
  end
  object Pessoas: TUniQuery
    Connection = Conexao
    SQL.Strings = (
      'select * from pessoa order by nome')
    Options.RequiredFields = False
    Left = 248
    Top = 64
  end
  object FormaPgto: TUniQuery
    Connection = Conexao
    SQL.Strings = (
      'select * from forma_pgto order by forma')
    Options.RequiredFields = False
    Left = 144
    Top = 456
  end
  object Venda: TUniQuery
    KeyFields = 'ID'
    Connection = Conexao
    SQL.Strings = (
      'select * from venda order by id')
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'InterBase.KeyGenerator=GEN_VENDA_ID'
      'InterBase.GeneratorMode=gmInsert')
    AfterPost = VendaAfterPost
    Left = 416
    Top = 64
  end
  object Item: TUniQuery
    KeyFields = 'ID'
    Connection = Conexao
    SQL.Strings = (
      'select * from venda_item order by id')
    MasterSource = dsVenda
    MasterFields = 'ID'
    DetailFields = 'ID_VENDA'
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'InterBase.GeneratorMode=gmInsert'
      'InterBase.KeyGenerator=GEN_VENDA_ITEM_ID')
    AfterPost = ItemAfterPost
    Left = 56
    Top = 272
    ParamData = <
      item
        DataType = ftInteger
        Name = 'ID'
        ParamType = ptInput
        Value = nil
      end>
  end
  object Pgto: TUniQuery
    KeyFields = 'ID'
    Connection = Conexao
    SQL.Strings = (
      'select * from venda_pgto order by id')
    MasterSource = dsVenda
    MasterFields = 'ID'
    DetailFields = 'ID_VENDA'
    Options.RequiredFields = False
    SpecificOptions.Strings = (
      'InterBase.GeneratorMode=gmInsert'
      'InterBase.KeyGenerator=GEN_VENDA_PGTO_ID')
    AfterPost = PgtoAfterPost
    Left = 56
    Top = 456
    ParamData = <
      item
        DataType = ftUnknown
        Name = 'ID'
        ParamType = ptInput
        Value = nil
      end>
  end
  object dsProdutos: TDataSource
    AutoEdit = False
    DataSet = Produtos
    Left = 128
    Top = 320
  end
  object dsPessoas: TDataSource
    AutoEdit = False
    DataSet = Pessoas
    Left = 248
    Top = 112
  end
  object dsFormaPgto: TDataSource
    AutoEdit = False
    DataSet = FormaPgto
    Left = 144
    Top = 504
  end
  object dsVenda: TDataSource
    DataSet = Venda
    Left = 416
    Top = 112
  end
  object dsItem: TDataSource
    DataSet = Item
    Left = 56
    Top = 320
  end
  object dsPgto: TDataSource
    DataSet = Pgto
    Left = 56
    Top = 504
  end
end
