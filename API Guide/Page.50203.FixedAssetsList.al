/// <summary>
/// Page ISA_CustomerList_API (ID 50203).
/// </summary>
page 50203 ISA_FixedAssetList_API
{
    PageType = API;
    Caption = 'Fixed Assets List';
    APIPublisher = 'saouchi';
    APIGroup = 'fixed_assets';
    APIVersion = 'v2.0';
    EntityName = 'fa_entity';
    EntitySetName = 'fa_setname';
    SourceTable = "Fixed Asset";
    DelayedInsert = true;
    ODataKeyFields = SystemId;
    //******************Acess the API from the web page************************
    // http://localhost:20048/BC204/api/APIPublisher/APIGroup/APIVersion/EntitySetName
    // http://localhost:20048/BC204/api/saouchi/fixed_assets/v2.0/fa_setname
    //******************Acess the API from the web page************************
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }

                field(acquired; Rec.Acquired)
                {
                    Caption = 'Acquired';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(blocked; Rec.Blocked)
                {
                    Caption = 'Blocked';
                }
            }
        }
    }
}