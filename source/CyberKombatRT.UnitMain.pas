Unit CyberKombatRT.UnitMain;

Interface

Uses
  Winapi.Windows
, Winapi.Messages
, System.SysUtils
, System.Variants
, System.Classes
, Vcl.Graphics
, Vcl.Controls
, Vcl.Forms
, Vcl.Dialogs
, Vcl.ComCtrls
, Vcl.ToolWin
, Vcl.ActnMan
, Vcl.ActnCtrls
, Vcl.StdCtrls
, PythonEngine
, Vcl.PythonGUIInputOutput
, Vcl.ExtCtrls
, Vcl.Mask
, System.Net.URLClient
, System.Net.HttpClient
, System.Net.HttpClientComponent
, Vcl.WinXCtrls
, ShellAPI;

Type
  TFormMain = Class(TForm)
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet4: TTabSheet;
    MemoNetworkActivity: TMemo;
    LblNetworkActivity: TLabel;
    PythonGUIInputOutputNA: TPythonGUIInputOutput;
    TimerNetworkActivity: TTimer;
    WebShield: TTabSheet;
    EditURL: TLabeledEdit;
    BtnURLScanVT: TButton;
    MemoURLCheckLog: TMemo;
    BtnScanURLog: TButton;
    PythonGUIInputOutputRegistry: TPythonGUIInputOutput;
    MemoRegistryChanges: TMemo;
    LblRegistryChanges: TLabel;
    Label1: TLabel;
    MemoFileActivity: TMemo;
    PythonIOFileActivity: TPythonGUIInputOutput;
    TimerFileActivity: TTimer;
    MemoFileScanLog: TMemo;
    Label2: TLabel;
    BtnUpload: TButton;
    EditSelectedFileDetails: TEdit;
    OpenDialogFile: TOpenDialog;
    ToggleSwitchNetworkActivity: TToggleSwitch;
    ToggleSwitchFileActivity: TToggleSwitch;
    ToggleSwitchRegistryChanges: TToggleSwitch;
    NetHTTPReqUploadToScan: TNetHTTPRequest;
    NetHTTPClientUploadToScan: TNetHTTPClient;
    ProgressBarFileUpload: TProgressBar;
    TimerFileAnalysis: TTimer;
    LblPDFAnalyzer: TLabel;
    MemoPDFAnalyzer: TMemo;
    BtnAnalyzePDF: TButton;
    BtnPDFAction: TButton;
    TimerRegistryLogReader: TTimer;
    MemoScanList: TMemo;
    BtnUpdateDaemon: TButton;
    BtnScanDaemonStart: TButton;
    BtnScanReport: TButton;
    PBScanGauge: TProgressBar;
    MemoScanResult: TMemo;
    TimerDaemon: TTimer;
    PythonGUIInputOutputScanResult: TPythonGUIInputOutput;
    Panel1: TPanel;
    Panel2: TPanel;
    PythonEngine: TPythonEngine;
    BtnNetworkReport: TButton;
    MemoNetworkGPT: TMemo;
    PythonIONetworkGPT: TPythonGUIInputOutput;
    PyGUI_IO_FileActivity: TPythonGUIInputOutput;
    Procedure FormCreate(Sender: TObject);
    Procedure TimerNetworkActivityTimer(Sender: TObject);
    Procedure BtnURLScanVTClick(Sender: TObject);
    Procedure BtnScanURLogClick(Sender: TObject);
    procedure ToggleSwitchNetworkActivityClick(Sender: TObject);
    procedure BtnUploadClick(Sender: TObject);
    procedure TimerFileAnalysisTimer(Sender: TObject);
    procedure ToggleSwitchRegistryChangesClick(Sender: TObject);
    procedure ToggleSwitchFileActivityClick(Sender: TObject);
    procedure TimerRegistryLogReaderTimer(Sender: TObject);
    procedure BtnAnalyzePDFClick(Sender: TObject);
    procedure BtnPDFActionClick(Sender: TObject);
    procedure BtnScanDaemonStartClick(Sender: TObject);
    procedure BtnUpdateDaemonClick(Sender: TObject);
    procedure BtnScanReportClick(Sender: TObject);
    procedure BtnNetworkReportClick(Sender: TObject);
    procedure TimerFileActivityTimer(Sender: TObject);
  Private
    VT_API_KEY: String;
    FAnalysis_ID: String;
    // WebShield Functions
    Function PostToVirusTotal(Const URL, APIKey: String): String;
    Function GetVirusTotalAnalysis(Const AnalysisID: String): String;
    Function ExtractWebrootResultFromJSON(const JSONStr: string): String;
    Function FormatDataURLog(const WebsiteName, FResult: string): string;
    Function GetFileReport(const FileID: string): string;

    // Utils
    Procedure SaveDataToFile(const Data, FilePath: string);
    Function CheckNetwork: boolean;

    // Error related functions
    Procedure WriteToLogFile(Const Msg: String);
  Public
    { Public declarations }
  End;

