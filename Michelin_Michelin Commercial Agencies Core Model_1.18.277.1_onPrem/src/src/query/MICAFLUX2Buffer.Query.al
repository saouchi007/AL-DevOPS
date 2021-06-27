query 80660 "MICA FLUX2 Buffer"
{
    Caption = 'Flux2 Buffer';
    QueryType = Normal;

    elements
    {
        dataitem(GLAccount; "G/L Account")
        {
            DataItemTableFilter = "MICA Excl. From Flux2 Report" = CONST(false);

            dataitem(GLEntry; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = GLAccount."No.";
                filter(PostingDate; "Posting Date") { }
                column(AccountNo; "MICA No. 2") { }
                column(SectionCode; "Global Dimension 1 Code") { }
                column(StructureCode; "Global Dimension 2 Code") { }
                column(CurrencyCode; "MICA Currency Code") { }
                column(GLEntryPostingDate; "Posting Date") { }
                column(GLAccountNo; "G/L Account No.") { }
                column(SumAmountLCY; Amount)
                {
                    Method = Sum;
                }
                column(SumAmountFCY; "MICA Amount (FCY)")
                {
                    Method = Sum;
                }
                dataitem(DimeSetEntry; "Dimension Set Entry")
                {
                    DataItemLink = "Dimension Set ID" = GLEntry."Dimension Set ID";
                    SqlJoinType = InnerJoin;
                    filter(IntercoCode; "Dimension Code") { }
                    column(IntercoValueCode; "Dimension Value Code") { }
                }
            }
        }

    }
    trigger OnBeforeOpen()
    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
    begin
        MICAFinancialReportingSetup.Get();
        MICAFinancialReportingSetup.TestField("Intercompany Dimension");
        SetRange(IntercoCode, MICAFinancialReportingSetup."Intercompany Dimension");
    end;
}