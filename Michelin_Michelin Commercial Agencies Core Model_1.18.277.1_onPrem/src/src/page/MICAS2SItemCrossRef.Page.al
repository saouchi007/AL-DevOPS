page 82861 "MICA S2S Item Cross Ref."
{
    PageType = API;
#if not OnPremise    
    APIPublisher = 'MichelinCA';
    APIGroup = 'S2S';
#endif    
    DelayedInsert = true;
    APIVersion = 'v1.0';
    Caption = 's2sItemCrossReferenceEntity', Locked = true;
    EntityName = 's2sItemCrossReference';
    EntitySetName = 's2sItemCrossReferences';
    ODataKeyFields = SystemId;
    SourceTable = "Item Cross Reference";
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    ChangeTrackingAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Caption = 'id', Locked = true;
                    Editable = false;
                }
                field(companyCode; MICAFinancialReportingSetup."Company Code")
                {
                    ApplicationArea = All;
                    Caption = 'companyCode', Locked = true;
                }
                field(crossReferenceType; Rec."Cross-Reference Type")
                {
                    ApplicationArea = All;
                    Caption = 'crossReferenceType', Locked = true;
                }
                field(crossReferenceTypeNo; Rec."Cross-Reference Type No.")
                {
                    ApplicationArea = All;
                    Caption = 'crossReferenceTypeNo', Locked = true;
                }
                field(customerId; CustomerSystemId)
                {
                    ApplicationArea = All;
                    Caption = 'customerId', Locked = true;
                }
                field(itemNoCAD; Rec."Item No.")
                {
                    ApplicationArea = All;
                    Caption = 'itemNoCAD', Locked = true;
                }
                field(itemNoCPN; Rec."Cross-Reference No.")
                {
                    ApplicationArea = All;
                    Caption = 'itemNoCPN', Locked = true;
                }
                field(itemUnitOfMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'itemUnitOfMeasure', Locked = true;
                }
                field(displayName; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'displayName', Locked = true;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Cross-Reference Type", Rec."Cross-Reference Type"::Customer);
        Rec.SetFilter("Cross-Reference Type No.", '<>%1', '');
        Rec.SetFilter("Cross-Reference No.", '<>%1', '');
        if not MICAFinancialReportingSetup.Get() then
            MICAFinancialReportingSetup.Init();
    end;

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
    begin
        if not Customer.Get(Rec."Cross-Reference Type No.") then
            Clear(CustomerSystemId)
        else
            CustomerSystemId := Customer.SystemId;
    end;

    var
        MICAFinancialReportingSetup: Record "MICA Financial Reporting Setup";
        CustomerSystemId: Guid;
}