Type
  TPythonScriptThread = Class(TThread)
  Private
    FScriptPath: String;
    Procedure UpdateGUI;
  Protected
    Procedure Execute; Override;
  Public
    Constructor Create(Const ScriptPath: String);
  End;

Var
  FormMain: TFormMain;

Implementation

{$R *.dfm}

Uses
  System.IOUtils, System.Threading, System.NetEncoding, WinInet, System.JSON
  , System.Net.Mime;

Function TFormMain.PostToVirusTotal(Const URL, APIKey: String): String;
Var
  NetHTTPClient: TNetHTTPClient;
  NetHTTPRequest: TNetHTTPRequest;
  Response: IHTTPResponse;
  FormData: TStrings;
Begin
  NetHTTPClient := TNetHTTPClient.Create(Nil);
  NetHTTPRequest := TNetHTTPRequest.Create(Nil);
  FormData := TStringList.Create;
  Try
    NetHTTPRequest.Client := NetHTTPClient;
    NetHTTPRequest.URL := 'https://www.virustotal.com/api/v3/urls';

    // Set request headers
    NetHTTPRequest.CustomHeaders['accept'] := 'application/json';
    NetHTTPRequest.CustomHeaders['content-type'] :=
      'application/x-www-form-urlencoded';
    NetHTTPRequest.CustomHeaders['x-apikey'] := APIKey;

    FormData.Add('url=' + URL);

    Response := NetHTTPRequest.Post(NetHTTPRequest.URL, FormData);
    Result := Response.ContentAsString();
  Finally
    NetHTTPClient.Free;
    NetHTTPRequest.Free;
    FormData.Free;
  End;
End;

procedure TFormMain.SaveDataToFile(const Data, FilePath: string);
begin
  try
    // Check if the file exists; if not, it will be created automatically
    if TFile.Exists(FilePath) then
      // Append the data to the file with a new line
      TFile.AppendAllText(FilePath, Data + sLineBreak)
    else
      // Create the file and write the data
      TFile.WriteAllText(FilePath, Data + sLineBreak);
  except
    on E: Exception do
      // Handle the error, for example, log it or show a message to the user
      WriteToLogFile('Error_writing_to_file_' + E.Message +  '_' + FilePath);
  end;
end;

procedure TFormMain.BtnUpdateDaemonClick(Sender: TObject);
begin
  var FileName := 'D:\CyberKombat RT\config\directories.csv'; // Path to the file

  // Check if the file exists
  if FileExists(FileName) then
  begin
    // If the file exists, load the file contents into the MemoScanList
    MemoScanList.Lines.LoadFromFile(FileName);

    // Check if the MemoScanList has any lines of data
    if MemoScanList.Lines.Count > 0 then
      BtnScanDaemonStart.Enabled := True  // Enable list is available
    else
      BtnScanDaemonStart.Enabled := False; // disable if the memo is empty
  end
  else
  begin
    // Optionally handle the case where the file does not exist
    WriteToLogFile('File not found for AV Scanning: ' + FileName);
    BtnScanDaemonStart.Enabled := False; // disable no directoreis added.
  end;
