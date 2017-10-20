{
  This file is part of Tester Web

  Copyright (C) 2017 Alexander Kernozhitsky <sh200105@mail.ru>

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
unit tswebsolvepages;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, tswebsolvefeatures, tswebsolveelements, webstrconsts, tswebmodules,
  tswebpages, htmlpreprocess, navbars, contests, tswebpagesbase, tswebnavbars;

type

  { TSolveListPage }

  TSolveListPage = class(TDefaultHtmlPage)
  protected
    procedure AddFeatures; override;
    procedure DoGetInnerContents(Strings: TIndentTaggedStrings); override;
    function CreateNavBar: TNavBar; override;
  public
    procedure AfterConstruction; override;
  end;

  { TSolveContestPage }

  TSolveContestPage = class(TDefaultHtmlPage, IContestSolvePage)
  private
    FContest: TContest;
  protected
    procedure AddFeatures; override;
    function CreateNavBar: TNavBar; override;
    procedure DoUpdateRequest; override;
  public
    function Contest: TContest;
    function ContestName: string;
    constructor Create; override;
    destructor Destroy; override;
  end;

  { TSolveContestPostPage }

  TSolveContestPostPage = class(TSolveContestPage, IPostHtmlPage)
  private
    FError: string;
    FSuccess: string;
  protected
    function GetError: string;
    procedure SetError(AValue: string);
    function GetSuccess: string;
    procedure SetSuccess(AValue: string);
  public
    property Error: string read GetError write SetError;
    property Success: string read GetSuccess write SetSuccess;
  end;

  { TSolveContestNavBar }

  TSolveContestNavBar = class(TTesterNavBar)
  protected
    procedure DoCreateElements; override;
    procedure DoFillVariables; override;
  public
    procedure AddNestedElement(const ACaption, ALink: string);
  end;

  { TSolveProblemListPage }

  TSolveProblemListPage = class(TSolveContestPage)
  protected
    procedure AddFeatures; override;
    procedure DoGetInnerContents(Strings: TIndentTaggedStrings); override;
  public
    procedure AfterConstruction; override;
  end;

implementation

uses
  tswebsolvemodules;

{ TSolveProblemListPage }

procedure TSolveProblemListPage.AddFeatures;
begin
  inherited AddFeatures;
  AddFeature(TSolveProblemListFeature);
end;

procedure TSolveProblemListPage.DoGetInnerContents(Strings: TIndentTaggedStrings);
begin
  Strings.Text := '~#solveProblemList;';
end;

procedure TSolveProblemListPage.AfterConstruction;
begin
  inherited AfterConstruction;
  Title := SSolveProblemListTitle;
end;

{ TSolveContestPage }

procedure TSolveContestPage.AddFeatures;
begin
  inherited AddFeatures;
  AddFeature(TSolveContestBaseFeature);
end;

function TSolveContestPage.CreateNavBar: TNavBar;
begin
  Result := TSolveContestNavBar.Create(Self);
end;

procedure TSolveContestPage.DoUpdateRequest;
begin
  inherited DoUpdateRequest;
  FreeAndNil(FContest);
  FContest := SolveContestFromRequest(Request);
end;

function TSolveContestPage.Contest: TContest;
begin
  Result := FContest;
end;

function TSolveContestPage.ContestName: string;
begin
  Result := SolveContestNameFromRequest(Request);
end;

constructor TSolveContestPage.Create;
begin
  inherited Create;
  FContest := nil;
end;

destructor TSolveContestPage.Destroy;
begin
  FreeAndNil(FContest);
  inherited Destroy;
end;

{ TSolveContestPostPage }

function TSolveContestPostPage.GetError: string;
begin
  Result := FError;
end;

procedure TSolveContestPostPage.SetError(AValue: string);
begin
  FError := AValue;
end;

function TSolveContestPostPage.GetSuccess: string;
begin
  Result := FSuccess;
end;

procedure TSolveContestPostPage.SetSuccess(AValue: string);
begin
  FSuccess := AValue;
end;

{ TSolveContestNavBar }

procedure TSolveContestNavBar.DoCreateElements;
begin
  // add common elements
  AddElement(SMainPage, '~documentRoot;/main');
  AddElement(SContestSolveTitle, '~documentRoot;/solve');
  // add contest-specific elements
  AddSplitter;
  AddElement(SSolveProblemListTitle, '~documentRoot;/solve-contest~+contestParam;');
end;

procedure TSolveContestNavBar.DoFillVariables;
begin
  Storage.ItemsAsText['contestParam'] := '?contest=' + (Parent as IContestSolvePage).ContestName;
  inherited DoFillVariables;
end;

procedure TSolveContestNavBar.AddNestedElement(const ACaption, ALink: string);
begin
  (AddElement(ACaption, ALink) as TTesterNavBarElement).ShowMiddleDot := True;
end;

{ TSolveListPage }

procedure TSolveListPage.AddFeatures;
begin
  inherited AddFeatures;
  AddFeature(TSolveContestListFeature);
end;

procedure TSolveListPage.DoGetInnerContents(Strings: TIndentTaggedStrings);
begin
  Strings.Text := '~#solveList;';
end;

function TSolveListPage.CreateNavBar: TNavBar;
begin
  Result := TDefaultNavBar.Create(Self);
end;

procedure TSolveListPage.AfterConstruction;
begin
  inherited AfterConstruction;
  Title := SContestSolveTitle;
end;

end.
