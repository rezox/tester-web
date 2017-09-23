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
unit tswebeditablefeatures;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, tswebpagesbase, editableobjects, htmlpages, htmlpreprocess,
  tswebfeatures, webstrconsts, users, userpages;

type
  {$interfaces CORBA}

  { IEditablePage }

  IEditablePage = interface
    ['{DC40AF42-023F-4781-B994-71228705D8A9}']
    function Manager: TEditableManager;
    function EditableObject: TEditableObject;
  end;
  {$interfaces COM}

  { TEditableBaseFeature }

  TEditableBaseFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
  end;

  { TEditableObjListNode }

  TEditableObjListNode = class(TTesterHtmlPageElement)
  private
    FEditableObject: TEditableObject;
    FManagerSession: TEditableManagerSession;
    FTransaction: TEditableTransaction;
  protected
    property ManagerSession: TEditableManagerSession read FManagerSession;
    property Transaction: TEditableTransaction read FTransaction;
    procedure DoFillVariables; override;
    procedure DoGetSkeleton(Strings: TIndentTaggedStrings); override;
  public
    property EditableObject: TEditableObject read FEditableObject;
    constructor Create(AParent: THtmlPage; AObject: TEditableObject);
    destructor Destroy; override;
  end;

  { TEditableObjList }

  TEditableObjList = class(TTesterHtmlListedPageElement)
  private
    FManager: TEditableManager;
  protected
    procedure FillList;
    procedure DoFillVariables; override;
    procedure DoGetSkeleton(Strings: TIndentTaggedStrings); override;
  public
    property Manager: TEditableManager read FManager;
    constructor Create(AParent: THtmlPage; AManager: TEditableManager);
  end;

  { TEditableAccessRightsOption }

  TEditableAccessRightsOption = class(TTesterHtmlPageElement)
  private
    FRights: TEditableAccessRights;
    FSelected: boolean;
    FSession: TEditableObjectAccessSession;
  protected
    property Session: TEditableObjectAccessSession read FSession;
    procedure DoFillVariables; override;
    procedure DoGetSkeleton(Strings: TIndentTaggedStrings); override;
  public
    property Rights: TEditableAccessRights read FRights;
    property Selected: boolean read FSelected;
    constructor Create(AParent: THtmlPage; ASession: TEditableObjectAccessSession;
      ARights: TEditableAccessRights; ASelected: boolean);
  end;

  { TEditableAccessNode }

  TEditableAccessNode = class(TTesterHtmlListedPageElement)
  private
    FIndex: integer;
    FSession: TEditableObjectAccessSession;
    FTarget: TUserInfo;
  protected
    property Session: TEditableObjectAccessSession read FSession;
    property Target: TUserInfo read FTarget;
    procedure FillList;
    procedure DoFillVariables; override;
    procedure DoGetSkeleton(Strings: TIndentTaggedStrings); override;
  public
    property Index: integer read FIndex;
    constructor Create(AParent: THtmlPage; ASession: TEditableObjectAccessSession;
      ATarget: TUserInfo; AIndex: integer);
    destructor Destroy; override;
  end;

  { TEditableAccessNodeList }

  TEditableAccessNodeList = class(TTesterHtmlListedPageElement)
  private
    FSession: TEditableObjectAccessSession;
  protected
    property Session: TEditableObjectAccessSession read FSession;
    procedure FillList;
    procedure DoFillVariables; override;
    procedure DoGetSkeleton(Strings: TIndentTaggedStrings); override;
  public
    constructor Create(AParent: THtmlPage; ASession: TEditableObjectAccessSession);
  end;

  { TEditableObjListFeature }

  TEditableObjListFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TEditableCreateFormFeature }

  TEditableCreateFormFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TEditableObjectFeature }

  TEditableObjectFeature = class(TTesterPageFeature)
  private
    FEditableObject: TEditableObject;
  protected
    function User: TEditorUser;
    property EditableObject: TEditableObject read FEditableObject;
    procedure InternalSatisfy; virtual; abstract;
    procedure BeforeSatisfy; virtual;
    procedure AfterSatisfy; virtual;
  public
    procedure Satisfy; override;
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TEditableObjectBaseFeature }

  TEditableObjectBaseFeature = class(TEditableObjectFeature)
  protected
    procedure InternalSatisfy; override;
  end;

  { TEditableNavButtonBaseFeature }

  TEditableNavButtonBaseFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TEditableNavButtonFeature }

  TEditableNavButtonFeature = class(TEditableObjectFeature)
  protected
    function Enabled: boolean; virtual; abstract;
    function PagePartName: string; virtual; abstract;
    function BtnInnerName: string; virtual;
    procedure InternalSatisfy; override;
  public
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TEditableViewButtonFeature }

  TEditableViewButtonFeature = class(TEditableNavButtonFeature)
  protected
    function Enabled: boolean; override;
    function PagePartName: string; override;
  end;

  { TEditableEditButtonFeature }

  TEditableEditButtonFeature = class(TEditableNavButtonFeature)
  protected
    function Enabled: boolean; override;
    function PagePartName: string; override;
  end;

  { TEditableAccessButtonFeature }

  TEditableAccessButtonFeature = class(TEditableNavButtonFeature)
  protected
    function Enabled: boolean; override;
    function PagePartName: string; override;
  end;

  { TEditableButtonsFeature }

  TEditableButtonsFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TEditableManageAccessFeature }

  TEditableManageAccessFeature = class(TEditableObjectFeature)
  protected
    procedure InternalSatisfy; override;
  public
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TEditableTransactionPageFeature }

  TEditableTransactionPageFeature = class(TEditableObjectFeature)
  private
    FTransaction: TEditableTransaction;
  protected
    procedure BeforeSatisfy; override;
    procedure AfterSatisfy; override;
  public
    property Transaction: TEditableTransaction read FTransaction;
  end;

  { TEditablePageTitleFeature }

  TEditablePageTitleFeature = class(TEditableTransactionPageFeature)
  protected
    procedure InternalSatisfy; override;
  public
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TEditableEditViewBaseFeature }

  TEditableEditViewBaseFeature = class(TEditableTransactionPageFeature)
  protected
    procedure InternalSatisfy; override;
  public
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TEditableViewFeature }

  TEditableViewFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

  { TEditableEditFeature }

  TEditableEditFeature = class(TTesterPageFeature)
  public
    procedure Satisfy; override;
    procedure DependsOn(ADependencies: THtmlPageFeatureList); override;
  end;

