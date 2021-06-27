report 80761 "MICA Init Accruals"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Init Deferred Rebates';
    ProcessingOnly = true;
    Permissions = tabledata "Value Entry" = RIMD;

    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {
            RequestFilterFields = "Entry No.";
            DataItemTableView = sorting ("Entry No.") where ("Item Ledger Entry Type" = const (Sale));
            dataitem(Item; Item)
            {
                DataItemLink = "No." = field ("Item No.");
                trigger OnAfterGetRecord()
                begin
                    "Value Entry".Validate("MICA Accr. Item Grp.", Item."MICA Accr. Item Grp.");
                    "Value Entry".Modify(true);
                end;
                //dataitem
            }
            dataitem("Item Ledger Entry"; "Item Ledger Entry")
            {
                DataItemLink = "Entry No." = field ("Item Ledger Entry No.");
                dataitem(Customer; Customer)
                {
                    DataItemLink = "No." = field ("Source No.");
                    trigger OnAfterGetRecord()
                    begin
                        "Value Entry".Validate("MICA Accr. Customer Grp.", Customer."MICA Accr. Customer Grp.");
                        "Value Entry".Modify(true);
                    end;
                }
            }

        }

    }
    trigger OnPostReport()
    var
        ValueUpdatedTxt: Label 'Value Entry data has been updated';
    begin
        Message(ValueUpdatedTxt);
    end;
}