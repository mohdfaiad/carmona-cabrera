unit KeySplash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, jpeg, IniFiles, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinCaramel, dxSkinCoffee, dxSkinDarkSide,
  dxSkinGlassOceans, dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky,
  dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinPumpkin,
  dxSkinSilver, dxSkinStardust, dxSkinSummer2008, dxSkinsDefaultPainters,
  dxSkinValentine, dxSkinXmas2008Blue, cxControls, cxContainer, cxEdit,
  cxLabel, dxGDIPlusClasses;

type
  TFrmSplash = class(TForm)
    LblEvento: TLabel;
    TmrSplash: TTimer;
    ImgMain: TImage;
    Shape1: TShape;
    LblTitulo: TLabel;
    LblSombra: TLabel;
    LblDesc: TLabel;
    procedure TmrSplashTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    iContador :Integer;
  public
    { Public declarations }
  end;

var
  FrmSplash: TFrmSplash;

implementation

{$R *.dfm}

procedure TFrmSplash.TmrSplashTimer(Sender: TObject);
begin
  If iContador <= 2 Then
    Begin
      Case iContador Of
        0: LblEvento.Caption := 'Preparando Ambiente Gr�fico...';
        1: LblEvento.Caption := 'Preparando Conex�o Com Banco de Dados...';
        2: LblEvento.Caption := 'Quase Pronto...';
      End;
      LblEvento.Refresh;
      iContador := iContador + 01;
    End
  Else
    Close;
end;

procedure TFrmSplash.FormShow(Sender: TObject);
Var
  Ini :TIniFile;
  cTempo :Cardinal;
begin
  Ini := TIniFile.Create('C:\HAS\HAS.ini');

  cTempo := StrToInt(Ini.ReadString('DIVERSOS', 'TIMESPLASH', ''));
  TmrSplash.Interval := cTempo;

  iContador := 0;

end;

end.