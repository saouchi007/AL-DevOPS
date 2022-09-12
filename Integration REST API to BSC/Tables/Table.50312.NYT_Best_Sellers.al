/// <summary>
/// Table ISA_Best_Sellers (ID 50312).
/// </summary>
table 50312 ISA_Best_Sellers
{
    DataClassification = CustomerContent;
    Caption = 'Best Sellers Book';

    fields
    {
        field(10; "List Name"; Text[250])
        {
            Caption = 'List Name';
            DataClassification = CustomerContent;
        }
        field(20; "Line No."; BigInteger)
        {
            Caption = 'Line No.';
            DataClassification = CustomerContent;
        }
        field(30; "Book Title"; Text[250])
        {
            Caption = 'Book Title';
            DataClassification = CustomerContent;
        }
        field(40; "Book Description"; Text[2048])
        {
            Caption = 'Book Description';
            DataClassification = CustomerContent;
        }
        field(50; "Book Author"; Text[250])
        {
            Caption = 'Book Author';
            DataClassification = CustomerContent;
        }
        field(60; "Amazon URL"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Amazon URL';
            ExtendedDatatype = URL;
        }
    }

    keys
    {
        key(PK; "List Name", "Line No.")
        {
            Clustered = true;
        }
    }


    trigger OnInsert()
    begin
        "Line No." := GetNextLineNo();
    end;

    /// <summary>
    /// GetNextLineNo.
    /// </summary>
    /// <returns>Return value of type BigInteger.</returns>
    procedure GetNextLineNo(): BigInteger
    var
        NYTBestSellers: Record ISA_Best_Sellers;
    begin
        NYTBestSellers.SetRange("List Name", "List Name");
        if NYTBestSellers.FindLast() then
            exit(NYTBestSellers."Line No." + 1);
    end;

}