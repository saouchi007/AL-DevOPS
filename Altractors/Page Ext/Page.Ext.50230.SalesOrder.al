/// <summary>
/// PageExtension ISA_SalesOrderSubform (ID 50230) extends Record Sales Order Subform.
/// </summary>
pageextension 50230 ISA_SalesOrderSubform extends "Sales Order"
{
    layout
    {
        addafter("Currency Code")
        {
            field(ISA_StampDuty; Rec.ISA_StampDuty)
            {
                ApplicationArea = All;
                ToolTip = 'Processes 1% of amount including VAT';
            }
        }


    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        ProcessStampDuty()
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
    begin
        clear(Rec.ISA_StampDuty);

        if Rec."Payment Terms Code" = 'COD' then begin
            Rec.CalcFields("Amount Including VAT");
            Rec.ISA_StampDuty := Rec."Amount Including VAT" * 0.01; //TotalSalesLine."Amount Including VAT" * 0.01;
            Rec.Modify();
            Message('%1', Rec.ISA_StampDuty);
            //isHandled := true;
            //Message('%1', Rec."Payment Terms Code");
            /*Error('Oh dear...Payment term code needs to be set to ''COD'' aka ''Cash On Delivery'' under ''Invoice Details''');
            exit;*/
        end;


    end;
}


