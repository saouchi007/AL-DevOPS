/// <summary>
/// Page Payroll Template (ID 52182555).
/// </summary>
page 52182555 "Payroll Template"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Template',
                FRA = 'Modèle de paie';
    PageType = Document;
    SourceTable = "Payroll Template Header";

    layout
    {
        area(content)
        {
            //Caption = 'Modèle de paie';
            group("<Général>")
            {
                Caption = 'Général';
                field("No."; "No.")
                {
                    DrillDownPageID = "No. Series List";
                    LookupPageID = "No. Series List";

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field(Description; Description)
                {
                }
                field(Comment; Comment)
                {
                }
            }
            part("<Listes des rébriques>"; 52182556)
            {
                Caption = 'Listes des rébriques';
                SubPageLink = "Template No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Template)
            {
                CaptionML = ENU = '&Template',
                            FRA = '&Modèle';
                Image = Template;
                action("Co&mments")
                {
                    CaptionML = ENU = 'Co&mments',
                                FRA = 'Co&mmentaires';
                    Image = ViewComments;
                    RunObject = Page 124;
                    RunPageLink = "Table Name" = CONST(18),
                                  "No." = FIELD("No.");
                }
            }
        }
    }


}

