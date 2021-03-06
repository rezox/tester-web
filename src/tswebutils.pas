{
  This file is part of Tester Web

  Copyright (C) 2017-2018 Alexander Kernozhitsky <sh200105@mail.ru>

  This program is free software; you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This code is distributed in the hope that it will be useful, but WITHOUT ANY
  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  A copy of the GNU General Public License is available on the World Wide Web
  at <http://www.gnu.org/copyleft/gpl.html>. You can also obtain it by writing
  to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
  MA 02111-1307, USA.
}
unit tswebutils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, webstrconsts, LazUTF8, fgl, math, HTTPDefs, DateUtils;

type
  EHTTPDateTime = class(Exception);

  { TIdList }

  TIdList = class(specialize TFPGList<integer>)
  public
    procedure Sort(Reversed: boolean);
  end;

function Id2Str(AID: integer): string;
function Str2Id(const AID: string): integer;

procedure ValidateVarNameStr(const VarType, VarName: string; AExceptClass: ExceptClass);
procedure ValidateStrLength(const AType, AStr: string; MinLen, MaxLen: integer;
  AExceptClass: ExceptClass);

function DumpBackTrace: string;

function DateTimeToHTTPDate(ADate: TDateTime): string;
function HTTPDateToDateTime(S: string): TDateTime;

implementation

function Id2Str(AID: integer): string;
begin
  Result := 'id' + IntToStr(AID);
end;

function Str2Id(const AID: string): integer;
begin
  if Pos('id', AID) <> 1 then
    raise EConvertError.CreateFmt(SInvalidIDStr, [AID]);
  Result := AID.Substring(2).ToInteger;
end;

procedure ValidateVarNameStr(const VarType, VarName: string; AExceptClass: ExceptClass);
const
  AvailableChars = ['A' .. 'Z', 'a' .. 'z', '0' .. '9', '_', '-'];
  Digits = ['0' .. '9'];
  AvailableCharsStr = '[''A'' .. ''Z'', ''a'' .. ''z'', ''0'' .. ''9'', ''_'', ''-'']';
var
  C: char;
begin
  if VarName = '' then
    raise AExceptClass.CreateFmt(SVarNameNonEmpty, [VarType]);
  if VarName[1] in Digits then
    raise AExceptClass.CreateFmt(SVarNameLeadingDigit, [VarType]);
  for C in VarName do
    if not (C in AvailableChars) then
      raise AExceptClass.CreateFmt(SVarNameInvalidChar, [VarType, AvailableCharsStr]);
end;

procedure ValidateStrLength(const AType, AStr: string; MinLen, MaxLen: integer;
  AExceptClass: ExceptClass);
var
  StrLen: integer;
begin
  if FindInvalidUTF8Character(PChar(AStr), Length(AStr)) >= 0 then
    raise AExceptClass.CreateFmt(SStrInvalidUTF8, [AType]);
  StrLen := UTF8Length(AStr);
  if (StrLen < MinLen) or (StrLen > MaxLen) then
    raise AExceptClass.CreateFmt(SStrInvalidLen, [AType, MinLen, MaxLen]);
end;

function DumpBackTrace: string;
var
  Strings: TStringList;
  FrameCount: integer;
  Frames: PCodePointer;
  I: integer;
begin
  Strings := TStringList.Create;
  try
    FrameCount := ExceptFrameCount;
    Frames := ExceptFrames;
    Strings.Add(Trim(BackTraceStrFunc(ExceptAddr)));
    for I := 0 to FrameCount - 1 do
      Strings.Add(Trim(BackTraceStrFunc(Frames[I])));
    Result := Strings.Text;
  finally
    FreeAndNil(Strings);
  end;
end;

function DateTimeToHTTPDate(ADate: TDateTime): string;
var
  WeekDay, Month: integer;
begin
  ADate := LocalTimeToUniversal(ADate);
  WeekDay := DayOfWeek(ADate);
  Month := MonthOf(ADate);
  Result := Format(FormatDateTime(HTTPDateFmt + ' "GMT"', ADate),
    [HTTPDays[WeekDay], HTTPMonths[Month]]);
end;

function HTTPDateToDateTime(S: string): TDateTime;

  function GetWeekDay(const S: string): integer;
  var
    I: integer;
  begin
    for I := Low(HTTPDays) to High(HTTPDays) do
      if CompareText(S, HTTPDays[I]) = 0 then
        Exit(I);
    raise EHTTPDateTime.CreateFmt(SInvalidHttpDay, [S]);
  end;

  function GetMonth(const S: string): integer;
  var
    I: integer;
  begin
    for I := Low(HTTPMonths) to High(HTTPMonths) do
      if CompareText(S, HTTPMonths[I]) = 0 then
        Exit(I);
    raise EHTTPDateTime.CreateFmt(SInvalidHttpMonth, [S]);
  end;

var
  Fields: array of string;
  DayName, MonthName: string;
  DateFmt: string;
  Month: integer;
begin
  Fields := S.Split(' ');
  if Length(Fields) < 3 then
    raise EHTTPDateTime.Create(SInvalidHttpDateTimeFormat);
  DayName := Fields[0];
  MonthName := Fields[2];
  if not DayName.IsEmpty then
    Delete(DayName, Length(DayName), 1);
  GetWeekDay(DayName);
  Month := GetMonth(MonthName);
  DateFmt := Format(HTTPDateFmt + ' "GMT"!m', [DayName, MonthName]);
  Result := ScanDateTime(DateFmt, S + '!' + IntToStr(Month));
  Result := UniversalTimeToLocal(Result);
end;

function IdComparePlain(const AID1, AID2: integer): integer;
begin
  Result := CompareValue(AID1, AID2);
end;

function IdCompareReversed(const AID1, AID2: integer): integer;
begin
  Result := -CompareValue(AID1, AID2);
end;

{ TIdList }

procedure TIdList.Sort(Reversed: boolean);
begin
  if Reversed then
    inherited Sort(@IdCompareReversed)
  else
    inherited Sort(@IdComparePlain);
end;

end.