implementation

{ TEditablePageTitleFeature }

procedure TEditablePageTitleFeature.InternalSatisfy;
begin
  with Parent.Variables do
  begin
    ItemsAsText['pageHeader'] := Transaction.Title;
    ItemsAsText['title'] := '~pageHeader;: ~contentHeaderText;';
  end;
end;

procedure TEditablePageTitleFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(THeaderFeature);
  ADependencies.Add(TContentHeaderFeature);
end;

{ TEditableEditFeature }

procedure TEditableEditFeature.Satisfy;
begin
  with Parent.Variables do
  begin
    ItemsAsText['contentHeaderText'] := SEditableEditText;
    ItemsAsText['objectEditSubmit'] := SObjectEditSubmit;
  end;
  LoadPagePart('editable', 'editableEdit', 'content');
end;

procedure TEditableEditFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(TEditableEditViewBaseFeature);
  ADependencies.Add(TPostDataFeature);
  ADependencies.Add(TContentFeature);
  ADependencies.Add(TEditablePageTitleFeature);
end;

{ TEditableViewFeature }

procedure TEditableViewFeature.Satisfy;
begin
  Parent.Variables.ItemsAsText['contentHeaderText'] := SEditableViewText;
  LoadPagePart('editable', 'editableView', 'content');
end;

procedure TEditableViewFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(TEditableEditViewBaseFeature);
  ADependencies.Add(TContentFeature);
  ADependencies.Add(TEditablePageTitleFeature);
