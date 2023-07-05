#define MyAppName "UToll Pista"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "U Traffic"

#define UTollVisorExeName "UToll Pista.exe"     ; Frontend Executable
#define UTollVisorDir "\UToll Pista-win32-x64\" ; Frontend App Directory

; Installer components
#define PublishFolder "C:\Users\Administrador\Documents\utraffic\InnoSetup\Solicitudes\SolicitudesInstaller\TestFiles\*"
#define InstallationDir "C:\UTollPista\"
#define InstallerName "UToll Pista Installer - LogicFlow"
#define ServerDir "\server\";
#define ServerFile "\server.js";
#define pm2Dir "pm2\";

#define SchemasDir "\DB-Schemas\"
#define SchemasTestFile "ut.utoll.tyr.vacio.backup"
#define SchemasTestDBName "TestDB"
#define PasswordDB "utraffic"


; Installer dependencies
#define DependenciesDir "Dependencies\"
#define VCRedisX64ExeName "VC_redist.x64.exe"
#define VCRedisX86ExeName "VC_redist.x86.exe"
#define DotnetExeName  "ndp461-devpack-kb3105179-enu.exe"
#define PostgreExeName "postgresql-15.3-1-windows-x64.exe"
#define NodeExeName "node-v18.16.0-x86.msi"
#define NIDAQ "NIDAQ.tar"
#define NIDAQDir "NIDAQ930f2\"
#define NIDAQExeName "setup.exe"
#define NIDAQConfigFile "setupSpecs.ini"
#define pm2 "pm2.tar"
#define DotnetOfflineExeName "NET-Framework-3.5-Offline-Installer-v2.3.exe"


; Files Packed with Installer
#define WindowsISO "Windows.iso"

; Installation Environment Variables
#define RestartEnvVar "RestartInstaller"
#define Checkpoint_1 "Checkpoint_1"
#define Checkpoint_2 "Checkpoint_2"
#define Checkpoint_3 "Checkpoint_3"

; Auxiliary Files (Icons, Licenses, text files)
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
  Restarted: Boolean;
  Checkpoint_1: Boolean;
  Checkpoint_2: Boolean;
  Checkpoint_3: Boolean;

procedure ExitProcess(uExitCode: Integer);
  external 'ExitProcess@kernel32.dll stdcall';

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

