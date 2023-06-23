#define MyAppName "Solicitudes"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "U Traffic"
#define MyAppExeName "Solicitudes.exe"
#define PublishFolder "C:\Users\Administrador\Documents\utraffic\InnoSetup\Solicitudes\SolicitudesInstaller\Publish\server\*"
#define InstallationDir "C:\Solicitudes\"
#define InstallerName "Instalador Solicitudes Backend"
#define DependenciesDir "Dependencies\"
#define DotnetExeName  "dotnet60_x64.exe"
#define PostgreExeName "postgresql-15.3-1-windows-x64.exe"
#define NodeExeName "node-v18.16.0-x86.msi"
#define NIDAQzip "NIDAQ930f2.zip"

#define RestartEnvVar "RestartInstaller"

#define AuxDataDir "AuxFiles\"

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

LicenseFile={#AuxDataDir}{#LicenseFile}
;InfoBeforeFile={#AuxDataDir}{#BeforeInstallFile}
;InfoAfterFile ={#AuxDataDir}{#AfterInstallFile}
WizardImageFile = {#AuxDataDir}upscaledvertical.bmp
WizardSmallImageFile = {#AuxDataDir}upscaledsmall.bmp
SetupIconFile = {#AuxDataDir}Utraffic.ico

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
  Restarted: Boolean;

function InitializeSetup(): Boolean;
begin
  if (GetEnv('{#RestartEnvVar}') <> '') then
    begin
      Restarted := true
    end 
    else begin
      Restarted  := false;
    end;
  Result := True;
  
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
  WizardForm.LicenseAcceptedRadio.Checked := True;
  WizardForm.PasswordEdit.Text := '{#Password}';
  WizardForm.WelcomeLabel1.Caption := 'Bienvenido al asistente de instalaci�n de SolicitudesApp';
  WizardForm.WelcomeLabel2.Caption := 'Este programa instalar� SolicitudesApp en su versi�n 1.0.0 en su sistema.' #13#10 #13#10 'Se recomienda cerrar todas las dem�s aplicaciones antes de continuar.' #13#10 #13#10 'Haga click en Siguiente para continuar o en Cancelar para salir de la instalaci�n.'
  AfterId := wpInfoBefore;
  OutputProgressWizardPage := CreateOutputProgressPage('Extracting Dependencies', 'The following programs will be extracted:' #13#10 'Dotnet, PostgreSQL, NodeJs');
  OutputMarqueeProgressWizardPage := CreateOutputMarqueeProgressPage('Instalando dependencias', 'Este programa es un requerimiento para Solicitudes App.');
  OutputMarqueeProgressWizardPageId := AfterId;

end;
procedure ExitProcess(uExitCode: Integer);
  external 'ExitProcess@kernel32.dll stdcall';

function NextButtonClick(CurPageId: Integer): Boolean;
var 
  I, Max: Integer;
  ResultCode: Integer;
begin
  if CurPageId = OutputMarqueeProgressWizardPageId then 
    begin
// ;          MsgBox('Entro a instalarse', mbInformation, MB_OK);


     try
        Max := 7;
        I := 1;
        
        OutputProgressWizardPage.SetProgress(I, Max);
        OutputProgressWizardPage.Show;

        

        I := 7;
        OutputProgressWizardPage.Msg2Label.Caption := 'Extracting NodeJs';
        ExtractTemporaryFile('{#NodeExeName}');
        OutputProgressWizardPage.SetProgress(I, Max);

     finally
      OutputProgressWizardPage.Hide;
     end;
     try 
      Max := 50;
      OutputMarqueeProgressWizardPage.Show;
      OutputMarqueeProgressWizardPage.Animate;
      if not Restarted then
        begin
          
          MsgBox(GetEnv('{#RestartEnvVar}'), mbInformation, MB_OK);

          InstallCMDParams := '';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando NodeJs';
          Result := Exec('msiexec.exe','/i ' + ExpandConstant('{tmp}\{#NodeExeName}')+' /passive', '', SW_SHOW, ewWaitUntilTerminated, ResultCode);
          MsgBox('Restart the installer now', mbInformation, MB_OK);
          Exec('cmd.exe', '/c setx {#RestartEnvVar} "True" /M', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
          ExitProcess(1);
        end
        else begin
          MsgBox(GetEnv('{#RestartEnvVar}'), mbInformation, MB_OK);

          InstallCMDParams := '/c npm install -g pm2 & pm2 & pause';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Pm2';
          Result := Exec('cmd.exe', InstallCMDParams, '', SW_SHOW, ewWaitUntilTerminated, ResultCode);

          Exec('cmd.exe', '/c setx {#RestartEnvVar} "" /M', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);

        end;         
     finally
       OutputMarqueeProgressWizardPage.Hide;
     end;
   end;
   if CurPageId = wpInfoAfter then
   begin
     try
       Max := 50;
       OutputMarqueeProgressWizardPage.Show;
       OutputMarqueeProgressWizardPage.Animate;
       InstallCMDParams := '/c cd {#InstallationDir}{#MyAppName} & npm install & pause & pm2 start {#InstallationDir}{#MyAppName}\server.js & pause ';
       OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando servicio';
       Result := Exec('cmd.exe', InstallCMDParams, '', SW_SHOW, ewWaitUntilTerminated, ResultCode);
     finally
       OutputMarqueeProgressWizardPage.Hide;
     end;
   end;
   Result := true;
end;

[Languages]

Name: "Eng"; MessagesFile: "compiler:Default.isl"; InfoBeforeFile:"{#AuxDataDir}\BeforeInstall.txt"; InfoAfterFile:"{#AuxDataDir}\AfterInstall.txt"; LicenseFile:"{#AuxDataDir}\License.txt"
Name: "Esp"; MessagesFile: "compiler:Languages\Spanish.isl"; InfoBeforeFile:"{#AuxDataDir}\BeforeInstall-Spanish.txt"; InfoAfterFile:"{#AuxDataDir}\AfterInstall-Spanish.txt"; LicenseFile:"{#AuxDataDir}\License-Spanish.txt"

[CustomMEssages]
Eng.MyAppName=Solicitudes-Eng
Eng.WelcomeMessage="Bienvenido al asistente de instalaci�n de SolicitudesApp"
Esp.MyAppName=Solicitudes-Esp
Esp.WelcomeMessage="Welcome to the SolicitudesApp instalation assistant"

[Files]
Source: {#PublishFolder}; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "conf.xml"
Source: {#AuxDataDir}{#AppIcon}; DestName:{#AppIcon}; DestDir: "{app}"
Source: {#DependenciesDir}{#NodeExeName}; Flags: dontcopy noencryption

[Icons]
Name: "{group}\{cm:MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#AppIcon}"
Name: "{commondesktop}\{cm:MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\{#AppIcon}"

[Run]
; Filename: {sys}\sc.exe; Parameters: "stop ""{#MyService}"""; Flags: runhidden
; Filename: {sys}\sc.exe; Parameters: "delete ""{#MyService}"""; Flags: runhidden
; Filename: {sys}\sc.exe; Parameters: "create ""{#MyService}"" start= auto binPath= ""{app}\{#MyAppExeName}"""; Flags: runhidden
; Filename: {sys}\sc.exe; Parameters: "start ""{#MyService}""" ; Flags: runhidden

; [UninstallRun]
; Filename: "{cmd}"; Parameters: "/C ""taskkill /im {#MyAppExeName} /f /t"
; Filename: {sys}\sc.exe; Parameters: "stop ""{#MyService}""" ; Flags: runhidden
; Filename: {sys}\sc.exe; Parameters: "delete ""{#MyService}"""; Flags: runhidden 



