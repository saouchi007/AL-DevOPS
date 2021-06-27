pageextension 81300 "MICA Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        addlast(Control1)
        {
            field("MICA AL No."; Rec."MICA AL No.")
            {
                ApplicationArea = All;
            }
            field("MICA Rcv. Last Flow Entry No."; Rec."MICA Rcv. Last Flow Entry No.")
            {
                ApplicationArea = All;
            }
        }
        addlast(FactBoxes)
        {
            part(FlowResult; "MICA Flow Result")
            {
                ApplicationArea = All;
                SubPageLink = "MICA Send Last Flow Entry No." = FIELD("MICA Send Last Flow Entry No."), "MICA Rcv. Last Flow Entry No." = FIELD("MICA Rcv. Last Flow Entry No.");
            }
        }
    }

    actions
    {
        addfirst("F&unctions")
        {
            action("MICA Import Purchase Order")
            {
                Promoted = true;
                PromotedIsBig = true;
                Image = Import;
                Caption = 'Import Purchase Order';
                ApplicationArea = all;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ImporPurchaseOrderXml: XmlPort "MICA Import Purchase Order";
                    ImportDataDialog: Page "MICA Import Data Dialog";
                    DateFormat: Option "MM/DD/YYYYY","DD/MM/YYYY";
                    DecimalSeparator: Option Comma,Dot;
                begin
                    if ImportDataDialog.RunModal() <> Action::OK then
                        exit;
                    ImportDataDialog.GetInputData(DateFormat, DecimalSeparator);
                    ImporPurchaseOrderXml.SetInputData(DateFormat, DecimalSeparator);
                    ImporPurchaseOrderXml.Run();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        CurrPage.FlowResult.Page.Initialize(Rec."MICA Send Last Flow Entry No.", Rec."MICA Rcv. Last Flow Entry No.", Rec."MICA Record ID");
    end;
}