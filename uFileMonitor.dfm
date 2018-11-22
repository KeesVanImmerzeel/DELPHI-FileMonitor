object Form3: TForm3
  Left = 0
  Top = 0
  Caption = 'Form3'
  ClientHeight = 482
  ClientWidth = 736
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 152
    Top = 136
    Width = 584
    Height = 346
    Align = alCustom
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object DirectoryWatch1: TDirectoryWatch
    Directory = 'd:\tmp\'
    NotifyFilters = [nfLastWrite]
    WatchSubDirs = False
    Active = False
    OnChange = DirectoryWatch1Change
    Left = 48
    Top = 40
  end
end
