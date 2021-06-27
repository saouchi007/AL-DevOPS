report 80860 "MICA Send Flow Entry"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Send Flow Entry';

    dataset
    {
        dataitem("MICA Flow"; "MICA Flow")
        {
            DataItemTableView = sorting (Code) order(ascending) where (Status = const (Released), Direction = const (Send));
            RequestFilterFields = Code, "Partner Code";
            trigger OnAfterGetRecord()
            begin
                "MICA Flow".ExecuteSendCodeunit();
                "MICA Flow".SendData();
            end;
        }
    }
}
