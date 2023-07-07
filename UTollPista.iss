#define MyAppName "UToll Pista"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "U Traffic"

#define UTollVisorExeName "UToll Pista.exe"     ; Frontend Executable
#define UTollVisorDir "\UToll Pista-win32-x64\" ; Frontend App Directory

; Installer components
#define PublishFolder "C:\Users\Administrador\Documents\utraffic\InnoSetup\Solicitudes\SolicitudesInstaller\Publish\*"
#define InstallationDir "C:\UTollPista\"
#define InstallerName "UToll Pista Installer"
#define SchemasDir          "\DB-Schemas\"
#define DBLogBackup         "ut_utoll_tyr_log_vacia.backup"
#define DBLogName           "ut_utoll_tyr_log"
#define DBPistaBackup       "ut_utoll_tyr_vacia.backup"
#define DBPistaName         "ut_utoll_tyr"


#define CsServiceDir        "\Deploy\"
#define CamarografoDir      "Debug_Camarografo\"
#define CamarografoExe      "UT.UToll.TyR.Pista.Camarografo.exe"
#define ConectorDir         "Debug_ConectorV2\net5.0\"
#define ConectorExe         "UT.UToll.TyR.ConectorV2.exe"
#define ImpresoraDir        "Debug_Impresora\"
#define ImpresoraExe        "UT.UToll.TyR.Pista.Printer.exe"
#define LectorManualDir     "Debug_LectorManual\"
#define LectorManualExe     "UT.UToll.TyR.Pista.LectorManual.exe"
#define MantenimientoDir    "Debug_Mantenimiento\"
#define MantenimientoExe    "UT.UToll.TyR.Pista.Mantenimiento.exe"
#define PanelMensajeriaDir  "Debug_PanelMensajeria\"
#define PanelMensajeriaExe  "UT.UToll.TyR.Pista.PMV.exe"
#define PistaDir            "Debug_Pista\"
#define PistaExe            "UT.UToll.TyR.Pista.Service.exe"
#define RFIDDir             "Debug_RFID\"
#define RFIDExe             "UT.UToll.TyR.RfidServer.exe"
#define UTCDir              "Debug_UTC\"
#define UTCExe              "UT.UToll.TyR.UTC.Server.exe"


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
#define NodeExeName "node-v18.16.1-x64.msi"
#define NIDAQ "NIDAQ.tar"
#define NIDAQDir "NIDAQ930f2\"
#define NIDAQExeName "setup.exe"
#define NIDAQConfigFile "setupSpecs.ini"
#define npm "npm.tar"
#define npmDir "npm\";


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
          ExtractTemporaryFile('{#DotNetExeName}');
          OutputProgressWizardPage.SetProgress(I, Max);

          I := 5;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting PostgreSQL';
          ExtractTemporaryFile('{#PostgreExeName}');
          OutputProgressWizardPage.SetProgress(I, Max);

          I := 6;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting NodeJs';
          ExtractTemporaryFile('{#NodeExeName}');
          OutputProgressWizardPage.SetProgress(I, Max);

          I := 7;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting PM2';
          ExtractTemporaryFile('{#npm}');
          OutputProgressWizardPage.SetProgress(I, Max);
      end;
      if not Checkpoint_2 then
      begin
          I := 8;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting Dotnet3.5 Offline Installer';
          ExtractTemporaryFile('{#DotnetOfflineExeName}');
          OutputProgressWizardPage.SetProgress(I, Max);
      end;
      if not Checkpoint_3 then
      begin    

          I := 10;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting NIDAQ';
          ExtractTemporaryFile('{#NIDAQ}');
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
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          InstallCMDParams := '/c netsh advfirewall set allprofiles state on & netsh advfirewall firewall add rule name="Puerto BBDD" dir=in action=allow enable=yes protocol=TCP localport=5432 profile=any & pause';
          InstallCMDExe := 'cmd.exe';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Adding firewall rule POSTGRESQL';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          InstallCMDParams := '/install /passive /norestart';
          InstallCMDExe := ExpandConstant('{tmp}\')+'{#DotNetExeName}';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Dotnet 4.6.1';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          InstallCMDParams := '/i '+ ExpandConstant('{tmp}\{#NodeExeName}')+' /passive';
          InstallCMDExe := 'msiexec.exe'; 
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando NodeJs';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          InstallCMDParams := ExpandConstant('/c netsh advfirewall firewall add rule name="node in" dir=in action=allow program="{commonpf}\nodejs\node.exe" & netsh advfirewall firewall add rule name="node out" dir=out action=allow program="{commonpf}\nodejs\node.exe" & pause');
          InstallCMDExe := 'cmd.exe';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Adding firewall rule POSTGRESQL';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);
          

          
          InstallCMDParams := ExpandConstant('/c tar -xf {tmp}\{#npm} -C {tmp} & xcopy /E /Y /I {tmp}\{#npmDir} {userappdata}\npm')
          InstallCMDExe := 'cmd.exe'
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Pm2';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);
          MsgBox('Instalado: Pm2', mbInformation, MB_OK);

          InstallCMDParams := ExpandConstant('/c netsh advfirewall firewall add rule name="PM2 in" dir=in action=allow program="{userappdata}\npm\pm2.cmd" & netsh advfirewall firewall add rule name="PM2 out" dir=out action=allow program="{userappdata}\npm\pm2.cmd" & pause');
          InstallCMDExe := 'cmd.exe'
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Adding firewall rule Pm2';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          InstallCMDParams := '/c setx {#Checkpoint_1} "True" /M';
          InstallCMDExe := 'cmd.exe'; 
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);
        end;
      if not Checkpoint_2 then
        begin
          InstallCMDParams := ExpandConstant('/c powershell.exe /c Mount-DiskImage -ImagePath {src}\{#WindowsISO}');
          InstallCMDExe := 'cmd.exe '
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Testing';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          InstallCMDParams := ExpandConstant('/c {tmp}\{#DotnetOfflineExeName}');
          InstallCMDExe := 'cmd.exe'
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Dotnet Offline';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          if MsgBox('Se instal� correctamente Dotnet3.5', mbConfirmation, MB_YESNO) = IDNO then
          begin
            ExitProcess(1);
          end;

          InstallCMDParams := '/c setx {#Checkpoint_2} "True" /M';
          InstallCMDExe := 'cmd.exe'; 
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);
        end;

      if not Checkpoint_3 then
        begin

          InstallCMDParams := ExpandConstant('/c echo "Decompressing NIDAQ" & tar -xf {tmp}\{#NIDAQ} -C {tmp} & {tmp}\{#NIDAQDir}{#NIDAQExeName} {tmp}\{#NIDAQDir}setup.ini /qb /AcceptLicenses yes /r ');
          InstallCMDExe := 'cmd.exe'; 
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando NI-DAQ';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          if MsgBox('Se instal� correctamente NIDAQ?', mbConfirmation, MB_YESNO) = IDNO then
            begin
              ExitProcess(1);
            end;

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

        InstallCMDParams := ExpandConstant('/c set "PGPASSWORD={#PasswordDB}" & "{#PostgreBin}createdb.exe" -h localhost -p 5432 -U postgres {#DBPistaName} & "{#PostgreBin}pg_restore.exe" -Fc -v -h localhost -p 5432 -U postgres -w -d {#DBPistaName} "{app}{#SchemasDir}{#DBPistaBackup}"  & pause');
        InstallCMDExe := 'cmd.exe';
        OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Inicializando Base de datos Pista';
        Result := InstallDependency(InstallCMDExe, InstallCMDParams)

        InstallCMDParams := ExpandConstant('/c set "PGPASSWORD={#PasswordDB}" &"{#PostgreBin}createdb.exe" -h localhost -p 5432 -U postgres {#DBLogName} & "{#PostgreBin}pg_restore.exe" -Fc -v -h localhost -p 5432 -U postgres -w -d {#DBLogName} "{app}{#SchemasDir}{#DBLogBackup}" & pause');
        InstallCMDExe := 'cmd.exe';
        OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Inicializando Base de datos Logger Pista';
        Result := InstallDependency(InstallCMDExe, InstallCMDParams)

       InstallCMDParams := '/c pm2-startup install & pm2 start "{#InstallationDir}{#MyAppName}\server\server.js" & pm2 save --force ';
       InstallCMDExe := 'cmd.exe';
       OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando servicio en PM2';
       Result := InstallDependency(InstallCMDExe, InstallCMDParams);

       InstallCMDParams := '/c setx {#Checkpoint_1} "" /M & setx {#Checkpoint_2} "" /M & setx {#Checkpoint_3} "" /M';
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
Source: {#DependenciesDir}{#PostgreExeName};  Flags: dontcopy noencryption
Source: {#DependenciesDir}{#DotnetExeName};   Flags: dontcopy noencryption
Source: {#DependenciesDir}{#NodeExeName};     Flags: dontcopy noencryption
Source: {#DependenciesDir}{#npm}; Flags: dontcopy noencryption
Source: {#DependenciesDir}{#NIDAQ}; Flags: dontcopy noencryption
Source: {#DependenciesDir}{#DotnetOfflineExeName}; Flags: dontcopy noencryption

[Icons]
Name: "{group}\{cm:MyAppName}";         Filename: "{app}\{#UTollVisorDir}\{#UtollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"
Name: "{commondesktop}\{cm:MyAppName}"; Filename: "{app}\{#UTollVisorDir}\{#UTollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"
Name: "{commonstartup}\{cm:MyAppName}"; Filename: "{app}\{#UTollVisorDir}\{#UTollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"

[Run]
;Instalacion Programas
Filename: "{app}\{#CsServiceDir}\{#CamarografoDir}\{#CamarografoExe}"; Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Camar�grafo"; 
Filename: "{app}\{#CsServiceDir}\{#ConectorDir}\{#ConectorExe}"; Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando ConectorV2";
Filename: "{app}\{#CsServiceDir}\{#ImpresoraDir}\{#ImpresoraExe}"; Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Printer";
Filename: "{app}\{#CsServiceDir}\{#LectorManualDir}\{#LectorManualExe}"; Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Lector Manual";
Filename: "{app}\{#CsServiceDir}\{#MantenimientoDir}\{#MantenimientoExe}"; Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Mantenimiento";
Filename: "{app}\{#CsServiceDir}\{#PanelMensajeriaDir}\{#PanelMensajeriaExe}"; Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Panel de Mensajer�a";
Filename: "{app}\{#CsServiceDir}\{#PistaDir}\{#PistaExe}"; Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Pista";
Filename: "{app}\{#CsServiceDir}\{#RFIDDir}\{#RFIDExe}"; Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando RFID Server";
Filename: "{app}\{#CsServiceDir}\{#UTCDir}\{#UTCExe}"; Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando UTC Server";


[UninstallRun]
; Stop Services
Filename: "{app}\{#CsServiceDir}\{#CamarografoDir}\{#CamarografoExe}";          Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#ConectorDir}\{#ConectorExe}";                Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#ImpresoraDir}\{#ImpresoraExe}";              Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#LectorManualDir}\{#LectorManualExe}";        Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#MantenimientoDir}\{#MantenimientoExe}";      Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#PanelMensajeriaDir}\{#PanelMensajeriaExe}";  Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#PistaDir}\{#PistaExe}";                      Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#RFIDDir}\{#RFIDExe}";                        Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#UTCDir}\{#UTCExe}";                          Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"

; Uninstall Services
Filename: "{app}\{#CsServiceDir}\{#CamarografoDir}\{#CamarografoExe}";          Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#ConectorDir}\{#ConectorExe}";                Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#ImpresoraDir}\{#ImpresoraExe}";              Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#LectorManualDir}\{#LectorManualExe}";        Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#MantenimientoDir}\{#MantenimientoExe}";      Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#PanelMensajeriaDir}\{#PanelMensajeriaExe}";  Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#PistaDir}\{#PistaExe}";                      Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#RFIDDir}\{#RFIDExe}";                        Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#CsServiceDir}\{#UTCDir}\{#UTCExe}";                          Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"






