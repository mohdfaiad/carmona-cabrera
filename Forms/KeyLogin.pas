unit KeyLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxLookAndFeelPainters, StdCtrls, cxButtons, cxTextEdit, cxLabel,
  cxControls, cxContainer, cxEdit, cxGroupBox, jpeg, ExtCtrls, IniFiles,
  DB, FIBDataSet, pFIBDataSet, dxSkinsCore, dxSkinBlack, dxSkinBlue,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkSide, dxSkinGlassOceans,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black,
  dxSkinOffice2007Blue, dxSkinOffice2007Green, dxSkinOffice2007Pink,
  dxSkinOffice2007Silver, dxSkinPumpkin, dxSkinSilver, dxSkinStardust,
  dxSkinSummer2008, dxSkinsDefaultPainters, dxSkinValentine,
  dxSkinXmas2008Blue, Menus, dxSkinscxPCPainter, cxPC, dxGDIPlusClasses,
  cxGraphics, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, DBXpress, SqlExpr, FMTBcd, frxClass, frxDBSet,
  cxLookAndFeels, DBClient, Provider, dxSkinOffice2013DarkGray,
  dxSkinOffice2013LightGray, dxSkinOffice2013White;

type
  TFrmLogin = class(TForm)
    btnOK: TcxButton;
    btnFechar: TcxButton;
    conWebMaster: TSQLConnection;
    QryUser: TSQLQuery;
    QryUserusr_codigo: TSmallintField;
    QryUserusr_nome: TStringField;
    QryUserusr_senha: TStringField;
    EdtBanco: TcxTextEdit;
    LblServidor: TcxLabel;
    LblBanco: TcxLabel;
    EdtServidor: TcxTextEdit;
    LblEvento: TLabel;
    ImgMain: TImage;
    Shape1: TShape;
    LblTitulo: TLabel;
    LblSombra: TLabel;
    LblDesc: TLabel;
    EdtSenha: TcxTextEdit;
    EdtUsuario: TcxTextEdit;
    LblUsuario: TcxLabel;
    LblSenha: TcxLabel;
    QryAcesso: TSQLQuery;
    QryAcessoper_nivel: TSmallintField;
    QryAcessousr_nivel: TSmallintField;
    QryUserusr_nivel: TSmallintField;
    GrpBxServidor: TcxGroupBox;
    cxLabel2: TcxLabel;
    EdtPassNET: TcxTextEdit;
    EdtUserNET: TcxTextEdit;
    cxLabel1: TcxLabel;
    QryEmpresa: TSQLQuery;
    FrDtStEmpresa: TfrxDBDataset;
    QryEmpresaemp_cnpj: TStringField;
    QryEmpresaemp_fantasia: TStringField;
    QryEmpresaemp_end_logra: TStringField;
    QryEmpresaemp_end_bairro: TStringField;
    QryEmpresaemp_end_cidade: TStringField;
    QryEmpresaemp_end_cep: TStringField;
    QryEmpresaemp_custos: TStringField;
    QryEmpresaemp_financeiro: TStringField;
    QryEmpresaemp_diretor: TStringField;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFecharClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    sString1, sString2 :String;
    Ini :TIniFile;
    sUserNet, sPassNet :String;
    function GetValorDB(sTabela, sCampo, sWhereSQL : String) : Variant;
  public
    { Public declarations }
    procedure GR_Refresh();
    function GR_Acesso(iUSR_CODIGO: Integer; iOBJ_NOME: String): Integer;
    function GR_Registro(sString: String): String;
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses
  KeyMain,
  KeyFuncoes,
  KeyVersion,
  KeyResource;

{$R *.dfm}

procedure TFrmLogin.FormShow(Sender: TObject);
Var
  sUsuario, sSenha :String;
begin
  EdtSenha.SetFocus;

  sString1 := Ini.ReadString('ACESSO', 'Servidor', '');
  sString2 := Ini.ReadString('ACESSO', 'Banco', '');
  sUsuario := Ini.ReadString('ACESSO', 'Usuario', '');

  sUserNet := Ini.ReadString('ACESSO', 'UserNet', '');
  sPassNet := Ini.ReadString('ACESSO', 'PassNet', '');

  EdtUserNET.Text := sUserNet;
  EdtPassNET.Text := sPassNet;

  EdtUsuario.Text := sUsuario;
  EdtSenha.Text   := sSenha;

  EdtServidor.Text := sString1;
  EdtBanco.Text    := sString2;
end;  

procedure TFrmLogin.FormCreate(Sender: TObject);
var
  ver : TInfoVersao;
begin
  Tag := SYS_IMONEY_ID;
  ver := TInfoVersao.GetInstance();

  LblTitulo.Caption := ver.getPropertyValue(ivPRODUCT_NAME);
  LblDesc.Caption   := ver.getPropertyValue(ivFILE_DESCRIPTION);

  Brush.Style := BsClear;
  Ini := TIniFile.Create( GetFileNameINI );
end;

procedure TFrmLogin.btnFecharClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrmLogin.btnOKClick(Sender: TObject);
var
  sLibMySQL: String;
