tableextension 80782 "MICA Document Sending Profile" extends "Document Sending Profile" //MyTargetTableId
{
    fields
    {
        field(80000; "MICA Daily Sent"; Boolean)
        {
            Caption = 'Daily Sent';
            DataClassification = CustomerContent;
        }

    }

}