end;

{ TEditableEditViewBaseFeature }

procedure TEditableEditViewBaseFeature.InternalSatisfy;
begin
  with Parent.Variables do
  begin
    ItemsAsText['objectTitleKey'] := SObjectTitleKey;
    ItemsAsText['objectTitleValue'] := Transaction.Title;
    ItemsAsText['objectTitlePrompt'] := SObjectTitlePrompt;
  end;
end;

procedure TEditableEditViewBaseFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(TEditableButtonsFeature);
  ADependencies.Add(TContentFeature);
end;

{ TEditableTransactionPageFeature }

procedure TEditableTransactionPageFeature.BeforeSatisfy;
begin
  inherited BeforeSatisfy;
  FTransaction := EditableObject.CreateTransaction(User);
end;

procedure TEditableTransactionPageFeature.AfterSatisfy;
begin
  FreeAndNil(FTransaction);
  inherited AfterSatisfy;
end;

{ TEditableAccessButtonFeature }

function TEditableAccessButtonFeature.Enabled: boolean;
begin
  Result := EditableObject.GetAccessRights(User) in AccessCanReadSet;
end;

function TEditableAccessButtonFeature.PagePartName: string;
begin
  Result := 'editableAccessBtn';
end;

{ TEditableEditButtonFeature }

function TEditableEditButtonFeature.Enabled: boolean;
begin
  Result := EditableObject.GetAccessRights(User) in AccessCanWriteSet;
end;

function TEditableEditButtonFeature.PagePartName: string;
begin
  Result := 'editableEditBtn';
end;

{ TEditableViewButtonFeature }

function TEditableViewButtonFeature.Enabled: boolean;
begin
  Result := EditableObject.GetAccessRights(User) in AccessCanReadSet;
end;

function TEditableViewButtonFeature.PagePartName: string;
begin
  Result := 'editableViewBtn';
end;

{ TEditableButtonsFeature }

procedure TEditableButtonsFeature.Satisfy;
begin
  with Parent.Variables do
  begin
    ItemsAsText['editableViewText'] := SEditableViewText;
    ItemsAsText['editableEditText'] := SEditableEditText;
    ItemsAsText['editableAccessText'] := SEditableAccessText;
  end;
end;

procedure TEditableButtonsFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(TEditableViewButtonFeature);
  ADependencies.Add(TEditableEditButtonFeature);
  ADependencies.Add(TEditableAccessButtonFeature);
end;

{ TEditableNavButtonFeature }

function TEditableNavButtonFeature.BtnInnerName: string;
begin
  Result := PagePartName + 'Inner';
end;

procedure TEditableNavButtonFeature.InternalSatisfy;
var
  BtnInnerVar: string;
begin
  if Enabled then
    BtnInnerVar := '~+#editableLinkEnabled;'
  else
    BtnInnerVar := '~+#editableLinkDisabled;';
  Parent.Variables.ItemsAsText[BtnInnerName] := BtnInnerVar;
  LoadPagePart('editable', PagePartName);
end;

procedure TEditableNavButtonFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(TEditableNavButtonBaseFeature);
end;

{ TEditableNavButtonBaseFeature }

procedure TEditableNavButtonBaseFeature.Satisfy;
begin
  LoadPagePart('editable', 'editableLinkEnabled');
  LoadPagePart('editable', 'editableLinkDisabled');
end;

procedure TEditableNavButtonBaseFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(TEditableObjectBaseFeature);
end;

{ TEditableObjectBaseFeature }

procedure TEditableObjectBaseFeature.InternalSatisfy;
begin
  with Parent.Variables do
    ItemsAsText['objectName'] := EditableObject.Name;
end;

{ TEditableObjectFeature }

function TEditableObjectFeature.User: TEditorUser;
begin
  Result := (Parent as TUserPage).User as TEditorUser;
end;

procedure TEditableObjectFeature.BeforeSatisfy;
begin
  FEditableObject := (Parent as IEditablePage).EditableObject;
