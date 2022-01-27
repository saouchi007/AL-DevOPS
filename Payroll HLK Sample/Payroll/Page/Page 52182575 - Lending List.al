/// <summary>
/// Page Lending List (ID 52182575).
/// </summary>
page 52182575 "Lending List"
{
    // version HALRHPAIE.6.1.01

    // HALKORB - CGMP cloisonnement par direction - F.HAOUS - Mars 2010
    // 01 : Cloisonnement par direction

    CardPageID = "Lending Card";
    Editable = false;
    PageType = List;
    SourceTable = Lending;

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("No."; "No.")
                {
                }
                field("Employee No."; "Employee No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field(Status; Status)
                {
                }
                field("No. of Monthly Payments"; "No. of Monthly Payments")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field("Lending Amount"; "Lending Amount")
                {
                }
                field("Grant Date"; "Grant Date")
                {
                }
                field("Monthly Amount"; "Monthly Amount")
                {
                }
                field("Previous Refund"; "Previous Refund")
                {
                }
                field("Total Refund"; "Total Refund")
                {
                }
                field("End Date"; "End Date")
                {
                }
                field("No. Series"; "No. Series")
                {
                }
                field("Last Date Modified"; "Last Date Modified")
                {
                }
                field("Refund Calculation"; "Refund Calculation")
                {
                }
                field(Period; Period)
                {
                }
                field("Lending Type"; "Lending Type")
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
    }

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

}

