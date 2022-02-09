/// <summary>
/// PageExtension SalesOrderList_Ext (ID 50139) extends Record .
/// 
/// There is a hack to add a "Confirm" function after "Repeat" but that would be prompting to save the file each time 
/// </summary>
pageextension 50139 SalesOrderList_Ext extends "Sales Order List"
{
    actions
    {
        addfirst(processing)
        {
            action(DownloadSO)
            {
                Caption = 'Download selected sales orders';
                ApplicationArea = All;
                ToolTip = 'It would download selected sales orders from the list';
                Image = SelectMore;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    OutStrm: OutStream;
                    RecRef: RecordRef;
                    FldRef: FieldRef;
                    TempBlob: Codeunit "Temp Blob";
                    //FileMgmt: Codeunit "File Management"; part of an update to exprot more than one report

                    InStrm: InStream;
                    DataCompression: Codeunit "Data Compression";
                    ZipFileName: Text[50];
                    PdfFileName: Text[50];
                begin
                    // part of an update to exprot more than one report
                    ZipFileName := 'Sales Order_' + Format(CurrentDateTime) + '.zip';
                    DataCompression.CreateZipArchive();
                    SalesHeader.Reset();
                    //TempBlob.CreateOutStream(OutStrm); part of an update to exprot more than one report
                    CurrPage.SetSelectionFilter(SalesHeader);

                    if SalesHeader.FindSet() then
                        repeat
                            // part of an update to exprot more than one report
                            TempBlob.CreateOutStream(OutStrm);
                            RecRef.GetTable(SalesHeader);
                            FldRef := RecRef.Field(SalesHeader.FieldNo("No."));
                            FldRef.SetRange(SalesHeader."No.");

                            if RecRef.FindFirst() then begin
                                Report.SaveAs(Report::"Standard Sales - Order Conf.", '', ReportFormat::Pdf, OutStrm, RecRef);
                                // part of an update to exprot more than one report
                                TempBlob.CreateInStream(InStrm);
                                PdfFileName := Format(SalesHeader."Document Type") + ' ' + SalesHeader."No." + '.pdf';
                                DataCompression.AddEntry(InStrm, PdfFileName);
                                // FileMgmt.BLOBExport(TempBlob, StrSubstNo('Sales Order %1.pdf', SalesHeader."No."), true);   part of an update to exprot more than one report
                                Commit();
                            end
                        until SalesHeader.Next() = 0;
                    TempBlob.CreateOutStream(OutStrm);
                    DataCompression.SaveZipArchive(OutStrm);
                    TempBlob.CreateInStream(InStrm);
                    DownloadFromStream(InStrm, '', '', '', ZipFileName);
                end;
            }
        }
    }

    var
        myInt: Integer;
}