/// <summary>
/// TableExtension ISA_ItemLedgerEntries_Ext (ID 50186) extends Record Item Ledger Entry.
/// </summary>
tableextension 50186 ISA_ItemLedgerEntries_Ext extends "Item Ledger Entry"
{
    fields
    {
        field(50100; ShortDim3; Code[20])
        {
            Caption = 'Shortcut Dimension 3 Code';
            CaptionClass = '1.2.3';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));
        }
        field(50101; ShortDim4; Code[20])
        {
            Caption = 'Shortcut Dimension 4 Code';
            CaptionClass = '1.2.4';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));
        }
        field(50102; ShortDim5; Code[20])
        {
            Caption = 'Shortcut Dimension 5 Code';
            CaptionClass = '1.2.5';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5));
        }
        field(50103; ShortDim6; Code[20])
        {
            Caption = 'Shortcut Dimension 6 Code';
            CaptionClass = '1.2.6';
            DataClassification = CustomerContent;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6));
        }

    }

    var
        myInt: Integer;
}