tableextension 80420 "MICA SC - Param. Collection" extends "SC - Parameters Collection"
{
    fields
    {
        // Add changes to table fields here
        field(80000; "MICA OrderType"; Text[20])
        {
            Caption = 'OrderType';
            DataClassification = CustomerContent;
        }
        field(80010; "MICA IsCompleteOrder"; Integer)
        {
            Caption = 'IsCompleteOrder';
            DataClassification = CustomerContent;
        }
        field(80020; "MICA Comment"; Text[250])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
        }

        field(80030; "MICA Ship-to Address Code"; Code[20])
        {
            Caption = 'Ship-to Code';
            DataClassification = CustomerContent;
        }
        field(80040; "MICA CustomerAddressId"; Code[20])
        {
            Caption = 'CustomerAddressId';
            DataClassification = CustomerContent;
        }
        field(80050; "MICA Exceeded Quantity"; Decimal)
        {
            Caption = 'Exceeded Quantity';
            DataClassification = CustomerContent;
        }
        field(80060; "MICA RequestedDeliveryDate"; Text[20])
        {
            Caption = 'RequestedDeliveryDate';
            DataClassification = CustomerContent;
        }

    }
}