begin
  conWebMaster.Connected:=False;
  sLibMySQL := ExtractFilePath( ParamStr(0) ) + 'libmySQL.dll';
  With conWebMaster do
    Begin
      Connected := False;

      Params.Clear;
      Params.Add('DriverName=MySQL50');
      Params.Add('HostName=' + EdtServidor.Text);
      Params.Add('Database='  + EdtBanco.Text);
      Params.Add('User_Name=' + EdtUserNET.Text);
      Params.Add('Password='  + EdtPassNET.Text);
      Params.Add('Port='  + '3308');

      Params.Add('BlobSize=-1');
      Params.Add('ErrorResourceFile=');
      Params.Add('LocaleCode=0000');

      LoadLibrary( PChar(sLibMySQL) );
      VendorLib := sLibMySQL;

      Connected := True;

      QryUser.Close;
      QryUser.Params.ParamByName('nome').Value := EdtUsuario.Text;
      QryUser.Params.ParamByName('senha').Value := EdtSenha.Text;
      QryUser.Open;

      If (Connected) And Not (QryUser.IsEmpty) Then
        Begin
          ModalResult := mrOK;

          FrmMain.StsBr.Panels[0].Text := 'Servidor: ' + EdtServidor.Text;
          FrmMain.StsBr.Panels[1].Text := 'Banco: ' + EdtBanco.Text;
          FrmMain.StsBr.Panels[2].Text := 'Usu�rio: ' + 'root://' + UpperCase(EdtUsuario.Text);
          FrmMain.StsBr.Panels[3].Text := 'Data: '+ FormatDateTime('dd/mm/yyyy', Date);
          FrmMain.StSBr.Panels[4].Text := 'Hora: ' + FormatDateTime('hh:mm:ss', Time);

          FrmMain.USR_Codigo := QryUserusr_codigo.Value;
          FrmMain.USR_Nome   := EdtUsuario.Text;
          FrmMain.USR_Nivel  := QryUserusr_nivel.Value;
          FrmMain.sServidor  := EdtServidor.Text;
          FrmMain.sBanco     := EdtBanco.Text;

          gUsuario.Codigo := QryUserusr_codigo.Value;
          gUsuario.Nivel  := QryUserusr_nivel.Value;
          gUsuario.Login  := QryUserusr_nome.Value;
          gUsuario.Nome   := QryUserusr_nome.Value;
          gUsuario.Senha  := QryUserusr_senha.Value;

          Ini.WriteString('ACESSO', 'Usuario', FrmMain.USR_Nome);
          Ini.WriteString('ACESSO', 'Servidor', EdtServidor.Text);
          Ini.WriteString('ACESSO', 'Banco', EdtBanco.Text);
          Ini.WriteString('ACESSO', 'UserNet', EdtUserNET.Text);
          Ini.WriteString('ACESSO', 'PassNet', EdtPassNET.Text);          

          Application.MessageBox('Sistema Contectando a Base de Dados', 'Confirma��o', MB_ICONINFORMATION);
          QryEmpresa.Close;
          QryEmpresa.Open;

          // Gravar registros de sistema
          
          if VarIsNull(GetValorDB('sys_sistema', 'sis_codigo', 'sis_codigo = ' + IntToStr(SYS_IMONEY_ID))) then
            conWebMaster.ExecuteDirect('Insert Into sys_sistema (sis_codigo, sis_descricao) values (' +
              IntToStr(SYS_IMONEY_ID) + ', ' + QuotedStr(Application.Title) + ')')
          else
            conWebMaster.ExecuteDirect('Update sys_sistema Set sis_descricao = ' + QuotedStr(Application.Title) +
              ' where sis_codigo = ' + IntToStr(SYS_IMONEY_ID));
        End
      Else
        Begin
          Application.MessageBox('Erro ao Tentar se Conectar, Verifique Sua Conex�o', 'Erro', MB_ICONERROR);
          Abort;
          Close;
        End;
    End; 
end;

function TFrmLogin.GR_Acesso(iUSR_CODIGO: Integer;
  iOBJ_NOME: String): Integer;
begin
  With QryAcesso Do
    Begin
      Close;
      Params.ParamByName('codigo').AsInteger := iUSR_CODIGO;
      Params.ParamByName('obj').AsString := iOBJ_NOME;
      Open;

      If Not IsEmpty Then
        Result := QryAcessoper_nivel.Value
      Else
        Result := 9;

    End;
end;

function TFrmLogin.GR_Registro(sString: String): String;
begin
  If sString = '' Then
    Result := 'N�o Existe A Informa��o Solicitada'
  Else
    Result := 'Incluido por: ' + Copy(sString, 19,60) +
              ' - Em: ' + Copy(sString, 1, 10) +
              ' - �s: ' + Copy(sString, 11, 8);
end;

procedure TFrmLogin.GR_Refresh;
begin
  conWebMaster.Connected := False;
  conWebMaster.Connected := True;
end;

function TFrmLogin.GetValorDB(sTabela, sCampo, sWhereSQL: String): Variant;
var
  qry : TSQLQuery;
  dsp : TDataSetProvider;
  cds : TClientDataSet;
begin

  sTabela   := Trim( AnsiLowerCase(sTabela) );
  sCampo    := Trim( AnsiLowerCase(sCampo) );
  sWhereSQL := Trim( AnsiLowerCase(sWhereSQL) );

  if sWhereSQL <> EmptyStr then
    sWhereSQL := Trim('where ' + sWhereSQL);

  qry := TSQLQuery.Create(nil);
  dsp := TDataSetProvider.Create(nil);
  cds := TClientDataSet.Create(nil);

  Screen.Cursor := crSQLWait;
  try
    qry.SQLConnection := conWebMaster;
    qry.SQL.Text := 'Select ' + sCampo + ' from ' + sTabela + ' ' + sWhereSQL;

    dsp.DataSet := qry;
    cds.SetProvider(dsp);

    cds.Open;

    Result := cds.Fields[0].Value;
  finally
    Screen.Cursor := crDefault;
    qry.Free;
    dsp.Free;
    cds.Free;
  end;
end;

end.


