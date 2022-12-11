/// <summary>
/// Table ISA_Excel (ID 50302).
/// </summary>
table 50302 ISAExcel
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Primary; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Primary';

        }
        field(2; Text_Data; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Text Data';
        }
        field(3; Date_Data; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Data';
        }
        field(4; Decimal_Data; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Decimal Data';
        }
    }

    keys
    {
        key(PK; Primary)
        {
            Clustered = true;
        }
    }
}