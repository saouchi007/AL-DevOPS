/// <summary>
/// Page Lending Card (ID 52182572).
/// </summary>
page 52182572 "Lending Card"
{
    // version HALRHPAIE.6.1.01

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Mars 2010
    // 01 : Cloisonnement par direction

    Caption = 'Fiche de prêt';
    PageType = Card;
    SourceTable = Lending;

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                field("No."; "No.")
                {

                    trigger OnAssistEdit();
                    begin
                        IF AssistEdit(xRec) THEN
                            CurrPage.UPDATE;
                    end;
                }
                field("Lending Type"; "Lending Type")
                {
                }
                field("Employee No."; "Employee No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Grant Date"; "Grant Date")
                {
                }
                field("End Date"; "End Date")
                {
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                }
                field("Deduct From Payroll"; "Deduct From Payroll")
                {
                }
                field("Lending Amount"; "Lending Amount")
                {
                }
                field("Refund Calculation"; "Refund Calculation")
                {
                }
                field("Monthly Amount"; "Monthly Amount")
                {
                }
                field(Period; Period)
                {
                }
                field("Previous Refund"; "Previous Refund")
                {
                }
                field("Total Refund"; "Total Refund")
                {

                    trigger OnDrillDown();
                    begin
                        EcriturePaie.RESET;
                        EcriturePaie.SETRANGE("Employee No.", "Employee No.");
                        EcriturePaie.SETRANGE("Item Code", "Lending Deduction (Capital)");
                        //EcriturePaie.SETFILTER("Document Date",'%1..%2',"Grant Date","End Date");
                        PAGE.RUNMODAL(51495, EcriturePaie);
                    end;
                }
                field("No. of Monthly Payments"; "No. of Monthly Payments")
                {

                    trigger OnDrillDown();
                    begin
                        EcriturePaie.RESET;
                        EcriturePaie.SETRANGE("Employee No.", "Employee No.");
                        EcriturePaie.SETRANGE("Item Code", "Lending Deduction (Capital)");
                        //EcriturePaie.SETFILTER("Document Date",'%1..%2',"Grant Date","End Date");
                        PAGE.RUNMODAL(51495, EcriturePaie);
                    end;
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field(Status; Status)
                {
                }
                field(Solde; "Lending Amount" - "Total Refund" - "Previous Refund")
                {
                }
                field(Total_Lending_Refund; "Total Refund for landing")
                {
                }
                field(Lending_Balance; "Lending Amount" - "Total Refund for landing" - "Previous Refund")
                {
                    Caption = 'Solde du Prêt';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Lending)
            {
                CaptionML = ENU = 'Lending',
                            FRA = '&Prêt';
                action("Co&mmentaires")
                {
                    Caption = 'Co&mmentaires';
                    RunObject = Page 5222;
                    RunPageLink = "Table Name" = CONST(5),
                                  "No." = FIELD("No.");
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        //Calcul de total rembourssements
        mount := 0;
        EcriturePaie.RESET;
        EcriturePaie.SETRANGE("Item Code", "Lending Deduction (Capital)");
        EcriturePaie.SETRANGE("Employee No.", "Employee No.");
        IF EcriturePaie.FINDFIRST THEN
            REPEAT
                mount := mount + EcriturePaie.Amount;
            UNTIL EcriturePaie.NEXT <= 0;
        "Total Refund" := 0 - mount;
    end;

    trigger OnOpenPage();
    begin

        //---01---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text01);
        IF ParamUtilisateur."Company Business Unit" <> '' THEN BEGIN
            Direction.GET(ParamUtilisateur."Company Business Unit");
            IF ParamUtilisateur."Company Business Unit" = '' THEN
                ERROR(Text02);
            FILTERGROUP(2);
            SETRANGE("Company Business Unit Code", ParamUtilisateur."Company Business Unit");
            FILTERGROUP(0);
        END;
        //+++01+++
    end;

    var
        ParamUtilisateur: Record 91;
        Direction: Record "Company Business Unit";
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        EcriturePaie: Record "Payroll Entry";
        ParamRH: Record 5218;
        NoSeriesMgt: Codeunit 396;
        solde: Decimal;
        mount: Decimal;

}

