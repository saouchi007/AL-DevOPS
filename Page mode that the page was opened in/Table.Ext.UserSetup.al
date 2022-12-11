/// <summary>
/// TableExtension ISA_UserSetupExt (ID 50301) extends Record User Setup.
/// </summary>
tableextension 50301 ISA_UserSetupExt extends "User Setup"
{
    fields
    {
        field(50300; ISA_AllowEditMode; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Edit Mode';
        }
    }
}