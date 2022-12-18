/// <summary>
/// Table ISA_Book (ID 50310).
/// </summary>
table 50310 ISA_Book
{
    DataClassification = ToBeClassified;
    Caption = 'ISA Book';

    fields
    {
        field(1; No; BigInteger)
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';

        }
        field(2; Title; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Title';
        }
        field(3; Author; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Author';
        }
        field(4; Hardcover; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Hardcover';
        }
        field(5; PageCount; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Page Count';
        }
    }

    keys
    {
        key(PK; No)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec.TestField(No);
    end;


}