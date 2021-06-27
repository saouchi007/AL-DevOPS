report 81800 "MICA Exp.Monthly Interco Inv."
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    UseRequestPage = true;
    Caption = 'Export Monthly Interco Invoices';

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(General)
                {
                    field(InvoicingMonth; InvoicingMonthValue)
                    {
                        ApplicationArea = All;
                        Caption = 'Invoicing month (YYYYMM)';
                    }
                }
            }
        }

    }

    var
        InvoicingMonthValue: Text[6];

    trigger OnInitReport()
    begin
        InvoicingMonthValue := Format(WorkDate(), 0, '<Year4,4><Month,2>');
    end;

    trigger OnPreReport()
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        TempBlob: Codeunit "Temp Blob";
        MICAMonthlyIntercoInvoices: XmlPort "MICA MonthlyIntercoInvoices";
        FileNameLbl: Label 'Relfact_%1_%2.txt';
        OutStream: OutStream;
        InStream: InStream;
        FileName: Text;
    begin
        TempBlob.CreateOutStream(OutStream, TextEncoding::MSDos);
        MICAMonthlyIntercoInvoices.SetInvoicingMonth(InvoicingMonthValue);
        MICAMonthlyIntercoInvoices.SetDestination(OutStream);
        MICAMonthlyIntercoInvoices.Export();

        MICAFinancialReportingSetup.Get();
        TempBlob.CreateInStream(InStream, TextEncoding::MSDos);
        FileName := StrSubstNo(FileNameLbl, InvoicingMonthValue, MICAFinancialReportingSetup."Company Code");
        File.DownloadFromStream(InStream, 'Export', '', '', FileName);
    end;
}