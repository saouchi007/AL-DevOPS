/// <summary>
/// Page Training : Institutions (ID 52182490).
/// </summary>
page 52182490 "Training : Institutions"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training : Institutions',
                FRA = 'Formation : Etablissements';
    DataCaptionFields = "Training No.";
    Editable = true;
    PageType = List;
    SourceTable = "Training Institution Catalog";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Training Institution No."; "Training Institution No.")
                {
                }
                field("Training No."; "Training No.")
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
                field("Training Description"; "Training Description")
                {
                    Editable = false;
                }
                field("Institution Description"; "Institution Description")
                {
                    Editable = false;
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
        area(navigation)
        {
            group("&Catalog")
            {
                CaptionML = ENU = '&Catalog',
                            FRA = '&Catalogue';
                Image = List;
                action("&Sessions")
                {
                    Caption = '&Sessions';
                    Image = SalesInvoice;
                    RunObject = Page "Training Session List";
                    RunPageLink = "Institution No." = FIELD("Training Institution No."),
                                  "Training No." = FIELD("Training No.");
                }
            }
        }
    }


}

