/// <summary>
/// Table CompanySales (ID 50129).
/// </summary>
table 50129 CompanySales
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(50129; CompanyName; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Company Name';
        }
        field(50130; TotalSales; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Total Sales';
        }
    }

    keys
    {
        key(Key1; CompanyName)
        {
            Clustered = true;
        }
    }
}