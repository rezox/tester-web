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
unit submissions_tsrun;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, submissions, UTF8Process, tswebcrypto, serverconfig,
  filemanager, LazFileUtils, tswebobservers, webstrconsts;

type
  ETsRunSubmission = class(Exception);

  { TTsRunThread }

  TTsRunThread = class(TThread)
  private
    FProcess: TProcessUTF8;
    FTsRunExe: string;
    FProblemWorkDir: string;
    FProblemPropsFile: string;
    FTestSrc: string;
    FResFile: string;
    FTestDirName: string;
    FTimeout: integer;
    FExitCode: integer;
  public
    property TsRunExe: string read FTsRunExe write FTsRunExe;
    property ProblemWorkDir: string read FProblemWorkDir write FProblemWorkDir;
    property ProblemPropsFile: string read FProblemPropsFile write FProblemPropsFile;
    property TestSrc: string read FTestSrc write FTestSrc;
    property ResFile: string read FResFile write FResFile;
    property TestDirName: string read FTestDirName write FTestDirName;
    property Timeout: integer read FTimeout write FTimeout;
    property ExitCode: integer read FExitCode;
    procedure Run;
    procedure Execute; override;
    procedure Terminate;
    constructor Create;
    destructor Destroy; override;
  end;

  { TTsRunTestSubmission }

  TTsRunTestSubmission = class(TTestSubmission)
  private
    FThread: TTsRunThread;
    procedure ThreadTerminate(Sender: TObject);
  protected
    property Thread: TTsRunThread read FThread;
    procedure Prepare; override;
    {%H-}constructor Create(AManager: TSubmissionManager; AID: integer);
  public
    destructor Destroy; override;
  end;

  TTsRunThreadTerminateMessage = class(TAuthorMessage);

  { TTsRunSubmissionPool }

  TTsRunSubmissionPool = class(TSubmissionPool)
  protected
    procedure DoAdd(ASubmission: TTestSubmission); override;
    procedure DoDelete(ASubmission: TTestSubmission); override;
    procedure MessageReceived(AMessage: TAuthorMessage);
  end;

  { TTsRunSubmissionQueue }

  TTsRunSubmissionQueue = class(TSubmissionQueue)
  protected
    function CreatePool: TSubmissionPool; override;
    {%H-}constructor Create(AManager: TSubmissionManager);
  end;

  { TTsRunSubmissionManager }

  TTsRunSubmissionManager = class(TSubmissionManager)
  protected
    function CreateQueue: TSubmissionQueue; override;
    function DoCreateTestSubmission(AID: integer): TTestSubmission; override;
  end;

implementation

{ TTsRunSubmissionManager }

function TTsRunSubmissionManager.CreateQueue: TSubmissionQueue;
begin
  Result := TTsRunSubmissionQueue.Create(Self);
end;

function TTsRunSubmissionManager.DoCreateTestSubmission(AID: integer): TTestSubmission;
begin
  Result := TTsRunTestSubmission.Create(Self, AID);
end;

{ TTsRunSubmissionQueue }

function TTsRunSubmissionQueue.CreatePool: TSubmissionPool;
begin
  Result := TTsRunSubmissionPool.Create;
end;

constructor TTsRunSubmissionQueue.Create(AManager: TSubmissionManager);
begin
  inherited Create(AManager);
end;

{ TTsRunSubmissionPool }

procedure TTsRunSubmissionPool.MessageReceived(AMessage: TAuthorMessage);
begin
  if AMessage is TTsRunThreadTerminateMessage then
    TriggerTestingFinished(AMessage.Sender as TTestSubmission);
end;

procedure TTsRunSubmissionPool.DoAdd(ASubmission: TTestSubmission);
begin
  ASubmission.Subscribe(Self);
  with (ASubmission as TTsRunTestSubmission).Thread do
    Run;
end;

procedure TTsRunSubmissionPool.DoDelete(ASubmission: TTestSubmission);
begin
  ASubmission.Unsubscribe(Self);
  with (ASubmission as TTsRunTestSubmission).Thread do
  begin
    Terminate;
    WaitFor;
  end;
end;

{ TTsRunTestSubmission }

procedure TTsRunTestSubmission.ThreadTerminate(Sender: TObject);
begin
  Finish(FThread.ExitCode = 0);
  Broadcast(TTsRunThreadTerminateMessage.Create.AddSender(Self).Lock);
  FThread := nil; // it will be freed automatically!
end;

procedure TTsRunTestSubmission.Prepare;
begin
  inherited Prepare;
  if FThread <> nil then
    raise ETsRunSubmission.Create(SThreadAlreadyAssigned);
  FThread := TTsRunThread.Create;
  with FThread do
  begin
    ProblemWorkDir := GetUnpackedFileName;
    ProblemPropsFile := GetPropsFileName;
    TestSrc := FileName;
    ResFile := ResultsFileName;
    OnTerminate := @ThreadTerminate;
  end;
end;

constructor TTsRunTestSubmission.Create(AManager: TSubmissionManager;
  AID: integer);
begin
  inherited Create(AManager, AID);
  FThread := nil;
end;

destructor TTsRunTestSubmission.Destroy;
begin
  FreeAndNil(FThread);
  inherited Destroy;
end;

{ TTsRunThread }

procedure TTsRunThread.Execute;
begin
  // wait
  FProcess.WaitOnExit;
  // retrieve exit code
  FExitCode := FProcess.ExitCode;
  if FExitCode = 0 then
    FExitCode := FProcess.ExitStatus;
  // cleanup working directory
  TryDeleteDir(AppendPathDelim(GetTempDir) + FTestDirName);
end;

procedure TTsRunThread.Run;
begin
  // add parameters
  FProcess.Executable := FTsRunExe;
  with FProcess.Parameters do
  begin
    Add(FProblemWorkDir);
    Add(FProblemPropsFile);
    Add(FTestSrc);
    Add(FResFile);
    Add(FTestDirName);
    Add(IntToStr(FTimeout));
  end;
  // run
  FProcess.Execute;
  // start thread to wait for the end
  Start;
end;

procedure TTsRunThread.Terminate;
begin
  FProcess.Terminate(42);
  inherited Terminate;
end;

constructor TTsRunThread.Create;
begin
  inherited Create(True, DefaultStackSize);
  FProcess := TProcessUTF8.Create(nil);
  FTsRunExe := Config.Location_TsRunExe;
  FTestDirName := 'tsweb-' + RandomFileName(12);
  FTimeout := 30;
  FreeOnTerminate := True;
end;

destructor TTsRunThread.Destroy;
begin
  FreeAndNil(FProcess);
  inherited Destroy;
end;

end.

