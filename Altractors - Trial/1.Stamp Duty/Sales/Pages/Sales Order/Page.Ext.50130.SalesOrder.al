/// <summary>
/// PageExtension ISA_SalesOrder_Ext (ID 50130) extends Record MyTargetPage.
/// </summary>
pageextension 50130 ISA_SalesOrder_Ext extends "Sales Order"
{
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
        modify(PostAndNew)
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
        modify(PreviewPosting)
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
        modify(PagePostedSalesPrepaymentInvoices)
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

}