page 81284 "MICA F. Secur User Access List"
{
    PageType = List;
    SourceTable = "MICA F. Security User Access";
    Caption = 'Field Security User Access List';
    UsageCategory = None;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Table Id"; Rec."Table Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Field ID"; Rec."Field ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(User; Rec."User Guid")
                {
                    ApplicationArea = All;
                    Editable = Rec."User Group" = '';
                    trigger OnValidate()
                    begin
                        ViewUserGroup := false;
                        if IsNullGuid(Rec."User Guid") then
                            ViewUserGroup := true;
                    end;
                }

                field("User ID"; Rec."User Name")
                {
                    ApplicationArea = All;
                }
                field("User Group"; Rec."User Group")
                {
                    ApplicationArea = All;
                    //Editable = "User" = '00000000-0000-0000-0000-000000000000';
                    Editable = ViewUserGroup;
                }
                field(Restricted; Rec."Restricted")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        ViewUserGroup := false;
        if IsNullGuid(Rec."User Guid") then
            ViewUserGroup := true;
    end;

    var
        ViewUserGroup: Boolean;
}
