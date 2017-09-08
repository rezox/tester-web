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
unit tswebhtmlpages;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, htmlpages, serverconfig, LazFileUtils, htmlpreprocess,
  webstrconsts;

// TODO : Add users and login panel!
// TODO : Add navbar also!

type

  { TTesterPageFeature }

  TTesterPageFeature = class(THtmlPageFeature)
  protected
    procedure LoadPagePart(const VarName: string);
  end;

  { TPageBaseFeature }

  TPageBaseFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
    procedure DependsOn({%H-}ADependencies: THtmlPageFeatureList); override;
  end;

  { THeaderFeature }

  THeaderFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TFooterFeature }

  TFooterFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TContentFeature }

  TContentFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TTesterHtmlPage }

  TTesterHtmlPage = class(TFeaturedHtmlPage)
  private
    FTitle: string;
  protected
    procedure DoGetInnerContents(Strings: TIndentTaggedStrings); virtual; abstract;
    procedure DoGetSkeleton(Strings: TIndentTaggedStrings); override;
  public
    property Title: string read FTitle write FTitle;
  end;

var
  DocumentRoot: string = '/';
  DataRoot: string = '/data';

function TemplateLocation(const TemplateName: string): string;

implementation

function TemplateLocation(const TemplateName: string): string;
begin
  Result := AppendPathDelim(Config.Location_TemplatesDir) + TemplateName + '.html';
end;

{ TContentFeature }

procedure TContentFeature.Satisfy;
var
  Strings: TIndentTaggedStrings;
begin
  Strings := TIndentTaggedStrings.Create;
  try
    with (Parent as TTesterHtmlPage) do
    begin
      DoGetInnerContents(Strings);
      PageParts.SetItemAsStrings('content', Strings);
    end;
  finally
    FreeAndNil(Strings);
  end;
end;

procedure TContentFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  ADependencies.Add(TPageBaseFeature);
end;

{ TTesterHtmlPage }

procedure TTesterHtmlPage.DoGetSkeleton(Strings: TIndentTaggedStrings);
begin
  Strings.LoadFromFile(TemplateLocation('skeleton'));
end;

{ TFooterFeature }

procedure TFooterFeature.Satisfy;
begin
  with Parent do
  begin
    Variables.ItemsAsText['copyright'] := SCopyright;
    Variables.ItemsAsText['license'] := SLicenseNotice;
    Variables.ItemsAsText['github'] := SSourcesNotice;
  end;
  LoadPagePart('footer');
end;

procedure TFooterFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  ADependencies.Add(TPageBaseFeature);
end;

{ THeaderFeature }

procedure THeaderFeature.Satisfy;
begin
  LoadPagePart('header');
  // TODO : Add login panel here!
end;

procedure THeaderFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  ADependencies.Add(TPageBaseFeature);
end;

{ TPageBaseFeature }

procedure TPageBaseFeature.Satisfy;
begin
  with Parent.Variables do
  begin
    ItemsAsText['documentRoot'] := DocumentRoot;
    ItemsAsText['dataRoot'] := DataRoot;
    if Parent is TTesterHtmlPage then
    begin
      ItemsAsText['pageHeader'] := (Parent as TTesterHtmlPage).Title;
      ItemsAsText['title'] := (Parent as TTesterHtmlPage).Title;
    end;
  end;
end;

procedure TPageBaseFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  // do nothing
end;

{ TTesterPageFeature }

procedure TTesterPageFeature.LoadPagePart(const VarName: string);
begin
  Parent.PageParts.SetFromFile(VarName, TemplateLocation(VarName));
end;

end.

