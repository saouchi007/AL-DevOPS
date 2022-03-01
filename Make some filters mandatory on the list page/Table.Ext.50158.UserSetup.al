/// <summary>
/// TableExtension UserSetup_Ext (ID 50158) extends Record User Setup.
/// </summary>
tableextension 50158 UserSetup_Ext extends "User Setup"
{
    fields
    {
        field(50158; AllowViewing; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow viewing all order';
        }
    }
}