table 81020 "MICA STE4 Key Allocation"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            DataClassification = CustomerContent;
            OptionMembers = "Global","Customer";
            OptionCaption = 'Global,Customer';
        }
        field(2; "Customer No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(3; "Date Of Calculation"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Date Of Calculation';
        }

        field(4; "LB Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'LB Code';
        }
        field(5; "% Allocation"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = '% Allocation';
        }

        field(6; "UserId"; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'UserId';
        }
        field(7; "LB Amount"; Decimal)
        {
            Caption = 'LB Amount';
            DataClassification = CustomerContent;
        }
        field(8; "Total Amount"; Decimal)
        {
            Caption = 'Total Amount';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Type", "Customer No.", "LB Code", UserId)
        {
            Clustered = true;
        }
        Key(Key2; UserId)
        {

        }
        key(Key3; "Type", "LB Code", UserId)
        {
            SumIndexFields = "LB Amount";
        }
        key(Key4; Type, "Customer No.", UserId)
        {
            SumIndexFields = "LB Amount";
        }
    }
}