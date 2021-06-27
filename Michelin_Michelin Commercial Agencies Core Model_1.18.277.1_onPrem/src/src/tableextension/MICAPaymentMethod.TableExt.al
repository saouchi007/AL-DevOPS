tableextension 81551 "MICA Payment Method" extends "Payment Method" //MyTargetTableId
{
    fields
    {
        field(81550; "MICA Payment Type"; Code[20])
        {
            Caption = 'Payment Type';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = const(PaymentMethodPaymentType), Blocked = const(false));
        }

        field(81551; "MICA Payment Code"; Code[20])
        {
            Caption = 'Payment Code';
            DataClassification = CustomerContent;
        }

        field(81552; "MICA Pmt. Method Filename"; Code[20])
        {
            Caption = 'Payment Method filename';
            DataClassification = CustomerContent;
        }
        field(81553; "MICA Payment Priority Code"; Code[4])
        {
            Caption = 'Payment Priority Code';
            DataClassification = CustomerContent;
        }

    }

}