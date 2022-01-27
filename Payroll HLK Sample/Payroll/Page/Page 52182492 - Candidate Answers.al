/// <summary>
/// Page Candidate Answers (ID 52182492).
/// </summary>
page 52182492 "Candidate Answers"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate Answers',
                FRA = 'Réponses au questionnaire candidat';
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Candidate Answer";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Type; Type)
                {
                }
                field(Description; Description)
                {
                }
                field(Answer; Answer)
                {

                    trigger OnValidate();
                    begin
                        TESTFIELD(Type, Type::Answer);
                        IF "Free Text" THEN
                            ERROR(Text01);
                    end;
                }
                field("Multiple Answers"; "Multiple Answers")
                {
                }
                field("Free Text"; "Free Text")
                {
                    Editable = false;
                }
                field("Answer Priority"; "Answer Priority")
                {
                    Editable = true;
                }
                field("Questionnaire Priority"; "Questionnaire Priority")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        TypeOnFormat;
        DescriptionOnFormat;
    end;



    var
        Text01: Label 'Pas de sélection disponible ! Saisissez la réponse.';
        [InDataSet]
        TypeEmphasize: Boolean;
        [InDataSet]
        DescriptionEmphasize: Boolean;


    local procedure DescriptionOnBeforeInput();
    begin
        //CurrPage.Description.UPDATEEDITABLE((Type=Type::Answer)AND("Free Text"));
        CurrPage.UPDATE;
    end;

    local procedure TypeOnFormat();
    begin
        TypeEmphasize := Type = Type::Question;
    end;

    local procedure DescriptionOnFormat();
    begin
        DescriptionEmphasize := Type = Type::Question;
    end;
}

