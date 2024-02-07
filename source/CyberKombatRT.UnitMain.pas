Unit CyberKombatRT.UnitMain;

Interface

Uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.ComCtrls, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.StdCtrls,
  PythonEngine, Vcl.PythonGUIInputOutput, Vcl.ExtCtrls, Vcl.Mask,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent;

Type
  TFormMain = Class(TForm)
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    MemoNetworkActivity: TMemo;
    LblNetworkActivity: TLabel;
    PythonEngineNetworkActivity: TPythonEngine;
    PythonGUIInputOutputNA: TPythonGUIInputOutput;
    TimerNetworkActivity: TTimer;
    TabSheet5: TTabSheet;
    EditURL: TLabeledEdit;
    BtnURLScanVT: TButton;
    MemoURLCheckLog: TMemo;
    BtnScanURLog: TButton;
    Procedure FormCreate(Sender: TObject);
    Procedure TimerNetworkActivityTimer(Sender: TObject);
    Procedure BtnURLScanVTClick(Sender: TObject);
    Procedure BtnScanURLogClick(Sender: TObject);
  Private
    // WebShield Functions
    Function PostToVirusTotal(Const URL, APIKey: String): String;
    Function GetVirusTotalAnalysis(Const AnalysisID: String): String;
    Function ExtractWebrootResultFromJSON(const JSONStr: string): String;
    Function FormatDataURLog(const WebsiteName, FResult: string): string;

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

Const
  VT_API_KEY = '';

Var
  FormMain: TFormMain;

Implementation

{$R *.dfm}

Uses
  System.IOUtils, System.Threading, System.NetEncoding, WinInet, System.JSON;

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

End;

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
    NetHTTPRequest.URL := 'https://www.virustotal.com/api/v3/analyses/' + AnalysisID;

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

Procedure TFormMain.TimerNetworkActivityTimer(Sender: TObject);
Var
  ScriptFolder, ScriptPath: String;
Begin
  // Define the path to the script
  ScriptFolder := 'D:\CyberKombat RT\scripts';
  ScriptPath := TPath.Combine(ScriptFolder, 'NetworkInfo.py');

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
      // Assuming PythonEngineNetworkActivity is thread-safe or called in a way that is safe (like using Synchronize)
      Synchronize(
        Procedure
        Begin
          FormMain.PythonEngineNetworkActivity.ExecString
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
