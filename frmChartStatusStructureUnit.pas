unit frmChartStatusStructureUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Variants,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  dmMainUnit, uChartUtilsUnit;

type
  TfrmChartStatusStructure = class(TForm)
    pTop: TPanel;
    btnRefresh: TButton;
    btnClose: TButton;
    pbChart: TPaintBox;
    procedure FormShow(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pbChartPaint(Sender: TObject);
  private
    FPts: TChartPoints;
    FOptions: TChartRenderOptions;
    procedure Build;
  end;

var
  frmChartStatusStructure: TfrmChartStatusStructure;

implementation

{$R *.dfm}

procedure TfrmChartStatusStructure.Build;
var
  Subtitle: string;
begin
  CollectChartPointsFromDS(dmMain.qChartStatusStruct, 'status_name', 'cnt_objects', FPts);

  Subtitle := 'Распределение объектов недвижимости по текущим статусам';
  if Length(FPts) > 0 then
    Subtitle := Subtitle + '. Категорий: ' + IntToStr(Length(FPts));

  FOptions := NewChartOptions(
    'Структура статусов объектов',
    'Количество объектов',
    Subtitle,
    '',
    '#,##0',
    True
  );

  pbChart.Invalidate;
end;

procedure TfrmChartStatusStructure.pbChartPaint(Sender: TObject);
begin
  DrawPieChart(pbChart, FPts, FOptions);
end;

procedure TfrmChartStatusStructure.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmChartStatusStructure := nil;
end;

procedure TfrmChartStatusStructure.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  Caption := 'График: структура статусов объектов';
  dmMain.OpenChartStatusStruct;
  Build;
end;

procedure TfrmChartStatusStructure.btnRefreshClick(Sender: TObject);
begin
  dmMain.OpenChartStatusStruct;
  Build;
end;

procedure TfrmChartStatusStructure.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.