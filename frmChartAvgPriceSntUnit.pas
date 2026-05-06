unit frmChartAvgPriceSntUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Variants,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  dmMainUnit, uChartUtilsUnit;

type
  TfrmChartAvgPriceSnt = class(TForm)
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
  frmChartAvgPriceSnt: TfrmChartAvgPriceSnt;

implementation

{$R *.dfm}

procedure TfrmChartAvgPriceSnt.Build;
var
  Subtitle: string;
begin
  CollectChartPointsFromDS(dmMain.qChartAvgPriceSnt, 'snt_name', 'avg_price', FPts);

  Subtitle := 'Средняя стоимость объектов недвижимости по СНТ';
  if Length(FPts) > 0 then
    Subtitle := Subtitle + '. Локаций: ' + IntToStr(Length(FPts));

  FOptions := NewChartOptions(
    'Средняя цена по локациям (СНТ)',
    'Средняя цена',
    Subtitle,
    'Цена, руб.',
    '#,##0',
    True
  );

  pbChart.Invalidate;
end;

procedure TfrmChartAvgPriceSnt.pbChartPaint(Sender: TObject);
begin
  DrawBarChart(pbChart, FPts, FOptions);
end;

procedure TfrmChartAvgPriceSnt.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmChartAvgPriceSnt := nil;
end;

procedure TfrmChartAvgPriceSnt.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  Caption := 'График: средняя цена по локациям (СНТ)';
  dmMain.OpenChartAvgPriceSnt;
  Build;
end;

procedure TfrmChartAvgPriceSnt.btnRefreshClick(Sender: TObject);
begin
  dmMain.OpenChartAvgPriceSnt;
  Build;
end;

procedure TfrmChartAvgPriceSnt.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.