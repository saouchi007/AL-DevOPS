tableextension 81120 "MICA Sales Header Archive" extends "Sales Header Archive" //MyTargetTableId
{
    fields
    {
        field(80000; "MICA Order Type"; Option)
        {
            Caption = 'Order Type';
            DataClassification = CustomerContent;
            OptionMembers = "Standard Order","Express Order";
            OptionCaption = 'Standard Order,Express Order';
        }

        field(81120; "MICA Return Order With Collect"; Boolean)
        {
            Caption = 'Return Order With Collect';
            DataClassification = CustomerContent;
        }

        field(81820; "MICA Shipment Post Option"; Option)
        {
            Caption = 'Shipment Post Option';
            DataClassification = CustomerContent;
            OptionMembers = " ",Ship,"Ship and Invoice";
            OptionCaption = ' ,Ship,Ship and Invoice';
        }

        field(81830; "MICA Unique Webshop Doc. Id"; Guid)
        {
            Caption = 'Unique Webshop Document Id';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(82500; "MICA Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }

    }

}