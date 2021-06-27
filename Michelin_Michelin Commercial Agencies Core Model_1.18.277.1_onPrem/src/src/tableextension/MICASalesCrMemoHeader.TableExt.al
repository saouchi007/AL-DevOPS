tableextension 80781 "MICA Sales Cr.Memo Header" extends "Sales Cr.Memo Header" //MyTargetTableId
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
        field(81500; "MICA Credit Memo Reason Code"; Code[20])
        {
            Caption = 'Credit Memo Reason Code';
            DataClassification = CustomerContent;
            TableRelation = "MICA Table Value".Code where("Table Type" = filter(ReasonCreditNote));
        }
        field(81510; "MICA Credit Memo Reason Desc."; Text[200])
        {
            FieldClass = FlowField;
            Caption = 'Credit Memo Reason Description';
            CalcFormula = lookup("MICA Table Value".Description where(Code = field("MICA Credit Memo Reason Code")));
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