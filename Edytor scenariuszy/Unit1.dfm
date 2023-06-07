object Form1: TForm1
  Left = 174
  Top = 107
  Width = 758
  Height = 574
  Caption = 'Sadist 3 - Edytor scenariuszy'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object st: TPageControl
    Left = 0
    Top = 0
    Width = 750
    Height = 545
    ActivePage = Ogolne
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    HotTrack = True
    MultiLine = True
    ParentFont = False
    RaggedRight = True
    TabIndex = 0
    TabOrder = 0
    object Ogolne: TTabSheet
      Caption = 'Og'#243'lne'
      object Splitter2: TSplitter
        Left = 239
        Top = 0
        Width = 3
        Height = 517
        Cursor = crHSplit
        AutoSnap = False
        Beveled = True
        ResizeStyle = rsUpdate
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 239
        Height = 517
        Align = alLeft
        TabOrder = 0
        object listascenariuszy: TListBox
          Left = 1
          Top = 57
          Width = 237
          Height = 459
          Align = alClient
          Color = 13491424
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 0
          OnClick = listascenariuszyClick
        end
        object Panel6: TPanel
          Left = 1
          Top = 1
          Width = 237
          Height = 56
          Align = alTop
          TabOrder = 1
          DesignSize = (
            237
            56)
          object Label4: TLabel
            Left = 8
            Top = 40
            Width = 138
            Height = 13
            Caption = 'Lista istniejcych scenariuszy:'
          end
          object Panel8: TPanel
            Left = 48
            Top = 8
            Width = 145
            Height = 25
            Anchors = [akTop]
            BevelOuter = bvNone
            TabOrder = 0
            object Zapisz: TSpeedButton
              Left = 0
              Top = 0
              Width = 73
              Height = 25
              Caption = 'Zapisz'
              Enabled = False
              OnClick = ZapiszClick
            end
            object Wczytaj: TSpeedButton
              Left = 79
              Top = 0
              Width = 66
              Height = 25
              Caption = 'Wczytaj'
              Enabled = False
              OnClick = WczytajClick
            end
          end
        end
      end
      object skrologolne: TScrollBox
        Left = 242
        Top = 0
        Width = 500
        Height = 517
        HorzScrollBar.Smooth = True
        HorzScrollBar.Tracking = True
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alClient
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
        DesignSize = (
          496
          513)
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 91
          Height = 13
          Caption = 'Nazwa scenariusza'
        end
        object Label2: TLabel
          Left = 8
          Top = 56
          Width = 86
          Height = 13
          Caption = 'Autor scenariusza'
        end
        object Label3: TLabel
          Left = 8
          Top = 104
          Width = 78
          Height = 13
          Caption = 'Data stworzenia'
        end
        object nnazwa: TEdit
          Left = 8
          Top = 24
          Width = 481
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Color = 13491424
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'Nowy scenariusz'
        end
        object nautor: TEdit
          Left = 8
          Top = 72
          Width = 481
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          Color = 13491424
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          Text = 'Autor'
        end
        object ndatastworzenia: TDateTimePicker
          Left = 8
          Top = 120
          Width = 481
          Height = 21
          Anchors = [akLeft, akTop, akRight]
          CalAlignment = dtaLeft
          CalColors.TextColor = clBlue
          Date = 38279.4267834838
          Time = 38279.4267834838
          Color = 13491424
          DateFormat = dfLong
          DateMode = dmComboBox
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Kind = dtkDate
          ParseInput = False
          ParentFont = False
          TabOrder = 2
        end
        object GroupBox1: TGroupBox
          Left = 8
          Top = 144
          Width = 481
          Height = 369
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = 'Ustawienia'
          Constraints.MinHeight = 150
          Constraints.MinWidth = 200
          TabOrder = 3
          object Label5: TLabel
            Left = 8
            Top = 102
            Width = 74
            Height = 13
            Caption = 'Szybko'#347#263' czasu'
          end
          object czasstand: TSpeedButton
            Left = 176
            Top = 99
            Width = 97
            Height = 22
            Caption = '<< Standardowa'
            Flat = True
            OnClick = czasstandClick
          end
          object Label8: TLabel
            Left = 8
            Top = 136
            Width = 308
            Height = 13
            Caption = 'Mo'#380'liwe ciecze (b'#281'd'#261' wybierane losowo spo'#347'r'#243'd zaznaczonych):'
          end
          object widslon: TCheckBox
            Left = 8
            Top = 16
            Width = 161
            Height = 17
            Caption = 'S'#322'o'#324'ce widoczne'
            Checked = True
            State = cbChecked
            TabOrder = 0
          end
          object winksie: TCheckBox
            Left = 8
            Top = 32
            Width = 161
            Height = 17
            Caption = 'Ksi'#281#380'yc widoczny'
            Checked = True
            State = cbChecked
            TabOrder = 1
          end
          object widgwia: TCheckBox
            Left = 8
            Top = 48
            Width = 161
            Height = 17
            Caption = 'Gwiazdy widoczne'
            Checked = True
            State = cbChecked
            TabOrder = 2
          end
          object widchmu: TCheckBox
            Left = 8
            Top = 64
            Width = 161
            Height = 17
            Caption = 'Chmury widoczne'
            Checked = True
            State = cbChecked
            TabOrder = 3
          end
          object widdeszsnie: TCheckBox
            Left = 8
            Top = 80
            Width = 161
            Height = 17
            Caption = 'Deszcz/'#347'nieg widoczne'
            Checked = True
            State = cbChecked
            TabOrder = 4
          end
          object szybczas: TSpinEdit
            Left = 112
            Top = 99
            Width = 57
            Height = 22
            MaxValue = 500
            MinValue = 1
            TabOrder = 5
            Value = 40
          end
          object ciecz1: TCheckBox
            Left = 12
            Top = 170
            Width = 161
            Height = 17
            Caption = 'Woda'
            Checked = True
            State = cbChecked
            TabOrder = 6
          end
          object ciecz2: TCheckBox
            Left = 12
            Top = 186
            Width = 161
            Height = 17
            Caption = 'Lawa'
            Checked = True
            State = cbChecked
            TabOrder = 7
          end
          object ciecz3: TCheckBox
            Left = 12
            Top = 202
            Width = 161
            Height = 17
            Caption = 'Kwas'
            Checked = True
            State = cbChecked
            TabOrder = 8
          end
          object ciecz4: TCheckBox
            Left = 12
            Top = 218
            Width = 161
            Height = 17
            Caption = 'Krew'
            Checked = True
            State = cbChecked
            TabOrder = 9
          end
          object ciecz5: TCheckBox
            Left = 12
            Top = 234
            Width = 161
            Height = 17
            Caption = 'B'#322'oto'
            Checked = True
            State = cbChecked
            TabOrder = 10
          end
          object ciecz0: TCheckBox
            Left = 12
            Top = 154
            Width = 161
            Height = 17
            Caption = 'Nic'
            Checked = True
            State = cbChecked
            TabOrder = 11
          end
        end
      end
    end
    object Obiekty: TTabSheet
      Caption = 'Obiekty'
      ImageIndex = 2
      object Splitter1: TSplitter
        Left = 185
        Top = 0
        Width = 3
        Height = 517
        Cursor = crHSplit
        AutoSnap = False
        ResizeStyle = rsUpdate
      end
      object Panel1: TPanel
        Left = 188
        Top = 0
        Width = 554
        Height = 517
        Align = alClient
        TabOrder = 0
        object Panel2: TPanel
          Left = 1
          Top = 35
          Width = 552
          Height = 40
          Align = alTop
          BevelOuter = bvLowered
          TabOrder = 0
          object obinazwa: TLabel
            Left = 4
            Top = 3
            Width = 5
            Height = 13
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object obiwlasciwosci: TLabel
            Left = 4
            Top = 19
            Width = 4
            Height = 13
            Caption = '-'
          end
        end
        object Panel7: TPanel
          Left = 1
          Top = 1
          Width = 552
          Height = 34
          Align = alTop
          TabOrder = 1
          object zoomin: TSpeedButton
            Left = 2
            Top = 2
            Width = 30
            Height = 30
            Caption = '+'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -24
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = zoominClick
          end
          object zoomout: TSpeedButton
            Left = 34
            Top = 2
            Width = 30
            Height = 30
            Caption = '-'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -24
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = zoomoutClick
          end
          object zoom100: TSpeedButton
            Left = 66
            Top = 2
            Width = 30
            Height = 30
            Caption = '100%'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            OnClick = zoom100Click
          end
          object zoomcale: TSpeedButton
            Left = 98
            Top = 2
            Width = 30
            Height = 30
            Caption = '1'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -21
            Font.Name = 'Marlett'
            Font.Style = []
            ParentFont = False
            OnClick = zoomcaleClick
          end
          object zoombar: TTrackBar
            Left = 129
            Top = 2
            Width = 296
            Height = 30
            Max = 1600
            Min = 15
            Orientation = trHorizontal
            PageSize = 50
            Frequency = 1
            Position = 100
            SelEnd = 0
            SelStart = 0
            TabOrder = 0
            ThumbLength = 14
            TickMarks = tmBoth
            TickStyle = tsManual
            OnChange = zoombarChange
          end
        end
        object skrolpodglad: TScrollBox
          Left = 1
          Top = 75
          Width = 552
          Height = 443
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 2
          object Podgob: TPaintBox
            Left = 0
            Top = 0
            Width = 552
            Height = 443
            Align = alClient
            OnPaint = podgterPaint
          end
        end
      end
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 185
        Height = 517
        Align = alLeft
        TabOrder = 1
        object Splitter3: TSplitter
          Left = 1
          Top = 115
          Width = 183
          Height = 3
          Cursor = crVSplit
          Align = alBottom
          AutoSnap = False
          ResizeStyle = rsUpdate
        end
        object ListaObiektow: TListBox
          Left = 1
          Top = 1
          Width = 183
          Height = 114
          Align = alClient
          Color = 13491424
          DragMode = dmAutomatic
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 0
          OnClick = ListaObiektowClick
          OnDragDrop = ListaObiektowDragDrop
          OnDragOver = ListaObiektowDragOver
        end
        object Panel11: TPanel
          Left = 1
          Top = 118
          Width = 183
          Height = 398
          Align = alBottom
          BevelOuter = bvLowered
          TabOrder = 1
          object Label7: TLabel
            Left = 1
            Top = 1
            Width = 181
            Height = 32
            Align = alTop
            Alignment = taCenter
            AutoSize = False
            Caption = 'Przeci'#261'gnij i upu'#347#263' obiekty wybrane do tego scenariusza'
            Layout = tlCenter
            WordWrap = True
          end
          object wybobi: TListBox
            Tag = 1
            Left = 1
            Top = 59
            Width = 181
            Height = 338
            Align = alClient
            Color = 13491424
            DragMode = dmAutomatic
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clGreen
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = []
            ItemHeight = 13
            ParentFont = False
            TabOrder = 0
            OnClick = ListaObiektowClick
            OnDragDrop = wybobiDragDrop
            OnDragOver = wybobiDragOver
          end
          object Panel13: TPanel
            Left = 1
            Top = 33
            Width = 181
            Height = 26
            Align = alTop
            TabOrder = 1
            DesignSize = (
              181
              26)
            object czyscliste: TSpeedButton
              Left = 2
              Top = 2
              Width = 177
              Height = 22
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Czy'#347#263
              Flat = True
              OnClick = czysclisteClick
            end
          end
        end
      end
    end
    object Tekstury: TTabSheet
      Caption = 'Tekstury'
      ImageIndex = 3
      object TexSplitter1: TSplitter
        Left = 185
        Top = 0
        Width = 3
        Height = 517
        Cursor = crHSplit
        AutoSnap = False
        ResizeStyle = rsUpdate
      end
      object TexPanel1: TPanel
        Left = 188
        Top = 0
        Width = 554
        Height = 517
        Align = alClient
        TabOrder = 0
        object TexPanel2: TPanel
          Left = 1
          Top = 35
          Width = 552
          Height = 40
          Align = alTop
          BevelOuter = bvLowered
          TabOrder = 0
          object Texobinazwa: TLabel
            Left = 4
            Top = 3
            Width = 5
            Height = 13
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
          object Texobiwlasciwosci: TLabel
            Left = 4
            Top = 19
            Width = 4
            Height = 13
            Caption = '-'
          end
        end
        object TexPanel7: TPanel
          Left = 1
          Top = 1
          Width = 552
          Height = 34
          Align = alTop
          TabOrder = 1
          object Texzoomin: TSpeedButton
            Left = 2
            Top = 2
            Width = 30
            Height = 30
            Caption = '+'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -24
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = TexzoominClick
          end
          object Texzoomout: TSpeedButton
            Left = 34
            Top = 2
            Width = 30
            Height = 30
            Caption = '-'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -24
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
            OnClick = TexzoomoutClick
          end
          object Texzoom100: TSpeedButton
            Left = 66
            Top = 2
            Width = 30
            Height = 30
            Caption = '100%'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -9
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentFont = False
            OnClick = Texzoom100Click
          end
          object Texzoomcale: TSpeedButton
            Left = 98
            Top = 2
            Width = 30
            Height = 30
            Caption = '1'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -21
            Font.Name = 'Marlett'
            Font.Style = []
            ParentFont = False
            OnClick = TexzoomcaleClick
          end
          object Texwiele: TSpeedButton
            Left = 130
            Top = 2
            Width = 30
            Height = 30
            AllowAllUp = True
            GroupIndex = 1
            Caption = 'v'
            Flat = True
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -21
            Font.Name = 'Wingdings'
            Font.Style = []
            ParentFont = False
            OnClick = TexwieleClick
          end
          object Texzoombar: TTrackBar
            Left = 169
            Top = 2
            Width = 296
            Height = 30
            Max = 1600
            Min = 15
            Orientation = trHorizontal
            PageSize = 50
            Frequency = 1
            Position = 100
            SelEnd = 0
            SelStart = 0
            TabOrder = 0
            ThumbLength = 14
            TickMarks = tmBoth
            TickStyle = tsManual
            OnChange = TexzoombarChange
          end
        end
        object Texskrolpodglad: TScrollBox
          Left = 1
          Top = 75
          Width = 552
          Height = 443
          Align = alClient
          BorderStyle = bsNone
          TabOrder = 2
          object TexPodgob: TPaintBox
            Left = 0
            Top = 0
            Width = 552
            Height = 360
            Align = alClient
            OnPaint = TexPodgobPaint
          end
          object Panel4: TPanel
            Left = 0
            Top = 360
            Width = 552
            Height = 83
            Align = alBottom
            TabOrder = 0
            object wierzch: TPaintBox
              Left = 8
              Top = 8
              Width = 217
              Height = 33
              OnPaint = wierzchPaint
            end
            object spod: TPaintBox
              Tag = 1
              Left = 8
              Top = 43
              Width = 217
              Height = 33
              OnPaint = wierzchPaint
            end
            object wierzchrodz: TSpeedButton
              Left = 232
              Top = 8
              Width = 81
              Height = 33
              Caption = 'Rodzaj= 1'
              Flat = True
              OnClick = wierzchrodzClick
            end
            object wierzchkol: TSpeedButton
              Left = 320
              Top = 8
              Width = 65
              Height = 33
              Caption = 'Kolor'
              Flat = True
              OnClick = wierzchkolClick
            end
            object spodrodz: TSpeedButton
              Tag = 1
              Left = 232
              Top = 43
              Width = 81
              Height = 33
              Caption = 'Rodzaj= 2'
              Flat = True
              OnClick = wierzchrodzClick
            end
            object spodkol: TSpeedButton
              Tag = 1
              Left = 320
              Top = 43
              Width = 65
              Height = 33
              Caption = 'Kolor'
              Flat = True
              OnClick = wierzchkolClick
            end
          end
        end
      end
      object TexPanel3: TPanel
        Left = 0
        Top = 0
        Width = 185
        Height = 517
        Align = alLeft
        TabOrder = 1
        object TexListaObiektow: TListBox
          Left = 1
          Top = 1
          Width = 183
          Height = 453
          Align = alClient
          Color = 13491424
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ItemHeight = 13
          ParentFont = False
          TabOrder = 0
          OnClick = TexListaObiektowClick
        end
        object Panel12: TPanel
          Left = 1
          Top = 454
          Width = 183
          Height = 62
          Align = alBottom
          TabOrder = 1
          object Label6: TLabel
            Left = 8
            Top = 8
            Width = 165
            Height = 13
            Caption = 'Wybrana tekstura do scenariusza:'
          end
          object wybtex: TLabel
            Left = 8
            Top = 32
            Width = 5
            Height = 13
            Caption = '-'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'Tahoma'
            Font.Style = [fsBold]
            ParentFont = False
          end
        end
      end
    end
    object Tlo: TTabSheet
      Caption = 'T'#322'o'
      ImageIndex = 4
      object Splitter4: TSplitter
        Left = 0
        Top = 89
        Width = 742
        Height = 6
        Cursor = crVSplit
        Align = alTop
        Beveled = True
        ResizeStyle = rsUpdate
      end
      object Panel10: TPanel
        Left = 0
        Top = 0
        Width = 742
        Height = 89
        Align = alTop
        TabOrder = 0
        DesignSize = (
          742
          89)
        object podgladtla: TPaintBox
          Left = 1
          Top = 1
          Width = 408
          Height = 87
          Align = alLeft
          Anchors = [akLeft, akTop, akRight, akBottom]
          OnPaint = tloobrPaint
        end
        object tloplay: TSpeedButton
          Left = 656
          Top = 64
          Width = 81
          Height = 20
          AllowAllUp = True
          Anchors = [akTop, akRight]
          GroupIndex = 1
          Caption = 'Ruszaj'
          OnClick = tloplayClick
        end
        object czastla: TTrackBar
          Left = 427
          Top = 2
          Width = 313
          Height = 33
          Hint = 'Godzina'
          Anchors = [akTop, akRight]
          Max = 23
          Orientation = trHorizontal
          ParentShowHint = False
          PageSize = 8
          Frequency = 1
          Position = 0
          SelEnd = 0
          SelStart = 0
          ShowHint = True
          TabOrder = 0
          ThumbLength = 16
          TickMarks = tmBoth
          TickStyle = tsAuto
          OnChange = czastlaChange
        end
        object minutytla: TTrackBar
          Left = 427
          Top = 34
          Width = 313
          Height = 27
          Hint = 'Minuty'
          Anchors = [akTop, akRight]
          Max = 59
          Orientation = trHorizontal
          ParentShowHint = False
          Frequency = 1
          Position = 0
          SelEnd = 0
          SelStart = 0
          ShowHint = True
          TabOrder = 1
          ThumbLength = 12
          TickMarks = tmBoth
          TickStyle = tsAuto
          OnChange = minutytlaChange
        end
        object TloTempo: TTrackBar
          Left = 427
          Top = 67
          Width = 227
          Height = 16
          Hint = 'Tempo'
          Anchors = [akTop, akRight]
          Max = 500
          Min = 2
          Orientation = trHorizontal
          ParentShowHint = False
          Frequency = 1
          Position = 30
          SelEnd = 0
          SelStart = 0
          ShowHint = True
          TabOrder = 2
          ThumbLength = 12
          TickMarks = tmBoth
          TickStyle = tsNone
          OnChange = TloTempoChange
        end
      end
      object skroltla: TScrollBox
        Left = 0
        Top = 95
        Width = 742
        Height = 422
        HorzScrollBar.Smooth = True
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 1
        OnResize = skroltlaResize
        object Panel9: TPanel
          Left = 80
          Top = 80
          Width = 113
          Height = 145
          TabOrder = 0
          Visible = False
          object tlogora: TSpeedButton
            Left = 24
            Top = 125
            Width = 41
            Height = 17
            Caption = 'G'#243'ra'
            Flat = True
            OnClick = tlogoraClick
          end
          object tlodol: TSpeedButton
            Left = 66
            Top = 125
            Width = 45
            Height = 17
            Caption = 'D'#243#322
            Flat = True
            OnClick = tlodolClick
          end
          object tloobr: TPaintBox
            Left = 1
            Top = 1
            Width = 110
            Height = 121
            OnPaint = tloobrPaint
          end
          object tlowl: TCheckBox
            Left = 3
            Top = 124
            Width = 16
            Height = 17
            Checked = True
            State = cbChecked
            TabOrder = 0
            OnClick = tlowlClick
          end
        end
      end
    end
    object oprogramie: TTabSheet
      Caption = 'O programie'
      ImageIndex = 4
      object tekstoprogramie: TStaticText
        Left = 0
        Top = 0
        Width = 742
        Height = 519
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 
          'Sadist 3 - Edytor scenariuszy'#13#10'wersja 0.1'#13#10'autor: Grzegorz "GAD"' +
          ' Drozd'#13#10'gad@gad.art.pl'#13#10'http://sadist.art.pl/'
        Color = clNavy
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentColor = False
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Left = 257
    Top = 131
  end
  object TimerTla: TTimer
    Enabled = False
    Interval = 30
    OnTimer = TimerTlaTimer
    Left = 624
    Top = 96
  end
end
