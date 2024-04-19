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
  CustomTitleBar.BackgroundColor = clWhite
  CustomTitleBar.ForegroundColor = 65793
  CustomTitleBar.InactiveBackgroundColor = clWhite
  CustomTitleBar.InactiveForegroundColor = 10066329
  CustomTitleBar.ButtonForegroundColor = 65793
  CustomTitleBar.ButtonBackgroundColor = clWhite
  CustomTitleBar.ButtonHoverForegroundColor = 65793
  CustomTitleBar.ButtonHoverBackgroundColor = 16053492
  CustomTitleBar.ButtonPressedForegroundColor = 65793
  CustomTitleBar.ButtonPressedBackgroundColor = 15395562
  CustomTitleBar.ButtonInactiveForegroundColor = 10066329
  CustomTitleBar.ButtonInactiveBackgroundColor = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  GlassFrame.Enabled = True
  GlassFrame.Top = 38
  Position = poScreenCenter
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
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Dashboard'
      object MemoScanList: TMemo
        Left = 16
        Top = 367
        Width = 400
        Height = 150
        BevelInner = bvNone
        BevelOuter = bvRaised
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsItalic]
        Lines.Strings = (
          'C:/Users/user/Downloads/Documents'
          'C:/Users/user/Downloads/Compressed')
        ParentFont = False
        TabOrder = 0
      end
      object BtnUpdateDaemon: TButton
        Left = 879
        Top = 367
        Width = 148
        Height = 29
        Caption = 'Update'
        TabOrder = 1
        OnClick = BtnUpdateDaemonClick
      end
      object BtnScanDaemonStart: TButton
        Left = 881
        Top = 429
        Width = 148
        Height = 29
        Caption = 'Scan'
        Enabled = False
        TabOrder = 2
        OnClick = BtnScanDaemonStartClick
      end
      object BtnScanReport: TButton
        Left = 879
        Top = 488
        Width = 148
        Height = 29
        Caption = 'Report'
        Enabled = False
        TabOrder = 3
        OnClick = BtnScanReportClick
      end
      object PBScanGauge: TProgressBar
        Left = 16
        Top = 533
        Width = 841
        Height = 21
        Min = 1
        Position = 1
        TabOrder = 4
      end
      object MemoScanResult: TMemo
        Left = 457
        Top = 367
        Width = 400
        Height = 150
        BevelInner = bvNone
        BevelOuter = bvRaised
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Segoe UI'
        Font.Style = [fsItalic]
        Lines.Strings = (
          '...'
          '..'
          '.')
        ParentFont = False
        TabOrder = 5
      end
      object Panel2: TPanel
        Left = 457
        Top = 16
        Width = 400
        Height = 329
        Caption = 'Panel1'
        TabOrder = 6
      end
      object Panel1: TPanel
        Left = 16
        Top = 16
        Width = 400
        Height = 329
        Caption = 'Panel1'
        TabOrder = 7
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'File | Reg Manager'
      ImageIndex = 1
      object LblRegistryChanges: TLabel
        Left = 4
        Top = 35
        Width = 207
        Height = 31
        Caption = 'Registry Changes '#11015#65039'  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object Label1: TLabel
        Left = 529
        Top = 35
        Width = 148
        Height = 31
        Caption = 'File Activity '#11015#65039'  '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -23
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object LblPDFAnalyzer: TLabel
        Left = 3
        Top = 410
        Width = 370
        Height = 23
        Caption = 'PDF Analyzer - Please give a directory to analyze'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = 'Segoe UI'
        Font.Style = []
        ParentFont = False
      end
      object MemoRegistryChanges: TMemo
        Left = 4
        Top = 72
        Width = 500
        Height = 321
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
      object MemoFileActivity: TMemo
        Left = 529
        Top = 72
        Width = 500
        Height = 321
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
        TabOrder = 1
      end
      object ToggleSwitchFileActivity: TToggleSwitch
        Left = 947
        Top = 39
        Width = 82
        Height = 27
        TabOrder = 2
        OnClick = ToggleSwitchFileActivityClick
      end
      object ToggleSwitchRegistryChanges: TToggleSwitch
        Left = 422
        Top = 39
        Width = 82
        Height = 27
        TabOrder = 3
        OnClick = ToggleSwitchRegistryChangesClick
      end
      object MemoPDFAnalyzer: TMemo
        Left = 3
        Top = 449
        Width = 1026
        Height = 120
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
        TabOrder = 4
      end
      object BtnAnalyzePDF: TButton
        Left = 390
        Top = 408
        Width = 114
        Height = 35
        Caption = 'Analyze'
        TabOrder = 5
        OnClick = BtnAnalyzePDFClick
      end
      object BtnPDFAction: TButton
        Left = 529
        Top = 408
        Width = 111
        Height = 35
        Caption = 'Get Report'
        TabOrder = 6
        OnClick = BtnPDFActionClick
      end
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
        Width = 997
        Height = 225
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
      object ToggleSwitchNetworkActivity: TToggleSwitch
        Left = 935
        Top = 47
        Width = 82
        Height = 27
        TabOrder = 1
        OnClick = ToggleSwitchNetworkActivityClick
      end
    end
    object WebShield: TTabSheet
      Caption = 'Web Shield'
      ImageIndex = 4
      object Label2: TLabel
        Left = 20
        Top = 346
        Width = 171
        Height = 25
        Caption = 'Upload a file to check'
      end
      object EditURL: TLabeledEdit
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
        Height = 35
        Caption = 'Analyse'
        TabOrder = 1
        OnClick = BtnURLScanVTClick
      end
      object MemoURLCheckLog: TMemo
        Left = 20
        Top = 119
        Width = 990
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
      object BtnScanURLog: TButton
        Left = 935
        Top = 80
        Width = 75
        Height = 35
        Caption = 'Log'
        TabOrder = 3
        OnClick = BtnScanURLogClick
      end
      object MemoFileScanLog: TMemo
        Left = 20
        Top = 383
        Width = 990
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
        TabOrder = 4
      end
      object BtnUpload: TButton
        Left = 815
        Top = 344
        Width = 195
        Height = 35
        Caption = 'Upload and Analyse'
        TabOrder = 5
        OnClick = BtnUploadClick
      end
      object EditSelectedFileDetails: TEdit
        Left = 197
        Top = 344
        Width = 612
        Height = 33
        ReadOnly = True
        TabOrder = 6
        Text = 'File ID: [00x0]   -   File Path: [...]'
      end
      object ProgressBarFileUpload: TProgressBar
        Left = 20
        Top = 539
        Width = 980
        Height = 20
        Max = 10
        Step = 1
        TabOrder = 7
      end
    end
  end
  object PythonGUIInputOutputNA: TPythonGUIInputOutput
    DelayWrites = True
    UnicodeIO = True
    RawOutput = False
    Output = MemoNetworkActivity
    Left = 811
    Top = 133
  end
  object TimerNetworkActivity: TTimer
    Enabled = False
    Interval = 10000
    OnTimer = TimerNetworkActivityTimer
    Left = 678
    Top = 199
  end
  object PythonGUIInputOutputRegistry: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Output = MemoRegistryChanges
    Left = 158
    Top = 112
  end
  object PythonGUIInputOutputFileActivity: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Output = MemoFileActivity
    Left = 400
    Top = 128
  end
  object TimerFileActivity: TTimer
    Enabled = False
    Left = 400
    Top = 192
  end
  object OpenDialogFile: TOpenDialog
    Title = 'Select a file to upload'
    Left = 926
    Top = 528
  end
  object NetHTTPReqUploadToScan: TNetHTTPRequest
    Asynchronous = True
    Client = NetHTTPClientUploadToScan
    Left = 281
    Top = 442
  end
  object NetHTTPClientUploadToScan: TNetHTTPClient
    Asynchronous = True
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 552
    Top = 564
  end
  object TimerFileAnalysis: TTimer
    Enabled = False
    OnTimer = TimerFileAnalysisTimer
    Left = 708
    Top = 308
  end
  object TimerRegistryLogReader: TTimer
    Enabled = False
    Interval = 1500
    OnTimer = TimerRegistryLogReaderTimer
    Left = 120
    Top = 192
  end
  object TimerDaemon: TTimer
    Enabled = False
    Interval = 7000
    Left = 920
    Top = 312
  end
  object PythonGUIInputOutputScanResult: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Output = MemoScanResult
    Left = 648
    Top = 450
  end
  object PythonEngine: TPythonEngine
    IO = PythonGUIInputOutputNA
    Left = 864
    Top = 240
  end
end
