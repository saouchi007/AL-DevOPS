page 80766 "MICA Cust. Accr. Led. Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "MICA Customer Accrual Entry";
    Editable = false;
    Caption = 'Customer Rebate Ledger Entries';

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
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Description 2"; Rec."Description 2")
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
                field("Calculation Type"; Rec."Calculation Type")
                {
                    ApplicationArea = All;

                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;

                }
                field(Quantity; Rec.Quantity)
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
                field("Paid Invoices"; Rec."Paid Invoices")
                {
                    ApplicationArea = All;
                }
                field("Paid AP Invoice"; Rec."Paid AP Invoice")
                {
                    ApplicationArea = All;
                }

                field(Open; Rec.Open)
                {
                    ApplicationArea = All;

                }
                field("Is Deffered"; Rec."Is Deffered")
                {
                    ApplicationArea = All;

                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = All;

                }
                field("Paid Amount"; Rec."Paid Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;

                }
                field("Include in Fin. Report"; Rec."Include in Fin. Report")
                {
                    ApplicationArea = All;

                }
                field("Closed By Document No."; Rec."Closed By Document No.")
                {
                    ApplicationArea = All;
                }
                field("Closed At Date"; Rec."Closed At Date")
                {
                    ApplicationArea = All;

                }
                field("Rebate Code Ending Date"; Rec."Rebate Code Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Rebate Pool Amount"; Rec."Rebate Pool Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Accr. Ledg. Entries")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Calculate;
                Caption = 'Calculate Rebate Ledg. Entries';
                Visible = RebateCalcVisible;

                trigger OnAction()
                var
                    ProcessingCU: codeunit "MICA Calc Accrual Ledger Entry";
                    InputPage: Page "MICA Date Input Page";
                    CalculationDate: date;
                    c001Lbl: Label 'Process completed.';
                begin

                    IF InputPage.RUNMODAL() = ACTION::OK THEN
                        InputPage.GetCalcDate(CalculationDate);
                    if CalculationDate <> 0D then begin
                        ProcessingCU.SetCalcDate(CalculationDate);
                        ProcessingCU.Run();
                        Message(c001Lbl);
                    end;
                end;
            }
            action("RAZ - TEST") //To remove for prod
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Calculate;
                Caption = 'Initialize Process - Do not touch';
                Visible = RebateDeletionVisible;

                trigger OnAction()
                var
                    MICACustDtlAccrEntry: Record "MICA Cust. Detail. Accr. Entry";
                begin

                    rec.Reset();
                    rec.DeleteAll(true);
                    MICACustDtlAccrEntry.DeleteAll(true);
                end;
            }
            action(CreateAccrual)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Create;
                Caption = 'Create isDeferred Rebates';
                ToolTip = 'Create isDeferred Rebates';
                trigger OnAction()
                var
                    CreateAccrual: Report "MICA Create Accrual";
                begin
                    CreateAccrual.SetIsDeferred(true);
                    CreateAccrual.Run();
                end;
            }
            action("Create Financial Rebate")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedOnly = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Create;
                Caption = 'Create Financial Rebate';
                ToolTip = 'Create Financial Rebate';
                trigger OnAction()
                var
                    CreateAccrual: Report "MICA Create Accrual";
                begin
                    CreateAccrual.SetIsDeferred(false);
                    CreateAccrual.Run();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange(Open, true);
    end;

    trigger OnInit()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            RebateDeletionVisible := UserSetup."MICA Allow Deletion Rebates";
            RebateCalcVisible := UserSetup."MICA Allow Calc. Rebates";
        end;
    end;



    var
        RebateDeletionVisible, RebateCalcVisible : Boolean;
}