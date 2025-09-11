[Setup]
AppName=GreenBiller
AppVersion=1.1.0
AppVerName=GreenBiller 1.1.0
AppPublisher=greenbiller.com

DefaultDirName={autopf}\GreenBiller
DefaultGroupName=GreenBiller
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=output
OutputBaseFilename=GreenBiller_Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "assets\favicon.ico"; DestDir: "{app}"; Flags: ignoreversion


[Icons]
Name: "{group}\GreenBiller"; Filename: "{app}\greenbiller.exe"; IconFilename: "{app}\favicon.ico"
Name: "{group}\{cm:UninstallProgram,GreenBiller}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\GreenBiller"; Filename: "{app}\greenbiller.exe"; IconFilename: "{app}\favicon.ico"; Tasks: desktopicon

[Run]
Filename: "{app}\greenbiller.exe"; Description: "{cm:LaunchProgram,GreenBiller}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
Type: filesandordirs; Name: "{app}"

[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
end;

function IsDotNetInstalled: Boolean;
var
  success: Boolean;
  install: Cardinal;
begin
  success := RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', 'Install', install);
  Result := success and (install = 1);
end;
