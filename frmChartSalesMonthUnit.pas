unit frmChartSalesMonthUnit;

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, System.Variants,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  dmMainUnit, uChartUtilsUnit;

type
  TfrmChartSalesMonth = class(TForm)
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
  frmChartSalesMonth: TfrmChartSalesMonth;

implementation

{$R *.dfm}

procedure TfrmChartSalesMonth.Build;
var
  Subtitle: string;
begin
  CollectChartPointsFromDS(dmMain.qChartSalesMonth, 'ym', 'sum_sales', FPts);

  Subtitle := 'Помесячная сумма продаж по заключённым договорам';
  if Length(FPts) > 0 then
    Subtitle := Subtitle + '. Периодов: ' + IntToStr(Length(FPts));

  FOptions := NewChartOptions(
    'Продажи по месяцам',
    'Сумма продаж',
    Subtitle,
    'Сумма, руб.',
    '#,##0',
    True
  );

  pbChart.Invalidate;
end;

procedure TfrmChartSalesMonth.pbChartPaint(Sender: TObject);
begin
  DrawBarChart(pbChart, FPts, FOptions);
end;

procedure TfrmChartSalesMonth.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  frmChartSalesMonth := nil;
end;

procedure TfrmChartSalesMonth.FormShow(Sender: TObject);
begin
  OnClose := FormClose;
  Caption := 'График: продажи по месяцам';
  dmMain.OpenChartSalesMonth;
  Build;
end;

procedure TfrmChartSalesMonth.btnRefreshClick(Sender: TObject);
begin
  dmMain.OpenChartSalesMonth;
  Build;
end;

procedure TfrmChartSalesMonth.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.