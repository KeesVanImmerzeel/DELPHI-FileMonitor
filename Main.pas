unit MAIN;

interface

uses Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Forms,
  Vcl.Controls, Vcl.Menus, Vcl.StdCtrls, Vcl.Dialogs, Vcl.Buttons, Winapi.Messages,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdActns, Vcl.ActnList, Vcl.ToolWin,
  Vcl.ImgList, System.Actions, FileCtrl, DirWatch, IniFiles, system.UITypes;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileOpenItem: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveAsItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    StatusBar: TStatusBar;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    FileNew1: TAction;
    FileSave1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton9: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ImageList1: TImageList;
    DirectoryWatch1: TDirectoryWatch;
    SelectDir: TMenuItem;
    OpenDialogAddFile: TOpenDialog;
    Clear: TMenuItem;
    AddFileToMonitor: TMenuItem;
    OpenIniFileDialog: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure SelectDirClick(Sender: TObject);
    procedure ButtonAddFileClick(Sender: TObject);
    procedure DirectoryWatch1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure AddFileToMonitorClick(Sender: TObject);
    procedure FileSaveAsItemClick(Sender: TObject);
  private
    { Private declarations }
    procedure CreateMDIChild(const Name: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Dir: String;
  IniFileName: String;
  Ini: TIniFile;

implementation

{$R *.dfm}

uses CHILDWIN, About;

procedure TMainForm.AddFileToMonitorClick(Sender: TObject);
begin
  OpenDialogAddFile.InitialDir := Dir;
  with OpenDialogAddFile do begin
    if Execute then begin
      if ( ExtractFileDir( FileName ) = Dir ) then begin
        CreateMDIChild( ExtractFileName( FileName ) );
        DirectoryWatch1.Active := true;
        WindowTileVertical1.Execute;
        Ini := TIniFile.Create( IniFileName );
        Ini.WriteString( 'Files',
                         'File_' + IntToStr( MDIChildCount ),
                         ExtractFileName( FileName ) );
        Ini.Free;
      end else begin
        MessageDlg( Format( 'File [%s] is not in folder [%s].',
          [FileName, Dir]), mtError, [mbAbort], 0 );
      end;
    end;
  end;
end;

procedure TMainForm.ButtonAddFileClick(Sender: TObject);
begin
  if System.SysUtils.DirectoryExists( Dir ) then begin
    SetCurrentDir( Dir );
    OpenDialogAddFile.InitialDir := Dir;
  end;
  with OpenDialogAddFile do begin
    if Execute and ( ExtractFileDir( FileName ) = Dir ) then begin
      {ListBox1.Items.Add( ExtractFileName( FileName ) );}
      {CreateChildForm ( ExtractFileName( FileName ) );}
      CreateMDIChild( ExtractFileName( FileName ) );
    end;
  end;
end;

procedure TMainForm.ClearClick(Sender: TObject);
var
  i: Integer;
  name: string;
begin
//  DeleteFile( IniFileName );
  for i:=0 to MDIChildCount - 1 do begin
    TMDIChild( MDIChildren[i] ).Memo1.Lines.Clear;
    Name := dir + '\' + MDIChildren[i].Caption;
    TMDIChild( MDIChildren[i] ).Memo1.Lines.SaveToFile( name );
  end;
//  dir := 'c:\';
//  MainForm.Caption := 'Monitor folder: ' + Dir;
//  DirectoryWatch1.Active := true;
end;

procedure TMainForm.CreateMDIChild(const Name: string);
var
  Child: TMDIChild;
begin
  { create a new MDI child window }
  Child := TMDIChild.Create(Application);
  Child.Caption := Name;
  if FileExists(Name) then Child.Memo1.Lines.LoadFromFile(Name);
end;

procedure TMainForm.DirectoryWatch1Change(Sender: TObject);
var
  i: Integer;
  Name: String;

begin
  for i:=0 to MDIChildCount - 1 do begin
    Name := dir + '\' + MDIChildren[i].Caption;
    if FileExists( name ) then begin
      TMDIChild( MDIChildren[i] ).Memo1.Clear;
      Try
        TMDIChild( MDIChildren[i] ).Memo1.Lines.LoadFromFile( Name );
      Except
      End;
    end else begin
      ShowMessage( 'File does not exist: ' +  Name );
    end;
  end;
end;

procedure TMainForm.FileNew1Execute(Sender: TObject);
begin
ClearClick(Sender);
end;

Function DefaultIniFileName: String;
begin
  Result := ChangeFileExt( ExpandFileName( ExtractFileName( ( Application.ExeName ) ) ), '.ini' );
end;

procedure TMainForm.FileOpen1Execute(Sender: TObject);
var
  NewDirStr: String;
  i: Integer;
begin
  with OpenIniFileDialog do begin
    if Execute then begin
      for i:=0 to MDIChildCount - 1 do
        MDIChildren[i].free;
      Ini := TIniFile.Create( FileName );
      NewDirStr := Ini.ReadString( 'Files', 'Dir', 'Error' );
      if ( NewDirStr = 'Error' ) then begin
         MessageDlg( Format( 'File [%s] is not a FileMonitor Ini-file.',
          [FileName]), mtError, [mbAbort], 0 );
      end else begin
        CopyFile( PWideChar(FileName), PWideChar(DefaultIniFileName), false );
        FormCreate( Sender );
      end;
    end;
  end;
end;

procedure TMainForm.FileSaveAsItemClick(Sender: TObject);
begin
  with SaveDialog1 do begin
    if execute then begin
      CopyFile( PWideChar( IniFileName ), PWideChar( FileName ), false );
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  IniFileName := DefaultIniFileName;
//  ShowMessage( IniFileName );
  Ini := TIniFile.Create( IniFileName );
  Dir := Ini.ReadString( 'Files', 'Dir', 'c:\' );
  DirectoryWatch1.Directory := Dir;
  MainForm.Caption := 'Monitor folder: ' + Dir;
  Ini.Free;
  {FormShow (Sender );}
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  i: Integer;
  FileName: String;
const
  cMaxNrOfChild = 25;
begin
  Ini := TIniFile.Create( IniFileName );
  for i:= 1 to cMaxNrOfChild do begin
    FileName := Ini.ReadString( 'Files', 'File_' + IntToStr( i ), 'Error'  );
    if ( FileName<> 'Error' ) then begin
      CreateMDIChild( ExtractFileName( FileName ) );
    end;
  end;
  if ( MDIChildCount > 0 ) then begin
    DirectoryWatch1.Active := true;
    WindowTileVertical1.Execute;
//    for i:=0 to MDIChildCount - 1 do begin
//      TMDIChild( MDIChildren[i] ).Memo1.Enabled := false;
//    end;
    ClearClick( Sender );
  end;
  Ini.Free;
end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.SelectDirClick(Sender: TObject);
var
  i: Integer;
  NewDir: String;
begin
  NewDir := Dir;;
  if ( FileCtrl.SelectDirectory( NewDir, [],0) ) then begin
    if ( NewDir <> Dir ) then begin
      MainForm.Caption := 'Monitor folder: ' + Dir;
      DirectoryWatch1.Directory := Dir;
      Ini := TIniFile.Create( IniFileName );
      Ini.WriteString( 'Files', 'Dir', Dir );
      Ini.Free;
      for i:=0 to MDIChildCount - 1 do
        MDIChildren[i].free;
//    FileOpenItem.Enabled := true;
     end;
   end;
end;

procedure TMainForm.FileExit1Execute(Sender: TObject);
begin
  Close;
end;


end.
