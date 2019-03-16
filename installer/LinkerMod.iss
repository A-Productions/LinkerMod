; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#include "./scripts/common.iss"

[Setup]
AppName=LinkerMod
AppVersion=0.0.1
UninstallDisplayIcon={app}\LinkerMod.exe

#if BUILD_TYPE == 'PRODUCTION'
	WizardImageFile=C:\Users\SE2Dev\Pictures\dface_512x512.bmp
	WizardSmallImageFile=C:\Users\SE2Dev\Pictures\dface_512x512.bmp
#endif


[Icons]
Name: "{commondesktop}\Game Mod";	Filename: "{#BinDir}\{#GameMod_Exe}"

; THESE ARE NOT NEEDED (AS STEAM'S LAUNCHER SHORTCUT WORKS FINE)
; Name: "{commondesktop}\Launcher";	Filename: "{#BinDir}\Launcher.exe"
; Name: "{commondesktop}\Radiant";	Filename: "{#BinDir}\CoDBORadiant.exe"

[Components]
;NOTE: The exlusive flag makes them radio buttons

Name: "GameMod";	Description: "Game Mod";	\
					Types: full compact custom;	\
					Flags: fixed;

Name: "LinkerMod"; 			Description: "Mod Tools";			\
							Types: full custom;
Name: "LinkerMod\Utils";	Description: "Asset Utility";		\
							Types: full custom;					\
							Flags: fixed;
Name: "LinkerMod\Mapping";	Description: "Mapping Tools";		\
							Types: full;

Name: "LinkerMod\Assets";	Description: "Game Assets";			\
							Types: full custom;

; IWD Assets
Name: "LinkerMod\Assets\IWD";		Description: "IWD Assets";				\
									Types: full custom;
Name: "LinkerMod\Assets\IWD\Img";	Description: "Images";					\
									Types: full custom;						\
									ExtraDiskSpaceRequired: 5343760384;
Name: "LinkerMod\Assets\IWD\Snd";	Description: "Sounds";					\
									Types: full custom;						\
									ExtraDiskSpaceRequired: 3819032576;
Name: "LinkerMod\Assets\IWD\Raw";		Description: "Rawfiles";			\
										Types: full custom;					\
										ExtraDiskSpaceRequired: 12439552;

; Fastfile Assets
Name: "LinkerMod\Assets\FF";		Description: "Fastfile Assets";			\
									Types: full custom;
Name: "LinkerMod\Assets\FF\Snd";	Description: "Sounds";					\
									Types: full custom;						\
									ExtraDiskSpaceRequired: 295206912;
Name: "LinkerMod\Assets\FF\Raw";	Description: "Rawfiles";				\
									Types: full custom;						\
									ExtraDiskSpaceRequired: 44056576;
Name: "LinkerMod\Assets\FF\Ents";	Description: "Entity Prefabs";			\
									Types: full custom;						\
									ExtraDiskSpaceRequired: 18104320;


[Tasks]
Name: Converter;	Description: "Run Converter";

[Files]
; Source: "README.md"; DestDir: "{app}"; Flags: isreadme

;
; Actual LinkerMod DLLs
;
Source: "build\Release\game_mod.dll";		DestDir: "{#BinDir}";				\
											Components: GameMod;
Source: "build\Release\linker_pc.dll";		DestDir: "{#BinDir}";				\
											Components: LinkerMod;
Source: "build\Release\cod2map.dll";		DestDir: "{#BinDir}";				\
											Components: LinkerMod\Mapping;
Source: "build\Release\cod2rad.dll";		DestDir: "{#BinDir}";				\
											Components: LinkerMod\Mapping;
Source: "build\Release\radiant_mod.dll";	DestDir: "{#BinDir}";				\
											Components: LinkerMod\Mapping;

;
; Install vanilla binaries
; NOTE: Anything that uses DestName must have it defined BEFORE DestDir
;       Otherwise the file will be copied, then copied again (and renamed)
;       Resulting in two files on the disk (or perhaps there was another cause).
;

; Install the existing BlackOps.exe into {app}\bin and add the required imports to it
; TODO: decide if renaming it GameMod works
Source: "{app}\BlackOps.exe";	DestName: "{#GameMod_Exe}";		\
								DestDir: "{#BinDir}";			\
								Components: GameMod;			\
								Flags: external ignoreversion;	\
								AfterInstall: PE_AddImport('game_mod.dll', '{#DEFAULT_EXPORT}');

; Copy the DLL dependencies for the patched game exe
Source: "{app}\binkw32.dll";	DestDir: "{#BinDir}";			\
								Components: GameMod;			\
								Flags: external ignoreversion;

Source: "{app}\steam_api.dll";	DestDir: "{#BinDir}";			\
								Components: GameMod;			\
								Flags: external ignoreversion;

; Mod tools binaries
Source: "{#BinSrcDir}\cod2map.exe";	DestDir: "{#BinDir}";			\
									Components: LinkerMod\Mapping;	\
									Flags: ignoreversion;			\
									AfterInstall: PE_AddImport('cod2map.dll', '{#DEFAULT_EXPORT}');

Source: "{#BinSrcDir}\cod2rad.exe";	DestDir: "{#BinDir}";			\
									Components: LinkerMod\Mapping;	\
									Flags: ignoreversion;			\
									AfterInstall: PE_AddImport('cod2rad.dll', '{#DEFAULT_EXPORT}');

Source: "{#BinSrcDir}\CoDWaWRadiant.exe";	DestName: "CoDBORadiant.exe";	\
											DestDir: "{#BinDir}";			\
											Components: LinkerMod\Mapping;	\
											Flags: ignoreversion;			\
											AfterInstall: PE_AddImport('radiant_mod.dll', '{#DEFAULT_EXPORT}');

;
; Mod Tools asset files
;

#if INSTALLER_INCLUDE_SCRIPTS == yes
; Utility scripts
Source: "components\scripts\*";		DestDir: "{#BinDir}\scripts";	\
									Components: LinkerMod\Utils; 	\
									Flags: recursesubdirs;
#endif

#if BUILD_TYPE == 'PRODUCTION'
; Custom / missing assets
; Should automatically be installed if the user requested mapping support
Source: "components\resource\*";	DestDir: "{app}";				\
									Components: LinkerMod\Mapping;	\
									Flags: recursesubdirs;
#endif

; Test automatic shit
; Source: "{code:GetAutoFiles}"; DestDir: "{#BinDir}\debug}";	Components: Debug; Flags: external recursesubdirs createallsubdirs

;
; Install Asset Util
; IMPORTANT: This MUST be installed LAST because it automatically initializes the
;            asset extraction steps, etc. (if the user enabled them)
;
Source: "build\Release\asset_util.exe";		DestDir: "{#BinDir}";				\
											Components: LinkerMod\Utils;		\
											AfterInstall: ExtractAssets;		\

[Run]
#if 0
Filename: "{#BinDir}\asset_util.exe";	StatusMsg: "Extracting IWD assets... {#PleaseWait}";											\
										Parameters: "extract-iwd --gamepath '{code:WizardDirValue}' {code:ExtractIWD_ResolveParams}";	\
										WorkingDir:	"{#BinDir}";																		\
										Components: LinkerMod\Assets\IWD;

Filename: "{#BinDir}\asset_util.exe";	StatusMsg: "Extracting fastfile assets... {#PleaseWait}";									\
										Parameters: "extract-ff --gamepath '{code:WizardDirValue}' {code:ExtractFF_ResolveParams}";	\
										WorkingDir:	"{#BinDir}";																	\
										Components: LinkerMod\Assets\FF\Snd LinkerMod\Assets\FF\Raw;

Filename: "{#BinDir}\asset_util.exe";	StatusMsg: "Extracting entity prefabs... {#PleaseWait}";									\
										Parameters: "ents --overwrite --dummyBrushes --gamepath '{code:WizardDirValue}' *";			\
										WorkingDir:	"{#BinDir}";																	\
										Components: LinkerMod\Assets\FF\Ents;
#endif

; Filename: "{app}\README.TXT"; Description: "View the README file"; Flags: postinstall shellexec skipifsilent

#if BUILD_TYPE == 'PRODUCTION'
Filename: "{#BinDir}\launcher.exe";		Description: "Launch mod tools";					\
										Flags: postinstall nowait skipifsilent unchecked;
#endif

[Code]
var
  Console: TRichEditViewer;

//
// Installer Entrypoint
//
procedure InitializeWizard;
begin
	// We don't need to do anything special here
	Console := TRichEditViewer.Create(WizardForm);
	Console.UseRichEdit := true;
	Console.Top := WizardForm.ProgressGauge.Top + WizardForm.ProgressGauge.Height + ScaleY(8);
	Console.Height := ScaleY(150);
	Console.Left := WizardForm.ProgressGauge.Left + ScaleX(0);
	Console.Width := ScaleX(417);
	Console.ScrollBars := ssVertical;
	// Console.ReadOnly := true;
	// Console.HideSelection := true;
	Console.Text := '';
	Console.Parent := WizardForm.InstallingPage;

	IPC_Init(Console.Handle);

	// CreateOutputMsgMemoPage(wpInstalling,
	// 	'Information', 'Please read the following important information before continuing.',
	// 	'When you are ready to continue with Setup, click Next.',
	// 	'Blah blah blah.');
	// ShouldProcessEntry;
end;

//
// Called when the user hits the "Next" button
//
function NextButtonClick(curPageID:integer): boolean;
begin
	// Automatically handle installation path validation
	// If the given path isn't valid, we return false and the
	// installer won't continue to the next page
	Result := Com_ValidateInstallPath(curPageID);
end;

// procedure CurStepChanged(CurStep: TSetupStep);
// begin
// 	// Upon entering the postInstall step, we need patch the imports
// 	// for the assigned files (this runs BEFORE the [Run] section)
// 	if CurStep = ssPostInstall then
// 	begin
// 		WizardForm.StatusLabel.Caption := 'Installing something...';
// 		{ Install something }
// 		MsgBox('POST INSTALL', mbError, MB_YESNO);
// 	end;
// end;

//
// Check if a given component is enabled - if it is, we append the mappedValue
// to argString and return argString
//
function AddRunArgument(var argString: string; compName: string; mappedValue: string): string;
begin
	if IsComponentSelected(compName) then
		argString := argString + ' ' + mappedValue;
	Result := argString;
end;

//
// Resolve the asset_util parameters for IWD asset extraction
//
function ExtractIWD_ResolveParams(): string;
begin
	Result := ' --overwrite --includeLocalized';

	AddRunArgument(Result, 'LinkerMod\Assets\IWD\Img', '--images');
	AddRunArgument(Result, 'LinkerMod\Assets\IWD\Snd', '--sounds');
	AddRunArgument(Result, 'LinkerMod\Assets\IWD\Raw', '--rawfiles');

	// MsgBox('IWD PARAMS: ' + Result, mbError, MB_YESNO);
end;

//
// Resolve the asset_util parameters for fastfile asset extraction
// TODO: Make this auto skip if sound & rawfiles are both empty
//
function ExtractFF_ResolveParams(): string;
begin
	Result := ' --overwrite --includeLocalized';

	AddRunArgument(Result, 'LinkerMod\Assets\FF\Snd', '--sounds');
	AddRunArgument(Result, 'LinkerMod\Assets\FF\Raw', '--rawfiles');

	// MsgBox('FF PARAMS: ' + Result, mbError, MB_YESNO);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
	if CurPageID = wpInstalling then begin
		// InstallMessage:= TLabel.Create(WizardForm);
		// InstallMessage.AutoSize:= False;
		// InstallMessage.Top := WizardForm.ProgressGauge.Top + WizardForm.ProgressGauge.Height + ScaleY(8);
		// InstallMessage.Height := ScaleY(150);
		// InstallMessage.Left := WizardForm.ProgressGauge.Left + ScaleX(0);
		// InstallMessage.Width := ScaleX(417);
		// InstallMessage.Font:= WizardForm.FilenameLabel.Font;
		// InstallMessage.Font.Color:= clBlack;
		// InstallMessage.Font.Height:= ScaleY(15);
		// InstallMessage.Transparent:= True;
		// InstallMessage.WordWrap:= true;
		// InstallMessage.Caption:= 'property BorderStyle: TFormBorderStyle; read write;\nproperty Caption: String; read write;\nproperty AutoScroll: Boolean; read write;\nproperty Color: TColor; read write;\nproperty Font: TFont; read write;\nproperty FormStyle: TFormStyle; read write;\nproperty KeyPreview: Boolean; read write;\nproperty Position: TPosition; read write;\nproperty OnActivate: TNotifyEvent; read write;\nproperty OnClick: TNotifyEvent; read write;\nproperty OnDblClick: TNotifyEvent; read write;\nproperty OnClose: TCloseEvent; read write;\nproperty OnCloseQuery: TCloseQueryEvent; read write;\nproperty OnCreate: TNotifyEvent; read write;\nproperty OnDestroy: TNotifyEvent; read write;\nproperty OnDeactivate: TNotifyEvent; read write;\nproperty OnHide: TNotifyEvent; read write;\nproperty OnKeyDown: TKeyEvent; read write;\nproperty OnKeyPress: TKeyPressEvent; read write;\nproperty OnKeyUp: TKeyEvent; read write;\nproperty OnResize: TNotifyEvent; read write;\nproperty OnShow: TNotifyEvent; read write;\n';
		// InstallMessage.Parent:= WizardForm.InstallingPage;


	end;
end;

// Notify the user that they need to validate their mod tools installation
// before they can use the mod tools again
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
	if CurUninstallStep = usPostUninstall then begin
		MsgBox('Please validate the integrity of your Mod Tools installation via Steam.', mbInformation, MB_OK);
	end
end;

function GetProgressHandle(Param: String): String;
begin
  Result := Format('%d', [Console.Handle]);
  //[WizardForm.FilenameLabel.Handle]);
	  //WizardForm.ProgressGauge.Handle]);
end;

// Filename: "{#BinDir}\asset_util.exe";	StatusMsg: "Extracting IWD assets... {#PleaseWait}";		\
// 										Parameters: "extract-iwd {code:ExtractIWD_ResolveParams}";		\
// 										WorkingDir:	"{#BinDir}";										\
// 										Components: LinkerMod\Assets\IWD;
//
// Filename: "{#BinDir}\asset_util.exe";	StatusMsg: "Extracting fastfile assets... {#PleaseWait}";	\
// 										Parameters: "extract-ff {code:ExtractFF_ResolveParams}";		\
// 										WorkingDir:	"{#BinDir}";										\
// 										Components: LinkerMod\Assets\FF\Snd LinkerMod\Assets\FF\Raw;
//
// Filename: "{#BinDir}\asset_util.exe";	StatusMsg: "Extracting entity prefabs... {#PleaseWait}";	\
// 										Parameters: "ents --overwrite --dummyBrushes *";				\
// 										WorkingDir:	"{#BinDir}";										\
// 										Components: LinkerMod\Assets\FF\Ents;

procedure ExtractAssets();
var
  AssetUtil: string;
  launchInfo: LaunchInfo;
begin
	// Resolve the filepath for asset util
	AssetUtil := ExpandConstant(CurrentFileName);

	WizardForm.StatusLabel.Caption := 'Extracting assets...';

	launchInfo.Filename := ExpandConstant(CurrentFileName);
	launchInfo.WorkingDir := ExpandConstant('{#BinDir}');
	// launchInfo.Parameters := 'help';

	// ExecPiped(launchInfo);

	// IWDs
	if(IsComponentSelected('LinkerMod\Assets\IWD')) then
	begin
		WizardForm.StatusLabel.Caption := ExpandConstant('Extracting IWD assets... {#PleaseWait}');
		WizardForm.FilenameLabel.Caption := '';

		launchInfo.Parameters := 'extract-iwd' + ExtractIWD_ResolveParams;
		ExecPiped(launchInfo);
	end

	// FASTFILES
	if(
		IsComponentSelected('LinkerMod\Assets\FF\Snd') or
		IsComponentSelected('LinkerMod\Assets\FF\Raw')
	) then
	begin
		WizardForm.StatusLabel.Caption := ExpandConstant('Extracting fastfile assets... {#PleaseWait}');
		WizardForm.FilenameLabel.Caption := '';

		launchInfo.Parameters := 'extract-ff ' + ExtractFF_ResolveParams;
		ExecPiped(launchInfo);
	end

	// ENTITIES
	if(IsComponentSelected('LinkerMod\Assets\FF\Ents')) then
	begin
		WizardForm.StatusLabel.Caption := ExpandConstant('Extracting entity prefabs... {#PleaseWait}');
		WizardForm.FilenameLabel.Caption := '';

		launchInfo.Filename := ExpandConstant(CurrentFileName);
		launchInfo.WorkingDir := ExpandConstant('{#BinDir}');
		launchInfo.Parameters := 'ents --overwrite --dummyBrushes *';
		ExecPiped(launchInfo);
	end
end;
