tableextension 50100 AlgerianCustomerCard extends Customer
{
    fields
    {
        field(50100; "Commerce Registration"; Text[15])
        {
            Caption = 'Commerce Registration';
            DataClassification = CustomerContent;
            NotBlank = true;
            
        }
        field(50101; "Fiscal Identification"; Text[15])
        {
            Caption = 'Fiscal Identification';
            DataClassification = CustomerContent;
        }
        field(50102; "Statistical Identification"; Text[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Statistical Identification';
        }
        field(50103; "Taxing Identification"; Text[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'Taxing Identification';
        }
    }
}
