pageextension 81621 "MICA Transfer Orders" extends "Transfer Orders"
{
    layout
    {

    }

    actions
    {
        modify("Create Whse. S&hipment")
        {
            Visible = false;
        }
        addbefore("Create &Whse. Receipt")
        {
            action("MICA Create Whse. Shipment")
            {
                Caption = 'Create Whse. S&hipment';
                ToolTip = 'Create a warehouse shipment to start a pick a ship process according to an advanced warehouse configuration.';
                AccessByPermission = TableData "Warehouse Shipment Header" = R;
                ApplicationArea = All;
                Image = NewShipment;
                trigger OnAction()
                var
                    GetSourceDocOutbound: Codeunit "MICA Get Source Doc. Outbound";
                begin
                    GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
                end;
            }
        }
        addlast("F&unctions")
        {
            action("MICA Import Transfer Order")
            {
                Promoted = true;
                PromotedIsBig = true;
                Image = Import;
                Caption = 'Import Transfer Order';
                ApplicationArea = all;
                PromotedCategory = Process;
                trigger OnAction()
                var
                    ImportTransferOrderXml: XmlPort "MICA Import Transfer Order";
                    ImportDataDialog: Page "MICA Import Data Dialog";
                    DateFormat: Option "MM/DD/YYYYY","DD/MM/YYYY";
                    DecimalSeparator: Option Comma,Dot;
                begin
                    if ImportDataDialog.RunModal() <> Action::OK then
                        exit;
                    ImportDataDialog.GetInputData(DateFormat, DecimalSeparator);
                    ImportTransferOrderXml.SetInputData(DateFormat, DecimalSeparator);
                    ImportTransferOrderXml.Run();
                end;
            }

        }
    }
}