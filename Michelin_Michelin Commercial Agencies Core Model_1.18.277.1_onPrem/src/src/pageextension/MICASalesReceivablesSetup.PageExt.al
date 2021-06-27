pageextension 80022 "MICA Sales & Receivables Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addlast(Content)
        {
            group("MICA Michelin")
            {
                Caption = 'Michelin';
                field("MICA Internal Code Nos."; Rec."MICA Internal Code Nos.")
                {
                    ApplicationArea = All;
                }

                field("MICA CES Evaluation Period"; Rec."MICA CES Evaluation Period")
                {
                    ApplicationArea = All;
                }

                field("MICA Interact. Template Req. Analy."; Rec."MICA Interact Templ Req Analy")
                {
                    ApplicationArea = All;
                }

                field("MICA Express Order Qty Max"; Rec."MICA Express Order Qty Max")
                {
                    ApplicationArea = All;
                }

                field("MICA SANA Next Trucks Period"; Rec."MICA SANA Next Trucks Period")
                {
                    ApplicationArea = All;
                }

                field("MICA In-transit default delay"; Rec."MICA In-transit default delay")
                {
                    ApplicationArea = All;
                }
                field("MICA Commitment Period"; Rec."MICA Commitment Period")
                {
                    ApplicationArea = All;
                }
                field("MICA Keep order when invoiced"; Rec."MICA Keep order when invoiced")
                {
                    ApplicationArea = All;
                }
                field("MICA Shipment Post Option"; Rec."MICA Shipment Post Option")
                {
                    ApplicationArea = All;
                }
                field("MICA Auto Whse.Ship on Partial Post"; Rec."MICA Auto Whse.Ship Part Post")
                {
                    ApplicationArea = All;
                }
                field("MICA Approval Workflow"; Rec."MICA Approval Workflow")
                {
                    ApplicationArea = All;
                }
                field("MICA Disable Appl. Sales Disc."; Rec."MICA Disable Appl. Sales Disc.")
                {
                    ApplicationArea = All;
                }
                field("MICA Force Appl. Sales Disc."; Rec."MICA Force Appl. Sales Disc.")
                {
                    ApplicationArea = All;
                }
                field("MICA Force Val. During WebShop"; Rec."MICA Force Val. During WebShop")
                {
                    ApplicationArea = All;
                }
                field("MICA BIBNET. Release Order"; Rec."MICA BIBNET. Release Order")
                {
                    ApplicationArea = All;
                }
                field("MICA Type of Cust. for Prices"; Rec."MICA Type of Cust. for Prices")
                {
                    ApplicationArea = All;
                }
                field("MICA NotUse In Mem. Split Line"; Rec."MICA NotUse In Mem. Split Line")
                {
                    ApplicationArea = All;
                }
                field("MICA Overdue Buffer"; Rec."MICA Overdue Buffer")
                {
                    ApplicationArea = All;
                }
                field("MICA Use Std Reservation Mode"; Rec."MICA Use Std Reservation Mode")
                {
                    ApplicationArea = All;
                }
                field("MICA Rebate Recalc. Window"; Rec."MICA Rebate Recalc. Window")
                {
                    ApplicationArea = All;
                }
                field("MICA SO Reb. Rec. Excl. Wind."; Rec."MICA SO Reb. Rec. Excl. Wind.")
                {
                    ApplicationArea = All;
                }
                field("MICA Price Recalc. Window"; Rec."MICA Price Recalc. Window")
                {
                    ApplicationArea = All;
                }
                field("MICA SO Price Rec. Excl. Wind."; Rec."MICA SO Price Rec. Excl. Wind.")
                {
                    ApplicationArea = All;
                }
                field("MICA Use ASN Line No."; Rec."MICA ASN Use Line No. Grouping")
                {
                    ApplicationArea = All;
                }
                field("MICA Default % of Prepayment"; Rec."MICA Default % of Prepayment")
                {
                    ApplicationArea = All;
                }
                field("MICA Optimize Archive Mgmt"; Rec."MICA Optimize Archive Mgmt")
                {
                    ApplicationArea = All;
                }
                field("MICA 3rd Party Cancel Reason"; Rec."MICA 3rd Party Cancel Reason")
                {
                    ApplicationArea = All;
                }
                field("MICA 3rd Party Avail. Warning %"; Rec."MICA 3rd Party Avail. Warn. %")
                {
                    ApplicationArea = All;
                }
                field("MICA Reb. Pool Jnl. Serie No."; Rec."MICA Reb. Pool Jnl. Serie No.")
                {
                    ApplicationArea = All;
                }
            }
            group("MICA Combine Shipment")
            {
                Caption = 'Combine Shipment';
                field("MICA Combine Shipment Option"; Rec."MICA Combine Shipment Option")
                {
                    ApplicationArea = All;
                }
                field("MICA Combine Ship. By VAT Rate"; Rec."MICA Combine Ship. By VAT Rate")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}