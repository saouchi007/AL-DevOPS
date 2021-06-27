page 82873 "MICA S2S S.Order Line Event"
{

    PageType = API;
#if not OnPremise
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif 
    DelayedInsert = true;
    APIVersion = 'v1.0';
    Caption = 's2sSalesOrderLineEvent', Locked = true;
    EntityName = 's2sSalesOrderLineEvent';
    EntitySetName = 's2sSalesOrderLineEvents';
    ODataKeyFields = SystemId;
    SourceTable = "MICA S2S S.Line Ext. Event";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'systemId', Locked = true;
                    ApplicationArea = All;
                }
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'entryNo', Locked = true;
                    ApplicationArea = All;
                }
                field(eventDateTime; Rec."Event Date Time")
                {
                    Caption = 'eventDateTime', Locked = true;
                    ApplicationArea = All;
                }
                field(sourceEventType; Rec."Source Event Type")
                {
                    Caption = 'sourceEventType', Locked = true;
                    ApplicationArea = All;
                }
                field(sourceRecordID; Rec."Source Record ID")
                {
                    Caption = 'sourceRecordID', Locked = true;
                    ApplicationArea = All;
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'documentNo', Locked = true;
                    ApplicationArea = All;
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'lineNo', Locked = true;
                    ApplicationArea = All;
                }
                field(lastModifiedDateTime; Rec."Last Modified Date Time")
                {
                    Caption = 'lastModifiedDateTime', Locked = true;
                    ApplicationArea = All;
                }
            }
        }
    }

}
