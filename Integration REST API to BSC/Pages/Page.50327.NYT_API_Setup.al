/// <summary>
/// Page ISA_NYT_API_Setup (ID 50326).
/// </summary>
page 50327 ISA_NYT_API_Setup
{
    PageType = Card;
    Caption = 'ISA New York Times API Setup';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = ISA_NYT_API_Setup;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(BaseURL; Rec.BaseURL)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Base URL field.';
                }
                field(APIKey; APIKey)
                {
                    ApplicationArea = All;
                    Caption = 'API Key';
                    ToolTip = 'Specifies API Key';
                    ExtendedDatatype = Masked;

                    trigger OnValidate()
                    begin
                        ISA_SetAPIKey(APIKey);
                        Message(APIKey);
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
        if ISA_GetAPIKey() <> '' then
            APIKey := '***';
    end;

    var
        APIKey: Text;


}