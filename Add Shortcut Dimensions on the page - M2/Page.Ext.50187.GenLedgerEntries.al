/// <summary>
/// PageExtension ISA_GenLedgerEntries_Ext (ID 50187) extends Record General Ledger Entries.
/// </summary>
pageextension 50187 ISA_GenLedgerEntries_Ext extends "General Ledger Entries"
{
    layout
    {
        modify("Global Dimension 1 Code")
        {
            Visible = true;
        }
        modify("Global Dimension 2 Code")
        {
            Visible = true;
        }
        addafter("Global Dimension 2 Code")
        {
            field(ShortCutDim3; ShortCutDim3)
            {
                Caption = 'Shortcut Dimension 3 Code';
                CaptionClass = '1,2,3';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
                ApplicationArea = All;
            }
            field(ShortCutDim4; ShortCutDim4)
            {
                Caption = 'Shortcut Dimension 4 Code';
                CaptionClass = '1,2,4';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
                ApplicationArea = All;
            }
            field(ShortCutDim5; ShortCutDim5)
            {
                Caption = 'Shortcut Dimension 5 Code';
                CaptionClass = '1,2,5';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
                ApplicationArea = All;
            }
            field(ShortCutDim6; ShortCutDim6)
            {
                Caption = 'Shortcut Dimension 6 Code';
                CaptionClass = '1,2,6';
                TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
                ApplicationArea = All;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        DimMgmt: Codeunit DimensionManagement;
        ShortCutDimCode: array[4] of Code[20];
    begin
        DimMgmt.GetShortcutDimensions("Dimension Set ID", ShortCutDimCode);
        ShortCutDim3 := ShortCutDimCode[3];
        ShortCutDim4 := ShortCutDimCode[4];
        ShortCutDim5 := ShortCutDimCode[5];
        ShortCutDim6 := ShortCutDimCode[6];
    end;

    var

        ShortCutDim3: Code[20];
        ShortCutDim4: Code[20];
        ShortCutDim5: Code[20];
        ShortCutDim6: Code[20];
}