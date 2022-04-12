/// <summary>
/// TableExtension ISA_UserSetup_Ext (ID 50220) extends Record MyTargetTable.
/// </summary>
tableextension 50220 ISA_UserSetup_Ext extends "User Setup"
{
    fields
    {
        field(50221; OpenSettings; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Open My Settings';
        }
        field(50222; ChangeRole; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Change Role Center';
        }
        field(50223; ChangeCompany; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Change Company';
        }
        field(50224; ChangeWorkDay; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Allow Change Work Day';
        }
    }

    var
        myInt: Integer;
}