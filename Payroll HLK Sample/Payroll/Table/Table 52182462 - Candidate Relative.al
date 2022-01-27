/// <summary>
/// Table Candidate Relative (ID 52182462).
/// </summary>
table 52182462 "Candidate Relative"
//table 39108433 "Candidate Relative"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate Relative',
                FRA = 'Lien de parenté candidat';
    DataCaptionFields = "Candidate No.";

    fields
    {
        field(1; "Candidate No."; Code[20])
        {
            CaptionML = ENU = 'Candidate No.',
                        FRA = 'N° candidat';
            NotBlank = true;
            TableRelation = Candidate;
        }
        field(2; "Line No."; Integer)
        {
            CaptionML = ENU = 'Line No.',
                        FRA = 'N° ligne';
        }
        field(3; "Relative Code"; Code[10])
        {
            CaptionML = ENU = 'Relative Code',
                        FRA = 'Code lien de parenté';
            TableRelation = Relative;
        }
        field(4; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
        }
        field(5; "Middle Name"; Text[30])
        {
            CaptionML = ENU = 'Middle Name',
                        FRA = 'Nom de jeune fille';
        }
        field(6; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom usuel';
        }
        field(7; "Birth Date"; Date)
        {
            CaptionML = ENU = 'Birth Date',
                        FRA = 'Date de naissance';
        }
        field(8; "Phone No."; Text[30])
        {
            CaptionML = ENU = 'Phone No.',
                        FRA = 'N° téléphone';
        }
        field(9; "Relative's Candidate No."; Code[20])
        {
            CaptionML = ENU = 'Relative''s Candidate No.',
                        FRA = 'N° candidat parent';
            TableRelation = Employee;
        }
        field(10; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(0),//CONST(14)
                                                                     "No." = FIELD("Candidate No."),
                                                                     "Table Line No." = FIELD("Line No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; Sex; Option)
        {
            CaptionML = ENU = 'Sex',
                        FRA = 'Sexe';
            OptionCaptionML = ENU = ' ,Female,Male',
                              FRA = ' ,Féminin,Masculin';
            OptionMembers = " ",Female,Male;
        }
        field(12; "Birthplace Post Code"; Code[10])
        {
            CaptionML = ENU = 'Birthplace Post Code',
                        FRA = 'Code postal lieu de naissance';
            TableRelation = "Post Code";

            trigger OnLookup();
            begin
                //PostCode.UpdateFromSalesHeader("Birthplace City","Birthplace Post Code",TRUE);
                PostCode.LookUpPostCode("Birthplace City", "Birthplace Post Code", TRUE);
            end;

            trigger OnValidate();
            begin
                //PostCode.LookUpPostCode("Birthplace City","Birthplace Post Code");
                PostCode.ValidatePostCode_old("Birthplace City", "Birthplace Post Code");
            end;
        }
        field(13; "Birthplace City"; Text[30])
        {
            CaptionML = ENU = 'Birthplace City',
                        FRA = 'Ville lieu de naissance';

            trigger OnLookup();
            begin
                PostCode.LookUpCity("Birthplace City", "Birthplace Post Code", TRUE);
            end;

            trigger OnValidate();
            begin
                //PostCode.ValidatePostCode_old("Birthplace City","Birthplace Post Code");
                PostCode.ValidateCity_old("Birthplace City", "Birthplace Post Code");
            end;
        }
    }

    keys
    {
        key(Key1; "Candidate No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    var
        HRCommentLine: Record 5208;
    begin
        HRCommentLine.SETRANGE("Table Name", HRCommentLine."Table Name"::"Employee Relative");
        HRCommentLine.SETRANGE("No.", "Candidate No.");
        HRCommentLine.DELETEALL;
    end;

    var
        PostCode: Record 225;
}

