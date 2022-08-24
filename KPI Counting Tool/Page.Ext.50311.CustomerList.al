/// <summary>
/// PageExtension ISA_CustomerList_Ext (ID 50311) extends Record Customer List.
/// </summary>
pageextension 50311 ISA_CustomerList_Ext extends "Customer List"
{

    actions
    {
        addfirst(processing)
        {
            action(KPI_Tool)
            {
                ApplicationArea = All;
                Caption = 'KPI Tool';
                Image = Tools;

                trigger OnAction()
                var
                    DataEntryDlg: Page ISA_DataEntry;
                    ISA_RecRef: RecordRef;
                    ISA_PageBuilder: FilterPageBuilder;
                    ISA_TableNo: Integer;
                    ProcessCanceledLbl: Label 'Process Canceled !';
                begin
                    if DataEntryDlg.RunModal() in [Action::OK, Action::Yes] then begin
                        ISA_TableNo := DataEntryDlg.ISA_SetNo();

                        ISA_PageBuilder.PageCaption('KPI Tool');
                        ISA_PageBuilder.AddTable('Filter', ISA_TableNo);

                        if ISA_PageBuilder.RunModal() then begin
                            ISA_RecRef.Open(ISA_TableNo);
                            ISA_RecRef.SetView(ISA_PageBuilder.GetView('Filter'));
                        end
                        else
                            Error(Format(ProcessCanceledLbl));
                        Message('%1, records for that filter', ISA_RecRef.Count);
                    end;
                end;
            }
        }
    }

    var
}