/// <summary>
/// Table ISA_NYT_Best_Sellers_Theme (ID 50311).
/// </summary>
table 50311 ISA_NYT_Best_Sellers_Theme
{
    DataClassification = CustomerContent;
    Caption = 'ISA NYT Best Sellers Theme';

    fields
    {
        field(1; ListName; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'List Name';

        }
        field(2; OldestPublishedDate; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Oldest Published Date';
        }
        field(30; "Newest Published Date"; Date)
        {
            Caption = 'Newest Published Date';
            DataClassification = CustomerContent;
        }
        field(40; Updated; Text[30])
        {
            Caption = 'Updated';
            DataClassification = CustomerContent;
        }
        field(50; "List Name Encoded"; Text[250])
        {
            Caption = 'List Name Encoded';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; ListName)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        NYTBestSellers: Record ISA_Best_Sellers;
    begin
        NYTBestSellers.SetRange("List Name", Rec.ListName);
        if not NYTBestSellers.IsEmpty then
            NYTBestSellers.DeleteAll();
    end;


}