/// <summary>
/// PageExtension Emp Card (ID 55200) extends Record Employee Card.
/// </summary>
pageextension 52182423 "Emp Card" extends "Employee Card"
{

    //PromotedActionCategoriesML = FRA = 'Gérer,Page,  ',
    //                          ENU = 'Gérer,Page, ';
    layout
    {
        // ***************************** Général ****************************

        modify("Job Title")
        {
            Visible = true;

        }
        moveafter("No."; "Job Title")
        moveafter("Job Title"; "First Name")
        moveafter("First Name"; "Last Name")
        moveafter("Last Name"; "Middle Name")

        movelast(General; Address)
        movelast(General; "Address 2")
        movelast(General; "Post Code")
        movelast(General; City)
        movelast(General; "Country/Region Code")
        addlast(General)
        {
            field("Total Absence (Base)"; rec."Total Absence (Base)")
            {
                ApplicationArea = All;
                Importance = Promoted;
            }

        }
        addlast(General)
        {
            field("Last Modified Date Time"; rec."Last Modified Date Time")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Total Absence (Base)"; "Search Name")
        moveafter("Search Name"; Gender)

        // ***************************** Communicaiton ****************************
        modify("Address & Contact")
        {
            CaptionML = ENU = 'Communication',
                            FRA = 'Communication';
            Visible = True;
        }

        modify(Extension)
        {
            Visible = true;
        }
        movelast("Address & Contact"; Extension)

        modify("Mobile Phone No.") { Visible = true; }
        movelast("Address & Contact"; "Mobile Phone No.")

        modify("Phone No.") { Visible = true; }
        movelast("Address & Contact"; "Phone No.")

        modify("E-Mail") { Visible = true; }
        movelast("Address & Contact"; "E-Mail")

        modify("Company E-Mail") { Visible = true; }
        movelast("Address & Contact"; "Company E-Mail")

        modify(Pager) { Visible = false; }
        moveafter("Company E-Mail"; "Alt. Address Code")
        moveafter("Company E-Mail"; "Alt. Address Start Date")
        moveafter("Company E-Mail"; "Alt. Address End Date")
        modify(ShowMap) { Visible = false; }


        // ***************************** Administration ****************************
        addlast(Administration)
        {
            field("Employment Date Init"; rec."Employment Date Init")
            {
                ApplicationArea = all;
                Style = Strong;
                StyleExpr = TRUE;
            }
        }
        addlast(Administration)
        {
            field("Date Taking Office"; rec."Date Taking Office")
            {
                ApplicationArea = all;
            }
        }
        addlast(Administration)
        {
            field("Function Code"; rec."Function Code")
            {
                ApplicationArea = all;
            }
        }
        addlast(Administration)
        {
            field("Degree Code"; rec."Degree Code")
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
        addlast(Administration)
        {
            field("Degree Description"; rec."Degree Description")
            {
                ApplicationArea = all;
                Visible = true;
            }
        }
        addlast(Administration)
        {
            field("Structure Code"; rec."Structure Code")
            {
                ApplicationArea = all;
            }
        }
        addlast(Administration)
        {
            field("Structure Description"; rec."Structure Description")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
        addlast(Administration)
        {
            field("Company Business Unit Code"; "Company Business Unit Code")
            {
                ApplicationArea = all;
                //Editable = false;
            }
        }
        addlast(Administration)
        {
            field("Antenna Code"; rec."Antenna Code")
            {
                ApplicationArea = all;
            }
        }
        addlast(Administration)
        {
            field("Socio-Professional Category"; rec."Socio-Professional Category")
            {
                ApplicationArea = all;
            }
        }
        addlast(Administration)
        {
            field(DateFinPEss; rec.DateFinPEss)
            {
                ApplicationArea = all;
            }
        }
        addlast(Administration)
        {
            field(Confirmed; rec.Confirmed)
            {
                ApplicationArea = all;
            }
        }
        addlast(Administration)
        {
            field("Confirmation Date"; rec."Confirmation Date")
            {
                ApplicationArea = all;
            }
        }
        addlast(Administration)
        {
            field("Confirmation Decision No."; rec."Confirmation Decision No.")
            {
                ApplicationArea = all;
            }
        }
        addlast(Administration)
        {
            field(Dateexit; rec.Dateexit)
            {
                ApplicationArea = all;
            }
        }
        addlast(Administration)
        {
            field("No. of Fixed Assets"; rec."No. of Fixed Assets")
            {
                ApplicationArea = all;
            }
        }
        moveafter("Socio-Professional Category"; Status)
        modify("Inactive Date") { Visible = false; }
        modify("Cause of Inactivity Code") { Visible = false; }
        moveafter("Confirmation Decision No."; "Termination Date")
        moveafter(Status; "Emplymt. Contract Code")
        moveafter("No. of Fixed Assets"; "Statistics Group Code")
        moveafter("Statistics Group Code"; "Resource No.")
        moveafter("Resource No."; "Salespers./Purch. Code")
        moveafter(Dateexit; "Grounds for Term. Code")

        // ***************************** Personnel ****************************
        addlast(Personal)
        {
            field("Présumé"; rec."Présumé")
            {
                ApplicationArea = all;

            }
        }
        addlast(Personal)
        {
            field("Birthplace Post Code"; rec."Birthplace Post Code")
            {
                ApplicationArea = all;
                CaptionML = ENU = 'Post Code/City Birthplace',
                            FRA = 'CP/Ville Lieu de naissance';

            }
        }
        addlast(Personal)
        {
            field("Birthplace City"; rec."Birthplace City")
            {
                ApplicationArea = all;
                ShowMandatory = true;
            }
        }
        addlast(Personal)
        {
            field("Birthplace Wilaya Code"; rec."Birthplace Wilaya Code")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("Birthplace Wilaya Description"; rec."Birthplace Wilaya Description")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
        addlast(Personal)
        {
            field("Military Situation"; rec."Military Situation")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("No. of Children"; rec."No. of Children")
            {
                ApplicationArea = all;
                Editable = true;
            }
        }
        addlast(Personal)
        {
            field("Marriage Date"; rec."Marriage Date")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("Marriage Post Code"; rec."Marriage Post Code")
            {
                ApplicationArea = all;
                Caption = 'CP/Ville Lieu de mariage';
            }
        }
        addlast(Personal)
        {
            field("Marriage City"; rec."Marriage City")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("Prénom du père"; rec."Prénom du père")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("Nom de la mère"; rec."Nom de la mère")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("Prénom de la mère"; rec."Prénom de la mère")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("Husband/Wife Function"; rec."Husband/Wife Function")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field(Etranger; rec.Etranger)
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("Nationality Code"; rec."Nationality Code")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("Post Code CACOBATPH"; rec."Post Code CACOBATPH")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("Blood Group"; rec."Blood Group")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field(Rhesus; rec.Rhesus)
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("Driving License"; rec."Driving License")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("Driving License Date"; rec."Driving License Date")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("N° Carte identité nationale"; rec."N° Carte identité nationale")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("N° Identification National"; rec."N° Identification National")
            {
                ApplicationArea = all;
            }
        }
        addlast(Personal)
        {
            field("N° acte de naissance"; rec."N° acte de naissance")
            {
                ApplicationArea = all;

            }
        }
        moveafter("Husband/Wife Function"; "Social Security No.")
        moveafter("Social Security No."; "Union Code")
        moveafter("Union Code"; "Union Membership No.")
        moveafter("Military Situation"; "Marital Status")

        // ***************************** Paiement ****************************
        addlast(Payments)
        {
            group(Control1000000093)
            {
                Caption = 'Grille par sections :';
                field("Section Grid Class"; rec."Section Grid Class") { ApplicationArea = all; }
                field("Section Grid Section"; rec."Section Grid Section") { ApplicationArea = all; }
                field("Section Grid Level"; rec."Section Grid Level") { ApplicationArea = all; }
                field("Section Index"; rec."Section Index") { ApplicationArea = all; }
            }

            group("Hourly Index Grid")
            {
                CaptionML = ENU = 'Hourly Index Grid',
                                FRA = 'Grille par indices horaires : ';
                field("Hourly Index Grid Function No."; rec."Hourly Index Grid Function No.")
                {

                    trigger OnValidate();
                    begin
                        IF "Hourly Index Grid Function No." <> 0 THEN BEGIN
                            TraiSection.GET("Hourly Index Grid Function No.");
                            IF "Hourly Index Grid Index" = 1 THEN "Base salary" := TraiSection."Section 1";
                            IF "Hourly Index Grid Index" = 2 THEN "Base salary" := TraiSection."Section 2";
                            IF "Hourly Index Grid Index" = 3 THEN "Base salary" := TraiSection."Section 3";
                            IF "Hourly Index Grid Index" = 4 THEN "Base salary" := TraiSection."Section 4";
                            IF "Hourly Index Grid Index" = 5 THEN "Base salary" := TraiSection."Section 5";
                            IF "Hourly Index Grid Index" = 6 THEN "Base salary" := TraiSection."Section 6";
                            IF "Hourly Index Grid Index" = 7 THEN "Base salary" := TraiSection."Section 7";
                            IF "Hourly Index Grid Index" = 8 THEN "Base salary" := TraiSection."Section 8";
                            IF "Hourly Index Grid Index" = 9 THEN "Base salary" := TraiSection."Section 9";
                        END
                        ELSE BEGIN
                            "Base salary" := 0;
                        END;
                    end;
                }
                field("Hourly Index Grid Function"; rec."Hourly Index Grid Function")
                {
                    Editable = false;
                }
                field("Hourly Index Grid CH"; rec."Hourly Index Grid CH")
                {
                    Editable = false;
                }
                field("Hourly Index Grid Index"; rec."Hourly Index Grid Index")
                {

                    trigger OnValidate();
                    begin
                        IF "Hourly Index Grid Function No." <> 0 THEN BEGIN
                            TraiSection.GET("Hourly Index Grid Function No.");
                            IF "Hourly Index Grid Index" = 1 THEN "Base salary" := TraiSection."Section 1";
                            IF "Hourly Index Grid Index" = 2 THEN "Base salary" := TraiSection."Section 2";
                            IF "Hourly Index Grid Index" = 3 THEN "Base salary" := TraiSection."Section 3";
                            IF "Hourly Index Grid Index" = 4 THEN "Base salary" := TraiSection."Section 4";
                            IF "Hourly Index Grid Index" = 5 THEN "Base salary" := TraiSection."Section 5";
                            IF "Hourly Index Grid Index" = 6 THEN "Base salary" := TraiSection."Section 6";
                            IF "Hourly Index Grid Index" = 7 THEN "Base salary" := TraiSection."Section 7";
                            IF "Hourly Index Grid Index" = 8 THEN "Base salary" := TraiSection."Section 8";
                            IF "Hourly Index Grid Index" = 9 THEN "Base salary" := TraiSection."Section 9";
                        END
                        ELSE BEGIN
                            "Base salary" := 0;
                        END;
                    end;
                }

                field("Base salary"; rec."Base salary") { ApplicationArea = all; Editable = true; }
                field("Do not Use Treatment Grid"; rec."Do not Use Treatment Grid") { ApplicationArea = all; }
                field(Regime; rec.Regime) { ApplicationArea = all; }
                field("Employer Cotisation %"; rec."Employer Cotisation %") { ApplicationArea = all; }
                field("Payment Method Code"; rec."Payment Method Code") { ApplicationArea = all; }
                field("Payroll Bank Account"; rec."Payroll Bank Account") { ApplicationArea = all; }
                field("Payroll Bank Account No"; rec."Payroll Bank Account No.") { ApplicationArea = all; }
                field("RIB Key"; rec."RIB Key") { ApplicationArea = all; }
                field("CCP N"; rec."CCP N") { ApplicationArea = all; }
                field("Previous IEP"; rec."Previous IEP") { ApplicationArea = all; }
                field("Current IEP"; rec."Current IEP") { ApplicationArea = all; Editable = false; }
            }

            group(IRG)
            {
                Caption = 'IRG :';
                field("Regime IRG"; rec."Regime IRG") { ApplicationArea = all; }
                field("Grand Sud"; rec."Grand Sud") { ApplicationArea = all; }

            }

            group(Control1000000140)
            {
                CaptionML = ENU = 'Section grid : ',
                                FRA = 'Analytique : ';
                field("Global Dimension 1 Code"; rec."Global Dimension 1 Code")
                {
                    ApplicationArea = all;
                    Caption = '"Axe de paie 1 : "';
                }
                field("Global Dimension 2 Code"; rec."Global Dimension 2 Code")
                {
                    ApplicationArea = all;
                    Caption = '"Axe de paie 2 : "';
                }
            }

        }
        modify(IBAN) { Visible = false; }
        modify("SWIFT Code") { Visible = false; }
        modify("Bank Account No.") { Visible = false; }
        modify("Bank Branch No.") { Visible = false; }
        modify("Application Method") { Visible = false; }
        modify("Employee Posting Group") { Visible = false; }


        addlast(content)
        {
            group(Control1000000078)
            {
                CaptionML = ENU = 'Payroll',
                            FRA = 'Congé & Récupération';
                group(Control1000000076)
                {
                    CaptionML = ENU = 'Section grid : ',
                                FRA = 'Congé :';
                    field("Total Leave Indem. Amount"; rec."Total Leave Indem. Amount") { ApplicationArea = all; }
                    field("Total Leave Indem. No."; rec."Total Leave Indem. No.") { ApplicationArea = all; }
                    field("Consumed Leave Days"; rec."Consumed Leave Days") { ApplicationArea = all; }
                }
                group(Control1000000069)
                {
                    CaptionML = ENU = 'Hourly Index Grid',
                                FRA = 'Récupération  :';
                    field("Total droit"; rec."Total droit") { ApplicationArea = all; }
                    field("Total Recovery (Base)"; rec."Total Recovery (Base)")
                    {
                        ApplicationArea = all;
                        CaptionML = ENU = 'Total Recovery (Base)',
                                    FRA = 'Total Récupération';
                    }
                    field(Reste; rec."Total droit" - rec."Total Recovery (Base)") { ApplicationArea = all; }
                }
            }
        }




    }


    actions
    {

        modify(PayEmployee) { Visible = false; }
        modify("Ledger E&ntries") { Visible = false; }
        modify(Attachments) { Visible = false; }
        modify(Contact) { Visible = false; }

        addafter("Q&ualifications")
        {
            action("&Diplomas")
            {
                CaptionML = ENU = '&Diplomas',
                                FRA = 'Diplômes';
                Image = DocumentsMaturity;
                RunObject = Page "Employee Diplomas";
                //RunObject = page 12;
            }
        }

        addafter("A&bsences")
        {
            action("Récupérations")
            {
                Caption = 'Récupérations';
                Image = AbsenceCalendar;
                RunObject = Page "Employee Recoveries";
                //RunObject = page 12;
            }
            action("Indisponibilités")
            {
                Caption = 'Indisponibilités';
                Image = AbsenceCalendar;
                RunObject = Page "Employee Unavailabilities";
                //RunObject = page 12;
            }
            action(Leaves)
            {
                CaptionML = ENU = 'Leaves',
                                FRA = 'Congés';
                Image = AbsenceCalendar;
                RunObject = Page "Employee Leaves";
                //RunObject = page 12;
            }
        }
        addafter("Co&nfidential Info. Overview")
        {
            action("Visites médicales")
            {
                Caption = 'Visites médicales';
                Image = PostInventoryToGL;
                RunObject = Page "Employee Examinations";
                //RunObject = page 12;
            }
            action("Accidents de travail")
            {
                Caption = 'Accidents de travail';
                Image = EnableBreakpoint;
                RunObject = Page "Employee Accidents";
                //RunObject = page 12;
            }
        }


        addlast(navigation)
        {
            group("&Training")
            {
                CaptionML = ENU = '&Training',
                            FRA = '&Formation';
                Image = Language;
                action("&Training Requests")
                {
                    CaptionML = ENU = '&Training Requests',
                                FRA = '&Demandes de formation';
                    RunObject = Page "Training Entries";
                    Image = SendApprovalRequest;
                    //RunObject = page 12;

                }
            }
            group("&Career")
            {
                CaptionML = ENU = '&Career',
                            FRA = '&Carrière';
                Image = CalendarMachine;
                action("&Assignements")
                {
                    CaptionML = ENU = '&Assignements',
                                FRA = '&Affectations';
                    RunObject = Page "Employee Assignment List";
                    RunPageLink = "Employee No." = FIELD("No.");
                    //RunObject = page 12;
                    Image = Description;
                }
                action("&Misconducts")
                {
                    CaptionML = ENU = '&Misconducts',
                                FRA = '&Fautes';
                    RunObject = Page "Employee Sanctions";
                    //RunObject = page 12;
                    Image = FaultDefault;
                }

                action("&Employment Contracts")
                {
                    CaptionML = ENU = '&Employment Contracts',
                                FRA = '&Contrats de travail';
                    RunObject = Page "Employee Contract List";
                    //RunObject = page 12;
                    Image = FileContract;
                }
                action("&Fulfilled Functions")
                {
                    CaptionML = ENU = '&Fulfilled Functions',
                                FRA = '&Fonctions occupées';
                    RunObject = Page "Fulfilled Function List";
                    //RunObject = page 12;
                    Image = Job;
                }

                action("Mettre à jour la fiche salarié")
                {
                    Caption = 'Mettre à jour la fiche salarié';
                    //RunObject = page 12;
                    Image = UpdateXML;
                    trigger OnAction();
                    begin
                        //---02---
                        ParamPaie.GET;
                        AffectationSalarie.RESET;
                        AffectationSalarie.SETRANGE("Employee No.", "No.");
                        IF NOT AffectationSalarie.FINDLAST THEN
                            ERROR(Text04);
                        IF AffectationSalarie."Post Code" = '' THEN
                            ERROR(Text06, AffectationSalarie.FIELDCAPTION("Post Code"));
                        IF AffectationSalarie."Structure No." = '' THEN
                            ERROR(Text06, AffectationSalarie.FIELDCAPTION("Structure No."));
                        IF AffectationSalarie."Function Code" = '' THEN
                            ERROR(Text06, AffectationSalarie.FIELDCAPTION("Function Code"));
                        IF AffectationSalarie."Starting Date" = 0D THEN
                            ERROR(Text06, AffectationSalarie.FIELDCAPTION("Starting Date"));
                        IF AffectationSalarie.Class = '' THEN
                            ERROR(Text06, AffectationSalarie.FIELDCAPTION(Class));
                        IF AffectationSalarie.Section = '' THEN
                            ERROR(Text06, AffectationSalarie.FIELDCAPTION(Section));
                        IF AffectationSalarie.Level = '' THEN
                            ERROR(Text06, AffectationSalarie.FIELDCAPTION(Level));
                        IF CONFIRM(Text05) THEN BEGIN
                            VALIDATE("Degree Code", AffectationSalarie."Post Code");
                            VALIDATE("Structure Code", AffectationSalarie."Structure No.");
                            VALIDATE("Function Code", AffectationSalarie."Function Code");
                            VALIDATE("Date Taking Office", AffectationSalarie."Starting Date");
                            VALIDATE(Dateexit, AffectationSalarie."Ending Date");
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::Sections THEN BEGIN
                                VALIDATE("Section Grid Class", AffectationSalarie.Class);
                                EVALUATE(Valeur, AffectationSalarie.Section);
                                VALIDATE("Section Grid Section", Valeur);
                                EVALUATE(Valeur, AffectationSalarie.Level);
                                VALIDATE("Section Grid Level", Valeur);
                            END;
                            IF ParamPaie."Treatment Grid Type" = ParamPaie."Treatment Grid Type"::"Hourly Index" THEN BEGIN
                                VALIDATE("Hourly Index Grid Function", AffectationSalarie.Class);
                                VALIDATE("Hourly Index Grid CH", AffectationSalarie.Section);
                                EVALUATE(Valeur, AffectationSalarie.Level);
                                VALIDATE("Hourly Index Grid Index", Valeur);
                            END;
                            MODIFY;
                            MESSAGE(Text07);
                        END;
                        //+++02+++
                    end;
                }
            }
        }



        addlast(processing)
        {
            group("&Payroll")
            {
                CaptionML = ENU = '&Payroll',
                            FRA = '&Paie';
                Image = Payroll;
                action("Types de cotisations")
                {
                    Caption = 'Types de cotisations';
                    Image = List;
                    //RunObject = page 12;
                    RunObject = Page "Employee Cotisations";
                }
                action("&Payroll Items")
                {
                    CaptionML = ENU = '&Payroll Items',
                                FRA = '&Rubriques de paie';
                    image = Payment;
                    RunObject = Page "Employee Payroll Item";
                    RunPageLink = "Employee No." = FIELD("No.");
                    //RunObject = page 12;
                }
                action("&Unions/Insurances Subscriptions")
                {
                    CaptionML = ENU = '&Unions/Insurances Subscriptions',
                                FRA = '&Souscriptions aux mutuelles/assurances';
                    Image = Insurance;
                    RunObject = Page "Union/Insurances Subscriptions";

                    //RunObject = page 12;
                }
                action("&Leave Rights")
                {
                    CaptionML = ENU = '&Leave Rights',
                                FRA = '&Droits au congé';
                    Image = OpenWorksheet;
                    //RunObject = page 12;


                    trigger OnAction();
                    begin
                        DroitConge.RESET;
                        DroitConge.SETRANGE("Employee No.", Rec."No.");
                        IF DroitConge.FINDFIRST THEN BEGIN
                            REPEAT
                                DroitConge.CALCFIELDS("No. of Consumed Days");
                                DroitConge.Difference := DroitConge."No. of Days" - DroitConge."No. of Consumed Days";
                                DroitConge.MODIFY;
                            UNTIL DroitConge.NEXT = 0;
                            COMMIT;

                            PAGE.RUNMODAL(52182496, DroitConge);

                        END;
                    end;

                }
                action("Jours de travail")
                {
                    Caption = 'Jours de travail';
                    RunObject = Page "Employee Working Days";
                    //RunObject = page 12;
                    Image = Workdays;
                }
                action("Clauses de rémunération")
                {
                    Caption = 'Clauses de rémunération';
                    RunObject = Page "Employee Terms of Pay";
                    //RunObject = page 12;
                    Image = PaymentForecast;
                }
            }
            group(Employee)
            {
                CaptionML = ENU = 'E&mployee',
                            FRA = 'Accès rapide';
                Image = Link;

                action("&Misconducts1")
                {
                    CaptionML = ENU = '&Misconducts',
                                FRA = 'C&ongés';
                    RunObject = Page "Leave Registration";
                    //RunObject = page 12;
                    Image = Holiday;
                    ShortCutKey = 'Shift+Ctrl+C';
                }

                action("A&dvances")
                {
                    CaptionML = ENU = 'A&dvances',
                                FRA = 'Av&ances';
                    RunObject = Page "Advance Registration";
                    //RunObject = page 12;
                    Image = VendorPayment;
                    ShortCutKey = 'Shift+Ctrl+V';
                }
                action("&Overtime")
                {
                    CaptionML = ENU = '&Overtime',
                                FRA = '&Heures supp.';
                    RunObject = Page "Overtime Registration";
                    Image = ServiceHours;
                    //RunObject = page 12;

                    ShortCutKey = 'Shift+Ctrl+H';
                }
                action("F&rais de mission")
                {
                    CaptionML = FRA = 'F&rais de mission',
                                ENU = 'Versements des cotisations AF';
                    RunObject = Page "Professional Expances";
                    //RunObject = page 12;
                    Image = PostedPayableVoucher;

                    ShortCutKey = 'Shift+Ctrl+F';
                }
                action("M&utuelle")
                {
                    CaptionML = FRA = 'M&utuelle',
                                ENU = 'Versements des cotisations mutuelle';
                    RunObject = Page "Union/Insur. Subs.Registration";
                    //RunObject = page 12;
                    Image = InsuranceLedger;

                    ShortCutKey = 'Shift+Ctrl+M';
                }
                action("P&rêt")
                {
                    Caption = 'P&rêt';
                    RunObject = Page "Lending Card";
                    //RunObject = page 12;
                    Image = Prepayment;

                    ShortCutKey = 'Shift+Ctrl+P';
                }
            }
        }
        addbefore("A&dvances")
        {

            action("A&bsences_Act")
            {
                CaptionML = ENU = 'A&bsences',
                                FRA = 'A&bsences';
                RunObject = Page 5212;
                Image = AbsenceCalendar;
                ShortCutKey = 'Shift+Ctrl+B';
            }
        }
        addlast(reporting)
        {
            group("Décisions")
            {
                Image = Apply;
                CaptionML = FRA = 'Décisions',
                        ENU = 'Desisions';
                action("Décision de confirmation")
                {
                    CaptionML = FRA = 'Décision de confirmation',
                                ENU = 'Confirmation Décision';
                    Image = Confirm;
                    Visible = true;
                    //RunObject = page 12;

                    trigger OnAction();
                    begin
                        Salarie.SETRANGE(Salarie."No.", "No.");
                        REPORT.RUN(REPORT::"Decision de Confirmation", TRUE, FALSE, Salarie);
                    end;
                }
                action("Décision de promotion")
                {
                    CaptionML = FRA = 'Décision de promotion',
                     ENU = 'Decision of promotion';
                    Image = Payables;
                    Visible = true;
                    //RunObject = page 12;

                    trigger OnAction();
                    begin
                        Salarie.SETRANGE(Salarie."No.", "No.");
                        REPORT.RUN(REPORT::"Decision de Promotion", TRUE, FALSE, Salarie);
                    end;
                }
                action("Décision d'affectation")
                {
                    Caption = 'Décision d''affectation';
                    Image = GoTo;
                    Visible = true;
                    //RunObject = page 12;

                    trigger OnAction();
                    begin
                        Salarie.SETRANGE(Salarie."No.", "No.");
                        REPORT.RUN(REPORT::"Decision de réaffectation", TRUE, FALSE, Salarie);
                    end;
                }
                action("Décision de fin de fonction")
                {
                    Caption = 'Décision de fin de fonction';
                    image = Stop;
                    Visible = true;
                    //RunObject = page 12;

                    trigger OnAction();
                    begin
                        Salarie.SETRANGE(Salarie."No.", "No.");
                        REPORT.RUN(REPORT::"Decision de fin de Fonction", TRUE, FALSE, Salarie);
                    end;
                }

            }
            group(Attestations)
            {
                Caption = 'Attestations';
                Image = TestFile;
                action("Quitus de départ")
                {
                    Caption = 'Quitus de départ';
                    Image = ExportReceipt;
                    //RunObject = page 12;

                    trigger OnAction();
                    begin
                        Salarie.SETRANGE(Salarie."No.", "No.");
                        REPORT.RUN(REPORT::"Quitus de départ", TRUE, FALSE, Salarie);
                    end;
                }
                action("Attestation de travail")
                {
                    Caption = 'Attestation de travail';
                    RunPageOnRec = true;
                    Visible = true;
                    Image = JobLedger;
                    //RunObject = page 12;

                    trigger OnAction();
                    var
                        salarie: record Employee;
                    begin

                        Salarie.SETRANGE(Salarie."No.", "No.");
                        REPORT.RUN(REPORT::"Attestation de travail SPS", TRUE, true, Salarie);
                    end;
                }
                action("Certificat de travail")
                {
                    Caption = 'Certificat de travail';
                    RunPageOnRec = true;
                    Image = JobResponsibility;
                    //RunObject = page 12;

                    trigger OnAction();
                    begin
                        Salarie.SETRANGE(Salarie."No.", "No.");
                        REPORT.RUN(REPORT::"Certificat de travail SPS", TRUE, FALSE, Salarie);
                    end;
                }
                action("Ordre de mission")
                {
                    Caption = 'Ordre de mission';
                    Image = Order;
                    //RunObject = page 12;

                    trigger OnAction();
                    begin
                        Salarie.SETRANGE(Salarie."No.", "No.");
                        REPORT.RUN(REPORT::"Ordre de mission SPS", TRUE, FALSE, Salarie);
                    end;
                }
                action("Procès-Verbal installation")
                {
                    Caption = 'Procès-Verbal installation';
                    Image = Process;
                    //RunObject = page 12;

                    trigger OnAction();
                    begin
                        Salarie.SETRANGE(Salarie."No.", "No.");
                        REPORT.RUN(REPORT::"Procès-Verbal installation SPS", TRUE, FALSE, Salarie);
                    end;
                }
                action("Titre de congé")
                {
                    Caption = 'Titre de congé';
                    Image = Holiday;
                    //RunObject = page 12;

                    trigger OnAction();
                    begin
                        Salarie.SETRANGE(Salarie."No.", "No.");
                        REPORT.RUN(REPORT::"Titre de conge SPS", TRUE, FALSE, Salarie);
                    end;
                }
                group(ATS)
                {
                    Caption = 'ATS';
                    Image = AuthorizeCreditCard;
                    action("Page 1")
                    {
                        Caption = 'Page 1';
                        Image = EnableBreakpoint;
                        Visible = true;
                        //RunObject = page 12;

                        trigger OnAction();
                        begin
                            Salarie.SETRANGE(Salarie."No.", "No.");
                            REPORT.RUN(REPORT::"Déclaration ATS Page 1", TRUE, FALSE, Salarie);
                        end;
                    }
                    action("Page 2")
                    {
                        Caption = 'Page 2';
                        Image = EnableBreakpoint;
                        Visible = true;
                        //RunObject = page 12;

                        trigger OnAction();
                        begin
                            Salarie.SETRANGE(Salarie."No.", "No.");
                            REPORT.RUN(REPORT::"Déclaration ATS Page 2", TRUE, FALSE, Salarie);
                        end;
                    }
                }
            }
        }
    }


    var
        Mail: Codeunit 397;
        DroitConge: Record "Leave Right";
        ParamUtilisateur: Record 91;
        Direction: Record "Company Business Unit";
        Text01: Label 'Utilisateur %1 non configuré !';
        Text02: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        Text03: Label 'Axe analytique 1 non paramétré pour la direction %1 !';
        TraiSection: Record "Treatment Hourly Index Grid";
        AffectationSalarie: Record "Employee Assignment";
        Text04: Label 'Aucune affectation saisie !';
        Text05: Label 'Mettre à jour la fiche salarié depuis la saisie des affectations ?';
        Text06: Label 'Renseignement manquant dans l''affectation ! %1';
        ParamPaie: Record Payroll_Setup;
        Valeur: Integer;
        Text07: Label 'Mise à jour effectuée avec succès.';
        Salarie: Record 5200;
        [InDataSet]
        MapPointVisible: Boolean;

}