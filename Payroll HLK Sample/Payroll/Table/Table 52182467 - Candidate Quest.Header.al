/// <summary>
/// Table Candidate Quest.Header (ID 52182467).
/// </summary>
table 52182467 "Candidate Quest.Header"
//table 39108438 "Candidate Quest.Header"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate Quest.Header',
                FRA = 'En-tête questionnaire candidat';
    DataCaptionFields = "Code", Description;
    LookupPageID = "Candidate Quest.";
    DrillDownPageId = "Candidate Quest.";

    fields
    {
        field(1; "Code"; Code[10])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[30])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Désignation';
        }
        field(3; Priority; Option)
        {
            CaptionML = ENU = 'Priority',
                        FRA = 'Priorité';
            InitValue = Normal;
            OptionCaptionML = ENU = 'Very Low,Low,Normal,High,Very High',
                              FRA = 'Très faible,Faible,Normale,Haute,Très haute';
            OptionMembers = "Very Low",Low,Normal,High,"Very High";
        }
        field(4; Type; Option)
        {
            CaptionML = ENU = 'Type',
                        FRA = 'Type';
            OptionCaptionML = ENU = 'Candidate,Employee',
                              FRA = 'Candidat,Salarié';
            OptionMembers = Candidate,Employee;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        QuestnLine.RESET;
        QuestnLine.SETRANGE("Questionnaire Code", Code);
        QuestnLine.DELETEALL(TRUE);
    end;

    var
        QuestnLine: Record 52182468;
}

