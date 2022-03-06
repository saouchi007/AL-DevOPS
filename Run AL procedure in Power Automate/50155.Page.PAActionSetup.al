/// <summary>
/// Page PowerAutomateetupEntity (ID 50155).
/// </summary>
page 50155 PowerAutomateetupEntity
{
    Caption = 'PowerAutomateSetup', Locked = true;
    DelayedInsert = true;
    PageType = API;
    APIGroup = 'ISAGroup';
    APIPublisher = 'ISA';
    APIVersion = 'beta';
    EntityName = 'PowerAutomateSetup';
    EntitySetName = 'PowerAutomateSetup';
    SourceTable = PowerAutomateSetup;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(ID; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Caption = 'ID', Locked = true;
                    Editable = false;
                }
                field(SetupField; Rec.SetupField)
                {
                    ApplicationArea = All;
                    Caption = 'Setup Field', Locked = true;
                }
            }
        }
    }


    /// <summary>
    /// TrialAction.
    /// </summary>
    /// <param name="context">VAR WebServiceActionContext.</param>
    [ServiceEnabled]
    procedure TrialAction(var context: WebServiceActionContext)
    var
        Item: Record Item;
    begin
        Item.Get('1896-S');
        Item.Description := Item.Description + '-ISA';
        Item.Modify();

        context.SetResultCode(WebServiceActionResultCode::Updated);
    end;
}