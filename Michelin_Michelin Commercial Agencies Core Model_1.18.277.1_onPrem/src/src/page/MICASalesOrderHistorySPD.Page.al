page 82400 "MICA Sales Order History SPD"
{
    Caption = 'Sales Order History SPD';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Integer;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(DocNo; DocNoValue)
                {
                    ApplicationArea = All;
                    Caption = 'DocNo';
                }
                field(LineNo; LineNoValue)
                {
                    ApplicationArea = All;
                    Caption = 'LineNo';
                }
                field(VersionNo; VersionNoValue)
                {
                    ApplicationArea = All;
                    Caption = 'VersionNo';
                }
                field(DocNoOccurence; DocNoOccurenceValue)
                {
                    ApplicationArea = All;
                    Caption = 'DocNoOccurence';
                }

                field(QtyNotInvoiced; QtyNotInvoicedValue)
                {
                    ApplicationArea = All;
                    Caption = 'QtyNotInvoiced';
                }
                field(Quantity; QuantityValue)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                }
            }
        }

    }


    actions
    {
        area(Processing)
        {
            action(SaveFile)
            {
                ApplicationArea = All;
                image = Save;
                Caption = 'Save File';

                trigger OnAction();
                var
                    TempBlob: Codeunit "Temp Blob";
                    FileMgt: Codeunit "File Management";
                    MyOutStream: OutStream;
                begin
                    TempBlob.CreateOutStream(MyOutStream);
                    MICASalesOrderHistorySPD.SaveAsCsv(MyOutStream);
                    FileMgt.BLOBExport(TempBlob, 'SalesOrderHistory', true);
                end;
            }
        }
    }

    var
        MICASalesOrderHistorySPD: Query "MICA Sales Order History SPD";
        DocNoValue: Text;
        DocNoOccurenceValue: Integer;
        LineNoValue: Integer;
        QtyNotInvoicedValue: Decimal;
        QuantityValue: Decimal;
        VersionNoValue: Integer;

    trigger OnOpenPage()
    begin
        //spd.SetRange(spd.Filter_Document_No_, '23699');
        //spd.SetRange(spd.Filter_Line_No_, 10100);
        MICASalesOrderHistorySPD.Open();
    end;

    trigger OnAfterGetRecord()
    begin
        Clear(DocNoValue);
        Clear(LineNoValue);
        Clear(VersionNoValue);
        Clear(QuantityValue);

        if MICASalesOrderHistorySPD.Read() then begin
            DocNoValue := MICASalesOrderHistorySPD.Document_No_;
            LineNoValue := MICASalesOrderHistorySPD.Line_No_;
            QtyNotInvoicedValue := MICASalesOrderHistorySPD.Qty__Shipped_Not_Invoiced;
            QuantityValue := MICASalesOrderHistorySPD.Quantity;
            VersionNoValue := MICASalesOrderHistorySPD.Arch_Version_No_;
            DocNoOccurenceValue := MICASalesOrderHistorySPD.Arch_Doc__No__Occurrence;
        end;
    end;

}