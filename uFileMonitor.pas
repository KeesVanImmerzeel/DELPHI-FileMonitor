unit uFileMonitor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, dirWatch;

type
  TForm3 = class(TForm)
    Memo1: TMemo;
    DirectoryWatch1: TDirectoryWatch;
    procedure DirectoryWatch1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.DirectoryWatch1Change(Sender: TObject);
begin
  ShowMessage('verandering');
end;

procedure TForm3.FormCreate(Sender: TObject);
begin
DirectoryWatch1.active := true;
end;

end.
