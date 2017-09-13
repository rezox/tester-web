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
unit tswebpages;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, tswebauthfeatures, tswebfeatures, tswebpagesbase, navbars,
  webstrconsts;

type

  { TDefaultHtmlPage }

  TDefaultHtmlPage = class(TContentHtmlPage, IPageNavBar)
  private
    FNavBar: TNavBar;
  protected
    procedure AddFeatures; override;
    function CreateNavBar: TNavBar; virtual; abstract;
    procedure DoSetVariables; override;
    function GetNavBar: TNavBar;
  public
    procedure Clear; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  { TAuthHtmlPage }

  TAuthHtmlPage = class(TAuthHtmlPageBase)
  protected
    procedure AddFeatures; override;
  end;

  { TLoginHtmlPage }

  TLoginHtmlPage = class(TAuthHtmlPage)
  protected
    procedure AddFeatures; override;
  public
    procedure AfterConstruction; override;
  end;

  { TRegisterHtmlPage }

  TRegisterHtmlPage = class(TAuthHtmlPage)
  protected
    procedure AddFeatures; override;
  public
    procedure AfterConstruction; override;
  end;

implementation

{ TRegisterHtmlPage }

procedure TRegisterHtmlPage.AddFeatures;
begin
  inherited AddFeatures;
  AddFeature(TAuthRegisterFormFeature);
end;

procedure TRegisterHtmlPage.AfterConstruction;
begin
  inherited AfterConstruction;
  Title := SRegisterTitle;
end;

{ TLoginHtmlPage }

procedure TLoginHtmlPage.AddFeatures;
begin
  inherited AddFeatures;
  AddFeature(TAuthLoginFormFeature);
end;

procedure TLoginHtmlPage.AfterConstruction;
begin
  inherited AfterConstruction;
  Title := SLoginTitle;
end;

{ TAuthHtmlPage }

procedure TAuthHtmlPage.AddFeatures;
begin
  inherited AddFeatures;
  AddFeature(THeaderFeature);
  AddFeature(TAuthFormFeature);
  AddFeature(TFooterFeature);
end;

{ TDefaultHtmlPage }

procedure TDefaultHtmlPage.AddFeatures;
begin
  inherited AddFeatures;
  AddFeature(THeaderFeature);
  AddFeature(TUserBarFeature);
  AddFeature(TNavBarFeature);
  AddFeature(TContentFeature);
  AddFeature(TFooterFeature);
end;

procedure TDefaultHtmlPage.DoSetVariables;
begin
  FNavBar.ActiveCaption := Title;
  inherited DoSetVariables;
end;

function TDefaultHtmlPage.GetNavBar: TNavBar;
begin
  Result := FNavBar;
end;

procedure TDefaultHtmlPage.Clear;
begin
  inherited Clear;
  FNavBar.Clear;
end;

constructor TDefaultHtmlPage.Create;
begin
  inherited Create;
  FNavBar := CreateNavBar;
end;

destructor TDefaultHtmlPage.Destroy;
begin
  FreeAndNil(FNavBar);
  inherited Destroy;
end;

end.
