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
    ActivePage = WebShield
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Dashboard'
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
      object MemoRegistryChanges: TMemo
        Left = 4
        Top = 88
        Width = 500
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
      object MemoFileActivity: TMemo
        Left = 529
        Top = 88
        Width = 500
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
        TabOrder = 1
      end
      object ToggleSwitchFileActivity: TToggleSwitch
        Left = 947
        Top = 39
        Width = 82
        Height = 27
        State = tssOn
        TabOrder = 2
      end
      object ToggleSwitchRegistryChanges: TToggleSwitch
        Left = 422
        Top = 39
        Width = 82
        Height = 27
        State = tssOn
        TabOrder = 3
      end
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
        Width = 997
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
      object ToggleSwitchNetworkActivity: TToggleSwitch
        Left = 935
        Top = 47
        Width = 82
        Height = 27
        State = tssOn
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
      object BtnScanURLog: TButton
        Left = 935
        Top = 80
        Width = 65
        Height = 35
        Caption = 'Log'
        TabOrder = 3
        OnClick = BtnScanURLogClick
      end
      object MemoFileScanLog: TMemo
        Left = 20
        Top = 383
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
        TabOrder = 4
      end
      object BtnUpload: TButton
        Left = 815
        Top = 344
        Width = 114
        Height = 35
        Caption = 'Upload'
        TabOrder = 5
        OnClick = BtnUploadClick
      end
      object BtnGetFileReportById: TButton
        Left = 935
        Top = 344
        Width = 65
        Height = 35
        Caption = 'Get'
        TabOrder = 6
        OnClick = BtnGetFileReportByIdClick
      end
      object EditSelectedFileDetails: TEdit
        Left = 197
        Top = 344
        Width = 612
        Height = 33
        ReadOnly = True
        TabOrder = 7
        Text = 'File ID: [00x0]   -   File Path: [...]'
      end
      object ProgressBarFileUpload: TProgressBar
        Left = 20
        Top = 539
        Width = 980
        Height = 20
        Max = 10
        Step = 1
        TabOrder = 8
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
    Left = 160
    Top = 444
  end
  object PythonGUIInputOutputRegistry: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Left = 112
    Top = 128
  end
  object TimerRegistryChanges: TTimer
    Interval = 15000
    Left = 112
    Top = 192
  end
  object PythonGUIInputOutputFileActivity: TPythonGUIInputOutput
    UnicodeIO = True
    RawOutput = False
    Left = 560
    Top = 136
  end
  object TimerFileActivity: TTimer
    Left = 560
    Top = 200
  end
  object OpenDialogFile: TOpenDialog
    Title = 'Select a file to upload'
    Left = 632
    Top = 448
  end
  object NetHTTPReqUploadToScan: TNetHTTPRequest
    Asynchronous = True
    Client = NetHTTPClientUploadToScan
    Left = 624
    Top = 522
  end
  object NetHTTPClientUploadToScan: TNetHTTPClient
    Asynchronous = True
    UserAgent = 'Embarcadero URI Client/1.0'
    Left = 464
    Top = 498
  end
  object TimerFileAnalysis: TTimer
    Enabled = False
    OnTimer = TimerFileAnalysisTimer
    Left = 816
    Top = 464
  end
end
