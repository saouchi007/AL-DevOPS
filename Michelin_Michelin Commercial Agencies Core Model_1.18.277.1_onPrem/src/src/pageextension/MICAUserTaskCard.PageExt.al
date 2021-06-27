pageextension 80102 "MICA User Task Card" extends "User Task Card"
{
    layout
    {
        addlast("Task Item")
        {
            field("MICA Process ID"; Rec."MICA Process ID")
            {
                ApplicationArea = All;
            }
            field("MICA URL"; "MICAURL")
            {
                ApplicationArea = All;
                Caption = 'URL';
                trigger OnValidate()
                begin
                    Rec.SetMICAURL(MICAURL);
                end;
            }
        }
        modify("Assigned To User Name")
        {
            Editable = Rec."MICA Process ID" <> 1;
        }
        modify("Completed By User Name")
        {
            Editable = Rec."MICA Process ID" <> 1;
        }
    }

    actions
    {
        addafter("Go To Task Item")
        {
            action("MICA Go To Task Item Spe")
            {
                ApplicationArea = All;
                Caption = 'Go To Task Item';
                Image = Navigate;
                trigger OnAction()
                var
                    MICACustRqst: Codeunit "MICA Customer Request";
                begin
                    MICACustRqst.GoToTaskItem(Rec);
                end;
            }
        }
        modify("Go To Task Item")
        {
            Visible = false;
        }
    }

    trigger OnAfterGetRecord()
    begin
        MICAURL := Rec.GetMICAURL();
    end;

    var
        MICAURL: Text;
}