end;

procedure TFormMain.BtnUploadClick(Sender: TObject);
var
  Client: TNetHTTPClient;
  Request: TNetHTTPRequest;
  Response: IHTTPResponse;
  MultiPartFormData: TMultipartFormData;
begin
  if OpenDialogFile.Execute then
  begin
    OpenDialogFile.FileName;

    EditSelectedFileDetails.Text := 'File ID: [00x0]   -   File Path: ['
      + OpenDialogFile.FileName + ']';

    ProgressBarFileUpload.Position := 0;

    Client := TNetHTTPClient.Create(nil);
    Request := TNetHTTPRequest.Create(nil);
    try
      Request.Client := Client;
      Request.URL := 'https://www.virustotal.com/api/v3/files';

      // Create the multipart form data
      MultiPartFormData := TMultipartFormData.Create;
      try
        // Add the file to be sent, replace 'file.png' with the actual file path
        MultiPartFormData.AddFile('file', OpenDialogFile.FileName);

        // Set necessary headers
        Request.CustomHeaders['accept'] := 'application/json';
        Request.CustomHeaders['x-apikey'] := VT_API_KEY;

        // Send the POST request
        Response := Request.Post(Request.URL, MultiPartFormData);

        var JSONValue := TJSONObject.ParseJSONValue(Response.ContentAsString);
        try
          if JSONValue is TJSONObject then
          begin
            var JSONObject := JSONValue as TJSONObject;
            var DataObject := JSONObject.GetValue('data') as TJSONObject;
            var AnalysisID := DataObject.GetValue('id').Value;
            MemoFileScanLog.Lines.Append('Report: ' + OpenDialogFile.FileName
              + ' is under ' + AnalysisID);

            FAnalysis_ID := AnalysisID;
            TimerFileAnalysis.Enabled := True;
          end;
        finally
          JSONValue.Free;
        end;
      finally
        MultiPartFormData.Free;
      end;
    finally
      Request.Free;
      Client.Free;
    end;
  end;
end;

Procedure TFormMain.BtnURLScanVTClick(Sender: TObject);
Begin
  If EditURL.Text = '' Then
  Begin
    EditURL.SetFocus;
  End
  Else
  Begin
    // VirusTotal URL Scan
    Try
      var Response := PostToVirusTotal(EditURL.Text, VT_API_KEY);

      var LJSONObj := TJSONObject.ParseJSONValue(Response) as TJSONObject;
      try
        // Navigate to the "data" object
        if Assigned(LJSONObj) then
        begin
          var LDataObj := LJSONObj.GetValue('data') as TJSONObject;
          // Now, get the "id" field value from the "data" object
          if Assigned(LDataObj) then
          begin
            var LIDValue := LDataObj.GetValue('id').Value;
            Response := GetVirusTotalAnalysis(LIDValue);  // whole analysis

            // now we have formatted final result
            var FinalResult
              := FormatDataURLog(EditURL.Text, ExtractWebrootResultFromJSON(Response));

            MemoURLCheckLog.Lines.Add(FinalResult);

            SaveDataToFile(FinalResult, 'D:\CyberKombat RT\db\Webroot.CyK');
          end;
        end;
      finally
        LJSONObj.Free;
      end;
    Except
      On E: Exception Do
        WriteToLogFile('Error on VT URL Scan: ' + E.Message);
    End;
  End;
End;

procedure TFormMain.BtnAnalyzePDFClick(Sender: TObject);
var
  ScriptFolder, ScriptPath: String;
  SEInfo: TShellExecuteInfo;
  ExitCode: DWORD;
