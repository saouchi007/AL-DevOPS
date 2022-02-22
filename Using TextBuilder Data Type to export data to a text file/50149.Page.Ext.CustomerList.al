/// <summary>
/// PageExtension CustomerList_Ext (ID 50149) extends Record Customer List.
/// </summary>
pageextension 50149 CustomerList_Ext extends "Customer List"
{
    actions
    {
        addfirst(processing)
        {
            action(ExportToTxT)
            {
                Caption = 'Export to Text';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ExportContact;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    ExporttoTXT();
                end;
            }
        }
    }

    local procedure ExporttoTXT()
    var
        TempBlolb: Codeunit "Temp Blob";
        inS: InStream;
        ouT: OutStream;
        txtBuilder: TextBuilder;
        FileName: Text;
        Lines: Integer;
        CustLedEnt: Record "Cust. Ledger Entry";
    begin
        FileName := 'TrialFile_' + UserId + '_' + Format(CurrentDateTime) + '.txt';
        /*txtBuilder.AppendLine('This is 1st line');
        txtBuilder.AppendLine('This is second line');
        txtBuilder.AppendLine('');
        txtBuilder.AppendLine('The end');// Add lines to the file by hard coding them*/

        /*txtBuilder.AppendLine('Start time: ' + Format(Time));
        for Lines := 1 to 1000 do
            txtBuilder.AppendLine(StrSubstNo('This is %1 line', Lines));
        txtBuilder.Append('End time: ' + Format(Time));  Add 1k lines in a text file*/

        txtBuilder.AppendLine('Posting Date, ' + 'Document Type, ' + 'Document N°, ' + 'Customer No., ' + 'Amount (LCY)');
        CustLedEnt.Reset();
        CustLedEnt.SetAutoCalcFields("Amount (LCY)");
        if CustLedEnt.FindSet() then
            repeat
                txtBuilder.AppendLine(Format(CustLedEnt."Posting Date") + ' , ' + Format(CustLedEnt."Document Type") + ' , ' + CustLedEnt."Document No." + ' , ' +
                CustLedEnt."Customer No." + ' , ' + Format(CustLedEnt."Amount (LCY)"));
            until CustLedEnt.Next() = 0;
        TempBlolb.CreateOutStream(ouT);
        ouT.Write(txtBuilder.ToText());
        TempBlolb.CreateInStream(inS);
        DownloadFromStream(inS, '', '', '', FileName);
    end;
}