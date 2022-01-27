/// <summary>
/// PageExtension Emp Page (ID 52182424) extends Record Employee List.
/// </summary>
pageextension 52182424 "Emp Page" extends "Employee List"
{
    layout
    {
        addafter("Middle Name")
        {
            field("Structure Description"; Rec."Structure Description")
            {
                ApplicationArea = All;
            }
        }
        modify("Middle Name")
        {
            Visible = true;

        }
        moveafter("No."; "Last Name")

        addafter("Structure Description")
        {
            field(Address; Rec.Address)
            {
                ApplicationArea = All;
            }
        }
        addafter("Job Title")
        {
            field("Function Code"; Rec."Function Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Function Code")
        {
            field("Employment Date Init"; Rec."Employment Date Init")
            {
                ApplicationArea = All;
            }
        }
        addafter("Employment Date Init")
        {
            field("Birth Date"; Rec."Birth Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Birth Date")
        {
            field("Section Index"; Rec."Section Index")
            {
                ApplicationArea = All;
            }
        }
        addafter("Section Index")
        {
            field("Grounds for Term. Code"; Rec."Grounds for Term. Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Grounds for Term. Code")
        {
            field("Address 2"; Rec."Address 2")
            {
                ApplicationArea = All;
            }
        }
        addafter("Address 2")
        {
            field("Birthplace City"; rec."Birthplace City")
            {
                ApplicationArea = All;
            }
        }
        addafter("Birthplace City")
        {
            field("Employer Cotisation %"; rec."Employer Cotisation %")
            {
                ApplicationArea = All;
            }
        }
        addafter("Employer Cotisation %")
        {
            field("Birthplace Wilaya Description"; rec."Birthplace Wilaya Description")
            {
                ApplicationArea = All;
            }
        }
        addafter("Birthplace Wilaya Description")
        {
            field("Birthplace Wilaya Code"; rec."Birthplace Wilaya Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Birthplace Wilaya Code")
        {
            field("No. of Children"; rec."No. of Children")
            {
                ApplicationArea = All;
            }
        }
        addafter("No. of Children")
        {
            field("Termination Date"; rec."Termination Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Termination Date")
        {
            field(Status; rec.Status)
            {
                ApplicationArea = All;
            }
        }
        addafter(Status)
        {
            field("Marital Status"; rec."Marital Status")
            {
                ApplicationArea = All;
            }
        }
        addafter("Marital Status")
        {
            field(DateFinPEss; rec.DateFinPEss)
            {
                ApplicationArea = All;
            }
        }
        addafter(DateFinPEss)
        {
            field(UserPay; rec.UserPay)
            {
                ApplicationArea = All;
            }
        }
        addafter(UserPay)
        {
            field(StatutPay; rec.StatutPay)
            {
                ApplicationArea = All;
            }
        }
        addafter(StatutPay)
        {
            field("Emplymt. Contract Code"; rec."Emplymt. Contract Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Emplymt. Contract Code")
        {
            field("Section Grid Class"; rec."Section Grid Class")
            {
                ApplicationArea = All;
            }
        }
        addafter("Section Grid Class")
        {
            field("Section Grid Section"; rec."Section Grid Section")
            {
                ApplicationArea = All;
            }
        }
        addafter("Section Grid Section")
        {
            field("Section Grid Level"; rec."Section Grid Level")
            {
                ApplicationArea = All;
            }
        }
        addafter("Section Grid Level")
        {
            field("Payroll Bank Account No"; rec."Payroll Bank Account No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Payroll Bank Account No")
        {
            field("RIB Key"; rec."RIB Key")
            {
                ApplicationArea = All;
            }
        }
        addafter("RIB Key")
        {
            field("CCP N"; rec."CCP N")
            {
                ApplicationArea = All;
            }
        }
        addafter("CCP N")
        {
            field("Employment Date"; rec."Employment Date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Employment Date")
        {
            field("Social Security No."; rec."Social Security No.")
            {
                ApplicationArea = All;
            }
        }

        modify("Post Code")
        {
            Visible = true;
        }
        moveafter("Social Security No."; "Post Code")

        modify("Country/Region Code")
        {
            Visible = true;
        }
        moveafter("Post Code"; "Country/Region Code")

        addafter("Country/Region Code")
        {
            field(Regime; rec.Regime)
            {
                ApplicationArea = All;
            }
        }

        modify(Extension)
        {
            Visible = true;
        }
        moveafter(Regime; Extension)

        modify("Phone No.")
        {
            Visible = true;
        }
        moveafter(Extension; "Phone No.")

        modify("Mobile Phone No.")
        {
            Visible = true;
        }
        moveafter("Phone No."; "Mobile Phone No.")

        modify("E-Mail")
        {
            Visible = true;
        }
        moveafter("Mobile Phone No."; "E-Mail")

        modify("Statistics Group Code")
        {
            Visible = true;
        }
        moveafter("E-Mail"; "Statistics Group Code")

        modify("Resource No.")
        {
            Visible = true;
        }
        moveafter("Statistics Group Code"; "Resource No.")

        moveafter("Resource No."; "Search Name")

        addafter(Comment)
        {
            field("Company Business Unit Code"; "Company Business Unit Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Company Business Unit Code")
        {
            field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Global Dimension 1 Code")
        {
            field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
        }
        addafter("Global Dimension 2 Code")
        {
            field("Previous IEP"; rec."Previous IEP")
            {
                ApplicationArea = All;
            }
        }
        addafter("Previous IEP")
        {
            field("Current IEP"; rec."Current IEP")
            {
                ApplicationArea = All;
            }
        }
        addafter("Current IEP")
        {
            field("Socio-Professional Category"; rec."Socio-Professional Category")
            {
                ApplicationArea = All;
            }
        }
        addafter("Socio-Professional Category")
        {
            field(Gender; rec.Gender)
            {
                ApplicationArea = All;
            }
        }
        addfirst(factboxes)
        {
            part(Image; "Employee Picture")
            {
                ApplicationArea = All;
            }

        }

        //movefirst(Control1;"First Name")
    }
    actions
    {
        addafter("A&bsences")
        {
            action("Visites médicales du salariés")
            {
                Image = PostInventoryToGL;

                RunObject = Page "Examination Registration";
                RunPageLink = "Employee No." = FIELD("No.");
            }

        }
        addfirst("E&mployee")
        {
            action("&Card")
            {
                CaptionML = ENU = '&Card',
                                FRA = 'Fiche';
                Image = EditLines;
                RunObject = Page 5200;
                RunPageLink = "No." = FIELD("No.");
                ShortCutKey = 'Shift+F5';
            }
        }
    }
}