begin
  MemoPDFAnalyzer.Lines.Clear;

  ScriptFolder := 'D:\CyberKombat RT\vendor\pdf_tools\';
  ScriptPath := TPath.Combine(ScriptFolder, 'pdf_analyzer.py');

  FillChar(SEInfo, SizeOf(SEInfo), 0);
  SEInfo.cbSize := SizeOf(TShellExecuteInfo);
  SEInfo.fMask := SEE_MASK_NOCLOSEPROCESS;
  SEInfo.Wnd := Application.Handle;
  SEInfo.lpFile := PChar('python'); // or the full path to the Python executable
  SEInfo.lpParameters := PChar('"' + ScriptPath + '"');
  SEInfo.lpDirectory := PChar(ScriptFolder);
  SEInfo.nShow := SW_SHOW;

  if ShellExecuteEx(@SEInfo) then
  begin
    WaitForSingleObject(SEInfo.hProcess, INFINITE);
    GetExitCodeProcess(SEInfo.hProcess, ExitCode);
    CloseHandle(SEInfo.hProcess);
    if ExitCode <> 0 then
      MemoPDFAnalyzer.Lines.Append('Script executed with errors. Exit code: ' + IntToStr(ExitCode));
  end
  else
    MemoPDFAnalyzer.Lines.Append('Failed to execute script.');
end;

procedure TFormMain.BtnNetworkReportClick(Sender: TObject);
Var
  ScriptFolder, ScriptPath: String;
Begin
  // Define the path to the script
  ScriptFolder := 'D:\CyberKombat RT\scripts';
  ScriptPath := TPath.Combine(ScriptFolder, 'NetworkAnalyzeGPT.py');

  PythonEngine.IO := PythonIONetworkGPT;

  If TFile.Exists(ScriptPath) Then
  Begin
    // Create and start the script execution thread
    TPythonScriptThread.Create(ScriptPath);
    MemoNetworkGPT.Clear;
    MemoNetworkGPT.Lines.Append('GPT started...');
  End
  Else
  Begin
    WriteToLogFile('NetworkAnalyzeGPT.py script not found or can`t access;');
  End;
end;

procedure TFormMain.BtnPDFActionClick(Sender: TObject);
begin
  MemoPDFAnalyzer.Clear;
  MemoPDFAnalyzer.Lines.LoadFromFile('D:\CyberKombat RT\logs\pdf_logs.txt');
end;

procedure TFormMain.BtnScanDaemonStartClick(Sender: TObject);
Var
  ScriptFolder, ScriptPath: String;
Begin
  // Define the path to the script
  ScriptFolder := 'D:\CyberKombat RT\vendor\clamav';
  ScriptPath := TPath.Combine(ScriptFolder, 'clamdaemon.py');

  PythonEngine.IO := PythonGUIInputOutputScanResult;

  If TFile.Exists(ScriptPath) Then
  Begin
    // Create and start the script execution thread
    TPythonScriptThread.Create(ScriptPath);
    MemoScanResult.Clear;
    MemoScanResult.Lines.Append('Scanning started...');
  End
  Else
  Begin
    WriteToLogFile('clamdaemon.py script not found or can`t access;');
  End;
end;

procedure TFormMain.BtnScanReportClick(Sender: TObject);
begin
  //
end;

Procedure TFormMain.BtnScanURLogClick(Sender: TObject);
Begin
  // capture to a file  - Will be moved to OnCreate function probably
End;

Function TFormMain.CheckNetwork: boolean;
Var
  origin: cardinal;
Begin
  Result := InternetGetConnectedState(@origin, 0);

  // connections origins by origin value
  // NO INTERNET CONNECTION              = 0;
  // INTERNET_CONNECTION_MODEM           = 1;
  // INTERNET_CONNECTION_LAN             = 2;
  // INTERNET_CONNECTION_PROXY           = 4;
  // INTERNET_CONNECTION_MODEM_BUSY      = 8;
End;

