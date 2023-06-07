object Formprogres: TFormprogres
  Left = 187
  Top = 108
  Width = 495
  Height = 403
  BorderIcons = []
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pasek: TGauge
    Left = 7
    Top = 32
    Width = 473
    Height = 25
    Anchors = [akLeft, akTop, akRight]
    Progress = 0
  end
  object nazwapl: TLabel
    Left = 8
    Top = 8
    Width = 3
    Height = 13
  end
  object Memo1: TMemo
    Left = 8
    Top = 64
    Width = 473
    Height = 273
    TabStop = False
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
    OnEnter = Memo1Enter
  end
  object Zamknij: TButton
    Left = 408
    Top = 344
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = ZamknijClick
  end
end
