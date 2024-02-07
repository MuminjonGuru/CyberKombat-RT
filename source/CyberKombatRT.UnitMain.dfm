object FormMain: TFormMain
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'CyberKombat RT'
  ClientHeight = 680
  ClientWidth = 1040
  Color = clBtnFace
  CustomTitleBar.CaptionAlignment = taCenter
  CustomTitleBar.Enabled = True
  CustomTitleBar.Height = 38
  CustomTitleBar.BackgroundColor = 11625216
  CustomTitleBar.ForegroundColor = clWhite
  CustomTitleBar.InactiveBackgroundColor = clWhite
  CustomTitleBar.InactiveForegroundColor = 10066329
  CustomTitleBar.ButtonForegroundColor = clWhite
  CustomTitleBar.ButtonBackgroundColor = 11625216
  CustomTitleBar.ButtonHoverForegroundColor = clWhite
  CustomTitleBar.ButtonHoverBackgroundColor = 8801024
  CustomTitleBar.ButtonPressedForegroundColor = clWhite
  CustomTitleBar.ButtonPressedBackgroundColor = 4663296
  CustomTitleBar.ButtonInactiveForegroundColor = 10066329
  CustomTitleBar.ButtonInactiveBackgroundColor = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 38
  Position = poDesktopCenter
  StyleElements = [seFont, seClient]
  OnCreate = FormCreate
  TextHeight = 25
  object StatusBar1: TStatusBar
    Left = 0
    Top = 640
    Width = 1040
    Height = 40
    Panels = <
      item
        Alignment = taCenter
        Text = 'Status: Running'
        Width = 110
      end
      item
        Text = 'Connection: Down'
        Width = 140
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1040
    Height = 640
    ActivePage = TabSheet5
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Dashboard'
    end
    object TabSheet2: TTabSheet
      Caption = 'File | Reg Manager'
      ImageIndex = 1
    end
    object TabSheet3: TTabSheet
      Caption = 'ClamAV'
      ImageIndex = 2
    end
    object TabSheet4: TTabSheet
      Caption = 'Network Manager'
      ImageIndex = 3
      object LblNetworkActivity: TLabel
        Left = 20
        Top = 27
        Width = 199
        Height = 31
        Caption = 'Network Activity '#11015#65039'  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object MemoNetworkActivity: TMemo
        Left = 20
        Top = 80
        Width = 305
        Height = 401
        BevelInner = bvSpace
        BevelKind = bkSoft
        DragCursor = crHandPoint
        EditMargins.Left = 1
        EditMargins.Right = 1
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Web Shield'
      ImageIndex = 4
      object LEditURL: TLabeledEdit
        Left = 20
        Top = 80
        Width = 789
        Height = 33
        EditLabel.Width = 73
        EditLabel.Height = 25
        EditLabel.Caption = 'Scan URL'
        TabOrder = 0
        Text = ''
        TextHint = 'https://example.com'
      end
      object BtnURLScanVT: TButton
        Left = 815
        Top = 80
        Width = 114
        Height = 33
        Caption = 'Analyse'
        TabOrder = 1
        OnClick = BtnURLScanVTClick
      end
      object MemoURLCheckLog: TMemo
        Left = 20
        Top = 119
        Width = 980
        Height = 150
        BevelInner = bvSpace
        BevelKind = bkSoft
        DragCursor = crHandPoint
        EditMargins.Left = 1
        EditMargins.Right = 1
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Consolas'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 2
      end
      object Button1: TButton
        Left = 935
        Top = 80
        Width = 65
        Height = 33
        Caption = 'Log'
        TabOrder = 3
        OnClick = Button1Click
      end
    end
  end
  object PythonEngineNetworkActivity: TPythonEngine
    IO = PythonGUIInputOutputNA
    Left = 162
    Top = 315
  end
  object PythonGUIInputOutputNA: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Output = MemoNetworkActivity
    Left = 163
    Top = 380
  end
  object TimerNetworkActivity: TTimer
    Interval = 20000
    OnTimer = TimerNetworkActivityTimer
    Left = 168
    Top = 444
  end
end
