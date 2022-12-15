/// <summary>
/// Table ISA_TransactionSimulator (ID 50303).
/// </summary>
table 50303 ISA_TransactionSimulator
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; EntryNo; BigInteger)
        {
            DataClassification = CustomerContent;
            AutoIncrement = true;
            Caption = 'Entry No.';

        }
        field(2; IsInsert; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Is insert';
        }
    }

    keys
    {
        key(PK; EntryNo)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin
        Rec.TestField(IsInsert);
    end;
}