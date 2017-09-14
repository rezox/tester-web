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
unit tswebmodules;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, webmodules, tswebnavbars, navbars, htmlpreprocess,
  fphttp, htmlpages, tswebpages, HTTPDefs, users;

type

  { TDefaultNavBar }

  TDefaultNavBar = class(TTesterNavBar)
  protected
    procedure DoCreateElements; override;
  end;

  { TSimpleHtmlPage }

  TSimpleHtmlPage = class(TDefaultHtmlPage)
  private
    FTextContent: string;
  protected
    function CreateNavBar: TNavBar; override;
    procedure DoGetInnerContents(Strings: TIndentTaggedStrings); override;
  public
    property TextContent: string read FTextContent write FTextContent;
  end;

  { TIndexWebModule }

  TIndexWebModule = class(THtmlPageWebModule)
  protected
    function DoCreatePage: THtmlPage; override;
  end;

  { TPage1WebModule }

  TPage1WebModule = class(THtmlPageWebModule)
  protected
    function DoCreatePage: THtmlPage; override;
  end;

  { TPage2WebModule }

  TPage2WebModule = class(THtmlPageWebModule)
  protected
    function DoCreatePage: THtmlPage; override;
  end;

  { TLoginWebModule }

  TLoginWebModule = class(THtmlPageWebModule)
  private
    FError: string;
    procedure RedirectIfLoggedRequest(Sender: TObject; {%H-}ARequest: TRequest;
      AResponse: TResponse; var Handled: boolean);
    procedure PostHandleRequest(Sender: TObject; ARequest: TRequest;
      AResponse: TResponse; var Handled: boolean);
  protected
    function DoCreatePage: THtmlPage; override;
    procedure DoBeforeRequest; override;
    procedure DoAfterRequest; override;
  public
    procedure AfterConstruction; override;
  end;

  { TLogoutWebModule }

  TLogoutWebModule = class(TTesterWebModule)
  protected
    procedure DoInsideRequest; override;
  end;

implementation

{ TLogoutWebModule }

procedure TLogoutWebModule.DoInsideRequest;
begin
  Session.Terminate;
  Response.Location := '/';
  Response.Code := 303;
end;

{ TLoginWebModule }

procedure TLoginWebModule.RedirectIfLoggedRequest(Sender: TObject;
  ARequest: TRequest; AResponse: TResponse; var Handled: boolean);
var
  AUser: TUser;
begin
  AUser := UserManager.LoadUserFromSession(Session);
  if AUser <> nil then
  begin
    FreeAndNil(AUser);
    AResponse.Location := '/';
    AResponse.Code := 303;
    Handled := True;
  end;
end;

procedure TLoginWebModule.PostHandleRequest(Sender: TObject;
  ARequest: TRequest; AResponse: TResponse; var Handled: boolean);
var
  Username, Password: string;
begin
  if ARequest.Method.ToUpper = 'POST' then
  begin
    try
      Username := ARequest.ContentFields.Values['username'];
      Password := ARequest.ContentFields.Values['password'];
      UserManager.AuthentificateSession(Session, Username, Password);
      // if no exception, we send redirect and don't render that page
      AResponse.Location := '/';
      AResponse.Code := 303;
      Handled := True;
    except
      on E: EUserAction do
        FError := E.Message
      else
        raise;
    end;
  end;
end;

function TLoginWebModule.DoCreatePage: THtmlPage;
begin
  Result := TLoginHtmlPage.Create;
  (Result as TAuthHtmlPage).Error := FError;
end;

procedure TLoginWebModule.DoBeforeRequest;
begin
  inherited DoBeforeRequest;
  FError := '';
end;

procedure TLoginWebModule.DoAfterRequest;
begin
  inherited DoAfterRequest;
  FError := '';
end;

procedure TLoginWebModule.AfterConstruction;
begin
  inherited AfterConstruction;
  AddEventHandler(@RedirectIfLoggedRequest);
  AddEventHandler(@PostHandleRequest);
end;

{ TPage2WebModule }

function TPage2WebModule.DoCreatePage: THtmlPage;
begin
  Result := TSimpleHtmlPage.Create;
  try
    with Result as TSimpleHtmlPage do
    begin
      Title := 'Page 2';
      TextContent := 'This is page 2.';
    end;
  except
    FreeAndNil(Result);
    raise;
  end;
end;

{ TPage1WebModule }

function TPage1WebModule.DoCreatePage: THtmlPage;
begin
  Result := TSimpleHtmlPage.Create;
  try
    with Result as TSimpleHtmlPage do
    begin
      Title := 'Page 1';
      TextContent := 'This is page 1.';
    end;
  except
    FreeAndNil(Result);
    raise;
  end;
end;

{ TIndexWebModule }

function TIndexWebModule.DoCreatePage: THtmlPage;
begin
  Result := TSimpleHtmlPage.Create;
  try
    with Result as TSimpleHtmlPage do
    begin
      Title := 'Main Page';
      TextContent := 'Hello World!';
    end;
  except
    FreeAndNil(Result);
    raise;
  end;
end;

{ TDefaultNavBar }

procedure TDefaultNavBar.DoCreateElements;
begin
  AddElement('Main Page', '~documentRoot;/index');
  AddElement('Page 1', '~documentRoot;/page1');
  AddElement('Page 2', '~documentRoot;/page2');
end;

{ TSimpleHtmlPage }

function TSimpleHtmlPage.CreateNavBar: TNavBar;
begin
  Result := TDefaultNavBar.Create(Self);
end;

procedure TSimpleHtmlPage.DoGetInnerContents(Strings: TIndentTaggedStrings);
begin
  Strings.Text := FTextContent;
end;

initialization
  RegisterHTTPModule('index', TIndexWebModule, True);
  RegisterHTTPModule('page1', TPage1WebModule, True);
  RegisterHTTPModule('page2', TPage2WebModule, True);
  RegisterHTTPModule('login', TLoginWebModule, True);
  RegisterHTTPModule('logout', TLogoutWebModule, True);

end.
