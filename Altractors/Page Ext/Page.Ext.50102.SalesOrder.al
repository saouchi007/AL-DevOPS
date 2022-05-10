/// <summary>
/// PageExtension ISA_SalesOrderSubform (ID 50230) extends Record Sales Order Subform.
/// </summary>
pageextension 50102 ISA_SalesOrderSubform extends "Sales Order"
{
    layout
    {
        addafter("Currency Code")
        {
            field(ISA_StampDuty; Rec.ISA_StampDuty)
            {
                ApplicationArea = All;
                ToolTipML = ENU = 'Processes 1% of amount including VAT', FRA = 'Calcule 1% du TTC';
            }
        }
    }
    actions
    {
        addafter("P&osting")
        {
            action(PorcessStampDuty)
            {
                ApplicationArea = All;
                CaptionML = ENU = 'Process Stamp Duty', FRA = 'Calcule du droit de timbre';
                Image = PostTaxInvoice;
                ToolTipML = ENU = 'Allows updating the ''Stamp Duty''', FRA = 'Permet de mettre à jour le droit de timbre';
                trigger OnAction()
                var
                    PaymtCodeLbl: Label '''Payment Methods Code'' must be set to ''COD aka ''Cash On Delivery''''';
                begin
                    if Rec."Payment Method Code" <> 'COD' then
                        Error(PaymtCodeLbl);
                    ProcessStampDuty();
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        PayMethCode: Record "Payment Method";
    begin
        PayMethCode.SetFilter(PayMethCode.Code, 'COD');
        if not PayMethCode.FindFirst() then begin
            PayMethCode.Init();
            PayMethCode.Code := 'COD';
            PayMethCode.Description := 'Espèces';
            PayMethCode."Bal. Account Type" := PayMethCode."Bal. Account Type"::"G/L Account";
            PayMethCode.Insert();
            Message('Not Found');
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ProcessStampDuty();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ProcessStampDuty();
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ProcessStampDuty();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ProcessStampDuty();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ProcessStampDuty();
    end;
    /// <summary>
    /// ProcessStampDuty.
    /// </summary>
    procedure ProcessStampDuty()
    var
        CheckStampDuty: Decimal;
    begin
        clear(Rec.ISA_StampDuty);

        if Rec."Payment Method Code" = 'COD' then begin
            Rec.CalcFields("Amount Including VAT");

            if Rec."Amount Including VAT" > 20 then begin
                CheckStampDuty := Rec."Amount Including VAT" * 0.01;

                if CheckStampDuty < 5 then
                    Rec.ISA_StampDuty := 5;
                Rec.Modify();
                //Message('Amount Incl VAT : %1 \ CheckStampDuty : %2', Rec."Amount Including VAT", Rec.ISA_StampDuty);

                if CheckStampDuty > 2500 then
                    Rec.ISA_StampDuty := 2500;
                Rec.Modify();
                //Message('Amount Incl VAT : %1 \ CheckStampDuty : %2', Rec."Amount Including VAT", Rec.ISA_StampDuty);

                if (CheckStampDuty > 5) and (CheckStampDuty < 2500) then
                    Rec.ISA_StampDuty := Round(Rec."Amount Including VAT" * 0.01, 1, '=');
                Rec.Modify();
                //Message('Amount Incl VAT : %1 \ CheckStampDuty : %2', Rec."Amount Including VAT", Rec.ISA_StampDuty);

            end;



            Rec.Modify();
            //Message('%1', Rec.ISA_StampDuty);
            //isHandled := true;
            //Message('%1', Rec."Payment Terms Code");
            /*Error('Oh dear...Payment term code needs to be set to ''COD'' aka ''Cash On Delivery'' under ''Invoice Details''');
            exit;*/
        end;


    end;
}



