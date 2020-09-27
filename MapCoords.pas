unit MapCoords;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, KalClientMap;

type
  TForm_SetMapXY = class(TForm)
    Edit_MapX: TEdit;
    Edit_MapY: TEdit;
    Label_MapX: TLabel;
    Label_MapY: TLabel;
    BitBtn_Ok: TBitBtn;
    BitBtn_Cancel: TBitBtn;
    procedure SetMapXY;
    procedure BitBtn_CancelClick(Sender: TObject);
    procedure BitBtn_OkClick(Sender: TObject);
  private
  public
    { Public declarations }
  end;

var
  Form_SetMapXY: TForm_SetMapXY;

implementation

uses Unit1;

{$R *.dfm}

procedure TForm_SetMapXY.SetMapXY;
begin
  Edit_MapX.Text:=IntToStr(Form_Main.KCM.Header.MapX);
  Edit_MapY.Text:=IntToStr(Form_Main.KCM.Header.MapY);
  Form_SetMapXY.Show;
  Form_SetMapXY.BringToFront;
end;

procedure TForm_SetMapXY.BitBtn_CancelClick(Sender: TObject);
begin
  Form_SetMapXY.Hide;
end;

procedure TForm_SetMapXY.BitBtn_OkClick(Sender: TObject);
var
  TempKCMHeader:TKCMHeader;
  TempOPLHeader:TOPLHeader;
begin

  TempKCMHeader:=TKCMHeader.Create;
  TempKCMHeader:=Form_Main.KCM.Header;
  TempKCMHeader.MapX:=StrToInt(Edit_MapX.Text);
  TempKCMHeader.MapY:=StrToInt(Edit_MapY.Text);
  Form_Main.KCM.Header:=TempKCMHeader;

  TempOPLHeader:=TOPLHeader.Create;
  TempOPLHeader:=Form_Main.OPL.Header;
  TempOPLHeader.MapX:=StrToInt(Edit_MapX.Text);
  TempOPLHeader.MapY:=StrToInt(Edit_MapY.Text);
  Form_Main.OPL.Header:=TempOPLHeader;

  Form_SetMapXY.Hide;
  Form_Main.MainMenu_File_SaveKCMFileAsClick(nil)
end;

end.
