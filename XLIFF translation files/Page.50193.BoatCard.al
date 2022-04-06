/// <summary>
/// Page ISA_BoatCard (ID 50193).
/// </summary>
page 50193 ISA_BoatCard
{
    Caption = 'ISA_BoatCard';
    PageType = Card;
    SourceTable = ISA_Boat;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No. "; Rec."No. ")
                {
                    ToolTip = 'Specifies the value of the No.  field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;
                }
                field(Speed; Rec.Speed)
                {
                    ToolTip = 'Specifies the value of the Speed Km/H field.';
                    ApplicationArea = All;
                }
            }
        }
    }

    /*
By setting the GenerateLockedTranslations flag in the app.json file, you specify that you want to generate <trans-unit>
 elements for locked labels in the XLIFF file. 
 The default behavior is that these elements are not generated.
    */

    trigger OnOpenPage()
    var
        OpeningMsg: Label 'Developer Translation for %1', Comment = '%1 is the extension''s name', Locked = false, MaxLength = 999;
        Module: ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(Module);
        Message(OpeningMsg, Module.Name);
    end;
}
