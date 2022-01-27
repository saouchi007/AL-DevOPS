/// <summary>
/// Page Institution Training Catalog (ID 52182438).
/// </summary>
page 52182438 "Institution Training Catalog"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Institution Training Catalog',
                FRA = 'Etabliss. : Catalogue des formations';
    DataCaptionFields = "Training Institution No.";
    Editable = false;
    PageType = Card;
    SourceTable = "Training Institution Catalog";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Training No."; "Training No.")
                {
                }
                field("Training Description"; "Training Description")
                {
                }
                field(Period; Period)
                {
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                }
                field(Coût; Coût)
                {
                }
                field("Institution Reference"; "Institution Reference")
                {
                }
                field("Editor Reference"; "Editor Reference")
                {
                }
                field("No. of Sessions"; "No. of Sessions")
                {
                }
            }
        }
    }

    actions
    {
    }


}

