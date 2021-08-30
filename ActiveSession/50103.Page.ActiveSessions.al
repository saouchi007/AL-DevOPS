page 50103 ActiveSessions
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Active Session";
    InsertAllowed = false;
    Editable = false;
    DeleteAllowed = false;
    Caption = 'Currently logged in Users';
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = all;
                }
                field("Login Datetime"; Rec."Login Datetime")
                {
                    ApplicationArea = all;
                }
                field("Client Type"; Rec."Client Type")
                {
                    ApplicationArea = all;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        ActiveSession: Record "Active Session";
        lastUserID: Text[100];
    begin
        lastUserID := '';
        ActiveSession.Reset();
        ActiveSession.SetCurrentKey("User ID");
        ActiveSession.Ascending(true);

        if ActiveSession.FindSet() then begin
            repeat
                if not (ActiveSession."User ID" = lastUserID) then begin
                    Rec.Init();
                    Rec."Server Instance ID" := ActiveSession."Server Instance ID";
                    Rec."Session ID" := ActiveSession."Session ID";
                    Rec."User ID" := ActiveSession."User ID";
                    Rec."Login Datetime" := ActiveSession."Login Datetime";
                    Rec."Client Type" := ActiveSession."Client Type";
                    Rec.Insert();
                    lastUserID := ActiveSession."User ID";
                end;
            until ActiveSession.Next() = 0;
        end;

    end;

}