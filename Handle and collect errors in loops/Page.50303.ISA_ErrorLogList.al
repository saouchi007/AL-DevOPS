/// <summary>
/// Page ISA_ErrorLogList (ID 50303).
/// </summary>
page 50303 ISA_ErrorLogList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = ISA_ErrorLog;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Caption = 'ISA Error Log List';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.';
                }
                field("Error Text"; Rec."Error Text")
                {
                    ToolTip = 'Specifies the value of the Error Text field.';
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(SimulateErrors)
            {
                ApplicationArea = All;
                Image = Start;
                Caption = 'Simulate Errors';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    ISA_SimulateErrors();
                end;
            }
            action(ShowErrorMessage)
            {
                ApplicationArea = All;
                Image = ErrorLog;
                Caption = 'Show Error Message';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.ISA_ShowErroMessage();
                end;
            }

            action(ShowErrorCallStack)
            {
                ApplicationArea = All;
                Image = ErrorLog;
                Caption = 'Show Error Callstack';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Rec.ISA_ShowErroCallStack();
                end;
            }
        }
    }

    /// <summary>
    /// ISA_SimulateErrors.
    /// </summary>
    procedure ISA_SimulateErrors()
    var
        ISA_RunProcess: Codeunit ISA_RunProcess;
        i, EndNumber : Integer;
        HasError: Boolean;
    begin
        EndNumber := 30;

        for i := 1 to EndNumber do begin
            ClearLastError();
            ISA_RunProcess.ISA_SetsParams(ISA_GetOneOrTwo());
            HasError := not ISA_RunProcess.Run();
            if HasError then
                ISA_InsertErrorLog();
            Commit();
        end;
    end;

    local procedure ISA_GetOneOrTwo(): Integer
    begin
        Randomize(Time - 000000T);
        exit(Random(2));
    end;

    local procedure ISA_InsertErrorLog()
    var
        ErrorLog: Record ISA_ErrorLog;
        OutStream: OutStream;
    begin
        ErrorLog.Init();
        ErrorLog."Error Text" := CopyStr(GetLastErrorText(), 1, MaxStrLen(ErrorLog."Error Text"));
        ErrorLog."Error Message".CreateOutStream(OutStream);
        OutStream.WriteText(GetLastErrorText());
        ErrorLog."Error Callstack".CreateOutStream(OutStream);
        OutStream.WriteText(GetLastErrorCallStack());
        ErrorLog.Insert();
    end;
}