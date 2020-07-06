object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'OtsFirebase '#169
  ClientHeight = 545
  ClientWidth = 644
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
  object pFundo: TPanel
    Left = 0
    Top = 0
    Width = 644
    Height = 113
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 649
    object pControls: TPanel
      Left = 1
      Top = 62
      Width = 642
      Height = 50
      Align = alBottom
      TabOrder = 0
      ExplicitTop = 22
      ExplicitWidth = 994
      object bDelete: TButton
        AlignWithMargins = True
        Left = 482
        Top = 4
        Width = 75
        Height = 42
        Align = alRight
        Caption = 'Delete'
        TabOrder = 0
        ExplicitLeft = 836
        ExplicitHeight = 41
      end
      object bPut: TButton
        AlignWithMargins = True
        Left = 401
        Top = 4
        Width = 75
        Height = 42
        Align = alRight
        Caption = 'Put'
        TabOrder = 1
        ExplicitLeft = 755
        ExplicitHeight = 41
      end
      object bPost: TButton
        AlignWithMargins = True
        Left = 320
        Top = 4
        Width = 75
        Height = 42
        Align = alRight
        Caption = 'Post'
        TabOrder = 2
        OnClick = bPostClick
        ExplicitLeft = 674
        ExplicitHeight = 41
      end
      object bGet: TButton
        AlignWithMargins = True
        Left = 239
        Top = 4
        Width = 75
        Height = 42
        Align = alRight
        Caption = 'Get'
        TabOrder = 3
        OnClick = bGetClick
        ExplicitLeft = 593
        ExplicitHeight = 41
      end
      object bPatch: TButton
        AlignWithMargins = True
        Left = 563
        Top = 4
        Width = 75
        Height = 42
        Align = alRight
        Caption = 'Patch'
        TabOrder = 4
        ExplicitLeft = 917
        ExplicitHeight = 41
      end
    end
    object edtHost: TEdit
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 636
      Height = 21
      Align = alTop
      TabOrder = 1
      Text = 'http://127.0.0.1:9000/ping'
      TextHint = 'Url do webservice'
      ExplicitLeft = 3
      ExplicitTop = 0
      ExplicitWidth = 486
    end
  end
  object mStatus: TMemo
    Left = 0
    Top = 113
    Width = 644
    Height = 64
    Align = alTop
    TabOrder = 1
    ExplicitTop = 170
    ExplicitWidth = 649
  end
  object mResp: TMemo
    Left = 0
    Top = 177
    Width = 644
    Height = 368
    Align = alClient
    TabOrder = 2
    ExplicitWidth = 649
    ExplicitHeight = 64
  end
end
