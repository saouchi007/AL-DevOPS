/// <summary>
/// PageExtension SalesOrders_Ext (ID 50133) extends Record Sales Order List.
/// </summary>
pageextension 50133 SalesOrders_Ext extends "Sales Order List"
{
    actions
    {
        addafter("Print Confirmation")
        {
            action(SaveConfirmationAsPDF)
            {
                Caption = 'Save Confirmation as PDF';
                Image = Export;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    FileMgmt: Codeunit "File Management";
                    Ostream: OutStream;
                    SHeader: Record "Sales Header";
                    RecRef: RecordRef;
                begin
                    SHeader.Reset();
                    Clear(Ostream);
                    CurrPage.SetSelectionFilter(SHeader);
                    RecRef.GetTable(SHeader);
                    TempBlob.CreateOutStream(Ostream);
                    Report.SaveAs(Report::"Standard Sales - Order Conf.", '', ReportFormat::Pdf, Ostream, RecRef);
                    FileMgmt.BLOBExport(TempBlob, UserId + ' Sales Order_' + Format(CurrentDateTime, 0,
                    '<Day,2> - <Month,2> - <Year4>') + '.pdf', true)
                    //'<Minutes,2> - <Hours24> - <Day,2> - <Month,2> - <Year4>') + '.pdf', true)
                end;
            }
        }
    }

    var
        myInt: Integer;
}