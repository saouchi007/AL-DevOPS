/// <summary>
/// PageExtension ISA_CustomerList_Ext (ID 50310) extends Record Customer List.
/// </summary>
pageextension 50310 ISA_CustomerList_Ext extends "Customer List"
{

    actions
    {
        addfirst(processing)
        {
            action(Sport)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Caption = 'Sport';
                Image = ProjectToolsProjectMaintenance;

                trigger OnAction()
                begin
                    Manager.GetHandler(SportsEval);
                    Message(SportsEval.GetEvaluation());
                end;
            }
        }

    }
    var
        SportsEval: Interface ISA_Sports;
        Manager: Codeunit ISA_SportsEvaluationMgmt;
}