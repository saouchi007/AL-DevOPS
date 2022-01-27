/// <summary>
/// Page Payroll Bank Account Card (ID 52182540).
/// </summary>
page 52182540 "Payroll Bank Account Card"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Bank Account Card',
                FRA = 'Fiche compte bancaire paie';
    PageType = Card;
    SourceTable = "Payroll Bank Account";

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU = 'General',
                            FRA = 'Général';
                field(Code; Code)
                {
                }
                field(Name; Name)
                {
                }
                field("Name 2"; "Name 2")
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field("Post Code"; "Post Code")
                {
                    CaptionML = ENU = 'Post Code/City',
                                FRA = 'CP/Ville';
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field(Contact; Contact)
                {
                }
                field(City; City)
                {
                }
                field("Currency Code"; "Currency Code")
                {
                }
                field("Bank Branch No."; "Bank Branch No.")
                {
                }
                field("Agency Code"; "Agency Code")
                {
                }
                field("E-Mail"; "E-Mail")
                {
                }
                field("No. of Domiciliated Employees"; "No. of Domiciliated Employees")
                {
                }
            }
            group(Communication)
            {
                CaptionML = ENU = 'Communication',
                            FRA = 'Communication';
                field("Fax No."; "Fax No.")
                {
                }
                field("Home Page"; "Home Page")
                {
                }
            }
        }
    }

    actions
    {
    }


    var
        Mail: Codeunit 397;

}

