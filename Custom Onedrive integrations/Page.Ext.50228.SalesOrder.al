/// <summary>
/// PageExtension ISA (ID 50228) extends Record Sales Order.
/// </summary>
pageextension 50228 ISA_SalesOrder_Ext extends "Sales Order"
{
    actions
    {
        addlast("O&rder")
        {
            action(OpenInOneDriver)
            {
                ApplicationArea = All;
                Caption = 'Open in drive';
                ToolTip = 'It copies the file to oneDrive folder';
                Image = Cloud;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedOnly = true;
                PromotedIsBig = true;
                Enabled = shareOptionEnabled; // enables the action of connection is established 

                trigger OnAction()
                var
                    tempBlob: Codeunit "Temp Blob";
                    documentServiceMgmnt: Codeunit "Document Service Management";
                    inStream: InStream;
                begin
                    getSalesOrder(tempBlob);
                    tempBlob.CreateInStream(inStream);
                    documentServiceMgmnt.OpenInOneDrive(StrSubstNo(salesOrderName, Rec."No."), '.pdf', inStream); // invoke document sharing flow
                end;
            }
            action(shareInOneDrive)
            {
                ApplicationArea = All;
                Caption = 'Share';
                ToolTip = 'It copies file to one drive and share it with other people';
                Image = Share;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Enabled = shareOptionEnabled;


                trigger OnAction()
                var
                    tempBlob: Codeunit "Temp Blob";
                    documentServiceMgmnt: Codeunit "Document Service Management";
                    inStream: InStream;
                begin
                    getSalesOrder(tempBlob);
                    tempBlob.CreateInStream(inStream);
                    documentServiceMgmnt.OpenInOneDrive(StrSubstNo(salesOrderName, Rec."No."), '.pdf', inStream);
                end;
            }
        }
    }

    var
        salesOrderName: Label 'Sales order %1';
        shareOptionEnabled: Boolean;

    trigger OnOpenPage()
    var
        documentSharing: Codeunit "Document Sharing";
    begin
        shareOptionEnabled := documentSharing.ShareEnabled();
    end;

    local procedure getSalesOrder(tempBlob: Codeunit "Temp Blob")
    var
        RepSelections: Record "Report Selections";
        recRef: RecordRef;
    begin
        recRef.GetTable(Rec);
        recRef.SetRecFilter();
        RepSelections.GetPdfReportForCust(tempBlob, RepSelections.Usage::"S.Order", recRef, Rec."Sell-to Customer No.");
    end;
}