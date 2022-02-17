/// <summary>
/// Page Consumers (ID 50144).
/// </summary>
page 50145 ConsumersAPI
{
    APIGroup = 'custom';
    APIPublisher = 'saouchi';
    APIVersion = 'v1.0';
    Caption = 'consumers';
    DelayedInsert = true;
    EntityName = 'consumers';
    EntitySetName = 'consumer';
    PageType = API;
    SourceTable = Consumers;
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
            }
        }
    }
}
