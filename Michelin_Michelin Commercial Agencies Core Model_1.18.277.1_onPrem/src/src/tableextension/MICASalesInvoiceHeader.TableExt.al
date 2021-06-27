tableextension 80780 "MICA Sales Invoice Header" extends "Sales Invoice Header" //MyTargetTableId
{
    fields
    {
        field(80000; "MICA Email Status"; Option)
        {
            Caption = 'Email Status';
            DataClassification = CustomerContent;
            OptionMembers = " ",Failure,Successful;
            OptionCaption = ' ,Failure,Successful';
        }
        field(81640; "MICA Sales Agreement No."; code[20])
        {
            Caption = 'Sales Agreement No.';
            DataClassification = CustomerContent;
            TableRelation = "MICA Sales Agreement";
            Editable = false;
        }
        field(81624; "MICA Truck Driver Info"; Text[50])
        {
            Caption = 'Truck Driver Info';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81625; "MICA Truck License Plate"; Text[50])
        {
            Caption = 'Truck License Plate';
            DataClassification = CustomerContent;
            Editable = false;
        }

    }

}