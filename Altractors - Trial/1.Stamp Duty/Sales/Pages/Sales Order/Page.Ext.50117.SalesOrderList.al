/// <summary>
/// PageExtension ISA_SalesOrderList_Ext (ID 50118) extends Record Sales Order List.
/// </summary>
pageextension 50118 ISA_SalesOrderList_Ext extends "Sales Order List"
{
    layout
    {
        addafter("Amount Including VAT")
        {
            field(ISA_AmountIncludingStampDuty; Rec.ISA_AmountIncludingStampDuty)
            {
                ApplicationArea = All;
                Visible = true;
                ToolTipML = ENU = 'Specifies the amount that includes VAT and Stamp duty', FRA = 'Spécifie le montant incluant la TVA et ledroit de timbre';
                CaptionML = ENU = 'Amount Including S.Duty', FRA = 'Montant includant D.Timbre';
            }
        }
    }

    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                SalRec: Record "Sales & Receivables Setup";
            begin
                SalRec.Get();
                if Rec."Payment Method Code" = SalRec.ISA_StampDutyPymtMethodsCode then begin
                    if Rec.ISA_StampDuty = 0 then
                        Error('Veuillez cliquer sur ''Commande > Statistiques'' afin de calculer le D.Timbre avant de valider');
                end;

            end;
        }
        modify("Post &Batch")
        {
            trigger OnBeforeAction()
            var
                SalRec: Record "Sales & Receivables Setup";
            begin
                SalRec.Get();
                if Rec."Payment Method Code" = SalRec.ISA_StampDutyPymtMethodsCode then begin
                    if Rec.ISA_StampDuty = 0 then
                        Error('Veuillez cliquer sur ''Commande > Statistiques'' afin de calculer le D.Timbre avant de valider');
                end;

            end;
        }
        modify(PostAndSend)
        {
            trigger OnBeforeAction()
            var
                SalRec: Record "Sales & Receivables Setup";
            begin
                SalRec.Get();
                if Rec."Payment Method Code" = SalRec.ISA_StampDutyPymtMethodsCode then begin
                    if Rec.ISA_StampDuty = 0 then
                        Error('Veuillez cliquer sur ''Commande > Statistiques'' afin de calculer le D.Timbre avant de valider');
                end;

            end;
        }
        modify("Preview Posting")
        {
            trigger OnBeforeAction()
            var
                SalRec: Record "Sales & Receivables Setup";
            begin
                SalRec.Get();
                if Rec."Payment Method Code" = SalRec.ISA_StampDutyPymtMethodsCode then begin
                    if Rec.ISA_StampDuty = 0 then
                        Error('Veuillez cliquer sur ''Commande > Statistiques'' afin de calculer le D.Timbre avant de valider');
                end;

            end;
        }
    }
    /*trigger OnAfterGetRecord() // used to refresh ISA_AmountIncludingStampDuty on the Sales order list
    begin
        Rec.CalcFields("Amount Including VAT");
        Rec."Amount Including VAT" += Rec.ISA_StampDuty;
        Rec.Modify();
    end;*/

}