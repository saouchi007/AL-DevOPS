page 80103 "MICA Assign To"
{
    // version REQUEST

    PageType = Card;
    UsageCategory = None;
    Caption = 'Assign To';
    layout
    {
        area(content)
        {
            field("Assigned User ID"; "Assigned User ID Value")
            {
                ApplicationArea = All;
                DrillDown = false;
                Caption = 'Assigned User ID';
                Editable = false;

                trigger OnAssistEdit()
                var
                    User: Record User;
                    Users: Page Users;
                begin
                    if User.Get("Assigned User Value") then
                        Users.SetRecord(User);

                    Users.LookupMode := true;
                    if Users.RunModal() = ACTION::LookupOK then begin
                        Users.GetRecord(User);
                        "Assigned User Value" := User."User Security ID";
                        "Assigned User ID Value" := User."User Name";
                        CurrPage.Update(true);
                    end;
                end;
            }
            field(Description; DescriptionValue)
            {
                ApplicationArea = All;
                Caption = 'Description';
            }
            field("Estimated Ending Date"; "Estimated Ending Date Value")
            {
                ApplicationArea = All;
                Caption = 'Estimated Ending Date';
            }
        }
    }

    actions
    {
    }

    var
        "Assigned User Value": Guid;
        "Assigned User ID Value": Code[50];
        DescriptionValue: Text[50];
        "Estimated Ending Date Value": Date;

    procedure GetAssignedUserID(): Code[50]
    begin
        EXIT("Assigned User ID Value");
    end;

    procedure GetAssignedUser(): Guid
    begin
        EXIT("Assigned User Value");
    end;

    procedure GetDescription(): Text[50]
    begin
        EXIT(DescriptionValue);
    end;

    procedure GetEstimatedEndingDate(): Date
    begin
        EXIT("Estimated Ending Date Value");
    end;
}