Function TFormMain.ExtractWebrootResultFromJSON(const JSONStr: string): String;
begin
  var LJSONObj := TJSONObject.ParseJSONValue(JSONStr) as TJSONObject;
  try
    if Assigned(LJSONObj) then
    begin
      // Navigate to the "data" object
      var LDataObj := LJSONObj.GetValue('data') as TJSONObject;
      if Assigned(LDataObj) then
      begin
        // "attributes"
        var LAttributesObj := LDataObj.GetValue('attributes') as TJSONObject;
        if Assigned(LAttributesObj) then
        begin
          // "results"
          var LResultsObj := LAttributesObj.GetValue('results') as TJSONObject;
          if Assigned(LResultsObj) then
          begin
            // "Webroot"
            var LWebrootObj := LResultsObj.GetValue('Webroot') as TJSONObject;
            if Assigned(LWebrootObj) then
            begin
              Result := LWebrootObj.GetValue('result').Value;
            end;
          end;
        end;
      end;
    end;
  finally
    LJSONObj.Free;
  end;
end;

function TFormMain.FormatDataURLog(const WebsiteName, FResult: string): string;
begin
  // Formats the date-time to a string and concatenates the website name and result
  var CurrentDateTime := Now;
  Result := FormatDateTime('yyyy-mm-dd hh:nn:ss', CurrentDateTime) + ',' + WebsiteName + ',' + FResult;
end;

Procedure TFormMain.FormCreate(Sender: TObject);
Begin
  PageControl1.ActivePageIndex := 0; // initial window

  If CheckNetwork Then
  Begin
    StatusBar1.Panels.Items[1].Text := 'Connection: On';
  End
  Else
  Begin
    StatusBar1.Panels.Items[1].Text := 'Connection: Down';
  End;

  // VirusTotal API Key Input Box
  VT_API_KEY := InputBox('API Key Required', 'Please enter your API Key:', '');
  if VT_API_KEY = '' then
  begin
    ShowMessage('No API Key provided.');
  end
  else
  begin
    ShowMessage('Key accepted');
  end;

  // Scan directories list must be loaded. It can be updated with Update button
  try
    var ConfigFolder := 'D:\CyberKombat RT\config';
    var ConfigPath   := TPath.Combine(ConfigFolder, 'directories.csv');
    MemoScanList.Lines.LoadFromFile(ConfigPath);
  except
    on E: Exception do
      ShowMessage('Scan List Not Found or Empty. Error msg: ' + E.ToString);
  end;

End;

function TFormMain.GetFileReport(const FileID: string): string;
var
  Client: TNetHTTPClient;
  Request: TNetHTTPRequest;
  Response: IHTTPResponse;
begin
  Client := TNetHTTPClient.Create(nil);
  Request := TNetHTTPRequest.Create(nil);
  try
    Request.Client := Client;
    Request.URL := 'https://www.virustotal.com/api/v3/analyses/' + FileID;

    // Set necessary headers
    Request.CustomHeaders['accept'] := 'application/json';
    Request.CustomHeaders['x-apikey'] := VT_API_KEY;

    ShowMessage(Request.URL);

    // Send the GET request
    Response := Request.Get(Request.URL);

    // Parse the JSON string to a JSON object
    var LJSONObject := TJSONObject.ParseJSONValue(Response.ContentAsString) as TJSONObject;
    try
      // Navigate through the JSON structure to retrieve the desired values
      // Get the 'data' object
      var LData := LJSONObject.GetValue<TJSONObject>('data');

      // Get the 'attributes' object
      var LAttributes := LData.GetValue<TJSONObject>('attributes');

      // Get the 'stats' object
      var LStats := LAttributes.GetValue<TJSONObject>('stats');

      // Extract 'malicious' and 'harmless' values
      var LMalicious := LStats.GetValue<Integer>('malicious');
      var LHarmless := LStats.GetValue<Integer>('harmless');


      // Next iteration
      // Get the 'meta' object
      var LMeta := LJSONObject.GetValue<TJSONObject>('meta');

      // Get the 'file_info' object
      var LFileInfo := LMeta.GetValue<TJSONObject>('file_info');

      // Extract 'sha256', 'md5', and 'size'
      var LSHA256 := LFileInfo.GetValue<string>('sha256');
      var LMD5 := LFileInfo.GetValue<string>('md5');
      var LSize := LFileInfo.GetValue<Integer>('size');

      // Output the extracted values (you can replace this with your own logic)
      MemoFileScanLog.Lines.Append('Maliciuos Level: ' + LMalicious.ToString);
      MemoFileScanLog.Lines.Append('Harmless: ' + LHarmless.ToString);
      MemoFileScanLog.Lines.Append('SHA256: ' + LSHA256);
      MemoFileScanLog.Lines.Append('MD5 : ' + LMD5);
      MemoFileScanLog.Lines.Append('Size : ' + LSize.ToString);
    finally
      LJSONObject.Free;
    end;

  finally
    Request.Free;
    Client.Free;
  end;
