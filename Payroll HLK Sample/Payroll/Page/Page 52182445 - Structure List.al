/// <summary>
/// Page Structure List (ID 51410).
/// </summary>
page 52182445 "Structure List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Structure List',
                FRA = 'Liste des structures';
    PageType = Card;
    SourceTable = Structure;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                IndentationColumn = DescriptionIndent;
                IndentationControls = Description;
                field(Code; Code)
                {
                }
                field(Description; Description)
                {
                }
                field("Structure Type"; "Structure Type")
                {
                }
                field(Totaling; Totaling)
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field(Blocked; Blocked)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Structure")
            {
                CaptionML = ENU = '&Structure',
                            FRA = '&Structure';
                Image = SetupAddressCountryRegion;
                action("&Employees")
                {
                    CaptionML = ENU = '&Employees',
                                FRA = '&Salariés';
                    Image = Employee;
                    RunObject = Page 52182444;
                    RunPageLink = "Structure No." = FIELD(Code);
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                CaptionML = ENU = 'F&unctions',
                            FRA = 'Fonction&s';
                Image = Job;
                action("Indent Structures")
                {
                    CaptionML = ENU = 'Indent Structures',
                                FRA = 'Indenter structures';
                    Image = Indent;
                    RunObject = Codeunit 52182426;
                    RunPageOnRec = true;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        DescriptionIndent := 0;
        CodeOnFormat;
        DescriptionOnFormat;
    end;



    var
        [InDataSet]
        CodeEmphasize: Boolean;
        [InDataSet]
        DescriptionEmphasize: Boolean;
        [InDataSet]
        DescriptionIndent: Integer;


    local procedure CodeOnFormat();
    begin
        CodeEmphasize := "Structure Type" <> "Structure Type"::Standard;
    end;

    local procedure DescriptionOnFormat();
    begin
        DescriptionEmphasize := "Structure Type" <> "Structure Type"::Standard;
        DescriptionIndent := Indentation;
    end;
}

