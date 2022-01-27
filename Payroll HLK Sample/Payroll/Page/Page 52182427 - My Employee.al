/// <summary>
/// Page My Employee (ID 52182427).
/// </summary>
page 52182427 "My Employee"
{
    // version NAVW19.00,RHPAIEK

    CaptionML = ENU = 'My Items',
                FRA = 'Mes articles';
    PageType = ListPart;
    SourceTable = 9152;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Item No."; "Item No.")
                {
                }
                field("First Name";
                Employee."First Name")
                {
                    CaptionML = ENU = 'Description',
                                FRA = 'Nom';
                    Editable = false;
                }
                field("Last Name";
                Employee."Last Name")
                {
                    Caption = 'Prénom';
                }
                field("Termination Date";
                Employee."Termination Date")
                {
                    Caption = 'Date fin de Contrat';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                CaptionML = ENU = 'Open',
                            FRA = 'Ouvrir';
                Image = ViewDetails;
                RunObject = Page 30;
                RunPageLink = "No." = FIELD("Item No.");
                RunPageMode = View;
                ShortCutKey = 'Return';
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        GetItem;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        CLEAR(Employee);
    end;

    trigger OnOpenPage();
    begin
        SETRANGE("User ID", USERID);
    end;

    var
        Employee: Record 5200;

    local procedure GetItem();
    begin
        CLEAR(Employee);

        //IF Item.GET("Item No.") THEN
        //  Item.CALCFIELDS(Inventory);
    end;
}