end;

Function TFormMain.GetVirusTotalAnalysis(Const AnalysisID: String): String;
Var
  NetHTTPClient: TNetHTTPClient;
  NetHTTPRequest: TNetHTTPRequest;
  Response: IHTTPResponse;
Begin
  NetHTTPClient := TNetHTTPClient.Create(Nil);
  NetHTTPRequest := TNetHTTPRequest.Create(Nil);
  Try
    NetHTTPRequest.Client := NetHTTPClient;
    // Adjust the URL to include the AnalysisID
    NetHTTPRequest.URL := 'https://www.virustotal.com/api/v3/analyses/'
                            + AnalysisID;
    // Set request headers
    NetHTTPRequest.CustomHeaders['x-apikey'] := VT_API_KEY;

    // Since it's a GET request, we don't send FormData
    Response := NetHTTPRequest.Get(NetHTTPRequest.URL);



    Result := Response.ContentAsString();
  Finally
    NetHTTPClient.Free;
    NetHTTPRequest.Free;
  End;
End;

procedure TFormMain.TimerFileActivityTimer(Sender: TObject);
Var
  ScriptFolder, ScriptPath: String;
Begin
  ScriptFolder := 'D:\CyberKombat RT\scripts';
  ScriptPath := TPath.Combine(ScriptFolder, 'FileActivity.py');

  PythonEngine.IO := PyGUI_IO_FileActivity;

  If TFile.Exists(ScriptPath) Then
  Begin
    TPythonScriptThread.Create(ScriptPath);
  End
  Else
  Begin
    WriteToLogFile('FileActivity.py script not found or can`t access;');
  End;
end;

procedure TFormMain.TimerFileAnalysisTimer(Sender: TObject);
begin
  ProgressBarFileUpload.Position := ProgressBarFileUpload.Position + 1;

  if ProgressBarFileUpload.Position >= ProgressBarFileUpload.Max then
  begin
    TimerFileAnalysis.Enabled := False;

    // get the analysis report
    GetFileReport(FAnalysis_ID);
  end;
end;

Procedure TFormMain.TimerNetworkActivityTimer(Sender: TObject);
Var
  ScriptFolder, ScriptPath: String;
Begin
  // Define the path to the script
  ScriptFolder := 'D:\CyberKombat RT\scripts';
  ScriptPath := TPath.Combine(ScriptFolder, 'NetworkInfo.py');

  PythonEngine.IO := PythonGUIInputOutputNA;

  // Check if the Python script file exists before attempting to run it
  If TFile.Exists(ScriptPath) Then
  Begin
    // Create and start the script execution thread
    TPythonScriptThread.Create(ScriptPath);
  End
  Else
  Begin
    WriteToLogFile('NetworkInfo.py script not found or can`t access;');
  End;
End;

procedure TFormMain.TimerRegistryLogReaderTimer(Sender: TObject);
Var
  ScriptFolder, ScriptPath: String;
Begin
  // Define the path to the script
  ScriptFolder := 'D:\CyberKombat RT\scripts';
  ScriptPath := TPath.Combine(ScriptFolder, 'RegistryControl.py');

  PythonEngine.IO := PythonGUIInputOutputRegistry;

  // Check if the Python script file exists before attempting to run it
  If TFile.Exists(ScriptPath) Then
  Begin
    // Create and start the script execution thread
    TPythonScriptThread.Create(ScriptPath);
  End
  Else
  Begin
    WriteToLogFile('RegistryControl.py script not found or can`t access;');
  End;