end;

procedure TEditableObjectFeature.AfterSatisfy;
begin
  FreeAndNil(FEditableObject);
end;

procedure TEditableObjectFeature.Satisfy;
begin
  BeforeSatisfy;
  try
    InternalSatisfy;
  finally
    AfterSatisfy;
  end;
end;

procedure TEditableObjectFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(TEditableBaseFeature);
end;

{ TEditableManageAccessFeature }

procedure TEditableManageAccessFeature.InternalSatisfy;
var
  Session: TEditableObjectAccessSession;
  List: TEditableAccessNodeList;
begin
  Session := EditableObject.CreateAccessSession(User);
  try
    // title
    Parent.Variables.ItemsAsText['contentHeaderText'] := SEditableAccessText;
    // "add user" panel
    if Session.CanAddUser then
    begin
      with Parent.Variables do
      begin
        ItemsAsText['objectAddUser'] := SObjectAddUser;
        ItemsAsText['objectAddUserPrompt'] := SObjectAddUserPrompt;
        ItemsAsText['objectAddUserBtn'] := SObjectAddUserBtn;
      end;
      LoadPagePart('editable', 'editableAccessAdd');
    end;
    // access table
    List := TEditableAccessNodeList.Create(Parent, Session);
    try
      Parent.AddElementPagePart('editableAccessTable', List)
    finally
      FreeAndNil(List);
    end;
    // load page content
    LoadPagePart('editable', 'editableAccess', 'content');
  finally
    FreeAndNil(Session);
  end;
end;

procedure TEditableManageAccessFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(TPostDataFeature);
  ADependencies.Add(TContentFeature);
  ADependencies.Add(TEditableButtonsFeature);
  ADependencies.Add(TEditablePageTitleFeature);
end;

{ TEditableAccessNodeList }

procedure TEditableAccessNodeList.FillList;
var
  I: integer;
  AccessUsers: TStringList;
begin
  List.Clear;
  AccessUsers := Session.EditableObject.ListUsers;
  try
    for I := 0 to AccessUsers.Count - 1 do
      List.Add(TEditableAccessNode.Create(Parent, Session,
        UserManager.GetUserInfo(AccessUsers[I]), I + 1));
  finally
    FreeAndNil(AccessUsers);
  end;
end;

procedure TEditableAccessNodeList.DoFillVariables;
begin
  with Parent.Variables do
  begin
    ItemsAsText['editableAccessId'] := SEditableAccessId;
	  ItemsAsText['editableAccessUsername'] := SEditableAccessUsername;
	  ItemsAsText['editableAccessRights'] := SEditableAccessRights;
	  ItemsAsText['editableAccessDelete'] := SEditableAccessDelete;
  end;
  FillList;
  AddListToVariable('editableAccessNodes');
  List.Clear;
end;

procedure TEditableAccessNodeList.DoGetSkeleton(Strings: TIndentTaggedStrings);
begin
  Strings.LoadFromFile(TemplateLocation('editable', 'editableAccessTable'));
end;

constructor TEditableAccessNodeList.Create(AParent: THtmlPage;
  ASession: TEditableObjectAccessSession);
begin
  inherited Create(AParent);
  FSession := ASession;
end;

{ TEditableAccessNode }

procedure TEditableAccessNode.FillList;
var
  R: TEditableAccessRights;
  TargetRights: TEditableAccessRights;
begin
  List.Clear;
  TargetRights := Session.EditableObject.GetAccessRights(Target);
  for R in TEditableAccessRights do
    if Session.CanGrantAccessRights(Target, R) then
      List.Add(TEditableAccessRightsOption.Create(Parent, Session, R, R = TargetRights));
end;

procedure TEditableAccessNode.DoFillVariables;
var
  DeleteBtnLocation: string;
  TargetRights: TEditableAccessRights;
