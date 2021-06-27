query 81020 "MICA STE4 Key Allocation"
{
    Caption = 'STE Key Allocation Summary';
    QueryType = Normal;

    elements
    {
        dataitem(ILEntry; "Item Ledger Entry")
        {
            DataItemTableFilter = "Source Type" = filter(Customer), "Entry Type" = filter(Sale);
            column(SourceNo; "Source No.") { }
            filter(PostingDate; "Posting Date") { }
            column(GlobalDimension2Code; "Global Dimension 2 Code") { }
            column(SalesAmActualSum; "Sales Amount (Actual)")
            {
                Method = Sum;
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = ILEntry."Source No.";
                DataItemTableFilter = "MICA Party Ownership" = filter("Non Group" | "Group Network");
                SqlJoinType = InnerJoin;
                filter(CustNo; "No.") { }
            }
        }
    }
}