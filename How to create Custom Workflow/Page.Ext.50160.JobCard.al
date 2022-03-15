/// <summary>
/// PageExtension JobCard_Ext (ID 50160) extends Record MyTargetPage.
/// </summary>
pageextension 50160 JobCard_Ext extends "Job Card"
{
    layout
    {
        addafter("Project Manager")
        {
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = All;
            }
        }
    }


    actions
    {
        addafter("Job - Planning Lines")
        {
            action(SendApproval)
            {
                Caption = 'Send for Approval';
                ApplicationArea = All;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    IntegrationCU.OnSendJobsforApproval(Rec);
                end;
            }
        }
    }

    var
        IntegrationCU: Codeunit IntegrationCU;
}