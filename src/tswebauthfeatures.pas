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
unit tswebauthfeatures;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, tswebpagesbase, tswebfeatures, users, htmlpages,
  webstrconsts;

type

  { TAuthBaseFeature }

  TAuthBaseFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
  end;

  { TAuthFormFeature }

  TAuthFormFeature = class(TTesterPageFeature)
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

implementation

{ TAuthBaseFeature }

procedure TAuthBaseFeature.Satisfy;
begin
  LoadPagePart('auth', 'auth', 'content');
  LoadPagePart('auth', 'authNameItem');
  LoadPagePart('auth', 'authUsernameItem');
  LoadPagePart('auth', 'authPasswordItem');
  with (Parent as TAuthHtmlPageBase) do
    with Variables do
    begin
      ItemsAsText['authUsername'] := SAuthUsername;
      ItemsAsText['authUsernamePrompt'] := SAuthUsernamePrompt;
      ItemsAsText['authPassword'] := SAuthPassword;
      ItemsAsText['authPasswordPrompt'] := SAuthPasswordPrompt;
      ItemsAsText['authFirstName'] := SAuthFirstName;
      ItemsAsText['authFirstNamePrompt'] := SAuthFirstNamePrompt;
      ItemsAsText['authLastName'] := SAuthLastName;
      ItemsAsText['authLastNamePrompt'] := SAuthLastNamePrompt;
    end;
end;

{ TAuthFormFeature }

procedure TAuthFormFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(TAuthBaseFeature);
end;

end.

