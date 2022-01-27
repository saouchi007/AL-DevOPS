/// <summary>
/// Table Decision Line Tag (ID 51451).
/// </summary>
table 52182479 "Decision Line Tag"
//table 39108451 "Decision Line Tag"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Decision Line Tag',
                FRA = 'Tag ligne décision';
    // DrillDownPageID = 39108472;
    //LookupPageID = 39108472;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; "Part"; Option)
        {
            Caption = 'Partie';
            NotBlank = true;
            OptionCaption = 'Entête,Article 1,Article 2,Article 3,Pied de page';
            OptionMembers = "Entête","Article 1","Article 2","Article 3","Pied de page";
        }
        field(3; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.',
                        FRA = 'N° ligne';
            NotBlank = true;
        }
        field(4; "Tag No."; Integer)
        {
            Caption = 'N° Tag';
            NotBlank = true;
        }
        field(5; "Table No."; Integer)
        {
            Caption = 'N° Table';

            trigger OnLookup();
            begin
                /*Objet.SETRANGE(Objet.Type,Objet.Type::Table);
                IF PAGE.RUNMODAL(PAGE::"Bilan de formation",Objet,Objet.ID) = ACTION::LookupOK THEN
                  VALIDATE("Table No.",Objet.ID);  */

            end;

            trigger OnValidate();
            begin
                IF "Table No." = 0 THEN BEGIN
                    "Table Name" := '';
                    EXIT;
                END;
                Objet.GET(Objet.Type::Table, '', "Table No.");
                "Table Name" := Objet.Name;
            end;
        }
        field(6; "Field No."; Integer)
        {
            Caption = 'N° Champ';

            trigger OnLookup();
            begin
                /*IF "Table No."=0 THEN
                  EXIT;
                Champ.SETRANGE(Champ.TableNo,"Table No.");
                IF PAGE.RUNMODAL(PAGE::Champs,Champ,Champ.TableNo) = ACTION::LookupOK THEN
                  VALIDATE("Field No.",Champ."No.");*/

            end;

            trigger OnValidate();
            begin
                IF "Field No." = 0 THEN BEGIN
                    "Field Name" := '';
                    EXIT;
                END;
                Champ.GET("Table No.", "Field No.");
                "Field Name" := Champ.FieldName;
            end;
        }
        field(7; "Table Name"; Text[30])
        {
            Caption = 'Nom table';
            Editable = false;
        }
        field(8; "Field Name"; Text[30])
        {
            Caption = 'Nom champ';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Code", "Part", "Line No.", "Tag No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Objet: Record 2000000001;
        Champ: Record 2000000041;
}

