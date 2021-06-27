tableextension 80660 "MICA G/L Account" extends "G/L Account"
{
    fields
    {
        field(80660; "MICA Excl. From Flux2 Report"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Exclude from Flux2 reporting';
        }
        field(80661; "MICA F2 Incl. Year Amt. Only"; Boolean)
        {
            Caption = 'Flow2 Incl. Year Amount Only';
            DataClassification = CustomerContent;
        }
        field(80662; "MICA Incl. on Flux2 Code3 Rpt."; Boolean)
        {
            Caption = 'Include on Flux2 Code 3 reporting';
            DataClassification = CustomerContent;
        }
    }
}