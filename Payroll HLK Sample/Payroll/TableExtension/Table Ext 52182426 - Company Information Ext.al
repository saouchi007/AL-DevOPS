/// <summary>
/// TableExtension Company Information Ext (ID 52182426) extends Record Company Information.
/// </summary>
tableextension 52182426 "Company Information Ext" extends "Company Information"
{
    fields
    {
        field(50000; "Employer SS No."; Text[30])
        {
            CaptionML = ENU = 'Employer SS No.',
                        FRA = 'N° SS employeur';
            Description = 'HALRHPAIE';
        }
        field(50001; "Right Logo"; BLOB)
        {
            CaptionML = ENU = 'Right Logo',
                        FRA = 'Logo de droite';
            Description = 'HALRHPAIE';
            SubType = Bitmap;
        }
        field(50002; Activity; Text[100])
        {
            Caption = 'Activité';
            Description = 'HLKLiasse';
        }
        field(50003; "No. IS"; Text[100])
        {
            CaptionML = ENU = 'NIF',
                        FRA = 'No.IS';
            Description = 'HLKLiasse';
        }
        field(50004; "No. AI"; Text[100])
        {
            CaptionML = ENU = 'Activité',
                        FRA = 'No.AI';
            Description = 'HLKLiasse';
        }
        field(50005; "No. IF"; Text[100])
        {
            Caption = 'NIF';
            Description = 'HLKLiasse';
        }
        field(50006; "Bank Name 2"; Text[50])
        {
            CaptionML = ENU = 'Bank Name',
                        FRA = 'Nom de la banque 2';
        }
        field(50007; "Bank Branch 2 No."; Text[20])
        {
            CaptionML = ENU = 'Bank Branch No.',
                        FRA = 'Code établissement 2';
        }
        field(50008; "Bank Account 2 No."; Text[30])
        {
            CaptionML = ENU = 'Bank Account No.',
                        FRA = 'N° compte bancaire 2';
        }
        //*************Implemented fields*******************//
        field(10801; "Trade Register"; Text[30])
        {
            Caption = 'Trade Register';
        }
        field(10803; "Legal Form"; Text[30])
        {
            Caption = 'Legal Form';
        }
        field(10804; "Stock Capital"; Text[30])
        {
            Caption = 'Stock Capital';
        }
        //*************************************************//
    }

    var
        myInt: Integer;
}