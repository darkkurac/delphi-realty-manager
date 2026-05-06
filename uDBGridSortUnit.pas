unit uDBGridSortUnit;

interface

uses
  System.SysUtils,
  System.Variants,
  Data.DB,
  Vcl.DBGrids,
  Data.Win.ADODB;

procedure DBGridTitleClickSort(AGrid: TDBGrid; Column: TColumn);

implementation

type
  UInt32 = Cardinal;

function FNV1a32(const S: string): UInt32;
var
  i: Integer;
  h: UInt32;
begin
  h := $811C9DC5; // 2166136261
  for i := 1 to Length(S) do
  begin
    h := h xor Ord(S[i]);
    h := UInt32(UInt64(h) * UInt64($01000193)); // 16777619 (no overflow)
  end;
  Result := h;
end;

function LastPosCI(const SubStr, S: string): Integer;
var
  USub, US: string;
  i, LSub, LS: Integer;
begin
  USub := UpperCase(SubStr);
  US := UpperCase(S);
  LSub := Length(USub);
  LS := Length(US);

  Result := 0;
  if (LSub = 0) or (LS < LSub) then Exit;

  for i := LS - LSub + 1 downto 1 do
    if Copy(US, i, LSub) = USub then
      Exit(i);
end;

function StripOrderBy(const SQLText: string): string;
var
  p: Integer;
begin
  p := LastPosCI('ORDER BY', SQLText);
  if p > 0 then
    Result := Trim(Copy(SQLText, 1, p - 1))
  else
    Result := Trim(SQLText);
end;

function TrimTrailingSemicolons(const S: string): string;
begin
  Result := TrimRight(S);
  while (Result <> '') and (Result[Length(Result)] = ';') do
  begin
    Delete(Result, Length(Result), 1);
    Result := TrimRight(Result);
  end;
end;

function IsSimpleIdent(const S: string): Boolean;
var
  i: Integer;
begin
  Result := False;
  if S = '' then Exit;

  if not CharInSet(S[1], ['A'..'Z','a'..'z','_']) then Exit;

  for i := 2 to Length(S) do
    if not CharInSet(S[i], ['A'..'Z','a'..'z','0'..'9','_']) then Exit;

  Result := True;
end;

function QuoteIdent(const Name: string): string;
begin
  if IsSimpleIdent(Name) then
    Result := '`' + Name + '`'
  else
    Result := Name;
end;

function PickKeyFieldName(DS: TDataSet): string;
begin
  Result := '';
  if DS.FindField('IDob') <> nil then Exit('IDob');
  if DS.FindField('IDcon') <> nil then Exit('IDcon');
  if DS.FindField('IDcl') <> nil then Exit('IDcl');
  if DS.Fields.Count > 0 then Exit(DS.Fields[0].FieldName);
end;

procedure DBGridTitleClickSort(AGrid: TDBGrid; Column: TColumn);
var
  DS: TDataSet;
  Q: TADOQuery;
  FieldName: string;
  Hash30, LastHash30: UInt32;
  Desc: Boolean;
  BaseSQL, NewSQL, Dir: string;
  KeyField: string;
  KeyValue: Variant;
  TagU: UInt32;
  PackVal: UInt32;
begin
  if (AGrid = nil) or (Column = nil) or (Column.Field = nil) then Exit;
  if (AGrid.DataSource = nil) or (AGrid.DataSource.DataSet = nil) then Exit;

  DS := AGrid.DataSource.DataSet;
  if not (DS is TADOQuery) then Exit;

  Q := TADOQuery(DS);
  if Column.Field.FieldKind <> fkData then Exit;

  FieldName := Column.Field.FieldName;
  if FieldName = '' then Exit;

  // pack into signed Tag without overflow on Win32 (31 bits max)
  Hash30 := FNV1a32(LowerCase(FieldName)) and $3FFFFFFF;

  TagU := UInt32(AGrid.Tag) and $7FFFFFFF;
  LastHash30 := TagU shr 1;
  Desc := (TagU and 1) <> 0;

  if Hash30 = LastHash30 then
    Desc := not Desc
  else
    Desc := False;

  PackVal := (Hash30 shl 1) or Ord(Desc);
  AGrid.Tag := NativeInt(PackVal);

  KeyField := PickKeyFieldName(Q);
  if (KeyField <> '') and (Q.FindField(KeyField) <> nil) and Q.Active and (not Q.IsEmpty) then
    KeyValue := Q.FieldByName(KeyField).Value
  else
    KeyValue := Null;

  if Q.State in [dsEdit, dsInsert] then
    Q.Cancel;

  BaseSQL := StripOrderBy(Q.SQL.Text);
  BaseSQL := TrimTrailingSemicolons(BaseSQL);
  if BaseSQL = '' then Exit;

  if Desc then Dir := 'DESC' else Dir := 'ASC';

  NewSQL := BaseSQL + sLineBreak +
            'ORDER BY ' + QuoteIdent(FieldName) + ' ' + Dir + ';';

  Q.DisableControls;
  try
    Q.Close;
    Q.SQL.Text := NewSQL;
    Q.Open;

    if (not VarIsNull(KeyValue)) and (KeyField <> '') then
      Q.Locate(KeyField, KeyValue, []);
  finally
    Q.EnableControls;
  end;
end;

end.

