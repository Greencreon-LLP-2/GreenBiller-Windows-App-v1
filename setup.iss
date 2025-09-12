[Setup]
AppName=GreenBiller
AppVersion=1.1.1
AppVerName=GreenBiller v1 Beta
AppPublisher=greenbiller.com
AppCopyright=© 2025 GreenCreon.com
DefaultDirName={autopf}\GreenBiller
DefaultGroupName=GreenBiller
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=output
OutputBaseFilename=GreenBiller_Installer
Compression=lzma
SolidCompression=yes
WizardStyle=modern
LicenseFile=License.txt
AllowNoIcons=no
AllowRootDirectory=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "assets\favicon.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "License.txt"; DestDir: "{tmp}"; Flags: dontcopy

[Icons]
Name: "{group}\GreenBiller"; Filename: "{app}\greenbiller.exe"; IconFilename: "{app}\favicon.ico"
Name: "{group}\{cm:UninstallProgram,GreenBiller}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\GreenBiller"; Filename: "{app}\greenbiller.exe"; IconFilename: "{app}\favicon.ico"; Tasks: desktopicon
Name: "{autoprograms}\Uninstall GreenBiller"; Filename: "{uninstallexe}"

[Run]
Filename: "{app}\greenbiller.exe"; Description: "{cm:LaunchProgram,GreenBiller}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Registry]
Root: HKCR; Subkey: ".gbill"; ValueType: string; ValueName: ""; ValueData: "GreenBillerFile"
Root: HKCR; Subkey: "GreenBillerFile\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\greenbiller.exe"" ""%1"""

[Code]
function IsDotNetInstalled: Boolean;
var
  success: Boolean;
  install: Cardinal;
begin
  success := RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', 'Install', install);
  Result := success and (install = 1);
end;

function InitializeSetup(): Boolean;
begin
  if not IsDotNetInstalled() then
  begin
    MsgBox('This application requires .NET Framework 4.x to be installed. Please install it first from https://dotnet.microsoft.com/download/dotnet-framework', mbError, MB_OK);
    Result := False;
  end
  else
    Result := True;
end;
