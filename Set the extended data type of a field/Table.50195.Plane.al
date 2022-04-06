/// <summary>
/// Table ISA_Plane (ID 50195).
/// </summary>
table 50195 ISA_Plane
{
    DataClassification = CustomerContent;
    Caption = 'ISA Plane';

    fields
    {
        field(1; "No. "; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'No .';

        }

        field(2; PhoneNumber; Text[50])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = PhoneNo;
            Caption = 'Phone No';
        }
        field(3; WebSite; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Web Site';
            ExtendedDatatype = URL;
        }
        field(4; Email; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Email';
            ExtendedDatatype = EMail;
        }
        field(5; Password; Text[50])
        {
            DataClassification = CustomerContent;
            ExtendedDatatype = Masked;
            Caption = 'Password';
        }
        field(6; Ratio; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Ratio';
            ExtendedDatatype = Ratio;
        }
    }

    keys
    {
        key(PK; "No. ")
        {
            Clustered = true;
        }
    }


}