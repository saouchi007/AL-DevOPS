/// <summary>
/// PageExtension CustomerList_Ext (ID 50140) extends Record Customer List.
/// </summary>
pageextension 50140 CustomerList_Ext extends "Customer List"
{
    actions
    {
        addfirst(processing)
        {
            action(ImportZipFile)
            {
                Caption = 'Import Zip File';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ImportDatabase;
                ToolTip = 'Import Attachements from Zip';

                trigger OnAction()
                begin
                        ImportAttachementsFromZip();                    
                end;
            }
        }
    }

    local procedure ImportAttachementsFromZip()
    begin
        Error('Procedure ImportAttachementFromZip not implemented.');
    end;
}