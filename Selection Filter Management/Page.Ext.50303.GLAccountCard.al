/// <summary>
/// PageExtension MyExtension (ID 50302) extends Record G/L Account Card.
/// </summary>
pageextension 50306 MyExtension extends "G/L Account Card"
{
    layout
    {
        addafter(Totaling)
        {
            field(ISA_Totalling; ISA_Totalling)
            {
                ApplicationArea = All;
                Caption = 'ISA Totalling';

                trigger OnLookup(var Text: Text): Boolean
                var
                    GLAccount: Page "G/L Account List";
                    OldText: Text;
                begin
                    OldText := Text;
                    GLAccount.LookupMode(true);
                    if not (GLAccount.RunModal() = Action::LookupOK) then
                        exit(false);
                    Text := OldText + GLAccount.GetSelectionFilter();
                    exit(true);
                end;

            }
        }

    }

    var
        ISA_Totalling: Text;
}