#ifndef Payload
  #error Payload must name the prepared runtime directory
#endif
#ifndef OutputDirectory
  #error OutputDirectory must name the installer output directory
#endif

[Setup]
AppId={{65F813C9-8F3B-4DB7-92FA-63B46891B663}
AppName=POYRAZ Vigor
AppVersion=0.3.20261012.7
VersionInfoVersion=0.3.7.0
AppPublisher=POYRAZ
DefaultDirName={localappdata}\Programs\POYRAZ\Vigor
DefaultGroupName=POYRAZ Vigor
AllowNoIcons=yes
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
MinVersion=10.0.17763
OutputDir={#OutputDirectory}
OutputBaseFilename=POYRAZ_Vigor_Setup_2026-10-12_CNI8_x64
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
DisableWelcomePage=no
DisableProgramGroupPage=yes
UninstallDisplayIcon={app}\app\SolidSimNative.exe
CloseApplications=no
RestartApplications=no
InfoAfterFile={#Payload}\Kurulum-Bilgisi.txt
SetupLogging=yes

[Languages]
Name: "turkish"; MessagesFile: "compiler:Languages\Turkish.isl"

[Tasks]
Name: "desktopicon"; Description: "Masaüstüne POYRAZ Vigor kısayolu ekle"; GroupDescription: "Kısayollar:"

[Files]
Source: "{#Payload}\*"; DestDir: "{app}"; Excludes: "vigor-settings.ini"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "{#Payload}\vigor-settings.ini"; DestDir: "{app}"; Flags: onlyifdoesntexist uninsneveruninstall

[Icons]
Name: "{group}\POYRAZ Vigor"; Filename: "{app}\app\SolidSimNative.exe"; WorkingDir: "{app}\app"
Name: "{autodesktop}\POYRAZ Vigor"; Filename: "{app}\app\SolidSimNative.exe"; WorkingDir: "{app}\app"; Tasks: desktopicon

[Run]
Filename: "{app}\app\SolidSimNative.exe"; Description: "POYRAZ Vigor'u aç"; WorkingDir: "{app}\app"; Flags: nowait postinstall skipifsilent
