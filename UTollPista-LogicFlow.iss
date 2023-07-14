#define MyAppName "UToll Pista"
#define MyAppVersion "1.0.0"
#define MyAppPublisher "U Traffic"




; #define PublishFolder "C:\Users\Administrador\Documents\utraffic\InnoSetup\Solicitudes\SolicitudesInstaller\TestFiles\*"
#define PublishFolder "C:\Users\Administrador\Documents\utraffic\InnoSetup\Solicitudes\SolicitudesInstaller\TestFiles\"

#define InstallationDir "{commonpf}\"
#define InstallerName "UToll Pista Installer - LogicFlow"

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

#define CsServiceDir        "Deploy\"                                          ;4
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
#define npm "npm.tar"
#define npmDir "npm\";
#define DotnetOfflineExeName "NET-Framework-3.5-Offline-Installer-v2.3.exe"


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

#define AppId "{{4372BD00-1EC0-4F22-9F87-5436E942D980}"


[Setup]
AppId = {#AppId}
AppName={#MyAppName}
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
OutputDir=userdocs:utraffic\InnoSetup\PruebaDotnet6

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

function Checkpoint(EnvVar: String): Boolean;
begin
  if (GetEnv(EnvVar) <> '') then
    Result := True
  else
    Result := False;
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
//   if not FileExists(ExpandConstant('{src}\{#WindowsISO}')) then
//   begin
//     MsgBox(ExpandConstant('Windows.iso was not detected in: "{src}"'), mbError, MB_OK);
//     ExitProcess(1);
//   end;
    PistaSetupPage := CreateInputQueryPage(wpPassword, 
  'Información de Configuración', 'Contraseña Base de datos', 
  'Especifique la contraseña, pulse click en Siguiente.');
  PistaSetupPage.Add('Password Base de Datos', True);
  PistaSetupPage.Values[0] := 'utraffic'; 
  PistaSetupPage.Add('Id Pista', False);
  PistaSetupPage.Values[1] := '1'; 
  PistaSetupPage.Add('Id Plaza', False);
  PistaSetupPage.Values[2] := '1';

  Checkpoint_1 := Checkpoint('{#Checkpoint_1}');
  Checkpoint_2 := Checkpoint('{#Checkpoint_2}');
  Checkpoint_3 := Checkpoint('{#Checkpoint_3}');
  PasswordDB := GetEnv('{#PasswordEnvVar}');
  IdPista := GetEnv('{#IdPistaEnvVar}');
  IdPlaza := GetEnv('{#IdPlazaEnvVar}');
  MsgBox(PasswordDB+ ' - ' + IdPista + ' - ' + IdPlaza, mbInformation, MB_OK);


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
    (PageID = wpSelectTasks) 
    
//     (PageID = wpReady)
  );
end;

procedure CurPageChanged(CurPageId: Integer);
begin
  if CurPageId = wpReady then 
    begin
      WizardForm.BackButton.Hide
    end;
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
          I := 3;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting DotNet6.0';
//           ExtractTemporaryFile('{#DotNetExeName}');
//           MsgBox('Extracting DotNet6.0', mbInformation, MB_OK);
          OutputProgressWizardPage.SetProgress(I, Max);

          I := 5;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting PostgreSQL';
//           ExtractTemporaryFile('{#PostgreExeName}');
//           MsgBox('Extracting PostgreSQL', mbInformation, MB_OK);
          OutputProgressWizardPage.SetProgress(I, Max);

          I := 6;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting NodeJs';
//           ExtractTemporaryFile('{#NodeExeName}');
//           MsgBox('Extracting NodeJs', mbInformation, MB_OK);
          OutputProgressWizardPage.SetProgress(I, Max);

          I := 7;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting PM2';
//           ExtractTemporaryFile('{#npm}');
//           MsgBox('Extracting PM2', mbInformation, MB_OK);
          OutputProgressWizardPage.SetProgress(I, Max);
      end; 
      if not Checkpoint_2 then
      begin
          I := 8;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting Dotnet3.5 Offline Installer';
//           ExtractTemporaryFile('{#DotnetOfflineExeName}');
//           MsgBox('Extracting Dotnet 3.5 offline installer', mbInformation, MB_OK);
          OutputProgressWizardPage.SetProgress(I, Max);
      end; 
      if not Checkpoint_3 then
      begin
          I := 10;
          OutputProgressWizardPage.Msg2Label.Caption := 'Extracting NIDAQ';
//           ExtractTemporaryFile('{#NIDAQ}');
//           MsgBox('Extracting NIDAQ', mbInformation, MB_OK);
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
            MsgBox('--unattendedmodeui minimal --mode unattended --superpassword "'+PistaSetupPage.Values[0]+'" --servicename "postgreSQL" --servicepassword "'+PistaSetupPage.Values[0]+'" --serverport 5432  --disable-components pgAdmin,stackbuilder', mbInformation, MB_OK);
          InstallCMDParams := '--unattendedmodeui minimal --mode unattended --superpassword "'+PistaSetupPage.Values[0]+'" --servicename "postgreSQL" --servicepassword "'+PistaSetupPage.Values[0]+'" --serverport 5432  --disable-components pgAdmin,stackbuilder';
          InstallCMDExe := ExpandConstant('{tmp}\')+'{#PostgreExeName}';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Postgre6.0';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
//           MsgBox('Instalado: de PostgreSQL', mbInformation, MB_OK);

//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
//           MsgBox('Add Firewall exception: PostgreSQL', mbInformation, MB_OK);

          InstallCMDParams := '/install /passive /norestart';
          InstallCMDExe := ExpandConstant('{tmp}\')+'{#DotNetExeName}';
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Dotnet 4.6.1';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
//           MsgBox('Instalado: de Dotnet 4.6.1', mbInformation, MB_OK);

          InstallCMDParams := '/i '+ ExpandConstant('{tmp}\{#NodeExeName}')+' /passive';
          InstallCMDExe := 'msiexec.exe'; 
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando NodeJs';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
//           MsgBox('Instalado: de NodeJs', mbInformation, MB_OK);

//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
//           MsgBox('Add Firewall exception: PostgreSQL', mbInformation, MB_OK);
          
          InstallCMDParams := ExpandConstant('/c tar -xf {tmp}\{#npm} -C {tmp} & xcopy /E /Y /I {tmp}\{#npmDir} {userappdata}\npm')
          InstallCMDExe := 'cmd.exe'
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Pm2';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
//           MsgBox('Instalado: Pm2', mbInformation, MB_OK);

//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
//           MsgBox('Add Firewall Exception: Pm2', mbInformation, MB_OK);

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
//           MsgBox('Windows.iso Montado', mbInformation, MB_OK);

          InstallCMDParams := ExpandConstant('/c {tmp}\{#DotnetOfflineExeName}');
          InstallCMDExe := 'cmd.exe'
          OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando Dotnet Offline';
//           Result := InstallDependency(InstallCMDExe, InstallCMDParams);
//           MsgBox('Se abre Dotnet 3.5 offline installer (operaci�n manual).', mbInformation, MB_OK);
          

          if MsgBox('Se instal� correctamente Dotnet3.5', mbConfirmation, MB_YESNO) = IDNO then
          begin
          ExitProcess(1);
          end;
//           MsgBox('Instalado: dotnet 3.5 offline', mbInformation, MB_OK);

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
//           MsgBox('Instalado NIDAQ', mbInformation, MB_OK);


//             InstallCMDParams := '/c setx {#Checkpoint_3} "True" /M & shutdown /r /t 10 ';
            InstallCMDParams := '/c setx {#Checkpoint_3} "True" /M';
            InstallCMDExe := 'cmd.exe'; 
//             MsgBox('Al presionar OK el sistema se reiniciar� en 10 segundos', mbInformation, MB_OK);
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

//         InstallCMDParams := '/c set "PGPASSWORD={#PasswordDB}" &"C:\Program Files\PostgreSQL\15\bin\createdb.exe" -h localhost -p 5432 -U postgres {#SchemasTestDBName} & "C:\Program Files\PostgreSQL\15\bin\pg_restore.exe" -Fc -v -h localhost -p 5432 -U postgres -w -d {#SchemasTestDBName} ' + ExpandConstant('"{app}{#SchemasDir}{#SchemasTestFile}"') + ' & pause';
           MsgBox('/c set "PGPASSWORD='+PasswordDB+'" &"C:\Program Files\PostgreSQL\15\bin\createdb.exe" -h localhost -p 5432 -U postgres  & "C:\Program Files\PostgreSQL\15\bin\pg_restore.exe" -Fc -v -h localhost -p 5432 -U postgres -w -d  ' + ExpandConstant('"{app}{#SchemasDir}"') + ' & pause',mbInformation,MB_OK);
        InstallCMDExe := 'cmd.exe';
        OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Inicializando Base de datos';
//         Result := InstallDependency(InstallCMDExe, InstallCMDParams)
//         MsgBox('Backup restored from .backup', mbInformation, MB_OK);       
//        MsgBox(ExpandConstant('/c pm2-startup install & pm2 start "{#InstallationDir}{#MyAppName}\server\server.js" & pm2 save --force & pause '), mbInformation, MB_OK);
       InstallCMDParams := ExpandConstant('/c pm2-startup install & pm2 start "{app}\server\server.js" & pm2 save --force & pause ');
       InstallCMDExe := 'cmd.exe';
       OutputMarqueeProgressWizardPage.Msg2Label.Caption := 'Instalando servicio en PM2';
//        Result := InstallDependency(InstallCMDExe, InstallCMDParams);
       MsgBox('Instalado: Servicio PM2', mbInformation, MB_OK);
       InstallCMDParams := '/c  setx /M {#Checkpoint_1} ""  & setx /M {#Checkpoint_2} ""  & setx /M {#Checkpoint_3} "" ';
       InstallCMDExe := 'cmd.exe';
//        Result := InstallDependency(InstallCMDExe, InstallCMDParams);
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




[Icons]
Name: "{group}\{cm:MyAppName}";         Filename: "{app}\{#UTollVisorDir}\{#UtollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"
Name: "{commondesktop}\{cm:MyAppName}"; Filename: "{app}\{#UTollVisorDir}\{#UTollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"
Name: "{commonstartup}\{cm:MyAppName}"; Filename: "{app}\{#UTollVisorDir}\{#UTollVisorExeName}"; IconFilename: "{app}\{#AppIcon}"

; [Run]
; nstalacion Programas
; Filename: "{app}\{#CsServiceDir}\{#CamarografoDir}\{#CamarografoExe}";          Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Camar�grafo";                                  
; Filename: "{app}\{#CsServiceDir}\{#ConectorDir}\{#ConectorExe}";                Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando ConectorV2";                           
; Filename: "{app}\{#CsServiceDir}\{#ImpresoraDir}\{#ImpresoraExe}";              Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Printer";                           
; Filename: "{app}\{#CsServiceDir}\{#LectorManualDir}\{#LectorManualExe}";        Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Lector Manual";                           
; Filename: "{app}\{#CsServiceDir}\{#MantenimientoDir}\{#MantenimientoExe}";      Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Mantenimiento";                           
; Filename: "{app}\{#CsServiceDir}\{#PanelMensajeriaDir}\{#PanelMensajeriaExe}";  Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Panel de Mensajer�a";                          
; Filename: "{app}\{#CsServiceDir}\{#PistaDir}\{#PistaExe}";                      Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando Pista";                 Components: Pista;                      
; Filename: "{app}\{#CsServiceDir}\{#RFIDDir}\{#RFIDExe}";                        Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando RFID Server";           Components: RFID;                             
; Filename: "{app}\{#CsServiceDir}\{#UTCDir}\{#UTCExe}";                          Parameters: "install"; Flags: runascurrentuser runhidden; Description: "Instalaci�n servicios C#"; StatusMsg: "Instalando UTC Server";            Components: UTC;                             


; [UninstallRun]
; Stop Services
; Filename: "{app}\{#CsServiceDir}\{#CamarografoDir}\{#CamarografoExe}";          Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#ConectorDir}\{#ConectorExe}";                Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#ImpresoraDir}\{#ImpresoraExe}";              Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#LectorManualDir}\{#LectorManualExe}";        Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#MantenimientoDir}\{#MantenimientoExe}";      Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#PanelMensajeriaDir}\{#PanelMensajeriaExe}";  Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#PistaDir}\{#PistaExe}";                      Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#RFIDDir}\{#RFIDExe}";                        Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#UTCDir}\{#UTCExe}";                          Parameters: "stop"; Flags: runhidden; RunOnceId: "DelService"

; Uninstall Services
; Filename: "{app}\{#CsServiceDir}\{#CamarografoDir}\{#CamarografoExe}";          Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#ConectorDir}\{#ConectorExe}";                Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#ImpresoraDir}\{#ImpresoraExe}";              Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#LectorManualDir}\{#LectorManualExe}";        Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#MantenimientoDir}\{#MantenimientoExe}";      Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#PanelMensajeriaDir}\{#PanelMensajeriaExe}";  Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#PistaDir}\{#PistaExe}";                      Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#RFIDDir}\{#RFIDExe}";                        Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"
; Filename: "{app}\{#CsServiceDir}\{#UTCDir}\{#UTCExe}";                          Parameters: "uninstall"; Flags: runhidden; RunOnceId: "DelService"