end;

procedure TFormMain.ToggleSwitchNetworkActivityClick(Sender: TObject);
begin
  if ToggleSwitchNetworkActivity.State = tssOff then
  begin
    TimerNetworkActivity.Enabled := False;
    MemoNetworkActivity.Lines.Append('Service stopped.');
  end
  else if ToggleSwitchNetworkActivity.State = tssOn then
  begin
    TimerNetworkActivity.Enabled := True;
    MemoNetworkActivity.Clear;
    MemoNetworkActivity.Lines.Append('Service started.');
  end;
end;

procedure TFormMain.ToggleSwitchFileActivityClick(Sender: TObject);
begin
  if ToggleSwitchFileActivity.State = tssOff then
  begin
    TimerFileActivity.Enabled := False;
    MemoFileActivity.Lines.Append('Service stopped.');
  end
  else if ToggleSwitchFileActivity.State = tssOn then
  begin
    TimerFileActivity.Enabled := True;
    MemoFileActivity.Clear;
    MemoFileActivity.Lines.Append('Service started.');
  end;
end;

procedure TFormMain.ToggleSwitchRegistryChangesClick(Sender: TObject);
begin
  if ToggleSwitchRegistryChanges.State = tssOff then
  begin
//    TimerRegistryLogReader.Enabled := False;
    MemoRegistryChanges.Lines.Append('Service stopped. Please use the script itself;');
  end
  else if ToggleSwitchRegistryChanges.State = tssOn then
  begin
//    TimerRegistryLogReader.Enabled := True;
    MemoRegistryChanges.Clear;
    MemoRegistryChanges.Lines.Append('Service started.');
  end;
end;

Procedure TFormMain.WriteToLogFile(Const Msg: String);
Var
  LogFileName: String;
  LogFile: TextFile;
  DateTimeString: String;
Begin
  // Define the path and name of your log file
  LogFileName := 'D:\CyberKombat RT\logs\app_log.txt';

  // Check if the logs directory exists; if not, create it
  If Not TDirectory.Exists(TPath.GetDirectoryName(LogFileName)) Then
    TDirectory.CreateDirectory(TPath.GetDirectoryName(LogFileName));

  // Assign file to the TextFile variable
  AssignFile(LogFile, LogFileName);

  // Format the current date and time
  DateTimeString := FormatDateTime('yyyy-mm-dd hh:nn:ss', Now);

  // Try to append to the file, if the file does not exist, it will be created
  Try
    If FileExists(LogFileName) Then
      Append(LogFile)
    Else
      Rewrite(LogFile);

    // Write the message with a timestamp
    Writeln(LogFile, Format('%s - %s', [DateTimeString, Msg]));

  Finally
    CloseFile(LogFile);
  End;
End;

{ TPythonScriptThread }

Constructor TPythonScriptThread.Create(Const ScriptPath: String);
Begin
  Inherited Create(False);
  FScriptPath := ScriptPath;
  FreeOnTerminate := True; // Automatically free the thread after execution
End;

Procedure TPythonScriptThread.Execute;
Var
  ScriptContent: TStringList;
Begin
  ScriptContent := TStringList.Create;
  Try
    If FileExists(FScriptPath) Then
    Begin
      ScriptContent.LoadFromFile(FScriptPath);
      // Assuming PythonEngine is thread-safe or called in a way that
      //  is safe (like using Synchronize)
      Synchronize(
        Procedure
        Begin
          FormMain.PythonEngine.ExecString
            (AnsiString(ScriptContent.Text));
        End);
    End;
  Finally
    ScriptContent.Free;
  End;
  Synchronize(UpdateGUI);
End;

Procedure TPythonScriptThread.UpdateGUI;
Begin
  // argument decoration
End;

End.
