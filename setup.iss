; Inno Setup Script for GreenBiller Windows Application
; -----------------------------------------------
; This script creates a Windows installer for your Flutter application

[Setup]
; Basic information about your application
AppName=GreenBiller
AppVersion=1.0.1
AppVerName=GreenBiller 1.0.1
AppPublisher=greenbiller.com

DefaultDirName={autopf}\GreenBiller
DefaultGroupName=GreenBiller
AllowNoIcons=yes
; Remove the following line to run in administrative install mode (install for all users.)
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=output
OutputBaseFilename=GreenBiller_Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
; Sign the installer if you have a code signing certificate
; SignTool=mysigntool

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Main application files
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Include any additional files your app needs
Source: "build\windows\x64\runner\Release\*.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\*.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "build\windows\x64\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; Include VC++ Redistributable if needed
; Source: "vcredist_x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

[Icons]
Name: "{group}\GreenBiller"; Filename: "{app}\greenbiller.exe"
Name: "{group}\{cm:UninstallProgram,GreenBiller}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\GreenBiller"; Filename: "{app}\greenbiller.exe"; Tasks: desktopicon

[Run]
; Run the application after installation
Filename: "{app}\greenbiller.exe"; Description: "{cm:LaunchProgram,GreenBiller}"; Flags: nowait postinstall skipifsilent
; Install VC++ Redistributable if needed
; Filename: "{tmp}\vcredist_x64.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing VC++ Redistributable..."

[UninstallDelete]
Type: filesandordirs; Name: "{app}"
; Remove app data if desired
; Type: filesandordirs; Name: "{localappdata}\GreenBiller"
; Type: filesandordirs; Name: "{userdocs}\GreenBiller"

[Code]
// Custom code to check for prerequisites
function InitializeSetup(): Boolean;
begin
  // Check for .NET Framework or other prerequisites if needed
  // if not IsDotNetInstalled then...
  Result := True;
end;

// Function to check if .NET Framework is installed (example)
function IsDotNetInstalled: Boolean;
var
  success: Boolean;
  install: Cardinal;
begin
  success := RegQueryDWordValue(HKLM, 'SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full', 'Install', install);
  Result := success and (install = 1);
end;