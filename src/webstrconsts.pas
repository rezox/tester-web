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
unit webstrconsts;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

resourcestring
  SNoIndentMarker = 'No indent marker!';
  SInvalidIndentMarker = 'Invalid indent marker!';
  SConvertError = 'Could not convert %s to %s.';
  SUnclosedVariable = 'Unclosed variable specifier.';
  SConflictingModifiers = 'Conflicting or repeating modifiers at variable "%s".';
  SInvalidVariableName = 'Invalid variable name "%s".';
  SVariableNotFound = 'Variable "%s" was not found.';
  SCryptoParamsNotice = 'WARNING: Changing these parameters will lead to loss ' +
    'of ALL passwords, because encryption algorithm will change if you change ' +
    'the parameters.';
  SOwnerParamsNotice = 'WARNING: do not store your actual password here, use ' +
    'Change password option right after your first login! This settings must ' +
    'be set only for INITIAL owner profile setup. It is also good to change ' +
    'this on something random after first login.';
  SErrSessionTerminated = 'No web session active: Session was terminated';
  SErrNoSession = 'No web session active: Session was not started';
  SUnescapeExpectedChar = 'Expected character after "\"';
  SUnescapeUnknownSequence = 'Unknown escape sequence : "%s"';
  SUnescapeExpectedHexDigits = 'Expected two hex digits after "\x"';
  SUnterminatedAssignment = 'Unterminated assignment.';
  SAssignmentQuoteExpected = 'Expected "''" after "=" in assignment.';
  SUnterminatedQuotes = 'Unterminated quotes in assignment.';
  SLoopDependencies = 'Loop dependenices detected.';
  SLoopVariables = 'Variables require each other in loop.';
  SCopyright = 'Copyright &copy; 2017 Alexander Kernozhitsky';
  SLicenseNotice = 'Tester Web is licensed under the terms of <a href="~licenseLink;">GNU GPL</a> version 2 or any later version.';
  SSourcesNotice = 'Sources are available on <a href="~githubLink;">Github</a>.';
  SNoSuchUserRole = 'No such TUserRole!';
  SInvalidUsernamePassword = 'Invalid username or password.';
  SInvalidPassword = 'Invalid password.';
  SUnableLogIn = 'Unable to log in (maybe, the user is blocked?)';
  SUserExists = 'User with name "%s" already exists.';
  SCannotTerminateServer = 'Cannot terminate server!';
  SAccessDenied = 'Access denied :|';
  SUpdateAlreadyUpdating = 'Already updating!';
  SUpdateNoUpdation = 'Updating is disabled! Use BeginUpdate to enable updating.';
  SUserDoesNotExist = 'User with name "%s" doesn''t exist!';
  SAuthDataNotStored = 'Authentification data is not stored!';
  SPasswordsNotEqual = 'Wrong password confirmation!';
  SAuthRequired = 'This action requires authentification.';
  SCreationPublic = '%s creation via public constructor is forbidden!';
  SLoggedAsGuest = 'You are a guest.';
  SLoggedAsUser = 'You are logged in as';
  SUserDoLogIn = 'Log in';
  SUserDoLogOut = 'Log out';
  SUserDoViewProfile = 'View profile';
  SUserDoRegister = 'Register';
  SAuthUsername = 'Username:';
  SAuthUsernamePrompt = 'Enter username';
  SAuthEnterPassword = 'Password:';
  SAuthEnterPasswordPrompt = 'Enter password';
  SAuthRetypePassword = 'Confirm password:';
  SAuthRetypePasswordPrompt = 'Enter password again';
  SAuthFirstName = 'First name:';
  SAuthFirstNamePrompt = 'Enter first name';
  SAuthLastName = 'Last name:';
  SAuthLastNamePrompt = 'Enter last name';
  SConfirmPasswordTitle = 'Password confirmation';
  SLoginRequest = 'To log into the system, please fill in the following form.';
  SLoginSubmit = 'Log in';
  SRegisterRequest = 'To register in the system, please fill in the following form.';
  SRegisterSubmit = 'Register';
  SConfirmPasswordRequest = 'Please confirm your password to continue.';
  SConfirmPasswordSubmit = 'Confirm';
  SBlockedUserRole = 'Banned';
  SSimpleUserRole = 'User';
  SEditorUserRole = 'Contest Setter';
  SAdminUserRole = 'Administrator';
  SOwnerUserRole = 'The Server Keeper';
  SMustNonNil = '%s expected to be non-nil :(';
  SProfileUserNameKey = 'Username:';
  SProfileRealNameKey = 'Real name:';
  SProfileUserRoleKey = 'User role:';
  SProfile = 'Profile';
  SProfileOf = 'Profile of %s';
  SProfileRegisterTimeKey = 'Registered at:';
  SProfileLoginTimeLey = 'Last visit at:';
  SPreferredDateTimeFormat = 'dd.mm.yyyy hh:nn:ss';
  SPreferredDateFormat = 'dd.mm.yyyy';
  SPreferredTimeFormat = 'hh:nn:ss';
  SProfileChangeRoleKey = 'Change role:';
  SProfileDoChangeRole = 'Change';
  SUsernameEmpty = 'Username must be non-empty!';
  SPasswordEmpty = 'Password must be non-empty!';
  SSettingsUpdateData = 'Update data:';
  SSettingsChangePassword = 'Change password:';
  SSettingsUpdate = 'Update';
  SSettingsUpdateSuccessful = 'Update successful.';
  SUpdateSettingsTitle = 'Update settings';
  SSettingsFirstNamePrompt = 'Enter first name to change';
  SSettingsLastNamePrompt = 'Enter last name to change';
  SSettingsOldPasswordPrompt = 'Enter old password to change';
  SSettingsNewPasswordPrompt = 'Enter new password';
  SSettingsConfirmPasswordPrompt = 'Confirm new password';
  SSettingsOldPassword = 'Old password:';
  SSettingsNewPassword = 'New password:';
  SSettingsConfirmPassword = 'Confirm password:';
  SBackToProfile = 'Back to profile';
  SSettingsNothingToUpdate = 'Nothing to update!';
  SDeleteUserTitle = 'Delete user';
  SNoSuchAccessRights = 'No such access rights!';
  SCannotChangeRoleClass = 'Cannot change role classes; the UserManager was ' +
    'created already!';
  SInvalidSessionToken = 'Invalid session token. Please try again.';
  SMessageLocked = 'Message is locked!';
  SOwnerAlreadyExists = 'User with role urOwner already exists!';
  SObjectDoesNotExist = '%s with name "%s" doesn''t exist!';
  SObjectExists = '%s with name "%s" already exists!';
  SObjectUserHasAccess = 'User with name "%2:s" already has access!';
  SObjectUserNoAccess = 'User with name "%2:s" doesn''t have access!';
  SObjectCannotGrantNoneRole = 'Cannot grant erNone to user!';
  SObjectAccessOwner = 'Author';
  SObjectAccessWrite = 'Editor';
  SObjectAccessRead = 'Reviewer';
  SProblemTypeName = 'Problem';
  SEditableDelete = 'Delete';
  SEditableNewText = 'New...';
  SEditableCreatePrompt = 'Enter name and title for your new object.';
  SEditableCreateName = 'Name:';
  SEditableCreateNamePrompt = 'Enter object name';
  SEditableCreateTitle = 'Title:';
  SEditableCreateTitlePrompt = 'Enter object title';
  SEditableCreateSubmit = 'Create';
  SProblemList = 'Problem Editor';
  SEditableListName = 'Name';
  SEditableListTitle = 'Title';
  SEditableListAuthor = 'Author';
  SEditableListAccess = 'Access type';
  SEditableListLastModified = 'Last modified';
  SEditableListDelete = 'Delete';
  SProblemCreateNew = 'Create New Problem';
  SProblemCreatePrompt = 'Enter name and title for your new problem.';
  SProblemCreateNamePrompt = 'Enter problem name';
  SProblemCreateTitlePrompt = 'Enter problem title';
  SEditableAccessId = '#';
  SEditableAccessUsername = 'User';
  SEditableAccessRights = 'Access type';
  SEditableAccessDelete = 'Delete';
  SObjectNodeAccessChange = 'Change';
  SObjectAddUser = 'Add user:';
  SObjectAddUserPrompt = 'Enter username to add';
  SObjectAddUserBtn = 'Add';
  SEditableManageAccess = 'Manage Access';
  SUserNoEditorAccess = 'User with name "%s" doesn''t have editor rights!';
  SEditableViewText = 'View';
  SEditableEditText = 'Edit';
  SEditableAccessText = 'Manage access';
  SObjectTitleKey = 'Title:';
  SObjectTitlePrompt = 'Enter title';
  SObjectEditSubmit = 'Edit object';
  SProblemEditSubmit = 'Edit problem';
  SEditableView = 'View';
  SEditableEdit = 'Edit';
  SCannotAccessThroughOutside = 'Cannot access EditableObject through outside hook!';
  SFileTooBigAlertHead = 'File size must not exceed ';
  SFileTooBigAlertTail = ' KBytes.';
  SNoSuchStatementsType = 'No such Statements type!';
  SFilesNotice = 'NOTE: All sizes are listed in KBytes!';
  SArchiveTooBig = 'Archive size must not exceed %d KBytes.';
  SStatementsTooBig = 'Statements size must not exceed %d KBytes.';
  SSubmissionTooBig = 'File size must not exceed %d KBytes.';
  SUnpackedTooBig = 'Unpacked archive size must not exceed %d KBytes.';
  SBadArchive = 'Bad archive!';
  SCouldNotCopyFile = 'Could not copy file "%s" to "%s"!';
  SCouldNotMoveFile = 'Could not move file "%s" to "%s"!';
  SCouldNotDeleteFile = 'Could not delete file "%s"!';
  SCouldNotDeleteDir = 'Could not delete directory "%s"!';
  SCouldNotUnpack = 'Could not unpack archive!';
  SErrorsWhileDeletingProblem = 'Errors while deleting problem "%s".';
  SMaxSrcSize = 'Max submission file size must be between %d and %d KBytes!';
  SProblemArchiveKey = 'Archive:';
  SProblemStatementsKey = 'Statements:';
  SProblemMaxSrcKey = 'Submission limit:';
  SKBytes = 'KB';
  SProblemStatementsHtml = 'HTML code snippet';
  SProblemStatementsPdf = 'PDF document';
  SProblemStatementsDoc = 'MS Word DOC document';
  SProblemStatementsDocx = 'MS Word DOCX document';
  SProblemStatementsTypeKey = 'Statements type:';
  SFileNotFoundInArchive = 'File "%s" not found in the archive!';
  SArchiveExtensionExpected = 'Archive file expected to have extension "%s"';
  SStatementsExtensionExpected = 'Statements file expected to have extension "%s"';
  SCode404 = 'File not found :(';
  SNone = '(none)';
  SDownloadPrompt = 'Download (%s)';
  SFileSizeBytes = '%d bytes';
  SFileSizeKBytes = '%.1f KB';
  SFileSizeMBytes = '%.1f MB';
  SObjectEditSuccessful = 'Edited successfully.';
  SUnknownSubmissionLanguage = 'Unknown submission language: "%s"!';
  SErrorTitle = 'Error!';
  SErrorMsg = 'Error %s : "%s".';
  SErrorStackTrace = 'Stack trace:';
  SServerRunning = 'Server is running, cannot change %s!';
  SInvalidIDStr = 'Invalid ID string "%s"';
  SFileOpenTimeout = 'Opening file "%s" timed out.';
  SSubmissionDoesNotExist = 'Submission %d doesn''t exist!';
  SThreadAlreadyAssigned = 'A thread is already assigned to the submission. ' +
    'Maybe the submission is already running?';
  SVerdictUnknown = 'Unknown';
  SVerdictTestFailed = 'Testing failed';
  SVerdictRunning = 'Running...';
  SVerdictWaiting = 'Waiting...';
  SVerdictCompiling = 'Compiling...';
  SVerdictFinishing = 'Finishing...';
  SProblemStatementsCaption = 'Statements:';
  SProblemNoStatementsCaption = 'No statements available';
  SProblemTestText = 'Test problem';
  SProblemSubmitSolution = 'Submit solution:';
  SProblemLanguage = 'Language:';
  SProblemSubmitText = 'Submit';
  SProblemFile = 'File:';
  SSubmissionHeaderId = 'ID';
  SSubmissionHeaderSubmitTime = 'Submit time';
  SSubmissionHeaderAuthor = 'Author';
  SSubmissionHeaderProblem = 'Problem';
  SSubmissionHeaderLanguage = 'Language';
  SSubmissionHeaderVerdict = 'Verdict';
  SSubmissionHeaderTest = 'Test';
  SSubmissionHeaderTime = 'Time';
  SSubmissionHeaderMemory = 'Memory';
  SSubmissionHeaderScore = 'Score';
  SNoSubmissionFile = 'No file specified!';
  SSubmissionExtensionExpected = 'File expected to have extension "%s"';
  STsRunNonZeroExitcode = 'TsRun exited with exitcode = %d';
  SStringCannotBeEmpty = 'String %s cannot be empty!';
  SProblemSubmissionsText = 'Submissions';
  SProblemRejudgeBtn = 'Rejudge';
  STestIdHeader = 'Test #';
  STestVerdictHeader = 'Verdict';
  STestTimeHeader = 'Time';
  STestMemoryHeader = 'Memory';
  STestScoreHeader = 'Score';
  SCompileVerdictCaption = 'Compilation verdict:';
  SSubmissionEmptySection = 'No information available!';
  SSubmissionCompileHeader = 'Compilation results';
  SSubmissionTestHeader = 'Testing results';
  SSubmissionSourceHeader = 'Source code';
  SCompileOutputCaption = 'Compiler output:';
  SSubmissionPageCaption = 'Submission #%d';
  SEditableSettingsText = 'Settings';
  SEditableCloneName = 'New name:';
  SEditableCloneNamePrompt = 'Enter new object name';
  SEditableCloneBtn = 'Clone';
  SProblemCloneNamePrompt = 'Enter new problem name';
  SProblemCloneObject = 'Clone problem:';
  SProblemDeleteObject = 'Delete problem:';
  SSuccessfulClone = 'Cloned successfully.';
  SContestTypeName = 'Contest';
  SContestCreatePrompt = 'Enter name and title for your new contest.';
  SContestCreateNamePrompt = 'Enter contest name';
  SContestCreateTitlePrompt = 'Enter contest title';
  SContestCloneNamePrompt = 'Enter new contest name';
  SContestCloneObject = 'Clone contest:';
  SContestDeleteObject = 'Delete contest:';
  SContestList = 'Contest Editor';
  SContestCreateNew = 'Create New Contest';
  SContestEditSubmit = 'Edit contest';
  SRequestShowFormat = '%s Request %s %s from %s done in %d ms.';
  SRequestDateTimeFormat = 'hh:mm:ss.zzzz';
  SArchiveTooManyFiles = 'Archive may not contain more than %d files.';
  SParticipantAlreadyAdded = 'Participant "%s" is already added!';
  SParticipantAlreadyDeleted = 'Participant "%s" is not added!';
  SParticipantIndexHeader = '#';
  SParticipantNameHeader = 'User';
  SParticipantDeleteHeader = 'Delete';
  SContestParticipantsText = 'Participants';
  SNoSuchScoringPolicy = 'No such scoring policy!';
  SContestDurationInterval = 'Contest duration must be between %d and %d minutes!';
  SMonth1 = 'January';
  SMonth2 = 'February';
  SMonth3 = 'March';
  SMonth4 = 'April';
  SMonth5 = 'May';
  SMonth6 = 'June';
  SMonth7 = 'July';
  SMonth8 = 'August';
  SMonth9 = 'September';
  SMonth10 = 'October';
  SMonth11 = 'November';
  SMonth12 = 'December';
  SYes = 'Yes';
  SNo = 'No';
  SContestStartDateKey = 'Start date:';
  SContestStartTimeKey = 'Start time:';
  SContestDurationKey = 'Duration:';
  SContestScoringPolicyKey = 'Scoring policy:';
  SContestAllowUpsolvingKey = 'Allow upsolving?';
  SDurationMinutes = 'minutes';
  SScoringPolicyMaxScore = 'Use submission with maximum score';
  SScoringPolicyLastScore = 'Use last submission';
  SWordToStrError = '"%s" is an invalid integer or it doesn''t fit the interval [%d .. %d]';
  SInvalidDate = '"%.2d.%.2d.%.4d %.2d:%.2d:%.2d" is an invalid date!';
  SContestAlreadySet = 'The contest is already set to this problem!';
  SProblemListNotValid = 'Problem list is not valid!';
  SIndexOutOfBounds = 'List index %d is out of bounds!';
  SProblemAlreadyAdded = 'Problem "%s" is already added!';
  SUnableMoveProblemUp = 'Unable to move the problem up.';
  SUnableMoveProblemDown = 'Unable to move the problem down.';
  SContestProblemsText = 'Problems';
  SUnableDeleteProblem = 'Unable to delete the problem.';
  SActionUpCaption = 'Up';
  SActionDownCaption = 'Down';
  SActionDeleteCaption = 'Delete';
  SContestProblemNumberHeader = '#';
  SContestProblemNameHeader = 'Name';
  SContestProblemTitleHeader = 'Title';
  SContestProblemActionsHeader = 'Actions';
  SContestAddProblem = 'Add problem:';
  SContestAddProblemPrompt = 'Enter problem name to add';
  SContestAddProblemBtn = 'Add';
  SProblemNotExist = 'Problem with name "%s" doesn''t exist!';
  SVarNameInvalidChar = '%s must contain only characters from the set %s.';
  SVarNameLeadingDigit = '%s must not have a digit as a first character.';
  SVarNameNonEmpty = '%s must not be empty.';
  SUserVarType = 'Username';
  SObjectVarType = 'Name';
  SUserFirstLastNameType = 'First or last name';
  SObjectTitleType = 'Title';
  SPasswordType = 'Password';
  SStrInvalidUTF8 = '%s is not a valid UTF-8 string.';
  SStrInvalidLen = '%s length must be from %d to %d characters.';
  SMainPage = 'Main Page';
  STsWebGreeting = 'Welcome to Tester Web!';
  SKillPageTitle = 'Kill Server';
  SFindUserRequest = 'Please enter username of the user to find.';
  SFindUserLabel = 'Username:';
  SFindUserPrompt = 'Enter username to find';
  SFindUserSubmit = 'Find user';
  SFindUserTitle = 'Find User';
  SContestShowStandingsKey = 'Show standings?';
  SContestSolveTitle = 'Contest List';
  SDurationMinFormatHours = '%d:%.2d';
  SDurationMinFormatDays = '%dd %d:%.2d';
  SDurationSecFormatHours = '%d:%.2d:%.2d';
  SDurationSecFormatDays = '%dd %d:%.2d:%.2d';
  SStatusNotStarted = 'Not started';
  SStatusRunning = 'Running';
  SStatusRunningFmt = 'Running (%s left)';
  SStatusUpsolve = 'Upsolving';
  SContestAccessTypeNone = '(none)';
  SContestAccessTypeSetter = 'Contest setter';
  SContestAccessTypeParticipant = 'Participant';
  SSolveNameHeader = 'Name';
  SSolveStartTimeHeader = 'Start time';
  SSolveDurationHeader = 'Duration';
  SSolveStatusHeader = 'Status';
  SSolveAccessTypeHeader = 'Access type';
  SSolveProblemIndexHeader = '#';
  SSolveProblemTitleHeader = 'Title';
  SSolveProblemScoreHeader = 'Score';
  SSolveProblemListTitle = 'Contest';
  SSolveTimeLeft = 'Time left:';
  SProblemIndexFmt = '%d. ';
  SSolveProblemTitle = 'Problem %d';
  SFullSolveProblemTitle = '%d. %s';
  SUnableParseFilename = 'Unable to parse filename';
  SSolveSubmissionsTitle = 'Submissions';
  SSolveStandingsTitle  = 'Standings';
  SSolveParticipantHeader = 'Participant';
  SSolveTotalScoreHeader = 'Total score';
  SSolvePlaceHeader = 'Place';

implementation

end.

