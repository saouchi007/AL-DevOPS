/// <summary>
/// Codeunit ISA_ToolBox (ID 50303).
/// </summary>
codeunit 50303 ISA_ToolBox
{
    /// <summary>
    /// ISA_SplitIntoList.
    /// </summary>
    procedure ISA_SplitIntoList()
    var
        RecipientsString: Text;
        RecipientList: List of [Text];
        Separator: Text;
        Recipient: Text;
    begin
        Separator := ';';
        RecipientsString := 'alpha@isa.com;beta@isa.com;charlie@isa.com;delta@isa.com;erik@isa.com';

        RecipientList := RecipientsString.Split(Separator.Split());

        foreach Recipient in RecipientList do begin
            Message(RecipientList.Get(RecipientList.IndexOf(Recipient)));
        end;
    end;
}