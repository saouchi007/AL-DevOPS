/// <summary>
/// Page Payroll Entries (ID 52182527).
/// </summary>
page 52182527 "Payroll Entries"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Entries',
                FRA = 'Ecritures de paie';
    Editable = false;
    PageType = List;
    SourceTable = "Payroll Entry";
    SourceTableView = SORTING("Document No.", "Employee No.", "Item Code");

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Document No."; "Document No.")
                {
                }
                field("Document Date"; "Document Date")
                {
                }
                field(Rate; Rate)
                {
                }
                field(Basis; Basis)
                {
                }
                field("Employee No."; "Employee No.")
                {
                }
                field("Item Code"; "Item Code")
                {
                }
                field("Item Description"; "Item Description")
                {
                }
                field(Amount; Amount)
                {
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field("Account No."; "Account No.")
                {
                    Visible = false;
                }
                field("Bal. Account No."; "Bal. Account No.")
                {
                    Visible = false;
                }
                field("User ID"; "User ID")
                {
                }
                field("Entry No."; "Entry No.")
                {
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                }
                field("Lending Code"; "Lending Code")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Ent&ry")
            {
                CaptionML = ENU = 'Ent&ry',
                            FRA = 'E&criture';
                Image = Entry;
                action(Dimensions)
                {
                    CaptionML = ENU = 'Dimensions',
                                FRA = 'A&xes analytiques';
                    Image = Dimensions;
                    RunObject = Page 479;
                    RunPageLink = "Dimension Set ID" = FIELD("Dimension Set ID");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action("Prets MAJ")
                {
                    Image = Prepayment;

                    trigger OnAction();
                    begin
                        pret := '004/2017';
                        EmplCode := 'ak2021';
                        "payroll entries".RESET;
                        "payroll entries".SETFILTER("payroll entries"."Employee No.", EmplCode);
                        "payroll entries".SETFILTER("Item Code", '860');
                        IF "payroll entries".FINDFIRST THEN BEGIN
                            REPEAT
                                "payroll entries"."Lending Code" := pret;
                                "payroll entries".MODIFY
                           UNTIL "payroll entries".NEXT = 0
                        END
                    end;
                }
            }
        }
    }



    var
        pret: Code[10];
        "payroll entries": Record "Payroll Entry";
        EmplCode: Code[10];

}