begin
  with Storage do
  begin
    ItemsAsText['objectNodeNum'] := IntToStr(Index);
    ItemsAsText['objectNodeUser'] := Parent.GenerateUserLink(Target);
    ItemsAsText['objectNodeAccessChange'] := SObjectNodeAccessChange;
    ItemsAsText['objectNodeUsername'] := Target.Username;
    // fill "edit rights" column
    FillList;
    if List.Count > 1 then
    begin
      AddListToVariable('objectNodeEditRightsOptions');
      SetFromFile('objectNodeRightsEdit', TemplateLocation('editable', 'editableEditRights'));
    end
    else
    begin
      TargetRights := Session.EditableObject.GetAccessRights(Target);
      ItemsAsText['objectUserRights'] := SAccessRightsNames[TargetRights];
      SetFromFile('objectNodeRightsEdit', TemplateLocation('editable', 'editableViewRights'));
    end;
    List.Clear;
    // fill "delete" column
    if Session.CanDeleteUser(Target) then
      DeleteBtnLocation := 'editableDeleteUserEnabled'
    else
      DeleteBtnLocation := 'editableDeleteUserDisabled';
    SetFromFile('objectNodeDelete', TemplateLocation('editable', DeleteBtnLocation));
  end;
end;

procedure TEditableAccessNode.DoGetSkeleton(Strings: TIndentTaggedStrings);
begin
  Strings.LoadFromFile(TemplateLocation('editable', 'editableAccessNode'));
end;

constructor TEditableAccessNode.Create(AParent: THtmlPage;
  ASession: TEditableObjectAccessSession; ATarget: TUserInfo; AIndex: integer);
begin
  inherited Create(AParent);
  FSession := ASession;
  FTarget := ATarget;
  FIndex := AIndex;
end;

destructor TEditableAccessNode.Destroy;
begin
  FreeAndNil(FTarget);
  inherited Destroy;
end;

{ TEditableAccessRightsOption }

procedure TEditableAccessRightsOption.DoFillVariables;
begin
  with Storage do
  begin
    ItemsAsText['rightsFullName'] := AccessRightsToStr(Rights);
    ItemsAsText['rightsName'] := SAccessRightsNames[Rights];
    if Selected then
      ItemsAsText['rightsSelected'] := ' selected'
    else
      ItemsAsText['rightsSelected'] := '';
  end;
end;

procedure TEditableAccessRightsOption.DoGetSkeleton(Strings: TIndentTaggedStrings);
begin
  Strings.LoadFromFile(TemplateLocation('editable', 'editableEditRightsOption'));
end;

constructor TEditableAccessRightsOption.Create(AParent: THtmlPage;
  ASession: TEditableObjectAccessSession; ARights: TEditableAccessRights;
  ASelected: boolean);
begin
  inherited Create(AParent);
  FSession := ASession;
  FRights := ARights;
  FSelected := ASelected;
end;

{ TEditableCreateFormFeature }

procedure TEditableCreateFormFeature.Satisfy;
begin
  with Parent.Variables do
  begin
    ItemsAsText['editableCreateName'] := SEditableCreateName;
    ItemsAsText['editableCreateNamePrompt'] := SEditableCreateNamePrompt;
    ItemsAsText['editableCreateTitle'] := SEditableCreateTitle;
    ItemsAsText['editableCreateTitlePrompt'] := SEditableCreateTitlePrompt;
    ItemsAsText['editableCreateSubmit'] := SEditableCreateSubmit;
    ItemsAsText['editableCreatePrompt'] := SEditableCreatePrompt;
  end;
  LoadPagePart('editable', 'editableCreateForm', 'content');
end;

procedure TEditableCreateFormFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(TEditableBaseFeature);
  ADependencies.Add(TPostDataFeature);
  ADependencies.Add(TSessionTokenFeature);
  ADependencies.Add(TContentFeature);
end;

{ TEditableObjListFeature }

procedure TEditableObjListFeature.Satisfy;
var
  List: TEditableObjList;
