page 80760 "MICA Accrual Setup"
{
    PageType = Card;
    UsageCategory = None;
    SourceTable = "MICA Accrual Setup";
    Caption = 'Rebate Setup';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                }

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
                {
                    ApplicationArea = All;
                }

                field("Sales Type"; Rec."Sales Type")
                {
                    ApplicationArea = All;
                }
                field("Sales Code"; Rec."Sales Code")
                {
                    ApplicationArea = All;
                    Editable = not (Rec."Sales Type" = Rec."Sales Type"::"All Customers");
                }
                field("Accr. Item  Grp."; Rec."Accr. Item  Grp.")
                {
                    ApplicationArea = All;
                }
                field("Reforecast Percentage"; Rec."Reforecast Percentage")
                {
                    ApplicationArea = All;
                }

                field("Begin Date"; Rec."Begin Date")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;
                }
                field("Accrual Global Amount"; Rec."Accrual Global Amount")
                {
                    ApplicationArea = All;
                    Editable = NOT Rec."Is Deferred";
                    Visible = false;
                }

                field("Accruals Posting Code"; Rec."Accruals Posting Code")
                {
                    ApplicationArea = All;
                }
                field("Rebate Pool Posting Setup"; "Rebate Pool Posting Setup")
                {
                    ApplicationArea = All;
                }

                field("Is Deferred"; Rec."Is Deferred")
                {
                    ApplicationArea = All;
                }
                field("Include in Fin. Report"; Rec."Include in Fin. Report")
                {
                    ApplicationArea = All;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = All;

                }
            }
            part("MICA Accrual Setup Subform"; "MICA Accrual Setup Subform")
            {
                ApplicationArea = all;
                SubPageLink = "Accrual Code" = field(Code);
            }

        }
    }
    actions
    {
        area(processing)
        {
            action("Create Rebate Pool")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = CreateInventoryPickup;
                Caption = 'Create Rebate Pool & Credit Memo';
                ToolTip = 'Create Rebate Pool & Credit Memo';
                trigger OnAction()
                var
                    MICARebatePoolMgt: Codeunit "MICA Rebate Pool Mgt.";
                begin
                    MICARebatePoolMgt.SetRebateSetup(Rec);
                    MICARebatePoolMgt.CreateRebatePoolFromRebateSetupCard(true);

                    Commit();

                    MICARebatePoolMgt.CreateDefferedCreditMemo(Rec);
                end;
            }
            action(Close)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Close;
                Caption = 'Close Rebate Card';
                ToolTip = 'Close Rebate Card';
                trigger OnAction()
                var
                    RebateClosingQst: Label 'The rebate will be closed, and all related detail entries will be deleted. Do you want to continue?';
                begin
                    if not Confirm(RebateClosingQst) then
                        Exit;
                    DeleteRelatedDetailRebateLedgerEntries();
                end;
            }
        }
    }
    local procedure DeleteRelatedDetailRebateLedgerEntries()
    var
        MICARebateMenagement: Codeunit "MICA Rebate Menagement";
    begin
        MICARebateMenagement.DeleteRelatedDetailRebateLedgerEntries(Rec);
    end;
}