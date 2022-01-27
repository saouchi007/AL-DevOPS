/// <summary>
/// Page Payroll Archive List (ID 52182531).
/// </summary>
page 52182531 "Payroll Archive List"
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Payroll Archive List',
                FRA = 'Liste des paies archivées';
    CardPageID = "Payroll Archive";
    Editable = false;
    PageType = List;
    SourceTable = "Payroll Archive Header";
    SourceTableView = SORTING("Payroll Code", "No.")
                      ORDER(Descending);

    layout
    {
        area(content)
        {
            repeater(new)
            {
                field("Payroll Code"; "Payroll Code")
                {
                }
                field("No."; "No.")
                {
                }
                field("First Name"; "First Name")
                {
                }
                field("Middle Name"; "Middle Name")
                {
                }
                field("Last Name"; "Last Name")
                {
                }
                field(Initials; Initials)
                {
                }
                field("Function Description"; "Function Description")
                {
                }
                field(Address; Address)
                {
                }
                field("Address 2"; "Address 2")
                {
                }
                field(City; City)
                {
                }
                field("Post Code"; "Post Code")
                {
                }
                field(County; County)
                {
                }
                field("Social Security No."; "Social Security No.")
                {
                }
                field("Union Code"; "Union Code")
                {
                }
                field("Union Membership No."; "Union Membership No.")
                {
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                }
                field("Emplymt. Contract Type Code"; "Emplymt. Contract Type Code")
                {
                }
                field("Statistics Group Code"; "Statistics Group Code")
                {
                }
                field("Employment Date"; "Employment Date")
                {
                }
                field(Status; Status)
                {
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                }
                field(Comment; Comment)
                {
                }
                field("Marital Status"; "Marital Status")
                {
                }
                field("Company Business Unit Code"; "Company Business Unit Code")
                {
                }
                field("Section Grid Class"; "Section Grid Class")
                {
                }
                field("Section Grid Section"; "Section Grid Section")
                {
                }
                field("Section Grid Level"; "Section Grid Level")
                {
                }
                field("Payroll Bank Account"; "Payroll Bank Account")
                {
                }
                field("RIB Key"; "RIB Key")
                {
                }
                field("Structure Code"; "Structure Code")
                {
                }
                field("Total Advance"; "Total Advance")
                {
                }
                field("Payroll Bank Account No."; "Payroll Bank Account No.")
                {
                }
                field(Sanctioned; Sanctioned)
                {
                }
                field("Total Overtime (Base)"; "Total Overtime (Base)")
                {
                }
                field("Military Situation"; "Military Situation")
                {
                }
                field("Payroll Template No."; "Payroll Template No.")
                {
                }
                field("Total Recovery (Base)"; "Total Recovery (Base)")
                {
                }
                field("Function Code"; "Function Code")
                {
                }
                field("Structure Description"; "Structure Description")
                {
                }
                field("Total Medical Refund"; "Total Medical Refund")
                {
                }
                field(Confirmed; Confirmed)
                {
                }
                field("Total Leave (Base)"; "Total Leave (Base)")
                {
                }
                field("Socio-Professional Category"; "Socio-Professional Category")
                {
                }
                field("Confirmation Date"; "Confirmation Date")
                {
                }
                field("No. of Children"; "No. of Children")
                {
                }
                field("Authorised Days Absence"; "Authorised Days Absence")
                {
                }
                field("Unauthorised Days Absence"; "Unauthorised Days Absence")
                {
                }
                field("Authorised Hours Absence"; "Authorised Hours Absence")
                {
                }
                field("Unauthorised Hours Absence"; "Unauthorised Hours Absence")
                {
                }
                field("Total Family Allowance Contr."; "Total Family Allowance Contr.")
                {
                }
                field("Total Union Contr."; "Total Union Contr.")
                {
                }
                field("Hourly Index Grid Function No."; "Hourly Index Grid Function No.")
                {
                }
                field("Hourly Index Grid Function"; "Hourly Index Grid Function")
                {
                }
                field("Hourly Index Grid CH"; "Hourly Index Grid CH")
                {
                }
                field("Hourly Index Grid Index"; "Hourly Index Grid Index")
                {
                }
                field("Payroll Type Code"; "Payroll Type Code")
                {
                }
                field("Payment Method Code"; "Payment Method Code")
                {
                }
                field("Leave Indemnity Amount"; "Leave Indemnity Amount")
                {
                }
                field("Leave Indemnity No."; "Leave Indemnity No.")
                {
                }
            }
        }
    }

    actions
    {
    }


}

