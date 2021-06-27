page 80765 "MICA Cust. Det. Accr. Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MICA Cust. Detail. Accr. Entry";
    Editable = false;
    Caption = 'Customer Detailed Rebate Ledger Entries';
    SourceTableView = where("Sales Amount" = filter(<> 0));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;

                }
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;

                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;

                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                }

                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;

                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                }

                field("Calculation Date"; Rec."Calculation Date")
                {
                    ApplicationArea = All;

                }
                field("Document Posting Date"; Rec."Document Posting Date")
                {
                    ApplicationArea = All;
                }

                field("Entry Type"; Rec."Entry Type")
                {
                    ApplicationArea = All;

                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;

                }
                field("Sales Amount"; Rec."Sales Amount")
                {
                    ApplicationArea = All;

                }
                field("Discount Amount"; Rec."Discount Amount")
                {
                    ApplicationArea = All;

                }
                field(Quantity; Rec."Quantity")
                {
                    ApplicationArea = All;

                }
                field("Accruals %"; Rec."Accruals %")
                {
                    ApplicationArea = All;

                }
                field("Accruals Amount"; Rec."Accruals Amount")
                {
                    ApplicationArea = All;

                }
                field("Paid AR Credit Memo"; Rec."Paid AR Credit Memo")
                {
                    ApplicationArea = All;
                }

                field("Paid AP Invoice"; Rec."Paid AP Invoice")
                {
                    ApplicationArea = All;
                }

                field("Is Deffered"; Rec."Is Deffered")
                {
                    ApplicationArea = All;

                }

                field("Customer Accruals Entry No."; Rec."Customer Accruals Entry No.")
                {
                    ApplicationArea = All;

                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;

                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;

                }
                field("Value Entry Document Type"; Rec."Value Entry Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;

                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;

                }
                field("Accr. Item Group"; Rec."Accr. Item Group")
                {
                    ApplicationArea = All;

                }
                field("Accr. Customer Group"; Rec."Accr. Customer Group")
                {
                    ApplicationArea = All;
                }
                field("Reforecast Percentage"; Rec."Reforecast Percentage")
                {
                    ApplicationArea = All;
                }

                field("Value Entry No."; Rec."Value Entry No.")
                {
                    ApplicationArea = All;

                }
                field("Include in Fin. Report"; Rec."Include in Fin. Report")
                {
                    ApplicationArea = All;

                }
                field("Country-of Sales"; Rec."Country-of Sales")
                {
                    ApplicationArea = All;
                }
                field("Market Code"; Rec."Market Code")
                {
                    ApplicationArea = All;
                }
                field("Forecast Code"; Rec."Forecast Code")
                {
                    ApplicationArea = All;
                }
                field("Intercompany Dimension"; Rec."Intercompany Dimension")
                {
                    ApplicationArea = All;
                }
                field("Accruals Dimension"; Rec."Accruals Dimension")
                {
                    ApplicationArea = All;
                }
                field("Site Dimension"; Rec."Site Dimension")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}