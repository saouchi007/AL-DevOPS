/// <summary>
/// Page ISA_DatGroupBuffer (ID 50325).
/// </summary>
page 50325 ISA_DatGroupBuffer
{
    ApplicationArea = All;
    Caption = 'ISA DAT Group Buffer';
    PageType = List;
    SourceTable = ISA_DATGroupBuffer;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(DocumentNo; Rec.DocumentNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field(DocumentType; Rec.DocumentType)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Document Type field.';
                }
                field(CustomerName; Rec.CustomerName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field(GroupNo; Rec.GroupNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Group No. field.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Amount field.';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        ISA_InitData();
    end;

    local procedure ISA_InitData()
    var
        GroupBuffer: Record ISA_DATGroupBuffer;
        Docno: Code[20];
        DocNoLbl: Label 'X000001', Locked = true;
        StartDateTime: DateTime;
        I: Integer;
    begin
        StartDateTime := CurrentDateTime;
        GroupBuffer.DeleteAll();
        Docno := '0001';
        //Message(IncStr(Docno));
        
                for I := 1 to 7500 do begin
                    GroupBuffer.Init();
                    GroupBuffer.DocumentType := Random(5);
                    GroupBuffer.DocumentNo := Docno;
                    GroupBuffer.Amount := Random(2000);
                    GroupBuffer.CustomerName := Format(Random(5));
                    Docno := IncStr(Docno);
                    GroupBuffer.Insert();
                end;
                Message('%1', CurrentDateTime - StartDateTime);
    end;
}
