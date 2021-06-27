tableextension 81820 "MICA SMTP Mail Setup" extends "SMTP Mail Setup"
{
    fields
    {
        field(81820; "MICA Default From Email Addr."; Text[250])
        {
            Caption = 'Default From Email Address';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "MICA Default From Email Addr." <> '' then
                    MailManagement.CheckValidEmailAddress("MICA Default From Email Addr.");
            end;
        }
    }
}