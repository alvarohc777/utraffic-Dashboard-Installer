#define MyAppName "UToll Pista"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "U Traffic"

#define UTollVisorExeName "UToll Pista.exe"     ; Frontend Executable
#define UTollVisorDir "\UToll-Pista-win32-x64\" ; Frontend App Directory

;#define PublishFolder "C:\Users\Administrador\Documents\utraffic\C#\Solicitudes\bin\Debug\net6.0\win-x64\publish\*"
#define PublishFolder "C:\Users\Administrador\Documents\utraffic\InnoSetup\Solicitudes\SolicitudesInstaller\Publish\*"
#define InstallationDir "C:\UTollPista\"
#define InstallerName "UToll Pista Installer"

#define DependenciesDir "Dependencies\"
#define VCRedisX64ExeName "VC_redist.x64.exe"
#define VCRedisX86ExeName "VC_redist.x86.exe"
#define DotnetExeName  "dotnet60_x64.exe"
#define PostgreExeName "postgresql-15.3-1-windows-x64.exe"
#define NodeExeName "node-v18.16.0-x86.msi"
#define NIDAQzip "NIDAQ930f2.zip"



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

  
  if Exec(DependencyExe,Params,'', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
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
  OutputProgressWizardPage := CreateOutputProgressPage('Extracting Dependencies', 'The following programs will be extracted:' #13#10 'Dotnet, PostgreSQL, NodeJs');
  OutputMarqueeProgressWizardPage := CreateOutputMarqueeProgressPage('Instalando dependencias', 'Este programa es un requerimiento para Solicitudes App.');
  OutputMarqueeProgressWizardPageId := AfterId;

end;

function NextButtonClick(CurPageId: Integer): Boolean;
var 
  I, Max: Integer;
  InstallCMDParams: String;
  InstallCMDExe: String;
begin
  if CurPageId = OutputMarqueeProgressWizardPageId then 
    begin
;          MsgBox('Entro a instalarse', mbInformation, MB_OK);


     try
        Max := 6;

        I := 1;
        
        OutputProgressWizardPage.SetProgress(I, Max);
        OutputProgressWizardPage.Show;

        I := 2;
        OutputProgressWizardPage.Msg2Label.Caption := 'Exctracting Microsoft Visual C++ Redistributable x64 2015-2022';
        ExtractTemporaryFile('{#VCRedisX64ExeName}');
        OutputProgressWizardPage.SetProgress(I, Max);
        I := 3;
        OutputProgressWizardPage.Msg2Label.Caption := 'Exctracting Microsoft Visual C++ Redistributable x86 2015-2022';
        ExtractTemporaryFile('{#VCRedisX86ExeName}');
        OutputProgressWizardPage.SetProgress(I, Max);

        I := 4;

        OutputProgressWizardPage.Msg2Label.Caption := 'Extracting DotNet6.0';
        ExtractTemporaryFile('{#DotNetExeName}');
        OutputProgressWizardPage.SetProgress(I, Max);

        I := 5;
        OutputProgressWizardPage.Msg2Label.Caption := 'Extracting PostgreSQL';
        ExtractTemporaryFile('{#PostgreExeName}');
        OutputProgressWizardPage.SetProgress(I, Max);

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

           InstallCMDParams := '/i ' + ExpandConstant('{tmp}\{#VCRedisX64ExeName}')+' /passive';
           InstallCMDExe := 'msiexec.exe';
           OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Microsoft Visual C++ Redistributable x64 2015-2022';
           Result := InstallDependency(InstallCMDExe, InstallCMDParams); 

           InstallCMDParams := '/i ' + ExpandConstant('{tmp}\{#VCRedisX86ExeName}')+' /passive';
           InstallCMDExe := 'msiexec.exe';
           OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Microsoft Visual C++ Redistributable x86 2015-2022';
           Result := InstallDependency(InstallCMDExe, InstallCMDParams);

           InstallCMDParams := '/install /passive /norestart';
           InstallCMDExe := ExpandConstant('{tmp}\')+'{#DotNetExeName}'
           OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Dotnet6.0';
           Result := InstallDependency(InstallCMDExe, InstallCMDParams);

           
           InstallCMDParams := '--unattendedmodeui minimal --mode unattended --superpassword "herrada2022" --servicename "postgreSQL" --servicepassword "herrada2022" --serverport 5432  --disable-components pgAdmin,stackbuilder';
           InstallCMDExe := ExpandConstant('{tmp}\')+'{#PostgreExeName}'
           OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Postgre6.0';
           Result := InstallDependency(InstallCMDExe, InstallCMDParams);

           InstallCMDParams := '/i '+ ExpandConstant('{tmp}\{#NodeExeName}')+' /passive';
           InstallCMDExe := 'msiexec.exe' 
           OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando NodeJs';
           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
         
     finally
       OutputMarqueeProgressWizardPage.Hide;
     end;
   end;
  Result := True;
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
Source: {#DependenciesDir}{#DotnetExeName}; Flags: dontcopy noencryption
Source: {#DependenciesDir}{#PostgreExeName}; Flags: dontcopy noencryption
Source: {#DependenciesDir}{#NodeExeName}; Flags: dontcopy noencryption
Source: {#DependenciesDir}{#VCRedisX64ExeName}; Flags: dontcopy noencryption
Source: {#DependenciesDir}{#VCRedisX86ExeName}; Flags: dontcopy noencryption

[Icons]
Name: "{group}\{cm:MyAppName}"; Filename: "{app}\{#UTollVisorDir}{#UtollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"
Name: "{commondesktop}\{cm:MyAppName}"; Filename: "{app}\{#UtollVisorDir}{#UTollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"

;[Run]
;Filename: {sys}\sc.exe; Parameters: "stop ""{#MyService}"""; Flags: runhidden
;Filename: {sys}\sc.exe; Parameters: "delete ""{#MyService}"""; Flags: runhidden
;Filename: {sys}\sc.exe; Parameters: "create ""{#MyService}"" start= auto binPath= ""{app}\{#MyAppExeName}"""; Flags: runhidden
;Filename: {sys}\sc.exe; Parameters: "start ""{#MyService}""" ; Flags: runhidden

;[UninstallRun]
;Filename: "{cmd}"; Parameters: "/C ""taskkill /im {#MyAppExeName} /f /t"
;Filename: {sys}\sc.exe; Parameters: "stop ""{#MyService}""" ; Flags: runhidden
;Filename: {sys}\sc.exe; Parameters: "delete ""{#MyService}"""; Flags: runhidden 



