/// <summary>
/// Table ISA_DATGroupBuffer (ID 50304).
/// </summary>
table 50304 ISA_DATGroupBuffer
{
    DataClassification = CustomerContent;
    Caption = 'ISA DAT Group Buffer';

    fields
    {
        field(1; DocumentNo; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';

        }
        field(2; DocumentType; Enum "Sales Document Type")
        {
            DataClassification = CustomerContent;
            Caption = 'Document Type';
        }
        field(3; GroupNo; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Group No.';
        }
        field(4; CustomerName; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer Name';
        }
        field(5; Amount; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        }
    }

    keys
    {
        key(PK; DocumentNo, DocumentType)
        {
            Clustered = true;
        }
    }

}