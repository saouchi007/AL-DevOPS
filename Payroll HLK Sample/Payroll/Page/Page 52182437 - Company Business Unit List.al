/// <summary>
/// Page Company Business Unit List (ID 52182437).
/// </summary>
page 52182437 "Company Business Unit List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Company Business Unit List',
                FRA = 'Liste des unités de la société';
    Editable = true;
    PageType = Card;
    SourceTable = "Company Business Unit";

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Location Code"; "Location Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Business Unit")
            {
                CaptionML = ENU = '&Business Unit',
                            FRA = '&Direction';
                action(Card)
                {
                    CaptionML = ENU = 'Card',
                                FRA = 'Fiche';
                    Image = EditLines;
                    RunObject = Page 52182436;
                    RunPageLink = Code = FIELD(Code);
                    ShortCutKey = 'Shift+F5';
                }
                group(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions',
                                FRA = 'A&xes analytiques';
                    action("Dimensions-Single")
                    {
                        CaptionML = ENU = 'Dimensions-Single',
                                    FRA = 'Affectations - &Simples';
                        RunObject = Page 540;
                        RunPageLink = "Table ID" = CONST(5714),
                                      "No." = FIELD(Code);
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        CaptionML = ENU = 'Dimensions-&Multiple',
                                    FRA = 'Affectations - &Multiples';

                        trigger OnAction();
                        var
                            RespCenter: Record 5714;
                            DefaultDimMultiple: Page 542;
                        begin
                            CurrPage.SETSELECTIONFILTER(RespCenter);
                            DefaultDimMultiple.SetMultiRespCenter(RespCenter);
                            DefaultDimMultiple.RUNMODAL;
                        end;
                    }
                }
            }
        }
    }




}