begin
  // load header names
  with Parent.Variables do
  begin
    ItemsAsText['editableListName'] := SEditableListName;
    ItemsAsText['editableListTitle'] := SEditableListTitle;
    ItemsAsText['editableListAuthor'] := SEditableListAuthor;
    ItemsAsText['editableListAccess'] := SEditableListAccess;
    ItemsAsText['editableListLastModified'] := SEditableListLastModified;
    ItemsAsText['editableListDelete'] := SEditableListDelete;
  end;
  // load list
  List := TEditableObjList.Create(Parent, (Parent as IEditablePage).Manager);
  try
    Parent.AddElementPagePart('editableObjListTable', List)
  finally
    FreeAndNil(List);
  end;
  // load content
  LoadPagePart('editable', 'editableObjList', 'content');
end;

procedure TEditableObjListFeature.DependsOn(ADependencies: THtmlPageFeatureList);
begin
  inherited DependsOn(ADependencies);
  ADependencies.Add(TEditableBaseFeature);
  ADependencies.Add(TContentFeature);
end;

{ TEditableBaseFeature }

procedure TEditableBaseFeature.Satisfy;
begin
  with Parent.Variables do
  begin
    ItemsAsText['editableDelete'] := SEditableDelete;
    ItemsAsText['editableNewText'] := SEditableNewText;
  end;
end;

{ TEditableObjListNode }

procedure TEditableObjListNode.DoFillVariables;
var
  DeleteNodeName: string;
begin
  with Storage, FEditableObject do
  begin
    ItemsAsText['objectNodeName'] := Name;
    ItemsAsText['objectNodeTitle'] := FTransaction.Title;
    ItemsAsText['objectNodeOwner'] := Parent.GenerateUserLink(GetObjectAuthorName);
    ItemsAsText['objectNodeRights'] := SAccessRightsNames[GetAccessRights(Parent.User as TEditorUser)];
    ItemsAsText['objectNodeLastModified'] := FormatDateTime(SPreferredDateTimeFormat,
      FTransaction.LastModifyTime);
    if FManagerSession.CanDeleteObject(Name) then
      DeleteNodeName := 'editableADeleteEnabled'
    else
      DeleteNodeName := 'editableADeleteDisabled';
    SetFromFile('objectNodeDelete', TemplateLocation('editable', DeleteNodeName));
  end;
end;

procedure TEditableObjListNode.DoGetSkeleton(Strings: TIndentTaggedStrings);
begin
  Strings.LoadFromFile(TemplateLocation('editable', 'editableObjListNode'));
end;

constructor TEditableObjListNode.Create(AParent: THtmlPage;
  AObject: TEditableObject);
begin
  inherited Create(AParent);
  FEditableObject := AObject;
  FManagerSession := FEditableObject.Manager.CreateManagerSession(Parent.User as TEditorUser);
  FTransaction := FEditableObject.CreateTransaction(Parent.User as TEditorUser);
end;

destructor TEditableObjListNode.Destroy;
begin
  FreeAndNil(FTransaction);
  FreeAndNil(FManagerSession);
  FreeAndNil(FEditableObject);
  inherited Destroy;
end;

{ TEditableObjList }

procedure TEditableObjList.FillList;
var
  ObjList: TStringList;
  ObjName: string;
begin
  List.Clear;
  ObjList := FManager.ListAvailableObjects(Parent.User as TEditorUser);
  try
    for ObjName in ObjList do
      List.Add(TEditableObjListNode.Create(Parent, FManager.GetObject(ObjName)))
  finally
    FreeAndNil(ObjList);
  end;
end;

procedure TEditableObjList.DoFillVariables;
begin
  FillList;
  AddListToVariable('editableObjListNodes');
  List.Clear;
end;

procedure TEditableObjList.DoGetSkeleton(Strings: TIndentTaggedStrings);
begin
  Strings.LoadFromFile(TemplateLocation('editable', 'editableObjListTable'));
end;

constructor TEditableObjList.Create(AParent: THtmlPage;
  AManager: TEditableManager);
begin
  inherited Create(AParent);
  FManager := AManager;
end;

end.

