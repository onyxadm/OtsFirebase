object frmMain: TfrmMain
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 
    'Demonstrativo | OtsFirebase '#174' - Componente de Conex'#227'o e Consumo ' +
    'do Google Firebase'
  ClientHeight = 788
  ClientWidth = 765
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    765
    788)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 7
    Width = 24
    Height = 13
    Caption = 'Email'
  end
  object Label2: TLabel
    Left = 9
    Top = 47
    Width = 46
    Height = 13
    Caption = 'Password'
  end
  object Label3: TLabel
    Left = 9
    Top = 219
    Width = 29
    Height = 13
    Caption = 'Token'
  end
  object Label4: TLabel
    Left = 8
    Top = 389
    Width = 47
    Height = 13
    Caption = 'Response'
  end
  object Label6: TLabel
    Left = 8
    Top = 135
    Width = 41
    Height = 13
    Caption = 'API_KEY'
  end
  object Label7: TLabel
    Left = 8
    Top = 176
    Width = 62
    Height = 13
    Caption = 'PROJECT_ID'
  end
  object lbResp: TLabel
    Left = 486
    Top = 210
    Width = 90
    Height = 19
    Caption = 'Resposta: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
  end
  object Label8: TLabel
    Left = 8
    Top = 91
    Width = 28
    Height = 13
    Caption = 'Node '
  end
  object edtEmail: TEdit
    Left = 9
    Top = 20
    Width = 450
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10878976
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object edtPassword: TEdit
    Left = 8
    Top = 60
    Width = 450
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10878976
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    PasswordChar = '*'
    TabOrder = 1
  end
  object memoToken: TMemo
    Left = 9
    Top = 235
    Width = 748
    Height = 152
    Anchors = [akLeft, akTop, akRight]
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object bLoginUser: TButton
    Left = 465
    Top = 61
    Width = 143
    Height = 25
    Caption = 'LoginUser'
    TabOrder = 3
    OnClick = bLoginUserClick
  end
  object memoResp: TMemo
    Left = 8
    Top = 408
    Width = 749
    Height = 372
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 4
  end
  object edtApiKey: TEdit
    Left = 8
    Top = 147
    Width = 450
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10878976
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 5
    Text = 'AIzaSyC2ofTLxZoA9HyXPWLV6Oub02LW0mRdTjs'
  end
  object edtProjectId: TEdit
    Left = 8
    Top = 188
    Width = 450
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10878976
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 6
    Text = 'auth-onyx'
  end
  object edtNode: TEdit
    Left = 8
    Top = 105
    Width = 201
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10878976
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 7
    Text = 'Vendas'
  end
  object bGetDocument: TButton
    Left = 613
    Top = 106
    Width = 143
    Height = 25
    Caption = 'Get Document'
    TabOrder = 8
    OnClick = bGetDocumentClick
  end
  object bCreateUser: TButton
    Left = 465
    Top = 21
    Width = 143
    Height = 25
    Caption = 'CreateUser'
    TabOrder = 9
    OnClick = bCreateUserClick
  end
  object bLogout: TButton
    Left = 613
    Top = 61
    Width = 143
    Height = 25
    Caption = 'Logout'
    TabOrder = 10
    OnClick = bLogoutClick
  end
  object noAuth: TCheckBox
    Left = 464
    Top = 110
    Width = 143
    Height = 17
    Caption = 'Consumir sem autenticar'
    TabOrder = 11
  end
  object edtNode2: TEdit
    Left = 215
    Top = 105
    Width = 243
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 10878976
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
  end
  object OtsFirebase: TOtsFirebase
    Left = 688
    Top = 104
  end
end
