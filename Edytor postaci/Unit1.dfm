object Form1: TForm1
  Left = 188
  Top = 108
  Width = 797
  Height = 584
  Caption = 'Sadist 3 - Edytor postaci'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object st: TPageControl
    Left = 0
    Top = 0
    Width = 789
    Height = 555
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
        Height = 527
        Cursor = crHSplit
        AutoSnap = False
        Beveled = True
        ResizeStyle = rsUpdate
      end
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 239
        Height = 527
        Align = alLeft
        TabOrder = 0
        object listadruzyn: TListBox
          Left = 1
          Top = 57
          Width = 237
          Height = 469
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
          OnClick = listadruzynClick
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
            Width = 121
            Height = 13
            Caption = 'Lista istniej'#261'cych dru'#380'yn:'
          end
          object Panel8: TPanel
            Left = 8
            Top = 8
            Width = 225
            Height = 25
            Anchors = [akTop]
            BevelOuter = bvNone
            TabOrder = 0
            object Zapisz: TSpeedButton
              Left = 72
              Top = 0
              Width = 73
              Height = 25
              Hint = 'Zapisz dru'#380'yn'#281
              Caption = 'Zapisz'
              ParentShowHint = False
              ShowHint = True
              OnClick = ZapiszClick
            end
            object Wczytaj: TSpeedButton
              Left = 152
              Top = 0
              Width = 73
              Height = 25
              Hint = 'Wczytaj dru'#380'yn'#281
              Caption = 'Wczytaj'
              Enabled = False
              ParentShowHint = False
              ShowHint = True
              OnClick = WczytajClick
            end
            object Nowy: TSpeedButton
              Left = 0
              Top = 0
              Width = 65
              Height = 25
              Hint = 'Stw'#243'rz now'#261' dru'#380'yn'#281
              Caption = 'Nowa'
              ParentShowHint = False
              ShowHint = True
              OnClick = NowyClick
            end
          end
        end
      end
      object skrologolne: TScrollBox
        Left = 242
        Top = 0
        Width = 539
        Height = 527
        HorzScrollBar.Smooth = True
        HorzScrollBar.Tracking = True
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alClient
        Color = clBtnFace
        ParentColor = False
        TabOrder = 1
        DesignSize = (
          535
          523)
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 74
          Height = 13
          Caption = 'Nazwa dru'#380'yny'
        end
        object Label2: TLabel
          Left = 8
          Top = 56
          Width = 27
          Height = 13
          Caption = 'Autor'
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
          Width = 520
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
          Text = 'Nowa dru'#380'yna'
        end
        object nautor: TEdit
          Left = 8
          Top = 72
          Width = 520
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
          Width = 520
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
      end
    end
    object Parametry: TTabSheet
      Caption = 'Parametry dru'#380'yny'
      ImageIndex = 1
      object skrolwarunki: TScrollBox
        Left = 0
        Top = 0
        Width = 781
        Height = 529
        HorzScrollBar.Smooth = True
        HorzScrollBar.Tracking = True
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        object GroupBox2: TGroupBox
          Left = 0
          Top = 185
          Width = 777
          Height = 121
          Align = alTop
          Caption = 'Maksymalna ilo'#347#263' amunicji'
          TabOrder = 0
          DesignSize = (
            777
            121)
          object Label5: TLabel
            Left = 8
            Top = 18
            Width = 273
            Height = 13
            AutoSize = False
            Caption = 'granat'#243'w'
          end
          object label6: TLabel
            Left = 8
            Top = 42
            Width = 273
            Height = 13
            AutoSize = False
            Caption = 'bomb'
          end
          object Label7: TLabel
            Left = 8
            Top = 66
            Width = 273
            Height = 13
            AutoSize = False
            Caption = 'pocisk'#243'w do karabinu'
          end
          object Label8: TLabel
            Left = 8
            Top = 90
            Width = 273
            Height = 13
            AutoSize = False
            Caption = 'dynamit'#243'w'
          end
          object ustamun0: TSpinEdit
            Left = 702
            Top = 14
            Width = 64
            Height = 22
            Anchors = [akTop, akRight]
            Color = 13491424
            MaxValue = 999
            MinValue = 0
            TabOrder = 0
            Value = 10
            OnChange = ustamun0Change
          end
          object ustamun1: TSpinEdit
            Left = 702
            Top = 38
            Width = 64
            Height = 22
            Anchors = [akTop, akRight]
            Color = 13491424
            MaxValue = 999
            MinValue = 0
            TabOrder = 1
            Value = 7
            OnChange = ustamun1Change
          end
          object ustamun2: TSpinEdit
            Left = 702
            Top = 62
            Width = 64
            Height = 22
            Anchors = [akTop, akRight]
            Color = 13491424
            MaxValue = 999
            MinValue = 0
            TabOrder = 2
            Value = 30
            OnChange = ustamun2Change
          end
          object ustamun3: TSpinEdit
            Left = 702
            Top = 86
            Width = 64
            Height = 22
            Anchors = [akTop, akRight]
            Color = 13491424
            MaxValue = 999
            MinValue = 0
            TabOrder = 3
            Value = 2
            OnChange = ustamun3Change
          end
          object baramun0: TTrackBar
            Left = 288
            Top = 16
            Width = 412
            Height = 20
            Anchors = [akLeft, akTop, akRight]
            Max = 999
            Orientation = trHorizontal
            PageSize = 30
            Frequency = 1
            Position = 10
            SelEnd = 0
            SelStart = 0
            TabOrder = 4
            ThumbLength = 12
            TickMarks = tmBottomRight
            TickStyle = tsNone
            OnChange = baramun0Change
          end
          object baramun1: TTrackBar
            Left = 288
            Top = 40
            Width = 412
            Height = 20
            Anchors = [akLeft, akTop, akRight]
            Max = 999
            Orientation = trHorizontal
            PageSize = 30
            Frequency = 1
            Position = 10
            SelEnd = 0
            SelStart = 0
            TabOrder = 5
            ThumbLength = 12
            TickMarks = tmBottomRight
            TickStyle = tsNone
            OnChange = baramun1Change
          end
          object baramun2: TTrackBar
            Left = 288
            Top = 64
            Width = 412
            Height = 20
            Anchors = [akLeft, akTop, akRight]
            Max = 999
            Orientation = trHorizontal
            PageSize = 30
            Frequency = 1
            Position = 10
            SelEnd = 0
            SelStart = 0
            TabOrder = 6
            ThumbLength = 12
            TickMarks = tmBottomRight
            TickStyle = tsNone
            OnChange = baramun2Change
          end
          object baramun3: TTrackBar
            Left = 288
            Top = 88
            Width = 412
            Height = 20
            Anchors = [akLeft, akTop, akRight]
            Max = 999
            Orientation = trHorizontal
            PageSize = 30
            Frequency = 1
            Position = 10
            SelEnd = 0
            SelStart = 0
            TabOrder = 7
            ThumbLength = 12
            TickMarks = tmBottomRight
            TickStyle = tsNone
            OnChange = baramun3Change
          end
        end
        object GroupBox1: TGroupBox
          Left = 0
          Top = 0
          Width = 777
          Height = 89
          Align = alTop
          Caption = 'Si'#322'y itp.'
          TabOrder = 1
          DesignSize = (
            777
            89)
          object Label9: TLabel
            Left = 8
            Top = 18
            Width = 273
            Height = 13
            AutoSize = False
            Caption = 'pocz'#261'tkowa ilo'#347#263' si'#322'y'
          end
          object Label10: TLabel
            Left = 8
            Top = 66
            Width = 273
            Height = 13
            AutoSize = False
            Caption = 'maksymalna ilo'#347#263' tlenu'
          end
          object Label15: TLabel
            Left = 8
            Top = 42
            Width = 273
            Height = 13
            AutoSize = False
            Caption = 'maksymalna ilo'#347#263' si'#322'y'
          end
          object ustpocsila: TSpinEdit
            Left = 702
            Top = 14
            Width = 64
            Height = 22
            Anchors = [akTop, akRight]
            Color = 13491424
            MaxValue = 999
            MinValue = 10
            TabOrder = 0
            Value = 100
            OnChange = ustpocsilaChange
          end
          object ustmaxtlen: TSpinEdit
            Left = 702
            Top = 62
            Width = 64
            Height = 22
            Anchors = [akTop, akRight]
            Color = 13491424
            MaxValue = 999
            MinValue = 10
            TabOrder = 1
            Value = 100
            OnChange = ustmaxtlenChange
          end
          object ustmaxsily: TSpinEdit
            Left = 702
            Top = 38
            Width = 64
            Height = 22
            Anchors = [akTop, akRight]
            Color = 13491424
            MaxValue = 999
            MinValue = 10
            TabOrder = 2
            Value = 500
            OnChange = ustmaxsilyChange
          end
          object barpocsila: TTrackBar
            Left = 288
            Top = 16
            Width = 412
            Height = 20
            Anchors = [akLeft, akTop, akRight]
            Max = 999
            Min = 10
            Orientation = trHorizontal
            PageSize = 30
            Frequency = 1
            Position = 10
            SelEnd = 0
            SelStart = 0
            TabOrder = 3
            ThumbLength = 12
            TickMarks = tmBottomRight
            TickStyle = tsNone
            OnChange = barpocsilaChange
          end
          object barmaxsily: TTrackBar
            Left = 288
            Top = 40
            Width = 412
            Height = 20
            Anchors = [akLeft, akTop, akRight]
            Max = 999
            Min = 10
            Orientation = trHorizontal
            PageSize = 30
            Frequency = 1
            Position = 10
            SelEnd = 0
            SelStart = 0
            TabOrder = 4
            ThumbLength = 12
            TickMarks = tmBottomRight
            TickStyle = tsNone
            OnChange = barmaxsilyChange
          end
          object barmaxtlen: TTrackBar
            Left = 288
            Top = 64
            Width = 412
            Height = 20
            Anchors = [akLeft, akTop, akRight]
            Max = 999
            Min = 10
            Orientation = trHorizontal
            PageSize = 30
            Frequency = 1
            Position = 10
            SelEnd = 0
            SelStart = 0
            TabOrder = 5
            ThumbLength = 12
            TickMarks = tmBottomRight
            TickStyle = tsNone
            OnChange = barmaxtlenChange
          end
        end
        object GroupBox3: TGroupBox
          Left = 0
          Top = 89
          Width = 777
          Height = 96
          Align = alTop
          Caption = 'W'#322'asno'#347'ci'
          TabOrder = 2
          DesignSize = (
            777
            96)
          object Label11: TLabel
            Left = 8
            Top = 18
            Width = 273
            Height = 13
            AutoSize = False
            Caption = 'szybko'#347#263' poruszania si'#281
          end
          object Label12: TLabel
            Left = 8
            Top = 42
            Width = 273
            Height = 13
            AutoSize = False
            Caption = 'waga'
          end
          object Label13: TLabel
            Left = 8
            Top = 66
            Width = 273
            Height = 13
            AutoSize = False
            Caption = 'si'#322'a bicia i kopania'
          end
          object ustszyb: TSpinEdit
            Left = 702
            Top = 14
            Width = 64
            Height = 22
            Anchors = [akTop, akRight]
            Color = 13491424
            MaxValue = 999
            MinValue = 10
            TabOrder = 0
            Value = 100
            OnChange = ustszybChange
          end
          object ustwaga: TSpinEdit
            Left = 702
            Top = 38
            Width = 64
            Height = 22
            Anchors = [akTop, akRight]
            Color = 13491424
            MaxValue = 999
            MinValue = 10
            TabOrder = 1
            Value = 100
            OnChange = ustwagaChange
          end
          object ustsilabicia: TSpinEdit
            Left = 702
            Top = 62
            Width = 64
            Height = 22
            Anchors = [akTop, akRight]
            Color = 13491424
            MaxValue = 999
            MinValue = 10
            TabOrder = 2
            Value = 100
            OnChange = ustsilabiciaChange
          end
          object barszyb: TTrackBar
            Left = 288
            Top = 16
            Width = 412
            Height = 20
            Anchors = [akLeft, akTop, akRight]
            Max = 999
            Min = 10
            Orientation = trHorizontal
            PageSize = 30
            Frequency = 1
            Position = 10
            SelEnd = 0
            SelStart = 0
            TabOrder = 3
            ThumbLength = 12
            TickMarks = tmBottomRight
            TickStyle = tsNone
            OnChange = barszybChange
          end
          object barwaga: TTrackBar
            Left = 288
            Top = 40
            Width = 412
            Height = 20
            Anchors = [akLeft, akTop, akRight]
            Max = 999
            Min = 10
            Orientation = trHorizontal
            PageSize = 30
            Frequency = 1
            Position = 10
            SelEnd = 0
            SelStart = 0
            TabOrder = 4
            ThumbLength = 12
            TickMarks = tmBottomRight
            TickStyle = tsNone
            OnChange = barwagaChange
          end
          object barsilabicia: TTrackBar
            Left = 288
            Top = 64
            Width = 412
            Height = 20
            Anchors = [akLeft, akTop, akRight]
            Max = 999
            Min = 10
            Orientation = trHorizontal
            PageSize = 30
            Frequency = 1
            Position = 10
            SelEnd = 0
            SelStart = 0
            TabOrder = 5
            ThumbLength = 12
            TickMarks = tmBottomRight
            TickStyle = tsNone
            OnChange = barsilabiciaChange
          end
        end
        object Kolory: TGroupBox
          Left = 0
          Top = 306
          Width = 777
          Height = 45
          Align = alTop
          Caption = 'Kolory'
          TabOrder = 3
          DesignSize = (
            777
            45)
          object Label14: TLabel
            Left = 8
            Top = 18
            Width = 537
            Height = 13
            Anchors = [akLeft, akTop, akRight]
            AutoSize = False
            Caption = 'kolor krwi'
          end
          object nkolorkrwi: TShape
            Left = 552
            Top = 10
            Width = 179
            Height = 30
            Anchors = [akTop, akRight]
            Brush.Color = 187
            OnMouseUp = nkolorkrwiMouseUp
          end
          object zmienkolorkrwi: TSpeedButton
            Left = 738
            Top = 16
            Width = 25
            Height = 17
            Anchors = [akTop, akRight]
            Caption = '>>'
            Flat = True
            OnClick = zmienkolorkrwiClick
          end
        end
      end
    end
    object Wyglad: TTabSheet
      Caption = 'Wygl'#261'd postaci'
      ImageIndex = 2
      object obrterenu: TImage
        Left = 152
        Top = 8
        Width = 105
        Height = 105
        Visible = False
      end
      object Splitter3: TSplitter
        Left = 233
        Top = 34
        Width = 3
        Height = 495
        Cursor = crHSplit
        AutoSnap = False
        Beveled = True
        MinSize = 210
        ResizeStyle = rsUpdate
        OnCanResize = Splitter3CanResize
        OnMoved = Splitter3Moved
      end
      object Panel7: TPanel
        Left = 0
        Top = 0
        Width = 781
        Height = 34
        Align = alTop
        TabOrder = 0
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
        object klatkapop: TSpeedButton
          Left = 322
          Top = 4
          Width = 30
          Height = 25
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Glyph.Data = {
            76040000424D7604000000000000360000002800000016000000100000000100
            18000000000040040000120B0000120B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            0000FF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000FF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FF0000FF00FFFF00FFFF00FFFF00FF0000000000000000000000000000
            00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FF0000FF00FFFF00FFFF00FF00000000000000000000000000
            0000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FF00FF0000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000FF00
            FF00000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000FF00FFFF00FF000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000FF00FFFF00FFFF00FF0000000000000000000000000000000000
            00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FF00000000000000000000
            0000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FF000000
            000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
          Layout = blGlyphTop
          ParentFont = False
          OnClick = klatkapopClick
        end
        object klatkanast: TSpeedButton
          Left = 453
          Top = 4
          Width = 30
          Height = 25
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Glyph.Data = {
            76040000424D7604000000000000360000002800000016000000100000000100
            18000000000040040000120B0000120B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FF000000000000000000000000FF00FFFF00FFFF00FFFF00
            FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000FF00FFFF
            00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000
            000000FF00FFFF00FFFF00FF0000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000FF00FFFF00FF00000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000FF00FF000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000FF00FF
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000FF00
            FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000000000FF
            00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000
            FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000
            00FF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000
            0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
            000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
          Layout = blGlyphTop
          ParentFont = False
          OnClick = klatkanastClick
        end
        object aniodtworz: TSpeedButton
          Left = 485
          Top = 4
          Width = 30
          Height = 25
          Hint = 'Odtw'#243'rz/zatrzymaj'
          AllowAllUp = True
          GroupIndex = 2
          Caption = '4'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Marlett'
          Font.Style = []
          Layout = blGlyphTop
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = aniodtworzClick
        end
        object zoombar: TTrackBar
          Left = 129
          Top = 2
          Width = 193
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
        object klatki: TStaticText
          Left = 354
          Top = 8
          Width = 97
          Height = 17
          Alignment = taCenter
          AutoSize = False
          BorderStyle = sbsSunken
          TabOrder = 1
        end
        object aniszybk: TTrackBar
          Left = 516
          Top = 2
          Width = 141
          Height = 30
          Max = 40
          Min = 1
          Orientation = trHorizontal
          PageSize = 50
          Frequency = 1
          Position = 1
          SelEnd = 0
          SelStart = 0
          TabOrder = 2
          ThumbLength = 14
          TickMarks = tmBoth
          TickStyle = tsAuto
          OnChange = aniszybkChange
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 34
        Width = 233
        Height = 495
        Align = alLeft
        TabOrder = 2
        object Splitter4: TSplitter
          Left = 1
          Top = 92
          Width = 231
          Height = 2
          Cursor = crVSplit
          Align = alBottom
          AutoSnap = False
          ResizeStyle = rsUpdate
        end
        object Panel2: TPanel
          Left = 1
          Top = 1
          Width = 231
          Height = 16
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Dost'#281'pne animacje:'
          TabOrder = 0
        end
        object Listaanimacji: TScrollBox
          Left = 1
          Top = 17
          Width = 231
          Height = 75
          HorzScrollBar.Smooth = True
          HorzScrollBar.Tracking = True
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alClient
          TabOrder = 1
        end
        object skrolparametry: TScrollBox
          Left = 1
          Top = 94
          Width = 231
          Height = 400
          HorzScrollBar.Smooth = True
          HorzScrollBar.Tracking = True
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alBottom
          TabOrder = 2
          object Panel3: TPanel
            Left = 0
            Top = 176
            Width = 214
            Height = 105
            Align = alTop
            BevelInner = bvLowered
            BevelOuter = bvSpace
            TabOrder = 0
            DesignSize = (
              211
              105)
            object pok_bom: TSpeedButton
              Left = 2
              Top = 18
              Width = 207
              Height = 22
              AllowAllUp = True
              Anchors = [akLeft, akTop, akRight]
              GroupIndex = 3
              Caption = 'Poka'#380' pozycj'#281' za'#322'o'#380'onej bomby'
              Flat = True
              OnClick = pok_bomClick
            end
            object StaticText3: TStaticText
              Left = 2
              Top = 41
              Width = 39
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'X='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object pok_bom_x: TEdit
              Tag = 3
              Left = 48
              Top = 41
              Width = 161
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object StaticText4: TStaticText
              Left = 2
              Top = 61
              Width = 39
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'Y='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
            end
            object pok_bom_y: TEdit
              Tag = 4
              Left = 48
              Top = 61
              Width = 161
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 3
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object pok_bom_kat: TEdit
              Tag = 5
              Left = 48
              Top = 81
              Width = 161
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 4
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object StaticText5: TStaticText
              Left = 2
              Top = 81
              Width = 39
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'k'#261't='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 5
            end
            object StaticText13: TStaticText
              Left = 2
              Top = 2
              Width = 207
              Height = 15
              Align = alTop
              Alignment = taCenter
              AutoSize = False
              Caption = 'Miejsce za'#322'o'#380'onej bomby na cia'#322'o'
              Color = clBtnShadow
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentColor = False
              ParentFont = False
              TabOrder = 6
            end
          end
          object Panel4: TPanel
            Left = 0
            Top = 28
            Width = 211
            Height = 148
            Align = alTop
            BevelInner = bvLowered
            BevelOuter = bvSpace
            TabOrder = 1
            DesignSize = (
              211
              148)
            object pok_wekt: TSpeedButton
              Left = 2
              Top = 18
              Width = 207
              Height = 22
              AllowAllUp = True
              Anchors = [akLeft, akTop, akRight]
              GroupIndex = 3
              Caption = 'Poka'#380' wektor uderzenia'
              Flat = True
              OnClick = pok_wektClick
            end
            object zatwierdz_wekt: TSpeedButton
              Left = 2
              Top = 123
              Width = 207
              Height = 22
              AllowAllUp = True
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Zatwierd'#378' ustawienia wektora'
              Flat = True
              Glyph.Data = {
                9A050000424D9A0500000000000036000000280000001E0000000F0000000100
                18000000000064050000120B0000120B00000000000000000000FF00FFFF00FF
                FF00FFFF00FFFF00FF00520A004408FF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9A9A9A9E9E9EFF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF
                00FFFF00FF005B0B004B09FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF9898989D9D9DFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FF0079
                0E006F0D005C0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
                00FFFF00FFFF00FFFF00FF909090949494999999FF00FFFF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FF009B12009912FF00FF
                007B0E005D0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FF8B8B8B898989FF00FF909090979797FF00FFFF00FFFF00FFFF00FFFF
                00FFFF00FFFF00FF0000FF00FFFF00FF17AB2828B1382AB23AFF00FF01A31400
                7F0FFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF898989
                7E7E7E737373FF00FF7D7D7D909090FF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FF00002AB23A34B64346BC5453C160FF00FFFF00FFFF00FF00A3130079
                0EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7272727676767474746B6B6BFF
                00FFFF00FFFF00FF868686959595FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                000055C2625DC56963C76FFF00FFFF00FFFF00FFFF00FF30B43F009712FF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FF5A5A5A5959595C5C5CFF00FFFF00FFFF00
                FFFF00FF6E6E6E8E8E8EFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF1BAD2C008810FF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                FF00FF7D7D7D949494FF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF46BC540DA81F00800FFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF63
                6363878787959595FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FF3FBA4D02A415FF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6868
                688B8B8BFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FF32B541009D12FF00FFFF00FFFF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6F6F6F
                8E8E8EFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FF2EB43E00A01300800FFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF7070708D
                8D8D969696FF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FF37B74608A61A008B10FF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6C6C6C8787
                879191910000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FF37B7460DA81FFF00FFFF00FFFF00FFFF00FFFF
                00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF6868687E7E7E
                0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
                FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
                FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
              NumGlyphs = 2
              OnClick = zatwierdz_wektClick
            end
            object pok_wekt_dx: TEdit
              Left = 64
              Top = 42
              Width = 145
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object pok_wekt_dy: TEdit
              Tag = 1
              Left = 64
              Top = 62
              Width = 145
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object StaticText1: TStaticText
              Left = 2
              Top = 42
              Width = 60
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'DX='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
            end
            object StaticText2: TStaticText
              Left = 2
              Top = 62
              Width = 60
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'DY='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
            end
            object pok_wekt_sila: TEdit
              Tag = 2
              Left = 64
              Top = 82
              Width = 145
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              Enabled = False
              TabOrder = 4
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object StaticText6: TStaticText
              Left = 2
              Top = 82
              Width = 60
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'si'#322'a='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 5
            end
            object pok_wekt_klatka: TEdit
              Tag = 6
              Left = 64
              Top = 102
              Width = 145
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 6
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object StaticText7: TStaticText
              Left = 2
              Top = 102
              Width = 60
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'klatka='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 7
            end
            object StaticText14: TStaticText
              Left = 2
              Top = 2
              Width = 207
              Height = 15
              Align = alTop
              Alignment = taCenter
              AutoSize = False
              Caption = 'Wektor uderzenia'
              Color = clBtnShadow
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentColor = False
              ParentFont = False
              TabOrder = 8
            end
          end
          object Panel9: TPanel
            Left = 0
            Top = 0
            Width = 211
            Height = 28
            Align = alTop
            BevelInner = bvLowered
            BevelOuter = bvSpace
            TabOrder = 2
            DesignSize = (
              211
              28)
            object StaticText8: TStaticText
              Left = 2
              Top = 3
              Width = 143
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'szybko'#347#263' animacji='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object ani_szybk: TEdit
              Tag = 7
              Left = 144
              Top = 3
              Width = 65
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
          end
          object panel_stoi: TPanel
            Left = 0
            Top = 386
            Width = 211
            Height = 104
            Align = alTop
            BevelInner = bvLowered
            BevelOuter = bvSpace
            TabOrder = 3
            DesignSize = (
              211
              104)
            object stoi_dod: TSpeedButton
              Left = 133
              Top = 67
              Width = 75
              Height = 22
              AllowAllUp = True
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Dodaj animacj'#281
              Flat = True
              OnClick = stoi_dodClick
            end
            object stoi_usun: TSpeedButton
              Left = 87
              Top = 67
              Width = 45
              Height = 22
              AllowAllUp = True
              Caption = 'Usu'#324' t'#281
              Flat = True
              OnClick = stoi_usunClick
            end
            object stoi_nast: TSpeedButton
              Left = 66
              Top = 67
              Width = 19
              Height = 22
              AllowAllUp = True
              Caption = '4'
              Flat = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Marlett'
              Font.Style = []
              ParentFont = False
              OnClick = stoi_nastClick
            end
            object stoi_pop: TSpeedButton
              Left = 4
              Top = 67
              Width = 19
              Height = 22
              AllowAllUp = True
              Caption = '3'
              Flat = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Marlett'
              Font.Style = []
              ParentFont = False
              OnClick = stoi_popClick
            end
            object stoi_od_wez: TSpeedButton
              Tag = 8
              Left = 96
              Top = 18
              Width = 16
              Height = 21
              AllowAllUp = True
              Caption = '7'
              Flat = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Marlett'
              Font.Style = []
              ParentFont = False
              OnClick = stoi_od_wezClick
            end
            object stoi_ile_wez: TSpeedButton
              Tag = 9
              Left = 192
              Top = 18
              Width = 16
              Height = 21
              AllowAllUp = True
              Anchors = [akTop, akRight]
              Caption = '7'
              Flat = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -13
              Font.Name = 'Marlett'
              Font.Style = []
              ParentFont = False
              OnClick = stoi_ile_wezClick
            end
            object stoi_play: TSpeedButton
              Left = 177
              Top = 41
              Width = 30
              Height = 22
              AllowAllUp = True
              Anchors = [akTop, akRight]
              GroupIndex = 5
              Caption = '4'
              Flat = True
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -17
              Font.Name = 'Marlett'
              Font.Style = []
              ParentFont = False
              OnClick = stoi_playClick
            end
            object StaticText9: TStaticText
              Left = 2
              Top = 18
              Width = 63
              Height = 21
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'od klatki='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object stoi_od: TEdit
              Tag = 8
              Left = 66
              Top = 18
              Width = 30
              Height = 21
              TabOrder = 1
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object stoi_ile: TEdit
              Tag = 9
              Left = 162
              Top = 18
              Width = 31
              Height = 21
              Anchors = [akTop, akRight]
              TabOrder = 2
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object StaticText10: TStaticText
              Left = 114
              Top = 18
              Width = 47
              Height = 21
              Alignment = taRightJustify
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'ile klatek='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
            end
            object StaticText11: TStaticText
              Left = 2
              Top = 42
              Width = 71
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'szybko'#347#263'='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 4
            end
            object stoi_szyb: TEdit
              Tag = 10
              Left = 74
              Top = 42
              Width = 41
              Height = 21
              TabOrder = 5
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object stoi_zapetl: TCheckBox
              Left = 120
              Top = 44
              Width = 57
              Height = 17
              Anchors = [akLeft, akTop, akRight]
              Caption = 'Zap'#281'tlone'
              TabOrder = 6
              OnClick = stoi_zapetlClick
            end
            object StaticText12: TStaticText
              Left = 2
              Top = 2
              Width = 207
              Height = 15
              Align = alTop
              Alignment = taCenter
              AutoSize = False
              Caption = 'Animacja postaci, gdy stoi (nudzi si'#281')'
              Color = clBtnShadow
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentColor = False
              ParentFont = False
              TabOrder = 7
            end
            object stoi_licznik: TStaticText
              Left = 24
              Top = 67
              Width = 41
              Height = 22
              Alignment = taCenter
              AutoSize = False
              BorderStyle = sbsSunken
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 8
            end
          end
          object Panel12: TPanel
            Left = 0
            Top = 281
            Width = 211
            Height = 105
            Align = alTop
            BevelInner = bvLowered
            BevelOuter = bvSpace
            TabOrder = 4
            DesignSize = (
              211
              105)
            object pok_bron: TSpeedButton
              Left = 2
              Top = 18
              Width = 207
              Height = 22
              AllowAllUp = True
              Anchors = [akLeft, akTop, akRight]
              GroupIndex = 3
              Caption = 'Poka'#380' pozycj'#281' trzymanej broni'
              Flat = True
              OnClick = pok_bronClick
            end
            object StaticText17: TStaticText
              Left = 2
              Top = 41
              Width = 39
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'X='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 0
            end
            object pok_bron_x: TEdit
              Tag = 11
              Left = 48
              Top = 41
              Width = 161
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object StaticText23: TStaticText
              Left = 2
              Top = 61
              Width = 39
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'Y='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
            end
            object pok_bron_y: TEdit
              Tag = 12
              Left = 48
              Top = 61
              Width = 161
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 3
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
            object StaticText25: TStaticText
              Left = 2
              Top = 2
              Width = 207
              Height = 15
              Align = alTop
              Alignment = taCenter
              AutoSize = False
              Caption = 'Miejsce dla trzymanej broni'
              Color = clBtnShadow
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentColor = False
              ParentFont = False
              TabOrder = 4
            end
            object StaticText26: TStaticText
              Left = 2
              Top = 81
              Width = 39
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'k'#261't='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 5
            end
            object pok_bron_kat: TEdit
              Tag = 5
              Left = 48
              Top = 81
              Width = 161
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 6
              OnExit = pok_wekt_dxExit
              OnKeyPress = pok_wekt_dxKeyPress
            end
          end
        end
      end
      object skrolpodglad: TScrollBox
        Left = 236
        Top = 34
        Width = 545
        Height = 493
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 1
        object podgani: TPaintBox
          Left = 0
          Top = 0
          Width = 541
          Height = 491
          Cursor = crCross
          Align = alClient
          OnMouseDown = podganiMouseDown
          OnMouseMove = podganiMouseMove
          OnMouseUp = podganiMouseUp
          OnPaint = podganiPaint
        end
      end
    end
    object miesotab: TTabSheet
      Caption = 'Mi'#281'sko'
      ImageIndex = 5
      object mies_Splitter3: TSplitter
        Left = 233
        Top = 34
        Width = 3
        Height = 495
        Cursor = crHSplit
        AutoSnap = False
        Beveled = True
        MinSize = 210
        ResizeStyle = rsUpdate
      end
      object mies_Panel7: TPanel
        Left = 0
        Top = 0
        Width = 781
        Height = 34
        Align = alTop
        TabOrder = 0
        object mies_zoomin: TSpeedButton
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
          OnClick = mies_zoominClick
        end
        object mies_zoomout: TSpeedButton
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
          OnClick = mies_zoomoutClick
        end
        object mies_zoom100: TSpeedButton
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
          OnClick = mies_zoom100Click
        end
        object mies_zoomcale: TSpeedButton
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
          OnClick = mies_zoomcaleClick
        end
        object mies_klatkapop: TSpeedButton
          Left = 322
          Top = 4
          Width = 30
          Height = 25
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Glyph.Data = {
            76040000424D7604000000000000360000002800000016000000100000000100
            18000000000040040000120B0000120B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000FF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            0000FF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000FF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FF0000FF00FFFF00FFFF00FFFF00FF0000000000000000000000000000
            00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FF0000FF00FFFF00FFFF00FF00000000000000000000000000
            0000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FF000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000FF00FF0000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000FF00
            FF00000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000FF00FFFF00FF000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000FF00FFFF00FFFF00FF0000000000000000000000000000000000
            00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FF00000000000000000000
            0000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FF000000
            000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
          Layout = blGlyphTop
          ParentFont = False
          OnClick = mies_klatkapopClick
        end
        object mies_klatkanast: TSpeedButton
          Left = 453
          Top = 4
          Width = 30
          Height = 25
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          Glyph.Data = {
            76040000424D7604000000000000360000002800000016000000100000000100
            18000000000040040000120B0000120B00000000000000000000FF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FF000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FF000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FF000000000000000000000000FF00FFFF00FFFF00FFFF00
            FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000FF00FFFF
            00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000
            000000FF00FFFF00FFFF00FF0000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            00000000000000000000FF00FFFF00FF00000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000FF00FF000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000FF00FF
            0000000000000000000000000000000000000000000000000000000000000000
            000000000000000000000000000000000000000000000000000000000000FF00
            FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000000000FF
            00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000000000000000000000000000
            FF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000
            00FF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF00000000000000
            0000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000FF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000
            000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000}
          Layout = blGlyphTop
          ParentFont = False
          OnClick = mies_klatkanastClick
        end
        object mies_aniodtworz: TSpeedButton
          Left = 485
          Top = 4
          Width = 30
          Height = 25
          Hint = 'Odtw'#243'rz/zatrzymaj'
          AllowAllUp = True
          GroupIndex = 2
          Caption = '4'
          Flat = True
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -28
          Font.Name = 'Marlett'
          Font.Style = []
          Layout = blGlyphTop
          ParentFont = False
          ParentShowHint = False
          ShowHint = True
          OnClick = mies_aniodtworzClick
        end
        object mies_zoombar: TTrackBar
          Left = 129
          Top = 2
          Width = 193
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
          OnChange = mies_zoombarChange
        end
        object mies_klatki: TStaticText
          Left = 354
          Top = 8
          Width = 97
          Height = 17
          Alignment = taCenter
          AutoSize = False
          BorderStyle = sbsSunken
          TabOrder = 1
        end
        object mies_aniszybk: TTrackBar
          Left = 516
          Top = 2
          Width = 141
          Height = 30
          Max = 40
          Min = 1
          Orientation = trHorizontal
          PageSize = 50
          Frequency = 1
          Position = 1
          SelEnd = 0
          SelStart = 0
          TabOrder = 2
          ThumbLength = 14
          TickMarks = tmBoth
          TickStyle = tsAuto
          OnChange = mies_aniszybkChange
        end
      end
      object mies_Panel1: TPanel
        Left = 0
        Top = 34
        Width = 233
        Height = 495
        Align = alLeft
        TabOrder = 1
        object mies_Splitter4: TSplitter
          Left = 1
          Top = 97
          Width = 231
          Height = 2
          Cursor = crVSplit
          Align = alBottom
          AutoSnap = False
          ResizeStyle = rsUpdate
        end
        object mies_Panel2: TPanel
          Left = 1
          Top = 1
          Width = 231
          Height = 16
          Align = alTop
          BevelOuter = bvNone
          Caption = 'Dost'#281'pne cz'#281#347'ci mi'#281'ska:'
          TabOrder = 0
        end
        object mies_Listaanimacji: TScrollBox
          Left = 1
          Top = 17
          Width = 231
          Height = 80
          HorzScrollBar.Smooth = True
          HorzScrollBar.Tracking = True
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alClient
          TabOrder = 1
        end
        object mies_skrolparametry: TScrollBox
          Left = 1
          Top = 99
          Width = 231
          Height = 395
          HorzScrollBar.Smooth = True
          HorzScrollBar.Tracking = True
          VertScrollBar.Smooth = True
          VertScrollBar.Tracking = True
          Align = alBottom
          TabOrder = 2
          object mies_Panel4: TPanel
            Left = 0
            Top = 248
            Width = 227
            Height = 68
            Align = alTop
            BevelInner = bvLowered
            BevelOuter = bvSpace
            TabOrder = 0
            DesignSize = (
              227
              68)
            object mies_widok_1: TSpeedButton
              Left = 2
              Top = 18
              Width = 222
              Height = 22
              Anchors = [akLeft, akTop, akRight]
              GroupIndex = 6
              Down = True
              Caption = 'Pojedyncze kawa'#322'ki mi'#281'sa'
              Flat = True
              OnClick = mies_widok_1Click
            end
            object mies_widok_2: TSpeedButton
              Left = 2
              Top = 42
              Width = 222
              Height = 22
              Anchors = [akLeft, akTop, akRight]
              GroupIndex = 6
              Caption = 'Ca'#322'o'#347#263
              Flat = True
              OnClick = mies_widok_2Click
            end
            object mies_StaticText14: TStaticText
              Left = 2
              Top = 2
              Width = 223
              Height = 15
              Align = alTop
              Alignment = taCenter
              AutoSize = False
              Caption = 'Widok'
              Color = clBtnShadow
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentColor = False
              ParentFont = False
              TabOrder = 0
            end
          end
          object Panel10: TPanel
            Left = 0
            Top = 164
            Width = 227
            Height = 84
            Align = alTop
            BevelInner = bvLowered
            BevelOuter = bvSpace
            TabOrder = 1
            DesignSize = (
              227
              84)
            object mies_wym: TEdit
              Tag = 3
              Left = 168
              Top = 18
              Width = 57
              Height = 21
              Anchors = [akTop, akRight]
              TabOrder = 0
              OnExit = mies_miejs_xExit
              OnKeyPress = mies_miejs_xKeyPress
            end
            object mies_wym_y: TEdit
              Tag = 5
              Left = 80
              Top = 38
              Width = 49
              Height = 21
              Enabled = False
              TabOrder = 1
              OnExit = mies_miejs_xExit
              OnKeyPress = mies_miejs_xKeyPress
            end
            object StaticText15: TStaticText
              Left = 2
              Top = 18
              Width = 164
              Height = 20
              Alignment = taRightJustify
              Anchors = [akLeft, akTop, akRight]
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'wys/szer w pixelach='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
            end
            object StaticText16: TStaticText
              Left = 56
              Top = 38
              Width = 25
              Height = 20
              Alignment = taCenter
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'x'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
            end
            object StaticText18: TStaticText
              Left = 2
              Top = 2
              Width = 223
              Height = 15
              Align = alTop
              Alignment = taCenter
              AutoSize = False
              Caption = 'Rozmiar jednej klatki animacji'
              Color = clBtnShadow
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentColor = False
              ParentFont = False
              TabOrder = 4
            end
            object mies_wym_x: TEdit
              Tag = 4
              Left = 2
              Top = 38
              Width = 55
              Height = 21
              Enabled = False
              TabOrder = 5
              OnExit = mies_miejs_xExit
              OnKeyPress = mies_miejs_xKeyPress
            end
            object mies_ileklatek: TEdit
              Tag = 6
              Left = 108
              Top = 58
              Width = 117
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 6
              OnExit = mies_miejs_xExit
              OnKeyPress = mies_miejs_xKeyPress
            end
            object StaticText24: TStaticText
              Left = 2
              Top = 58
              Width = 103
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'ilo'#347#263' klatek='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 7
            end
          end
          object Panel11: TPanel
            Left = 0
            Top = 0
            Width = 227
            Height = 164
            Align = alTop
            BevelInner = bvLowered
            BevelOuter = bvSpace
            TabOrder = 2
            DesignSize = (
              227
              164)
            object mies_miejs_x: TEdit
              Left = 127
              Top = 18
              Width = 98
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 0
              OnExit = mies_miejs_xExit
              OnKeyPress = mies_miejs_xKeyPress
            end
            object mies_miejs_y: TEdit
              Tag = 1
              Left = 127
              Top = 38
              Width = 98
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 1
              OnExit = mies_miejs_xExit
              OnKeyPress = mies_miejs_xKeyPress
            end
            object StaticText19: TStaticText
              Left = 2
              Top = 18
              Width = 125
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'X='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 2
            end
            object StaticText20: TStaticText
              Left = 2
              Top = 38
              Width = 125
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'Y='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 3
            end
            object mies_miejs_kl: TEdit
              Tag = 2
              Left = 127
              Top = 58
              Width = 98
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 4
              OnExit = mies_miejs_xExit
              OnKeyPress = mies_miejs_xKeyPress
            end
            object StaticText21: TStaticText
              Left = 2
              Top = 58
              Width = 125
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'klatka='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 5
            end
            object StaticText22: TStaticText
              Left = 2
              Top = 2
              Width = 223
              Height = 15
              Align = alTop
              Alignment = taCenter
              AutoSize = False
              Caption = 'Pocz'#261'tkowa pozycja po '#347'mierci'
              Color = clBtnShadow
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentColor = False
              ParentFont = False
              TabOrder = 6
            end
            object StaticText27: TStaticText
              Left = 2
              Top = 78
              Width = 125
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'k'#261't='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 7
            end
            object mies_miejs_kat: TEdit
              Tag = 2
              Left = 127
              Top = 78
              Width = 98
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              Enabled = False
              TabOrder = 8
              OnExit = mies_miejs_xExit
              OnKeyPress = mies_miejs_xKeyPress
            end
            object StaticText28: TStaticText
              Left = 2
              Top = 98
              Width = 125
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'odleg'#322'o'#347#263'='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 9
            end
            object mies_miejs_odl: TEdit
              Tag = 2
              Left = 127
              Top = 98
              Width = 98
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              Enabled = False
              TabOrder = 10
              OnExit = mies_miejs_xExit
              OnKeyPress = mies_miejs_xKeyPress
            end
            object mies_miejs_zaczx: TEdit
              Tag = 7
              Left = 127
              Top = 118
              Width = 98
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 11
              OnExit = mies_miejs_xExit
              OnKeyPress = mies_miejs_xKeyPress
            end
            object StaticText29: TStaticText
              Left = 2
              Top = 118
              Width = 125
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'pkt.zaczepienia X='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 12
            end
            object mies_miejs_zaczy: TEdit
              Tag = 8
              Left = 127
              Top = 138
              Width = 98
              Height = 21
              Anchors = [akLeft, akTop, akRight]
              TabOrder = 13
              OnExit = mies_miejs_xExit
              OnKeyPress = mies_miejs_xKeyPress
            end
            object StaticText30: TStaticText
              Left = 2
              Top = 138
              Width = 125
              Height = 20
              Alignment = taRightJustify
              AutoSize = False
              BorderStyle = sbsSunken
              Caption = 'pkt.zaczepienia Y='
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clWindowText
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = [fsBold]
              ParentFont = False
              TabOrder = 14
            end
          end
        end
      end
      object mies_skrolpodglad: TScrollBox
        Left = 236
        Top = 34
        Width = 545
        Height = 493
        HorzScrollBar.Tracking = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 2
        object mies_podgani: TPaintBox
          Left = 0
          Top = 0
          Width = 541
          Height = 491
          Cursor = crCross
          Align = alClient
          OnMouseDown = mies_podganiMouseDown
          OnMouseMove = mies_podganiMouseMove
          OnMouseUp = podganiMouseUp
          OnPaint = mies_podganiPaint
        end
      end
    end
    object Dzwieki: TTabSheet
      Caption = 'D'#378'wi'#281'ki'
      ImageIndex = 4
      object skroldzwieki: TScrollBox
        Left = 0
        Top = 0
        Width = 781
        Height = 529
        HorzScrollBar.Smooth = True
        HorzScrollBar.Tracking = True
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
        DesignSize = (
          777
          523)
        object dzwiekistop: TButton
          Left = 528
          Top = 344
          Width = 209
          Height = 21
          Anchors = [akTop, akRight]
          Caption = 'Zatrzymaj d'#378'wi'#281'ki'
          TabOrder = 0
          OnClick = dzwiekistopClick
        end
      end
    end
    object dymkitab: TTabSheet
      Caption = 'Dymki'
      ImageIndex = 6
      object skroldymki: TScrollBox
        Left = 0
        Top = 0
        Width = 781
        Height = 529
        HorzScrollBar.Smooth = True
        HorzScrollBar.Tracking = True
        VertScrollBar.Smooth = True
        VertScrollBar.Tracking = True
        Align = alClient
        TabOrder = 0
      end
    end
    object oprogramie: TTabSheet
      Caption = 'O programie'
      ImageIndex = 4
      object tekstoprogramie: TStaticText
        Left = 0
        Top = 0
        Width = 781
        Height = 527
        Align = alClient
        Alignment = taCenter
        AutoSize = False
        BorderStyle = sbsSunken
        Caption = 
          'Sadist 3 - Edytor postaci'#13#10'wersja 0.1'#13#10#13#10'autor: Grzegorz "GAD" D' +
          'rozd'#13#10'gad@gad.art.pl'#13#10'http://sadist.art.pl/'
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
  object ikonki: TImageList
    Height = 32
    Width = 32
    Left = 559
    Top = 396
  end
  object ColorDialog1: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen]
    Left = 558
    Top = 432
  end
  object OpenDialogwav: TOpenDialog
    DefaultExt = 'wav'
    Filter = 'Pliki WAV|*.wav'
    InitialDir = '.'
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofNoTestFileCreate, ofEnableSizing]
    Title = 'Wybierz plik d'#378'wi'#281'kowy'
    Left = 527
    Top = 445
  end
  object Timerani: TTimer
    Enabled = False
    Interval = 60
    OnTimer = TimeraniTimer
    Left = 258
    Top = 460
  end
  object OpenDialogtga: TOpenDialog
    DefaultExt = 'tga'
    Filter = 'Pliki TGA|*.tga'
    InitialDir = '.'
    Options = [ofHideReadOnly, ofNoChangeDir, ofPathMustExist, ofFileMustExist, ofNoTestFileCreate, ofEnableSizing]
    Title = 'Wybierz grafik'#281' TGA'
    Left = 527
    Top = 413
  end
  object mies_Timerani: TTimer
    Enabled = False
    Interval = 15
    OnTimer = mies_TimeraniTimer
    Left = 466
    Top = 460
  end
end
