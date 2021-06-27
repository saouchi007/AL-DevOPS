tableextension 81468 "MICA Sales Shipment Header" extends "Sales Shipment Header"
{
    fields
    {
        field(80000; "MICA Order Type"; Option)
        {
            Caption = 'Order Type';
            DataClassification = CustomerContent;
            OptionMembers = "Standard Order","Express Order";
        }
        field(81060; "MICA Stat./Send. S. Doc./Whse."; Option)
        {
            Caption = 'Status of sending sales documents to warehouse by email';
            DataClassification = CustomerContent;
            OptionMembers = "","To send","Sent","In error",Canceled;
            OptionCaption = ',To send,Sent,In error,Canceled';
            Editable = false;
        }
        field(81061; "MICA Send. S. Doc./Whse. Text"; Text[250])
        {
            Caption = 'Last text status of sending sales documents to warehouse by email';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(80062; "MICA S.Doc. Type to Send/Whse."; Option)
        {
            Caption = 'Sales Document Type to Send to Warehouse';
            OptionMembers = "","Shipment only","Invoice only","Shipment and Invoice";
            OptionCaption = ',Shipment Only,Invoice Only,Shipment and Invoice';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81063; "MICA DT Email to Whse. Status"; DateTime)
        {
            caption = 'Date/time Email to Warehouse status';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81064; "MICA User Email to Whse. St."; Code[50])
        {
            caption = 'User Email to Warehouse Status';
            DataClassification = CustomerContent;
            TableRelation = User;
            ValidateTableRelation = false;
            Editable = false;
        }
        field(81306; "MICA AL No."; Code[35])
        {
            Caption = 'AL No.';
            DataClassification = CustomerContent;
        }
        field(81307; "MICA SRD"; Date)
        {
            Caption = 'SRD';
            DataClassification = CustomerContent;
        }

        field(81460; "MICA ASN No."; Code[35])
        {
            Caption = 'ASN No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81461; "MICA ETA"; Date)
        {
            Caption = 'ETA';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81462; "MICA Container ID"; Code[50])
        {
            Caption = 'Container ID';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81463; "MICA Seal No."; Code[20])
        {
            Caption = 'Seal No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81464; "MICA Port of Arrival"; Code[20])
        {
            Caption = 'Port of Arrival';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81465; "MICA Carrier Doc. No."; Code[20])
        {
            Caption = 'Carrier Doc. No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81466; "MICA ASN Date"; Date)
        {
            Caption = 'ASN Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81468; "MICA Initial ETA"; Date)
        {
            Caption = 'Inital ETA';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(81469; "MICA Initial SRD"; Date)
        {
            Caption = 'Inital SRD';
            DataClassification = CustomerContent;
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
    keys
    {
        key(KEY1; "MICA Stat./Send. S. Doc./Whse.")
        { }
    }
    procedure ShowSendEmailWhseErrorMessage()
    begin
        if "MICA Send. S. Doc./Whse. Text" <> '' then
            Message("MICA Send. S. Doc./Whse. Text");
    end;

}