// Verificar que Windows ISO est� installado   
  if not FileExists(ExpandConstant('{src}\{#WindowsISO}')) then
  begin
    MsgBox(ExpandConstant('Windows.iso was not detected in: "{src}"'), mbError, MB_OK);
    ExitProcess(1);
  end;

  if (GetEnv('{#RestartEnvVar}') <> '') then
    begin
      Restarted := true
    end 
    else begin
      Restarted  := false;
    end;
  if (GetEnv('{#Checkpoint_1}') <> '') then
    begin
      Checkpoint_1 := true
    end 
    else begin
      Checkpoint_1  := false;
    end;
  if (GetEnv('{#Checkpoint_2}') <> '') then
    begin
      Checkpoint_2 := true
    end 
    else begin
      Checkpoint_2  := false;
    end;
  if (GetEnv('{#Checkpoint_3}') <> '') then
    begin
      Checkpoint_3 := true
    end 
    else begin
      Checkpoint_3  := false;
    end;




  WizardForm.LicenseAcceptedRadio.Checked := True;
  WizardForm.PasswordEdit.Text := '{#Password}';
  WizardForm.WelcomeLabel1.Caption := 'Bienvenido al asistente de instalaci�n de UToll Pista';
  WizardForm.WelcomeLabel2.Caption := 'Este programa instalar� UToll Pista en su versi�n 1.0.0 en su sistema.' #13#10 #13#10 'Se recomienda cerrar todas las dem�s aplicaciones antes de continuar.' #13#10 #13#10 'Haga click en Siguiente para continuar o en Cancelar para salir de la instalaci�n.'
  OutputProgressWizardPage := CreateOutputProgressPage('Extracting Dependencies', 'The following programs will be extracted:' #13#10 'VIsual C++ Redistributablex64, Visual C++ Redistributablex86, NIDAQ, Dotnet, PostgreSQL, NodeJs, NI-DAQ');
  OutputMarqueeProgressWizardPage := CreateOutputMarqueeProgressPage('Instalando dependencias', 'Este programa es un requerimiento para UToll Pista App.');
  OutputMarqueeProgressWizardPageId := wpInfoBefore;

end;

function ShouldSkipPage(PageID: Integer): Boolean;
begin
  Result := (Checkpoint_1 or Checkpoint_2 or Checkpoint_3) and (
    (PageID = wpWelcome) or
    (PageID = wpLicense) or
    (PageID = wpPassword) or
//     (PageID = wpInfoBefore) or
    (PageID = wpUserInfo) or
    (PageID = wpSelectDir) or
    (PageID = wpSelectComponents) or
    (PageID = wpSelectProgramGroup) or
    (PageID = wpSelectTasks) or
    (PageID = wpReady)
  );
end;

function NextButtonClick(CurPageId: Integer): Boolean;
var 
  I, Max: Integer;
  InstallCMDParams: String;
  InstallCMDExe: String;
  ResultCode: Integer;
begin
  if CurPageId = OutputMarqueeProgressWizardPageId then 
    begin
    try
      Max := 10;
      I := 1;
      OutputProgressWizardPage.SetProgress(I, Max);
      OutputProgressWizardPage.Show;
      
      if not Checkpoint_1 then
      begin
          I := 3;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting DotNet6.0';
//           ExtractTemporaryFile('{#DotNetExeName}');
          MsgBox('Extracting DotNet6.0', mbInformation, MB_OK);
          OutputProgressWizardPage.SetProgress(I, Max);

          I := 5;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting PostgreSQL';
//           ExtractTemporaryFile('{#PostgreExeName}');
          MsgBox('Extracting PostgreSQL', mbInformation, MB_OK);
          OutputProgressWizardPage.SetProgress(I, Max);

          I := 6;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting NodeJs';
//           ExtractTemporaryFile('{#NodeExeName}');
          MsgBox('Extracting NodeJs', mbInformation, MB_OK);
          OutputProgressWizardPage.SetProgress(I, Max);

          I := 7;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting PM2';
//           ExtractTemporaryFile('{#pm2}');
          MsgBox('Extracting PM2', mbInformation, MB_OK);
          OutputProgressWizardPage.SetProgress(I, Max);
      end; 
      if not Checkpoint_2 then
      begin
          I := 8;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting Dotnet3.5 Offline Installer';
//           ExtractTemporaryFile('{#DotnetOfflineExeName}');
          MsgBox('Extracting Dotnet 3.5 offline installer', mbInformation, MB_OK);
          OutputProgressWizardPage.SetProgress(I, Max);
      end; 
      if not Checkpoint_3 then
      begin
          I := 10;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting NIDAQ';
//           ExtractTemporaryFile('{#NIDAQ}');
          MsgBox('Extracting NIDAQ', mbInformation, MB_OK);
          OutputProgressWizardPage.SetProgress(I, Max);
      end  
          






      
      else begin

      end;
    finally
      OutputProgressWizardPage.Hide;
     end;
      
        

     
    try 
      Max := 50;
      OutputMarqueeProgressWizardPage.Show; 
      OutputMarqueeProgressWizardPage.Animate;
      if not Checkpoint_1 then
      begin
          InstallCMDParams := '--unattendedmodeui minimal --mode unattended --superpassword "utraffic" --servicename "postgreSQL" --servicepassword "utraffic" --serverport 5432  --disable-components pgAdmin,stackbuilder';
          InstallCMDExe := ExpandConstant('{tmp}\')+'{#PostgreExeName}';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Postgre6.0';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
          MsgBox('Instalado: de PostgreSQL', mbInformation, MB_OK);

          InstallCMDParams := '/install /passive /norestart';
          InstallCMDExe := ExpandConstant('{tmp}\')+'{#DotNetExeName}';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Dotnet 4.6.1';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
          MsgBox('Instalado: de Dotnet 4.6.1', mbInformation, MB_OK);

          InstallCMDParams := '/i '+ ExpandConstant('{tmp}\{#NodeExeName}')+' /passive';
          InstallCMDExe := 'msiexec.exe'; 
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando NodeJs';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
          MsgBox('Instalado: de NodeJs', mbInformation, MB_OK);
          
          InstallCMDParams := ExpandConstant('/c tar -xf {tmp}\{#pm2} -C {tmp} & xcopy /E /Y /I {tmp}\{#pm2Dir} {userappdata}\npm')
          InstallCMDExe := 'cmd.exe'
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Pm2';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
          MsgBox('Instalado: Pm2', mbInformation, MB_OK);

          InstallCMDParams := '/c setx {#Checkpoint_1} "True" /M';
          InstallCMDExe := 'cmd.exe'; 
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);
      end; 
      if not Checkpoint_2 then
      begin
          InstallCMDParams := ExpandConstant('/c powershell.exe /c Mount-DiskImage -ImagePath {src}\{#WindowsISO}');
          InstallCMDExe := 'cmd.exe '
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Testing';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
          MsgBox('Windows.iso Montado', mbInformation, MB_OK);

          InstallCMDParams := ExpandConstant('/c {tmp}\{#DotnetOfflineExeName}');
          InstallCMDExe := 'cmd.exe'
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Dotnet Offline';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
          MsgBox('Se abre Dotnet 3.5 offline installer (operaci�n manual).', mbInformation, MB_OK);
          

          if MsgBox('Se instal� correctamente Dotnet3.5', mbConfirmation, MB_YESNO) = IDNO then
          begin
          ExitProcess(1);
          end;
          MsgBox('Instalado: dotnet 3.5 offline', mbInformation, MB_OK);

          InstallCMDParams := '/c setx {#Checkpoint_2} "True" /M';
          InstallCMDExe := 'cmd.exe'; 
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);
      end; 
      if not Checkpoint_3 then
      begin
          InstallCMDParams := ExpandConstant('/c tar -xf {tmp}\{#NIDAQ} -C {tmp} & {tmp}\{#NIDAQDir}{#NIDAQExeName} {tmp}\{#NIDAQDir}setup.ini /qb /AcceptLicenses yes /r ');
          InstallCMDExe := 'cmd.exe'; 
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando NI-DAQ';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
          MsgBox('Instalado NIDAQ', mbInformation, MB_OK);


            InstallCMDParams := '/c setx {#Checkpoint_3} "True" /M & shutdown /r /t 10 ';
            InstallCMDExe := 'cmd.exe'; 
            MsgBox('Al presionar OK el sistema se reiniciar� en 10 segundos', mbInformation, MB_OK);
            Result := InstallDependency(InstallCMDExe, InstallCMDParams);
            OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Reiniciando el sistema';

          ExitProcess(1);
      end        
        else begin
          
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Esperando a que se instalen los sensores';

          MsgBox('En este punto se abre el NIDAQ para que se instalen los sensores manualmente', mbInformation, MB_OK);
          if MsgBox('Aseg�rese de haber instalado correctamente los sensores', mbConfirmation, MB_YESNO) = IDNO then
          begin
          ExitProcess(1);
          end;
          
        end;   
     finally
       OutputMarqueeProgressWizardPage.Hide;
     end;
   end;

   if CurPageId = wpInfoAfter then
   begin
     try
       OutputMarqueeProgressWizardPage.Show;
       OutputMarqueeProgressWizardPage.Animate;

        InstallCMDParams := '/c set "PGPASSWORD={#PasswordDB}" &"C:\Program Files\PostgreSQL\15\bin\createdb.exe" -h localhost -p 5432 -U postgres {#SchemasTestDBName} & "C:\Program Files\PostgreSQL\15\bin\pg_restore.exe" -Fc -v -h localhost -p 5432 -U postgres -w -d {#SchemasTestDBName} ' + ExpandConstant('"{app}{#SchemasDir}{#SchemasTestFile}"') + ' & pause';
        InstallCMDExe := 'cmd.exe';
        OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Inicializando Base de datos';
//         Result := InstallDependency(InstallCMDExe, InstallCMDParams)
        MsgBox('Backup restored from .backup', mbInformation, MB_OK);       

       InstallCMDParams := '/c  pm2 start "{#InstallationDir}{#MyAppName}\server\server.js" & pm2 save --force ';
       InstallCMDExe := 'cmd.exe';
       OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando servicio en PM2';
//        Result := InstallDependency(InstallCMDExe, InstallCMDParams);
       MsgBox('Instalado: Servicio PM2', mbInformation, MB_OK);

       InstallCMDParams := '/c setx {#RestartEnvVar} "" /M & setx {#Checkpoint_1} "" /M & setx {#Checkpoint_2} "" /M & setx {#Checkpoint_3} "" /M';
       InstallCMDExe := 'cmd.exe';
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
Eng.MyAppName=UToll Lane
Eng.WelcomeMessage="Bienvenido al asistente de instalaci�n de SolicitudesApp"
Esp.MyAppName=UToll Pista
Esp.WelcomeMessage="Welcome to the SolicitudesApp instalation assistant"

[Files]
Source: {#PublishFolder}; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Excludes: "conf.xml"
Source: {#AuxDataDir}{#AppIcon}; DestName:{#AppIcon}; DestDir: "{app}"
; Dependencies Temporary Files
; Source: {#DependenciesDir}{#PostgreExeName};  Flags: dontcopy noencryption
; Source: {#DependenciesDir}{#DotnetExeName};   Flags: dontcopy noencryption
; Source: {#DependenciesDir}{#NodeExeName};     Flags: dontcopy noencryption
; Source: {#DependenciesDir}{#pm2}; Flags: dontcopy noencryption
; Source: {#DependenciesDir}{#NIDAQ}; Flags: dontcopy noencryption
; Source: {#DependenciesDir}{#DotnetOfflineExeName}; Flags: dontcopy noencryption

[Icons]
Name: "{group}\{cm:MyAppName}";         Filename: "{app}\{#UTollVisorDir}\{#UtollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"
Name: "{commondesktop}\{cm:MyAppName}"; Filename: "{app}\{#UTollVisorDir}\{#UTollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"
Name: "{commonstartup}\{cm:MyAppName}"; Filename: "{app}\{#UTollVisorDir}\{#UTollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"





