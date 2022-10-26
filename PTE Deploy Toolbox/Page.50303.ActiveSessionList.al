/// <summary>
/// Page ISA_ActiveSessionList (ID 50303).
/// </summary>
page 50303 ISA_ActiveSessionList
{
    PageType = List;
    Caption = 'Active Sessions';
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Active Session";
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Server Instance ID"; Rec."Server Instance ID")
                {
                    ApplicationArea = All;
                }
                field("Client Computer Name"; Rec."Client Computer Name")
                {
                    ApplicationArea = All;
                }
                field("Login Datetime"; Rec."Login Datetime")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

}