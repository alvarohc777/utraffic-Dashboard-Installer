#define MyAppName "UToll Pista"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "U Traffic"




#define PublishFolder "Publish\"
#define InstallationDir "{commonpf}\"
#define InstallerName "UToll Pista Installer"

; Installer components
#define UTollVisorExeName   "UToll Pista.exe"     ; Frontend Executable
#define UTollVisorDir       "UToll Pista-win32-x64\" ; Frontend App Directory  ;1
#define ServerDir           "server\";
#define ServerFile          "\server.js";                                      ;2

#define SchemasDir          "\DB-Schemas\"
#define DBLogBackup         "ut_utoll_tyr_log_vacia.backup"
#define DBLogName           "ut_utoll_tyr_log"
#define DBPistaBackup       "ut_utoll_tyr_vacia.backup"
#define DBPistaName         "ut_utoll_tyr"

#define CsServiceDir        "Services\"                                          ;4
#define CamarografoDir      "Camarografo\"
#define CamarografoExe      "UT.UToll.TyR.Pista.Camarografo.exe"
#define ConectorDir         "Conector\"
#define ConectorExe         "UT.UToll.TyR.ConectorV2.exe"
#define ImpresoraDir        "Impresora\"
#define ImpresoraExe        "UT.UToll.TyR.Pista.Printer.exe"
#define LectorManualDir     "LectorManual\"
#define LectorManualExe     "UT.UToll.TyR.Pista.LectorManual.exe"
#define MantenimientoDir    "Mantenimiento\"
#define MantenimientoExe    "UT.UToll.TyR.Pista.Mantenimiento.exe"
#define PanelMensajeriaDir  "PanelMensajeria\"
#define PanelMensajeriaExe  "UT.UToll.TyR.Pista.PMV.exe"
#define PistaDir            "Pista\"
#define PistaExe            "UT.UToll.TyR.Pista.Service.exe"
#define RFIDDir             "RFID\"
#define RFIDExe             "UT.UToll.TyR.RfidServer.exe"
#define UTCDir              "UTC\"
#define UTCExe              "UT.UToll.TyR.UTC.Server.exe"

#define UtilsDir            "Utils\"


; Installer dependencies
#define DependenciesDir       "Dependencies\"
#define VCRedisX64ExeName     "VC_redist.x64.exe"
#define VCRedisX86ExeName     "VC_redist.x86.exe"
#define DotnetExeName         "ndp461-devpack-kb3105179-enu.exe"
#define Dotnet5ExeName        "dotnet-sdk-5.0.408-win-x64.exe"
#define PostgreExeName        "postgresql-15.3-1-windows-x64.exe"
#define NodeExeName           "node-v18.16.1-x64.msi"
#define NIDAQ                 "NIDAQ.tar"
#define NIDAQDir              "NIDAQ930f2\"
#define NIDAQExeName          "setup.exe"
#define NIDAQConfigFile       "customInstallation.ini"
#define npm "npm.tar"
#define npmDir "npm\";
#define DotnetOfflineExeName  "NET-Framework-3.5-Offline-Installer-v2.3.exe"


; Files Packed with Installer
#define WindowsISO "Windows.iso"

; Installation Environment Variables
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

#define PasswordDB "utraffic"

#define PasswordEnvVar "PasswordDB"
#define IdPistaEnvVar "IdPista"
#define IdPlazaEnvVar "IdPlaza"

#define MyService "Solicitudes"
#define PostgreBin "C:\Program Files\PostgreSQL\15\bin\"
; App GUID
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
  PistaSetupPage: TInputQueryWizardPage;
  Checkpoint_1: Boolean;
  Checkpoint_2: Boolean;
  Checkpoint_3: Boolean;
  PasswordDB: String;
  IdPista: String;
  IdPlaza: String;

// Procedure to close the Installer
procedure ExitProcess(uExitCode: Integer);
  external 'ExitProcess@kernel32.dll stdcall';

function InstallDependency(DependencyExe: String; Params: String): Boolean;
var 
  ResultCode: Integer;
begin

  
  if Exec(DependencyExe,Params,'', SW_HIDE, ewWaitUntilTerminated, ResultCode) then
    begin
      if ResultCode = 1 then
        Result:=True
      else
        Result:=false;
    end;
end;

// Funci�n para evaluar los checkpoint
function Checkpoint(EnvVar: String): Boolean;
begin
  if (GetEnv(EnvVar) <> '') then
    Result := True
  else
    Result := False;
end;

procedure CurPageChanged(CurPageId: Integer);
begin
  if CurPageId = wpReady then 
    begin
      WizardForm.BackButton.Hide
    end;
