pageextension 80063 "MICA Sales quote Subform" extends "Sales Quote Subform"
{
    layout
    {
        addafter("No.")
        {
            field("MICA Catalog Item No."; Rec."MICA Catalog Item No.")
            {
                ApplicationArea = All;
                trigger OnDrillDown()
                var
                    MICACustomerAssortment: codeunit "MICA CustomerAssortment";
                begin
                    MICACustomerAssortment.OnAssistEditMICACatalogItemNo(Rec);
                end;
            }

        }
        addlast(Control1)
        {
            field("MICA Comment"; Rec."MICA Countermark")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }
}