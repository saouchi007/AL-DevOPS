page 80879 "MICA Int. Monitoring Setup"
{

    PageType = Card;
    SourceTable = "MICA Int. Monitoring Setup";
    Caption = 'Interface Monitoring Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            group(EndPoint)
            {
                caption = 'EndPoint Substitution';

                field("EndPoint Substitute Value 1"; Rec."EndPoint Substitute Value 1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Act as %1 in EndPoint substitution';
                }
                field("EndPoint Substitute Value 2"; Rec."EndPoint Substitute Value 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Act as %2 in EndPoint substitution';
                }
                field("EndPoint Substitute Value 3"; Rec."EndPoint Substitute Value 3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Act as %3 in EndPoint substitution';
                }
                field("EndPoint Substitute Value 4"; Rec."EndPoint Substitute Value 4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Act as %4 in EndPoint substitution';
                }
                field("EndPoint Substitute Value 5"; Rec."EndPoint Substitute Value 5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Act as %5 in EndPoint substitution';
                }
            }
            group(Security)
            {
                caption = 'Security';
                field("Use Def. Windows Network Auth."; Rec."Use Def. Windows Network Auth.")
                {
                    ApplicationArea = All;

                }
            }
            group("Blob")
            {
                caption = 'Blob';
                field("Discard Blob Name Containing"; Rec."Discard Blob Name Containing")
                {
                    ApplicationArea = All;

                }
                field("Disable Blob Prefix Control"; Rec."Disable Blob Prefix Control")
                {
                    ApplicationArea = All;

                }
            }
            group(Information)
            {
                caption = 'Information';
                field("Force Add. Text On Close Error"; Rec."Force Add. Text On Close Error")
                {
                    ApplicationArea = All;

                }
                field("Enable API Detailed Log"; Rec."Enable API Detailed Log")
                {
                    ApplicationArea = All;
                }
                field("Confirm Buffer Record Deletion"; Rec."Confirm Buffer Record Deletion")
                {
                    ApplicationArea = All;
                }
            }
            group(PGPAzureFunction)
            {
                Caption = 'PGP Azure Function';
                field("PGP Azure Function URI"; Rec."PGP Azure Function URI")
                {
                    ApplicationArea = All;
                }
                field("PGP Azure Function Key"; Rec."PGP Azure Function Key")
                {
                    ApplicationArea = All;
                }
                field("PGP File Extension"; Rec."PGP File Extension")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

}
