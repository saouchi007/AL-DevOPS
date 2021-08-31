pageextension 50105 CustListExt extends "Customer Details FactBox"
{
    layout
    {
        modify("E-Mail")
        {
            trigger OnDrillDown()
            var
                Email: Codeunit Email;
                EmailMessage: Codeunit "Email Message";
            begin
                EmailMessage.Create(Rec."E-Mail", '', '', true);
                Email.AddRelation(EmailMessage, Database::Customer, Rec.SystemId, Enum::"Email Relation Type"::"Primary Source");
                Email.OpenInEditorModally(EmailMessage);
            end;
        }

    }

}