end;
function FileReplaceString(const FileName, SearchString, ReplaceString: string):boolean;
var
  MyFile : TStrings;
  MyText : string;
begin
  MyFile := TStringList.Create;

  try
    result := true;

    try
      MyFile.LoadFromFile(FileName);
      MyText := MyFile.Text;

      { Only save if text has been changed. }
      if StringChangeEx(MyText, SearchString, ReplaceString, True) > 0 then
      begin;
        MyFile.Text := MyText;
        MyFile.SaveToFile(FileName);
      end;
    except
      result := false;
    end;
  finally
    MyFile.Free;
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
    PistaSetupPage := CreateInputQueryPage(wpPassword, 
  'Información de Configuración', 'Contraseña Base de datos', 
  'Especifique la contraseña, pulse click en Siguiente.');
  PistaSetupPage.Add('Password Base de Datos', True);
  PistaSetupPage.Values[0] := 'utraffic'; 
  PistaSetupPage.Add('Id Pista', False);
  PistaSetupPage.Values[1] := '1'; 
  PistaSetupPage.Add('Id Plaza', False);
  PistaSetupPage.Values[2] := '1';

  // Verificar los checkpoints
  Checkpoint_1 := Checkpoint('{#Checkpoint_1}');
  Checkpoint_2 := Checkpoint('{#Checkpoint_2}');
  Checkpoint_3 := Checkpoint('{#Checkpoint_3}');
  PasswordDB := GetEnv('{#PasswordEnvVar}');
  IdPista := GetEnv('{#IdPistaEnvVar}');
  IdPlaza := GetEnv('{#IdPlazaEnvVar}');

  WizardForm.LicenseAcceptedRadio.Checked := True;
  WizardForm.PasswordEdit.Text := '{#Password}';
  WizardForm.WelcomeLabel1.Caption := 'Bienvenido al asistente de instalación de UToll Pista';
  WizardForm.WelcomeLabel2.Caption := 'Este programa instalará UToll Pista en su versión 1.0.0 en su sistema.' #13#10 #13#10 'Se recomienda cerrar todas las demás aplicaciones antes de continuar.' #13#10 #13#10 'Haga click en Siguiente para continuar o en Cancelar para salir de la instalación.'
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
    (PageID = PistaSetupPage.ID)  
  );
end;

