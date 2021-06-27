pageextension 80740 "MICA PurchasesAndPayablesSetup" extends "Purchases & Payables Setup"
{
    layout
    {

        addlast(General)
        {
            field("MICA Detail Invoices Mass Pay."; Rec."MICA Detail Invoices Mass Pay.")
            {
                ApplicationArea = All;
            }
            field("MICA Add. Info. in Mass Pmt."; Rec."MICA Add. Info. in Mass Pmt.")
            {
                ApplicationArea = All;
            }
        }
        addlast("Number Series")
        {
            field("MICA Mass Payment No."; Rec."MICA Mass Payment No.")
            {
                ApplicationArea = All;
            }

        }
        addlast(Content)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA Po Notes Text 1"; Rec."MICA PO Notes Text 1")
                {
                    Caption = 'PO Notes Text 1';
                    ApplicationArea = all;
                }
                field("MICA Po Notes Text 2"; Rec."MICA PO Notes Text 2")
                {
                    Caption = 'PO Notes Text 2';
                    ApplicationArea = all;
                }
                field("MICA PO Footer Text - Left"; Rec."MICA PO Footer Text Left")
                {
                    ApplicationArea = all;
                }
                field("MICA PO Footer Text - Right"; Rec."MICA PO Footer Text Right")
                {
                    ApplicationArea = all;
                }
                field("MICA Intercompany Dimension"; Rec."MICA Intercompany Dimension")
                {
                    ApplicationArea = All;
                }
                field("MICA ASN Flow Code"; Rec."MICA ASN Flow Code")
                {
                    ApplicationArea = All;
                }
                field("MICA AL to PO Flow Code"; Rec."MICA AL to PO Flow Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Update SRD Flow Code"; Rec."MICA Update SRD Flow Code")
                {
                    ApplicationArea = All;
                }
                field("MICA Keep order when invoiced"; Rec."MICA Keep order when invoiced")
                {
                    ApplicationArea = All;
                }
            }

            group("MICA GIS Integration")
            {
                Caption = 'GIS Integration';
                field("MICA GIS Sup. Inv. Flow Code"; Rec."MICA GIS Sup. Inv. Flow Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}