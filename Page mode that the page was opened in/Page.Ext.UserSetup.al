/// <summary>
/// PageExtension ISA_UserSetupExt (ID 50302) extends Record User Setup.
/// </summary>
pageextension 50302 ISA_UserSetupExt extends "User Setup"
{
    layout
    {
        addafter("Allow Deferral Posting From")
        {
            field(ISA_AllowEditMode; Rec.ISA_AllowEditMode)
            {
                ApplicationArea = All;
                ToolTip = 'Sets whether the user can edit Customer Card';
            }
        }
    }

}