function NextButtonClick(CurPageId: Integer): Boolean;
var 
  I, Max: Integer;
  InstallCMDParams: String;
  InstallCMDExe: String;
  ResultCode: Integer;
  strFilename: string;
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
          I := 2;

          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting DotNet 4.6.1';
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
          InstallDependency('cmd.exe', Format('/c setx {#PasswordEnvVar} "%s" /M & setx {#IdPistaEnvVar} "%s" /M & setx {#IdPlazaEnvVar} "%s" /M', [PistaSetupPage.Values[0], PistaSetupPage.Values[1], PistaSetupPage.Values[2]])); 

          
          
          InstallCMDParams := '--unattendedmodeui minimal --mode unattended --superpassword "'+PistaSetupPage.Values[0]+'" --servicename "postgreSQL" --servicepassword "'+PistaSetupPage.Values[0]+'" --serverport 5432  --disable-components pgAdmin,stackbuilder';
          InstallCMDExe := ExpandConstant('{tmp}\')+'{#PostgreExeName}';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Postgre6.0';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          InstallCMDParams := '/install /passive /norestart';
          InstallCMDExe := ExpandConstant('{tmp}\')+'{#DotNetExeName}';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Dotnet 4.6.1';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          InstallCMDParams := '/install /passive /norestart';
          InstallCMDExe := ExpandConstant('{tmp}\')+'{#Dotnet5ExeName}';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Dotnet 5.0.0';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          InstallCMDParams := '/i '+ ExpandConstant('{tmp}\{#NodeExeName}')+' /passive';
          InstallCMDExe := 'msiexec.exe'; 
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando NodeJs';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);
             
          InstallCMDParams := ExpandConstant('/c tar -xf {tmp}\{#npm} -C {tmp} & xcopy /E /Y /I {tmp}\{#npmDir} {userappdata}\npm')
          InstallCMDExe := 'cmd.exe'
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Pm2';
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

          if MsgBox('Se instaló correctamente Dotnet3.5', mbConfirmation, MB_YESNO) = IDNO then
          begin
            ExitProcess(1);
          end;

          InstallCMDParams := '/c setx {#Checkpoint_2} "True" /M';
          InstallCMDExe := 'cmd.exe'; 
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);
        end;

      if not Checkpoint_3 then
        begin

          InstallCMDParams := ExpandConstant('/c echo "Decompressing NIDAQ" & tar -xf {tmp}\{#NIDAQ} -C {tmp} & {tmp}\{#NIDAQDir}{#NIDAQExeName} {tmp}\{#NIDAQDir}{#NIDAQConfigFile} /qb /AcceptLicenses yes /r ');
          InstallCMDExe := 'cmd.exe'; 
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando NI-DAQ';
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          if MsgBox('Se instaló correctamente NIDAQ?', mbConfirmation, MB_YESNO) = IDNO then
            begin
              ExitProcess(1);
            end;

            InstallCMDParams := '/c setx {#Checkpoint_3} "True" /M & shutdown /r /t 10 ';
            InstallCMDExe := 'cmd.exe'; 
            MsgBox('Al presionar OK el sistema se reiniciará en 10 segundos', mbInformation, MB_OK);
            Result := InstallDependency(InstallCMDExe, InstallCMDParams);
            OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Reiniciando el sistema';

          ExitProcess(1);
        end
        else begin
          
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Esperando a que se instalen los sensores';

          MsgBox('A continuación se abrirá el NIDAQ. Asegúrese de que están correctamente confgurados los sensores.', mbInformation, MB_OK);

          InstallCMDParams := '/c "C:\Program Files (x86)\National Instruments\MAX\NIMax.exe"';
          InstallCMDExe := 'cmd.exe'; 
          Result := InstallDependency(InstallCMDExe, InstallCMDParams);

          
          if MsgBox('Asegúrese de haber instalado correctamente los sensores', mbConfirmation, MB_YESNO) = IDNO then
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
 
          //Configuracion Servicio
            
            strFilename := ExpandConstant('{app}\{#PistaDir}UT.UToll.TyR.Pista.Service.exe.config');
            MsgBox(strFilename, mbInformation, MB_OK);
            if FileExists(strFilename) then
            begin
                FileReplaceString(strFilename, '{PasswordDB}', PasswordDB);
            end;

            strFilename := ExpandConstant('{app}\{#PistaDir}config.json');
            if FileExists(strFilename) then
            begin
                FileReplaceString(strFilename, '{IdPista}', IdPista);
                FileReplaceString(strFilename, '{IdPlaza}', IdPlaza);
            end;

        InstallCMDParams := '/c netsh advfirewall set allprofiles state on & netsh advfirewall firewall add rule name="Puerto BBDD" dir=in action=allow enable=yes protocol=TCP localport=5432 profile=any';
        InstallCMDExe := 'cmd.exe';
        OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Adding firewall rule POSTGRESQL';
        Result := InstallDependency(InstallCMDExe, InstallCMDParams);

        InstallCMDParams := ExpandConstant('/c netsh advfirewall firewall add rule name="node in" dir=in action=allow program="{commonpf}\nodejs\node.exe" & netsh advfirewall firewall add rule name="node out" dir=out action=allow program="{commonpf}\nodejs\node.exe"');
        InstallCMDExe := 'cmd.exe';
        OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Adding firewall rule POSTGRESQL';
        Result := InstallDependency(InstallCMDExe, InstallCMDParams);

        InstallCMDParams := ExpandConstant('/c netsh advfirewall firewall add rule name="PM2 in" dir=in action=allow program="{userappdata}\npm\pm2.cmd" & netsh advfirewall firewall add rule name="PM2 out" dir=out action=allow program="{userappdata}\npm\pm2.cmd"');
        InstallCMDExe := 'cmd.exe'
        OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Adding firewall rule Pm2';
        Result := InstallDependency(InstallCMDExe, InstallCMDParams);

        InstallCMDParams := ExpandConstant('/c netsh advfirewall firewall add rule name="Pista in" dir=in action=allow program="{app}\{#PistaDir}\{#PistaExe}" & netsh advfirewall firewall add rule name="Pista out" dir=out action=allow program="{app}\{#PistaDir}\{#PistaExe}"');
        InstallCMDExe := 'cmd.exe'
        OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Adding firewall rule Pista Service';
        Result := InstallDependency(InstallCMDExe, InstallCMDParams);

        InstallCMDParams := ExpandConstant('/c set "PGPASSWORD='+PasswordDB+'" & "{#PostgreBin}createdb.exe" -h localhost -p 5432 -U postgres {#DBPistaName} & "{#PostgreBin}pg_restore.exe" -Fc -v -h localhost -p 5432 -U postgres -w -d {#DBPistaName} "{app}{#SchemasDir}{#DBPistaBackup}" ');
        InstallCMDExe := 'cmd.exe';
        OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Inicializando Base de datos Pista';
        Result := InstallDependency(InstallCMDExe, InstallCMDParams)

        InstallCMDParams := ExpandConstant('/c set "PGPASSWORD='+PasswordDB+'" &"{#PostgreBin}createdb.exe" -h localhost -p 5432 -U postgres {#DBLogName} & "{#PostgreBin}pg_restore.exe" -Fc -v -h localhost -p 5432 -U postgres -w -d {#DBLogName} "{app}{#SchemasDir}{#DBLogBackup}"');
        InstallCMDExe := 'cmd.exe';
        OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Inicializando Base de datos Logger Pista';
        Result := InstallDependency(InstallCMDExe, InstallCMDParams)

       InstallCMDParams := ExpandConstant('/c pm2-startup install & pm2 start "{app}\server\server.js" & pm2 save --force');
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

[Types]
Name: "full";     Description: "Full install";
; Name: "compact";  Description: "Compact installation"
; Name: "custom";   Description: "Custom installation"; Flags: iscustom

[Components]
Name: UTollVisor;               Description: "UToll Pista Visor (Frontend)";    types: full; Flags: fixed;

Name: Services;                 Description: "Pista Services";                  types: full; Flags: fixed;     
Name: Services\Camarografo;     Description: "Camarógrafo";                     types: full; Flags: fixed; 
Name: Services\Conector;        Description: "Conector";                        types: full; Flags: fixed; 
Name: Services\Impresora;       Description: "Impresora";                       types: full; Flags: fixed; 
Name: Services\LectorManual;    Description: "Lector Manual";                   types: full; Flags: fixed; 
Name: Services\Mantenimiento;   Description: "Mantenimiento";                   types: full; Flags: fixed; 
Name: Services\PanelMensajeria; Description: "Panel de Mensajería";             types: full; Flags: fixed; 
Name: Services\Pista;           Description: "Pista";                           types: full; Flags: fixed;     
Name: Services\RFID;            Description: "RFID";                            types: full; Flags: fixed;     
Name: Services\UTC;             Description: "UTraffic Controller (UTC)";       types: full; Flags: fixed;

Name: Server;                   Description: "Server Pista";                    types: full; Flags: fixed;

Name: Database;                 Description: "Database Schemas";                types: full; Flags: fixed; 
Name: Database\Pista;           Description: "Pista Database";                  types: full; Flags: fixed; 
Name: Database\PistaLog;        Description: "Pista Log Database";              types: full; Flags: fixed; 

Name: Utils;                    Description: "Touch Screen Drivers";            types: full; Flags: fixed;


          

[Files]
Source: {#PublishFolder}{#UTollVisorDir}*;                      DestDir: "{app}\{#UTollVisorDir}";      Flags: ignoreversion recursesubdirs createallsubdirs; Components: UTollVisor
Source: {#PublishFolder}{#CsServiceDir}{#CamarografoDir}*;      DestDir: "{app}\{#CamarografoDir}";     Flags: ignoreversion recursesubdirs createallsubdirs; Components: Services\Camarografo
Source: {#PublishFolder}{#CsServiceDir}{#ConectorDir}*;         DestDir: "{app}\{#ConectorDir}";        Flags: ignoreversion recursesubdirs createallsubdirs; Components: Services\Conector
Source: {#PublishFolder}{#CsServiceDir}{#ImpresoraDir}*;        DestDir: "{app}\{#ImpresoraDir}";       Flags: ignoreversion recursesubdirs createallsubdirs; Components: Services\Impresora
Source: {#PublishFolder}{#CsServiceDir}{#LectorManualDir}*;     DestDir: "{app}\{#LectorManualDir}";    Flags: ignoreversion recursesubdirs createallsubdirs; Components: Services\LectorManual
Source: {#PublishFolder}{#CsServiceDir}{#MantenimientoDir}*;    DestDir: "{app}\{#MantenimientoDir}";   Flags: ignoreversion recursesubdirs createallsubdirs; Components: Services\Mantenimiento
Source: {#PublishFolder}{#CsServiceDir}{#PanelMensajeriaDir}*;  DestDir: "{app}\{#PanelMensajeriaDir}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: Services\PanelMensajeria
Source: {#PublishFolder}{#CsServiceDir}{#PistaDir}*;            DestDir: "{app}\{#PistaDir}";           Flags: ignoreversion recursesubdirs createallsubdirs; Components: Services\Pista
Source: {#PublishFolder}{#CsServiceDir}{#RFIDDir}*;             DestDir: "{app}\{#RFIDDir}";            Flags: ignoreversion recursesubdirs createallsubdirs; Components: Services\RFID
Source: {#PublishFolder}{#CsServiceDir}{#UTCDir}*;              DestDir: "{app}\{#UTCDir}";             Flags: ignoreversion recursesubdirs createallsubdirs; Components: Services\UTC
Source: {#PublishFolder}{#ServerDir}*;                          DestDir: "{app}\{#ServerDir}";          Flags: ignoreversion recursesubdirs createallsubdirs; Components: Server
Source: {#PublishFolder}{#SchemasDir}{#DBLogBackup};            DestDir: "{app}\{#SchemasDir}";         Flags: ignoreversion recursesubdirs createallsubdirs; Components: Database\Pista
Source: {#PublishFolder}{#SchemasDir}{#DBPistaBackup};          DestDir: "{app}\{#SchemasDir}";         Flags: ignoreversion recursesubdirs createallsubdirs; Components: DataBase\PistaLog
Source: {#PublishFolder}{#UtilsDir}*;                           DestDir: "{app}\{#UtilsDir}";           Flags: ignoreversion recursesubdirs createallsubdirs; Components: Utils
; Icons and Aux Files
Source: {#AuxDataDir}{#AppIcon}; DestName:{#AppIcon}; DestDir: "{app}"
; Dependencies Temporary Files
Source: {#DependenciesDir}{#PostgreExeName};        Flags: dontcopy noencryption
Source: {#DependenciesDir}{#DotnetExeName};         Flags: dontcopy noencryption
Source: {#DependenciesDir}{#Dotnet5ExeName};         Flags: dontcopy noencryption
Source: {#DependenciesDir}{#NodeExeName};           Flags: dontcopy noencryption
Source: {#DependenciesDir}{#npm};                   Flags: dontcopy noencryption
Source: {#DependenciesDir}{#NIDAQ};                 Flags: dontcopy noencryption
Source: {#DependenciesDir}{#DotnetOfflineExeName};  Flags: dontcopy noencryption

[Icons]
Name: "{group}\{cm:MyAppName}";         Filename: "{app}\{#UTollVisorDir}\{#UtollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"
Name: "{commondesktop}\{cm:MyAppName}"; Filename: "{app}\{#UTollVisorDir}\{#UTollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"
Name: "{commonstartup}\{cm:MyAppName}"; Filename: "{app}\{#UTollVisorDir}\{#UTollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"

[Run]
; Instalacion Programas
Filename: "{app}\{#CamarografoDir}\{#CamarografoExe}";          Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Camar�grafo";                                  
Filename: "{app}\{#ConectorDir}\{#ConectorExe}";                Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando ConectorV2";                           
Filename: "{app}\{#ImpresoraDir}\{#ImpresoraExe}";              Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Printer";                           
Filename: "{app}\{#LectorManualDir}\{#LectorManualExe}";        Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Lector Manual";                           
Filename: "{app}\{#MantenimientoDir}\{#MantenimientoExe}";      Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Mantenimiento";                           
Filename: "{app}\{#PanelMensajeriaDir}\{#PanelMensajeriaExe}";  Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Panel de Mensajer�a";                          
Filename: "{app}\{#PistaDir}\{#PistaExe}";                      Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Pista";                                       
Filename: "{app}\{#RFIDDir}\{#RFIDExe}";                        Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando RFID Server";                                        
Filename: "{app}\{#UTCDir}\{#UTCExe}";                          Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando UTC Server";                                         


[UninstallRun]
; Stop Services
Filename: "{app}\{#CamarografoDir}\{#CamarografoExe}";          Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#ConectorDir}\{#ConectorExe}";                Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#ImpresoraDir}\{#ImpresoraExe}";              Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#LectorManualDir}\{#LectorManualExe}";        Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#MantenimientoDir}\{#MantenimientoExe}";      Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#PanelMensajeriaDir}\{#PanelMensajeriaExe}";  Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#PistaDir}\{#PistaExe}";                      Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#RFIDDir}\{#RFIDExe}";                        Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#UTCDir}\{#UTCExe}";                          Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"

; Uninstall Services
Filename: "{app}\{#CamarografoDir}\{#CamarografoExe}";          Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#ConectorDir}\{#ConectorExe}";                Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#ImpresoraDir}\{#ImpresoraExe}";              Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#LectorManualDir}\{#LectorManualExe}";        Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#MantenimientoDir}\{#MantenimientoExe}";      Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#PanelMensajeriaDir}\{#PanelMensajeriaExe}";  Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#PistaDir}\{#PistaExe}";                      Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#RFIDDir}\{#RFIDExe}";                        Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
Filename: "{app}\{#UTCDir}\{#UTCExe}";                          Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"






