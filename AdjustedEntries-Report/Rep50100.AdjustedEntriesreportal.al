report 50101 AdjustedEntries
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Adjusted Entries';
    RDLCLayout = 'AdjustedEntries.rdl';
    DefaultLayout = RDLC;
    ProcessingOnly = false;

    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = SORTING("Posting Date") ORDER(Ascending) WHERE(Adjustment = FILTER('Yes'));
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "Document No." = field("Document No.");
                RequestFilterFields = "Posting Date";
                column(G_L_Account_No_; "G/L Account No.")
                {

                }
                column(Description; Description)
                {

                }
                column(Debit_Amount; "Debit Amount")
                {

                }
                column(Credit_Amount; "Credit Amount")
                {

                }

            }
        }
    }
}

