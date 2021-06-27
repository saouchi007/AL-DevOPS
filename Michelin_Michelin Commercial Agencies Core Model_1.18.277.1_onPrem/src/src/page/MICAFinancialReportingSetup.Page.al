page 80640 "MICA Financial Reporting Setup"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "MICA Financial Reporting Setup";
    Caption = 'Financial Report Setup';
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Company Code"; Rec."Company Code")
                {
                    ApplicationArea = All;
                }
                field("Intercompany Dimension"; Rec."Intercompany Dimension")
                {
                    ApplicationArea = All;
                }
                field("Section Dimension"; Rec."Section Dimension")
                {
                    ApplicationArea = All;
                }
                field("P-FAMILY Dimension"; Rec."P-FAMILY Dimension")
                {
                    ApplicationArea = All;
                }
                field("Structure Dimension"; Rec."Structure Dimension")
                {
                    ApplicationArea = All;
                }
                field("Accr. Last Date Calculation"; Rec."Accr. Last Date Calculation")
                {
                    ApplicationArea = All;
                }
                field("F028 Last Export No."; Rec."F028 Last Export No.")
                {
                    ApplicationArea = All;
                }
                field("Pelican Code-Sending Company"; Rec."Pelican Code-Sending Company")
                {
                    ApplicationArea = All;
                }
                field("RelFact Extract Ext. Doc."; Rec."RelFact Extract Ext. Doc.")
                {
                    ApplicationArea = All;
                }

                field("Accrual Dimension Code"; Rec."Accrual Dimension Code")
                {
                    ApplicationArea = All;
                }
                field("Site Dimension Code"; Rec."Site Dimension Code")
                {
                    ApplicationArea = All;
                }
                field("F336 Last Export No."; Rec."F336 Last Export No.")
                {
                    ApplicationArea = All;
                }
                field("Commercial Organization Code"; Rec."Commercial Organization Code")
                {
                    ApplicationArea = All;
                }
                field("F336 G/L Acc. No.2 Filter"; Rec."F336 G/L Acc. No.2 Filter")
                {
                    ApplicationArea = All;
                }
                field("F336 Dimension Section Filter"; Rec."F336 Dimension Section Filter")
                {
                    ApplicationArea = All;
                }
                field("Deferred Group Account"; Rec."Deferred Group Account")
                {
                    ApplicationArea = All;
                }
                field("Multi-Posting"; Rec."Multi-Posting")
                {
                    ApplicationArea = All;
                }
                field("Disable Forced Dim. Uncheck"; Rec."Disable Forced Dim. Uncheck")
                {
                    ApplicationArea = All;
                }
                field("Value Entries Parameter"; Rec."Value Entries Parameter")
                {
                    ApplicationArea = All;
                }
            }

            group(MassPayment)
            {
                Caption = 'Mass Payment';
                field("Mass Payment Amount"; Rec."Mass Payment Amount")
                {
                    ApplicationArea = All;
                }
                field("Dynamic Pay. Mtd. Code Value 1"; Rec."Dynamic Pay. Mtd. Code Value 1")
                {
                    ApplicationArea = All;
                }
                field("Dynamic Pay. Mtd. Code Value 2"; Rec."Dynamic Pay. Mtd. Code Value 2")
                {
                    ApplicationArea = All;
                }
                field("Mass Payment Flow code"; Rec."Mass Payment Flow code")
                {
                    ApplicationArea = all;
                }
                field("Mass Payment Codeunit ID"; Rec."Mass Payment Codeunit ID")
                {
                    ApplicationArea = all;
                }
                field("Mass Payment Codeunit Name"; Rec."Mass Payment Codeunit Name")
                {
                    ApplicationArea = all;
                }

            }
            group("STE4 Setup")
            {
                field("LB Dimension"; Rec."LB Dimension")
                {
                    ApplicationArea = All;
                }
                field("STE4 Posting Group Filter"; Rec."STE4 Posting Group Filter")
                {
                    ApplicationArea = All;
                }
                field("STE4 AR Pst. Group Filter"; Rec."STE4 AR Pst. Group Filter")
                {
                    ApplicationArea = All;
                }
                field("STE4 PROV Filter"; Rec."STE4 PROV Filter")
                {
                    ApplicationArea = All;
                }
                field("STE4 Add LOSSES Filter"; Rec."STE4 Add LOSSES Filter")
                {
                    ApplicationArea = All;
                }
                field("STE4 Sub LOSSES Filter"; Rec."STE4 Sub LOSSES Filter")
                {
                    ApplicationArea = All;
                }
                field("STE4 LOANS Filter"; Rec."STE4 LOANS Filter")
                {
                    ApplicationArea = All;
                }
                field("STE4 Region Code"; Rec."STE4 Region Code")
                {
                    ApplicationArea = All;
                }
            }
            group("FLUX2 Setup")
            {
                field("Non Group Interco Code"; Rec."Non Group Interco Code")
                {
                    ApplicationArea = All;
                }
            }
            Group("Number Series")
            {
                field("Sales Agreement Nos."; Rec."Sales Agreement Nos.")
                {
                    ApplicationArea = All;
                }
            }
            group("GIS Integration")
            {
                field("GIS AP Integrat. Charge (Item)"; Rec."GIS AP Integrat. Charge (Item)")
                {
                    ApplicationArea = All;
                }
                field("GIS AP Integrat. Freight Item"; Rec."GIS AP Integrat. Freight Item")
                {
                    ApplicationArea = All;
                }
            }
            group(Accrual)
            {
                Caption = 'Deferred Rebates';
                field("Deferred Journal Name"; Rec."Deferred Journal Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Deferred Journal Name';
                }
                field("Deferred Journal Batch Name"; Rec."Deferred Journal Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Deferred Journal Batch Name';
                }
                field("Deferred Nos."; Rec."Deferred Nos.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Deferred Nos.';
                }
                field("Financial Journal Name"; Rec."Financial Journal Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Financial Journal Name';
                }
                field("Financial Journal Batch Name"; Rec."Financial Journal Batch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Financial Journal Batch Name';
                }
                field("Calc. Rebate Rates Codeunit ID"; Rec."Calc. Rebate Rates Codeunit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Calculate Rebate Rates Codeunit ID';
                }

            }
            group("Rebate Pool")
            {
                Caption = 'Rebate Pool';
                field("Rebate Pool Application %"; "Rebate Pool Application %")
                {
                    ApplicationArea = All;
                }
            }
        }

    }

    trigger OnOpenPage()
    begin
        if NOT Rec.FINDFIRST() then
            Rec.Insert();
    end;
}