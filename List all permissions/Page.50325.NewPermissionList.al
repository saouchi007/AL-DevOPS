/// <summary>
/// Page ISA_NewPermissionList (ID 50325).
/// </summary>
page 50326 ISA_NewPermissionList
{
    ApplicationArea = All;
    Caption = 'ISA New Permission List';
    PageType = List;
    SourceTable = ISA_EffectivePerimissionList;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User Name"; Rec."User Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Name field.';
                }
                field("User Security ID"; Rec."User Security ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Security ID field.';
                }
                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field("App Name"; Rec."App Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the App Name field.';
                }
                field("Role ID"; Rec."Role ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Role ID field.';
                }
                field("Role Name"; Rec."Role Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Role Name field.';
                }
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Object Type field.';
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Object ID field.';
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Object Name field.';
                }
                field("Read Permission"; Rec."Read Permission")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Read Permission field.';
                }
                field("Modify Permission"; Rec."Modify Permission")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Modify Permission field.';
                }
                field("Insert Permission"; Rec."Insert Permission")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Insert Permission field.';
                }
                field("Execute Permission"; Rec."Execute Permission")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Execute Permission field.';
                }
                field("Delete Permission"; Rec."Delete Permission")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delete Permission field.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        AccessControl: Record "Access Control";
        RecPermission: Record Permission;
    begin
        AccessControl.Reset();
        AccessControl.SetAutoCalcFields("Role Name", "User Name");
        Rec.LineNo := 0;

        if AccessControl.FindSet() then
            repeat
                RecPermission.Reset();
                RecPermission.SetRange("Role ID", AccessControl."Role ID");
                RecPermission.SetAutoCalcFields("Object Name");
                if RecPermission.FindSet() then
                    repeat
                        Rec.LineNo := Rec.LineNo + 1;
                        Rec.Init();
                        Rec."User Security ID" := AccessControl."User Security ID";
                        Rec."Role ID" := AccessControl."Role ID";
                        Rec."Role Name" := AccessControl."Role Name";
                        Rec."Company Name" := AccessControl."Company Name";
                        Rec."User Name" := AccessControl."User Name";
                        Rec."App Name" := AccessControl."App Name";
                        Rec."Object Type" := RecPermission."Object Type";
                        Rec."Object ID" := RecPermission."Object ID";
                        Rec."Object Name" := RecPermission."Object Name";
                        Rec."Insert Permission" := RecPermission."Insert Permission";
                        Rec."Modify Permission" := RecPermission."Modify Permission";
                        Rec."Execute Permission" := RecPermission."Execute Permission";
                        Rec."Delete Permission" := RecPermission."Delete Permission";
                        Rec."Read Permission" := RecPermission."Read Permission";
                        Rec.Insert();
                    until RecPermission.Next() = 0;
            until AccessControl.Next() = 0;
    end;
}
