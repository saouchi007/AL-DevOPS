/// <summary>
/// Page Decision Template Fields (ID 52182507).
/// </summary>
page 52182507 "Decision Template Fields"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Decision Template Fields',
                FRA = 'Champs de modèles de décisions';
    PageType = Card;
    SourceTable = "Decision Line Tag";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Tag No."; "Tag No.")
                {
                }
                field("Table No."; "Table No.")
                {
                }
                field("Table Name"; "Table Name")
                {
                }
                field("Field No."; "Field No.")
                {
                }
                field("Field Name"; "Field Name")
                {
                }
            }
        }
    }

    actions
    {
    }



    var
        Objet: Record 2000000001;
        Champ: Record 2000000041;
}

