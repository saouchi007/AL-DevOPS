/// <summary>
/// PageExtension ISA_UsersList_Ext (ID 50302).
/// </summary>
pageextension 50306 ISA_UsersList_Ext extends "Users"
{
    actions
    {
        addfirst(processing)
        {
            action(CutOff)
            {
                ApplicationArea = All;
                Image = Lock;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Caption = 'Lock Users';

                trigger OnAction()
                var
                    Status: Option Enabled,Disabled;
                begin
                    Rec.SetFilter("User Name", '<>%1', UserId);
                    if Rec.FindSet then begin
                        repeat
                            Rec.State := Status::Disabled;
                            Rec.Modify();
                        until Rec.Next() = 0;
                    end;
                    Rec.Reset();
                    //Rec.SetRange("User Name", 'DAPPALGNAV18\TIM|DAPPALGNAV18\ISA_admin');
                end;
            }
            action(ResumeUers)
            {
                ApplicationArea = All;
                Image = LinkWeb;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Caption = 'Resume Access';

                trigger OnAction()
                var
                    Status: Option Enabled,Disabled;
                begin
                    Rec.Reset();
                    if Rec.FindSet then begin
                        repeat
                            Rec.State := Status::Enabled;
                            Rec.Modify();
                        until Rec.Next() = 0;
                    end;
                end;
            }
            action(ActiveSessions)
            {
                ApplicationArea = All;
                Image = Account;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Caption = 'Active Sessions';
                trigger OnAction()
                var
                    ActiveSession: Page ISA_ActiveSessionList;
                begin
                    ActiveSession.RunModal();
                end;
            }
            action(UserGroupPlan)
            {
                ApplicationArea = All;
                Image = UserCertificate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Caption = 'User Group by Plan';

                trigger OnAction()
                var
                    UserGroupPlan: Page "User Group by Plan";
                begin
                    UserGroupPlan.Run();
                end;
            }
        }
    }
}