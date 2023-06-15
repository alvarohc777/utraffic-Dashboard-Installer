#define MyAppName "Solicitudes"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "U Traffic"
#define MyAppExeName "Solicitudes.exe"
#define PublishFolder "C:\Users\Administrador\Documents\utraffic\C#\Solicitudes\bin\Debug\net6.0\win-x64\publish\*"
#define InstallationDir "C:\Solicitudes\"
#define InstallerName "Instalador Solicitudes Backend"
#define DotnetExeName "dotnet60_x64.exe"
#define PostgreExeName "postgresql-15.3-1-windows-x64.exe"


#define AuxDataFolder "AuxFiles\"
#define AppIcon "Utraffic.ico"
#define BeforeInstallFile "BeforeInstall.txt"
#define AfterInstallFile "AfterInstall.txt"
#define LicenseFile "License.txt"
#define public Dependency_NoExampleSetup
#define Password "utraffic"

#define MyService "Solicitudes"

#define AppId "{{4372BD00-1EC0-4F22-9F87-5436E942D980}"


[Setup]
AppId = {#AppId}
AppName={cm:MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={#InstallationDir}{#MyAppName}
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename={#InstallerName}
DisableWelcomePage=no

LicenseFile={#AuxDataFolder}{#LicenseFile}
;InfoBeforeFile={#AuxDataFolder}{#BeforeInstallFile}
;InfoAfterFile ={#AuxDataFolder}{#AfterInstallFile}
WizardImageFile = {#AuxDataFolder}upscaledvertical.bmp
WizardSmallImageFile = {#AuxDataFolder}upscaledsmall.bmp
SetupIconFile = {#AuxDataFolder}Utraffic.ico

Password={#Password}

Compression=lzma
SolidCompression=yes

WizardStyle=modern

PrivilegesRequired=admin
ArchitecturesInstallIn64BitMode=x64

[Code]
var
  OutputProgressWizardPage: TOutputProgressWizardPage;
  OutputMarqueeProgressWizardPage: TOutputMarqueeProgressWizardPage;
  OutputMarqueeProgressWizardPageId: Integer;
  InstallCMDParams: String;

function InitializeSetup(): Boolean;
begin
  Result := True;
  if RegKeyExists(HKEY_LOCAL_MACHINE,
       'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#AppId}_is1') or
     RegKeyExists(HKEY_CURRENT_USER,
       'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#AppId}_is1') then
  begin
    MsgBox('The application is installed already.', mbInformation, MB_OK);
    Result := False;
  end;
end;  

function InstallDependency(DependencyExe: String; Params: String): Boolean;
var 
  ResultCode: Integer;
begin

  
  if Exec(ExpandConstant('{tmp}\')+DependencyExe,Params,'', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
    begin
      if ResultCode = 1 then
        Result:=True
      else
        Result:=false;
    end;
end;
  
procedure InitializeWizard();
var
  AfterId: Integer;
begin
  WizardForm.WelcomeLabel1.Caption := 'Bienvenido al asistente de instalaci�n de SolicitudesApp';
  WizardForm.WelcomeLabel2.Caption := 'Este programa instalar� SolicitudesApp en su versi�n 1.0.0 en su sistema.' #13#10 #13#10 'Se recomienda cerrar todas las dem�s aplicaciones antes de continuar.' #13#10 #13#10 'Haga click en Siguiente para continuar o en Cancelar para salir de la instalaci�n.'
  AfterId := wpInfoBefore;
  OutputProgressWizardPage := CreateOutputProgressPage('Extracting Dependencies', 'The following programs will be extracted:' #13#10 'Dotnet, PostgreSQL');
  OutputMarqueeProgressWizardPage := CreateOutputMarqueeProgressPage('Instalando dependencias', 'Este programa es un requerimiento para Solicitudes App.');
  OutputMarqueeProgressWizardPageId := AfterId;

end;

function NextButtonClick(CurPageId: Integer): Boolean;
var 
  I, Max: Integer;
begin
  if CurPageId = OutputMarqueeProgressWizardPageId then 
    begin
;          MsgBox('Entro a instalarse', mbInformation, MB_OK);


     try
        Max := 5;
        I := 1;
        
        OutputProgressWizardPage.SetProgress(I, Max);
        OutputProgressWizardPage.Show;

        I := 3;

        OutputProgressWizardPage.Msg2Label.Caption := 'Extracting DotNet6.0';
        ExtractTemporaryFile('{#DotNetExeName}');
        OutputProgressWizardPage.SetProgress(I, Max);

        I := 5;
        OutputProgressWizardPage.Msg2Label.Caption := 'Extracting PostgreSQL';
        ExtractTemporaryFile('{#PostgreExeName}');
        OutputProgressWizardPage.SetProgress(I, Max);

     finally
      OutputProgressWizardPage.Hide;
     end;
     try 
      Max := 50;
      OutputMarqueeProgressWizardPage.Show;
       
           OutputMarqueeProgressWizardPage.Animate;
           InstallCMDParams := '/install /quiet /norestart';
           OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Dotnet6.0';
           Result := InstallDependency('{#DotNetExeName}', InstallCMDParams);

           
           InstallCMDParams := '--unattendedmodeui minimal --mode unattended --superpassword "herrada2022" --servicename "postgreSQL" --servicepassword "herrada2022" --serverport 5432  --disable-components pgAdmin,stackbuilder';
           OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Postgre6.0';
           Result := InstallDependency('{#PostgreExeName}', InstallCMDParams);
         
     finally
       OutputMarqueeProgressWizardPage.Hide;
     end;
   end;
  Result := True;
end;


[Languages]

Name: "Eng"; MessagesFile: "compiler:Default.isl"; InfoBeforeFile:"{#AuxDataFolder}\BeforeInstall.txt"; InfoAfterFile:"{#AuxDataFolder}\AfterInstall.txt"; LicenseFile:"{#AuxDataFolder}\License.txt"
Name: "Esp"; MessagesFile: "compiler:Languages\Spanish.isl"; InfoBeforeFile:"{#AuxDataFolder}\BeforeInstall-Spanish.txt"; InfoAfterFile:"{#AuxDataFolder}\AfterInstall-Spanish.txt"; LicenseFile:"{#AuxDataFolder}\License-Spanish.txt"

[CustomMEssages]
Eng.MyAppName=Solicitudes-Eng
Eng.WelcomeMessage="Bienvenido al asistente de instalaci�n de SolicitudesApp"
Esp.MyAppName=Solicitudes-Esp
Esp.WelcomeMessage="Welcome to the SolicitudesApp instalation assistant"

[Files]
Source: {#PublishFolder}; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "conf.xml"
Source: {#AuxDataFolder}{#AppIcon}; DestName:{#AppIcon}; DestDir: "{app}"
Source: {#DotnetExeName}; Flags: dontcopy noencryption
Source: {#PostgreExeName}; Flags: dontcopy noencryption

[Icons]
Name: "{group}\{cm:MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#AppIcon}"
Name: "{commondesktop}\{cm:MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#AppIcon}"

[Run]
Filename: {sys}\sc.exe; Parameters: "stop ""{#MyService}"""; Flags: runhidden
Filename: {sys}\sc.exe; Parameters: "delete ""{#MyService}"""; Flags: runhidden
Filename: {sys}\sc.exe; Parameters: "create ""{#MyService}"" start= auto binPath= ""{app}\{#MyAppExeName}"""; Flags: runhidden
Filename: {sys}\sc.exe; Parameters: "start ""{#MyService}""" ; Flags: runhidden

[UninstallRun]
Filename: "{cmd}"; Parameters: "/C ""taskkill /im {#MyAppExeName} /f /t"
Filename: {sys}\sc.exe; Parameters: "stop ""{#MyService}""" ; Flags: runhidden
Filename: {sys}\sc.exe; Parameters: "delete ""{#MyService}"""; Flags: runhidden 



