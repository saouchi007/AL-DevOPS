table 82860 "MICA S2S Product Catalog"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
            AutoIncrement = true;
        }
        field(2; customerId; Guid)
        {
            Caption = 'customerId';
            DataClassification = CustomerContent;
            TableRelation = Customer.SystemId;
        }
        field(3; customerNumber; Code[20])
        {
            Caption = 'customerNumber';
            DataClassification = CustomerContent;
            TableRelation = Customer."No.";
        }
        field(4; customerName; Text[100])
        {
            Caption = 'customerName';
            DataClassification = CustomerContent;
        }
        field(5; "MDM Bill-to Site Use ID"; Code[20])
        {
            Caption = 'MDM Bill-to Site Use ID';
            DataClassification = CustomerContent;
        }
        field(6; itemId; Guid)
        {
            Caption = 'itemId';
            DataClassification = CustomerContent;
            TableRelation = Item.SystemId;
        }
        field(7; itemNumber; Code[20])
        {
            Caption = 'itemNumber';
            DataClassification = CustomerContent;
            TableRelation = Item."No.";
        }
        field(8; itemName; Text[100])
        {
            Caption = 'itemNumber';
            DataClassification = CustomerContent;
        }
        field(9; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            DataClassification = CustomerContent;
        }
        field(10; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            DataClassification = CustomerContent;
        }
        field(11; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
            DataClassification = CustomerContent;
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
        }
        field(12; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }
        field(13; "Company Code"; Code[10])
        {
            Caption = 'Company Code';
            DataClassification = CustomerContent;
        }
        field(14; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
            DataClassification = CustomerContent;
        }
        field(15; itemLocation; Code[20])
        {
            Caption = 'itemLocation';
            DataClassification = CustomerContent;
        }
        field(16; Blocked; Boolean)
        {
            Caption = 'Blocked';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key1; customerNumber)
        {

        }
        key(Key2; itemNumber)
        {

        }
    }

    trigger OnInsert()
    var
        APIWebhookNotificationMgt: Codeunit "API Webhook Notification Mgt.";
        RecRef: RecordRef;
    begin
        "Last Modified Date Time" := CurrentDateTime;
#if OnPremise
        RecRef := Rec.RecordId.GetRecord();
        RecRef.GetTable(Rec);
        APIWebhookNotificationMgt.OnDatabaseInsert(RecRef);
#endif
    end;

    trigger OnModify()
    var
        APIWebhookNotificationMgt: Codeunit "API Webhook Notification Mgt.";
        RecRef: RecordRef;
    begin
        "Last Modified Date Time" := CurrentDateTime;
#if OnPremise        
        RecRef := Rec.RecordId.GetRecord();
        RecRef.GetTable(Rec);
        APIWebhookNotificationMgt.OnDatabaseModify(RecRef);
#endif        
    end;

    trigger OnDelete()
    var
        APIWebhookNotificationMgt: Codeunit "API Webhook Notification Mgt.";
        RecRef: RecordRef;
    begin
#if OnPremise        
        RecRef := Rec.RecordId.GetRecord();
        RecRef.GetTable(Rec);
        APIWebhookNotificationMgt.OnDatabaseDelete(RecRef);
#endif        
    end;

    trigger OnRename()
    var
        APIWebhookNotificationMgt: Codeunit "API Webhook Notification Mgt.";
        RecRef: RecordRef;
        xRecRef: RecordRef;
    begin
#if OnPremise        
        RecRef := Rec.RecordId.GetRecord();
        RecRef.GetTable(Rec);
        xRecRef := xRec.RecordId.GetRecord();
        xRecRef.GetTable(xRec);
        APIWebhookNotificationMgt.OnDatabaseRename(RecRef, xRecRef);
#endif        
    end;
}