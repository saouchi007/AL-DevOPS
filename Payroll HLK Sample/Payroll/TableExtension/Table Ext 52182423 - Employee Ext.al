/// <summary>
/// TableExtension Employee Ext (ID 55200) extends Record Employee.
/// </summary>
tableextension 52182423 "Employee Ext" extends Employee
{
    fields
    {
        field(95000; "Company Business Unit Code"; code[10])
        {
            //DataClassification = ToBeClassified;
            Caption = 'Code unité';
            //FieldClass = FlowField;
            TableRelation = "Company Business Unit".Code;


        }
        field(95001; "Section Grid Class"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Classe';
            TableRelation = "Treatment Section Grid".Class;
            trigger OnValidate()
            begin
                IF ("Section Grid Class" <> xRec."Section Grid Class") OR ("Section Grid Class" = '') THEN BEGIN
                    VALIDATE("Section Grid Section", 0);
                    VALIDATE("Section Grid Level", 0);
                END;
            end;
        }
        
        field(95002; "Section Grid Section"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Section';
            TableRelation = "Treatment Section Grid".Section WHERE(Class = FIELD("Section Grid Class"));
            trigger OnValidate()
            begin
                IF ("Section Grid Section" <> xRec."Section Grid Section") OR ("Section Grid Section" = 0) THEN BEGIN
                    VALIDATE("Section Grid Level", 0);
                    IF ("Section Grid Class" <> '') AND ("Section Grid Section" <> 0) AND ("Socio-Professional Category" = '') THEN BEGIN
                        TreatmentSectionGrid.RESET;
                        TreatmentSectionGrid.SETRANGE(Class, "Section Grid Class");
                        TreatmentSectionGrid.SETRANGE(Section, "Section Grid Section");
                        VALIDATE("Socio-Professional Category", TreatmentSectionGrid.Category);
                    END;
                END;
            end;
        }
        field(95003; "Section Grid Level"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Echelon';
            trigger OnValidate()
            begin
                IF "Section Grid Level" < 0 THEN
                    ERROR(Text03, FIELDCAPTION("Section Grid Level"));
                PayrollSetup.GET;
                IF "Section Grid Level" > PayrollSetup."No. of Levels" THEN
                    ERROR(Text04, FIELDCAPTION("Section Grid Level"), PayrollSetup."No. of Levels");
                IF ("Section Grid Class" = '') OR ("Section Grid Section" = 0) THEN
                    EXIT;
                TreatmentSectionGrid.GET("Section Grid Class", "Section Grid Section");
                CASE "Section Grid Level" OF
                    //Element 07 Début
                    0:
                        "Section Index" := TreatmentSectionGrid."Minimal Index";
                    //Element 07 Fin
                    1:
                        "Section Index" := TreatmentSectionGrid."Level 1";
                    2:
                        "Section Index" := TreatmentSectionGrid."Level 2";
                    3:
                        "Section Index" := TreatmentSectionGrid."Level 3";
                    4:
                        "Section Index" := TreatmentSectionGrid."Level 4";
                    5:
                        "Section Index" := TreatmentSectionGrid."Level 5";
                    6:
                        "Section Index" := TreatmentSectionGrid."Level 6";
                    7:
                        "Section Index" := TreatmentSectionGrid."Level 7";
                    8:
                        "Section Index" := TreatmentSectionGrid."Level 8";
                    9:
                        "Section Index" := TreatmentSectionGrid."Level 9";
                    10:
                        "Section Index" := TreatmentSectionGrid."Level 10";
                    11:
                        "Section Index" := TreatmentSectionGrid."Level 11";
                    12:
                        "Section Index" := TreatmentSectionGrid."Level 12";
                    13:
                        "Section Index" := TreatmentSectionGrid."Level 13";
                    14:
                        "Section Index" := TreatmentSectionGrid."Level 14";
                    15:
                        "Section Index" := TreatmentSectionGrid."Level 15";
                    16:
                        "Section Index" := TreatmentSectionGrid."Level 16";
                    17:
                        "Section Index" := TreatmentSectionGrid."Level 17";
                    18:
                        "Section Index" := TreatmentSectionGrid."Level 18";
                    19:
                        "Section Index" := TreatmentSectionGrid."Level 19";
                    20:
                        "Section Index" := TreatmentSectionGrid."Level 20";
                END;
            end;
        }
        field(95004; "Payroll Bank Account"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Compte bancaire de paie';
            TableRelation = "Payroll Bank Account";
        }
        field(95005; "Do not Use Treatment Grid"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Ne pas utiliser la grille de traitement';

        }
        field(95006; "Structure Code"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
            Caption = 'Code de structure';
            TableRelation = Structure;
            trigger OnValidate()
            begin
                IF "Structure Code" = '' THEN
                    "Structure Description" := ''
                ELSE BEGIN
                    Structure.GET("Structure Code");
                    "Structure Description" := Structure.Description;
                END;
            end;
        }
        field(95007; "Cause of Advance Filter"; code[10])
        {

            Caption = 'Filtre code motif avance';
            FieldClass = FlowFilter;
            TableRelation = "Cause of Advance";
        }
        field(95008; "Total Advance"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total avances';
            CalcFormula = Sum("Employee Advance".Amount WHERE
                        ("Employee No." = FIELD("No."), "Advance Date" = FIELD("Date Filter"), "Cause of Advance Code" = FIELD("Cause of Advance Filter")));
        }
        field(95009; "Payroll Bank Account No."; Text[2048])
        {
            DataClassification = ToBeClassified;
            Caption = 'N° compte bancaire de paie';
        }
        field(95010; "Sanctioned"; Boolean)
        {
            FieldClass = FlowField;
            Caption = 'Sanctionné';
            CalcFormula = Exist("Employee Sanction" WHERE("Employee No." = FIELD("No."), "Sanction Date" = FIELD("Date Filter")));
            Editable = false;
        }
        field(95011; "Cause of Overtime Filter"; code[10])
        {
            Caption = 'Filtre motif heures supp';
            TableRelation = "Cause of Overtime";
            FieldClass = FlowFilter;
        }
        field(95012; "Total Overtime (Base)"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total heures supp.';
            CalcFormula = Sum("Employee Overtime".Quantity WHERE
                        ("Employee No." = FIELD("No."), "Overtime Date" = FIELD("Date Filter"), "Cause of Overtime Code" = FIELD("Cause of Overtime Filter"), Category = FIELD("Overtime Category Filter")));
            Editable = false;
        }
        field(95013; "Nationality Code"; Text[2048])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code nationalité';
            TableRelation = Nationality;
        }
        field(95014; "Birthplace Post Code"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code postal lieu de naissance';
            TableRelation = "Post Code";
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode_old("Birthplace City", "Birthplace Post Code");
            end;

            trigger OnLookup()
            begin
                PostCode.LookUpPostCode("Birthplace City", "Birthplace Post Code", TRUE);
            end;
        }
        field(95015; "Military Situation"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Non concernée","Dégagé -Accompli","Dégagé - Dispensé","Dégagé - Exempté","Dégagé - Amnistié","Dégagé - ANI","Non dégagé - Sursitaire","Non dégagé - Dossier en cours de traitement","Non dégagé - BASN";
            OptionCaption = 'Non concernée, Dégagé - Accompli, Dégagé - Dispensé;Dégagé - Exempté,Dégagé - Amnistié,Dégagé - ANI,Non dégagé - Sursitaire,Non dégagé - Dossier en cours de traitement,Non dégagé - BASN';
            Caption = 'Situation militaire';
        }
        field(95016; "Birthplace City"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ville de naissance';
            TableRelation = "Post Code";
            trigger OnValidate()
            begin
                PostCode.ValidateCity_old("Birthplace City", "Birthplace Post Code");
            end;

            trigger OnLookup()
            begin
                PostCode.LookUpCity("Birthplace City", "Birthplace Post Code", TRUE);
            end;
        }
        field(95017; "Payroll Template No."; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'N° modèle de paie';
            TableRelation = "Payroll Template Header";
            trigger OnValidate()
            begin
                IF "Payroll Template No." = '' THEN
                    EXIT;
                IF "Payroll Template No." <> xRec."Payroll Template No." THEN
                    IF CONFIRM(Text01, FALSE, "Payroll Template No.") THEN
                        IF CONFIRM(Text02, FALSE, "No.", "Payroll Template No.") THEN BEGIN
                            EmployeePayrollItem.RESET;
                            EmployeePayrollItem.SETRANGE("Employee No.", "No.");
                            EmployeePayrollItem.DELETEALL;
                            PayrollTemplateLine.RESET;
                            PayrollTemplateLine.SETRANGE("Template No.", "Payroll Template No.");
                            IF PayrollTemplateLine.FINDSET THEN BEGIN
                                PayrollTemplateLine.FINDFIRST;
                                REPEAT
                                    EmployeePayrollItem.INIT;
                                    EmployeePayrollItem."Employee No." := "No.";
                                    EmployeePayrollItem.VALIDATE("Item Code", PayrollTemplateLine."Item Code");
                                    EmployeePayrollItem.Type := PayrollTemplateLine."Item Type";
                                    IF PayrollTemplateLine."Item Type" = PayrollTemplateLine."Item Type"::"Libre saisie" THEN BEGIN
                                        EmployeePayrollItem.VALIDATE(Basis, PayrollTemplateLine.Amount);
                                    END;
                                    EmployeePayrollItem.INSERT;
                                UNTIL PayrollTemplateLine.NEXT = 0;
                            END;
                        END;
            end;
        }
        field(95018; "Total Recovery (Base)"; Decimal)
        {
            Caption = 'Total récupération (Base)';
            FieldClass = FlowField;
            CalcFormula = Sum("Employee Recovery".Quantity WHERE("Employee No." = FIELD("No."), nature = FILTER(consomé)));
            Editable = false;
        }
        field(95019; "Cause of Recovery Filter"; code[10])
        {
            FieldClass = FlowFilter;
            Caption = 'Filtre motif de récupération';
            TableRelation = "Cause of Recovery";
        }
        field(95020; "Overtime Category Filter"; code[10])
        {
            FieldClass = FlowFilter;
            Caption = 'Filtre catégorie heures supp';
            TableRelation = "Overtime Category";
        }
        field(95021; "Function Code"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code fonction';
            TableRelation = Function;
            trigger OnValidate()
            begin
                IF "Function Code" = '' THEN
                    "Job Title" := ''
                ELSE BEGIN
                    Function2.GET("Function Code");
                    "Job Title" := Function2.Description;
                END;
            end;
        }
        field(95022; "Structure Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Désignation structure';
            Editable = false;
        }
        field(95023; "Total Medical Refund"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total remboursement frais médicaux';
            CalcFormula = Sum("Medical Refund Line"."Refund Amount" WHERE("No." = FIELD("No."), "Refund Date" = FIELD("Date Filter")));
            Editable = false;
        }
        field(95024; "Confirmed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Confirmé';
        }
        field(95025; "Total Leave (Base)"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total congé (base)';
            CalcFormula = Sum("Employee Leave"."Quantity (Base)" WHERE("Employee No." = FIELD("No."), "Leave Period" = FIELD("Leave Period Filter")));
            Editable = false;
        }
        field(95026; "Socio-Professional Category"; code[10])
        {
            DataClassification = ToBeClassified;
            CaptionML = ENU = 'Socio-Professional Category', FRA = 'Catégorie socio-professionnelle';
            TableRelation = "Socio-professional Category";
        }
        field(95027; "Confirmation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date de confirmation';
        }
        field(95028; "Birthplace Wilaya Code"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Wilaya naissance';
            TableRelation = Wilaya;
            ValidateTableRelation = false;
            trigger OnValidate()
            begin
                IF "Birthplace Wilaya Code" = '' THEN
                    "Birthplace Wilaya Description" := ''
                ELSE BEGIN
                    Wilaya.GET("Birthplace Wilaya Code");
                    "Birthplace Wilaya Description" := Wilaya.Name;
                END;
            end;
        }
        field(95029; "Birthplace Wilaya Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Désignation wilaya';
            Editable = false;
        }
        field(95030; "No. of Children"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Nombre enfants';
            Editable = false;
        }
        field(95031; "Total Absences Days"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total absences (jours)';
            CalcFormula = Sum("Employee Absence".Quantity WHERE("Employee No." = FIELD("No."), "From Date" = FIELD("Date Filter"), "To Be Deducted" = CONST(true), "Unit of Measure" = CONST(Day)));
            Editable = false;
        }
        field(95032; "Total Absences Hours"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total absences (heures)';
            CalcFormula = Sum("Employee Absence".Quantity WHERE("Employee No." = FIELD("No."), "From Date" = FIELD("Date Filter"), "To Be Deducted" = CONST(true), "Unit of Measure" = CONST(Hour)));
            Editable = false;
        }
        field(95033; "Total Unauthorised Absence"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total absences non autorisées';
            CalcFormula = Sum("Employee Absence"."Quantity (Base)" WHERE("Employee No." = FIELD("No."), "From Date" = FIELD("Date Filter"), "To Be Deducted" = CONST(true), Authorised = CONST(false)));

        }

        field(95035; "Company Business Unit Filter"; code[10])
        {
            FieldClass = FlowFilter;
            Caption = 'Filtre direction';
            TableRelation = "Company Business Unit";
        }
        field(95036; "Study Level"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Niveau étude';
            TableRelation = "Company Business Unit";
        }
        field(95037; "Driving License"; Option)
        {
            OptionMembers = "A","B","C","D","E","Tous Catégories";
            DataClassification = ToBeClassified;
            Caption = 'Permis de conduire';
        }
        field(95038; "Blood Group"; Option)
        {
            OptionMembers = "A","B","AB","O";
            DataClassification = ToBeClassified;
            Caption = 'Groupe Sanguin';
        }
        field(95039; "Rhesus"; Option)
        {
            OptionMembers = "Rh-","Rh+";
            DataClassification = ToBeClassified;
            Caption = 'Rhésus';
        }
        field(95040; "Driving License Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date permis de conduire';
        }
        field(95041; "Total Professional Expances"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total frais de mission';
            CalcFormula = Sum("Professional Expances".Amount WHERE("Employee No." = FIELD("No."), Date = FIELD("Date Filter")));
            Editable = false;
        }
        field(95042; "Total Profess. Expances Refund"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total remboursement frais de mission';
            CalcFormula = Sum("Professional Expances".Amount WHERE("Employee No." = FIELD("No."), Contribution = CONST(RFM), "Deduction Payroll Code" = CONST()));
            Editable = false;
        }
        field(95043; "Treatment Grid Type"; Option)
        {
            OptionMembers = "Sections","Hourly","Index";
            OptionCaption = 'Sections,Indices horaires';
            DataClassification = ToBeClassified;
            Caption = 'Type de grille de traitements';
            Editable = false;
        }
        field(95044; "Hourly Index Grid Function No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'N° fonction';
            TableRelation = "Treatment Hourly Index Grid"."No.";
            trigger OnValidate()
            begin
                IF "Hourly Index Grid Function No." = 0 THEN BEGIN
                    "Hourly Index Grid Function" := '';
                    "Hourly Index Grid CH" := '';
                END
                ELSE BEGIN
                    TreatmentHourlyIndexGrid.GET("Hourly Index Grid Function No.");
                    "Hourly Index Grid Function" := TreatmentHourlyIndexGrid."Function";
                    "Hourly Index Grid CH" := TreatmentHourlyIndexGrid.CH;
                END;
            end;
        }
        field(95045; "Hourly Index Grid Function"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Fonction';
            Editable = false;
        }
        field(95046; "Hourly Index Grid CH"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Echelle';
            Editable = false;
        }
        field(95047; "Employer Cotisation %"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cotisation employeur %';
        }
        field(95048; "Hourly Index Grid Index"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Echelon';
            Editable = false;
            trigger OnValidate()
            begin
                IF "Hourly Index Grid Index" < 1 THEN
                    ERROR(Text03, FIELDCAPTION("Hourly Index Grid Index"));
                PayrollSetup.GET;
                IF "Hourly Index Grid Index" > PayrollSetup."No. of Index" THEN
                    ERROR(Text04, FIELDCAPTION("Hourly Index Grid Index"), PayrollSetup."No. of Index");
            end;
        }
        field(95049; "Leave Period Filter"; code[200])
        {
            FieldClass = FlowFilter;
            Caption = 'Filtre période congé';
        }
        field(95050; "Marriage Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date de mariage';
        }
        field(95051; "Marriage Post Code"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code postal lieu de mariage';
            TableRelation = "Post Code";
            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, "Country/Region Code", (CurrFieldNo <> 0) AND GUIALLOWED);
            end;

            trigger OnLookup()
            begin
                PostCode.LookUpPostCode("Marriage City", "Marriage Post Code", TRUE);
            end;

        }

        field(95052; "Marriage City"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ville de mariage';
            TableRelation = "Post Code";
            trigger OnValidate()
            begin
                PostCode.ValidateCity_old("Marriage City", "Marriage Post Code");
            end;

            trigger OnLookup()
            begin
                PostCode.LookUpCity("Marriage City", "Marriage Post Code", TRUE);
            end;
        }
        field(95053; "Husband/Wife Function"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Profession du conjoint';
        }
        field(95054; "RIB Key"; Text[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Clé RIB';
        }
        field(95055; "Previous IEP"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'IEP hors établissement';
        }
        field(95056; "Current IEP"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'IEP actuel';
            Editable = true;
        }
        field(95057; "Payroll Type Code"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type de paie';
            TableRelation = "Payment Method";
        }
        field(95058; "Payment Method Code"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code mode de règlement';
            TableRelation = "Payment Method";
        }
        field(95059; "Leave Indemnity Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Indemnité de congé (montant)';
        }
        field(95060; "Leave Indemnity No."; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Indemnité de congé (nbre)';
        }
        field(95061; "Total Leave Indem. Amount"; Decimal)
        {
            //DataClassification = ToBeClassified;
            Caption = 'Total indemnité de congé';
            FieldClass = FlowField;
            CalcFormula = Sum("Leave Right By Years"."Remaining Amount" WHERE("Employee No." = FIELD("No.")));
            Editable = false;
        }
        field(95062; "Total Leave Indem. No."; Decimal)
        {
            Caption = 'Total droit à congé';
            FieldClass = FlowField;
            CalcFormula = Sum("Leave Right By Years"."Remaining Days" WHERE("Employee No." = FIELD("No.")));
            Editable = false;
        }
        field(95063; "Consumed Leave Days"; Decimal)
        {
            Caption = 'Jours de congé consommés';
            FieldClass = FlowField;
            CalcFormula = Sum("Leave Right By Years"."Consumed Days" WHERE("Employee No." = FIELD("No.")));
            Editable = false;
        }
        field(95064; "Leave Indemnity TIT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Indemnité de congé (IRG)';
        }
        field(95065; "Total Leave Indem. TIT"; Decimal)
        {
            FieldClass = FlowField;
            Caption = 'Total indemnité de congé (IRG)';
            CalcFormula = Sum("Payroll Archive Header"."Leave Indemnity No." WHERE("No." = FIELD("No.")));
            Editable = false;
        }
        field(95066; "Antenna Code"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code antenne';
            TableRelation = Antenna WHERE("Company Business Unit" = FIELD("Company Business Unit Code"));
        }
        field(95067; "Regime"; Option)
        {
            OptionMembers = "Mensuel","Vacataire journalier","Vacataire horaire";
            DataClassification = ToBeClassified;
            Caption = 'Régime';
        }
        field(95068; "No. of Fixed Assets"; Integer)
        {
            Caption = 'Nbre immobilisations à charge';
            FieldClass = FlowField;
            CalcFormula = Count("Fixed Asset" WHERE("Responsible Employee" = FIELD("No.")));
            Editable = false;

        }
        field(95069; "Degree Code"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code grade';
            TableRelation = Post;
            NotBlank = true;
            trigger OnValidate()
            begin
                IF "Degree Code" = '' THEN
                    "Degree Description" := ''
                ELSE BEGIN
                    Poste.GET("Degree Code");
                    "Degree Description" := Poste.Description;
                END;
            end;
        }
        field(95070; "Degree Description"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Désignation grade';
            Editable = false;
        }
        field(95071; "Observation"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Observation';
        }
        field(95072; "Confirmation Decision No."; Text[40])
        {
            DataClassification = ToBeClassified;
            Caption = 'N° décision de confirmation';
        }
        field(95073; "Section Index"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Indice';
            Editable = false;
        }
        field(95074; "Base salary"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Salaire de Base';
            Editable = false;
        }
        field(95075; "CCP N"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'N° CCP';
        }
        field(95076; "Date Taking Office"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date de prise de fonction';
            Editable = true;
        }
        field(95077; "STC Payroll"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Paie STC';
            Editable = false;
        }
        field(95078; "Employment Date Init"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date de recrutement initiale';
        }
        field(95079; "StatutPay"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = '<StatutPay>';
        }
        field(95080; "UserPay"; code[150])
        {
            DataClassification = ToBeClassified;
            Caption = '<UserPay>';
        }
        field(95081; "Présumé"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Présumé';
        }
        field(95082; "DateFinPEss"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date Fin période dessai';
        }
        field(95083; "DateFinPEss2"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date Fin période dessai 2';
        }
        field(95084; "Dateexit"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date de srotie';
            Editable = true;
        }
        field(95086; "Etranger"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Etranger';
        }
        field(95087; "N° Carte identité nationale"; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'N° Carte identité nationale';
        }
        field(95088; "N° Identification National"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'N° Identification National';
        }
        field(95089; "N° acte de naissance"; Text[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'N° acte de naissance';
        }
        field(95090; "Prénom de la mère"; Text[40])
        {
            DataClassification = ToBeClassified;
            Caption = 'Prénom de la mère';
        }
        field(95091; "Nom de la mère"; Text[40])
        {
            DataClassification = ToBeClassified;
            Caption = 'Nom de la mère';
        }
        field(95092; "Prénom du père"; Text[40])
        {
            DataClassification = ToBeClassified;
            Caption = 'Prénom du père';
        }
        field(95200; "Total droit"; Decimal)
        {

            Caption = 'Total droit';
            FieldClass = FlowField;
            CalcFormula = Sum("Employee Recovery".Quantity WHERE("Employee No." = FIELD("No."), nature = FILTER(Droit)));
            Editable = false;
        }
        field(95201; "Post Code CACOBATPH"; code[4])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code postal cacobatph';
            TableRelation = "Code cacobatph";
        }
        field(95203; "Grand Sud"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Grand Sud';
        }

        field(95204; "Regime IRG"; option)
        {
            OptionMembers = " ","Retraité","sit Handicape";
            DataClassification = ToBeClassified;
            Caption = 'Regime IRG';

        }
        field(10800; "Marital Status"; Option)
        {
            Caption = 'Marital Status';
            OptionCaption = ' ,Single,Married,Divorced,Widowed';
            OptionMembers = " ",Single,Married,Divorced,Widowed;
        }


    }

    var
        HumanResSetup: Record 5218;
        NoSeriesMgt: Codeunit 396;
        DimMgt: Codeunit 408;
        ParamUtilisateur: Record 91;
        Direction: Record 52182429;
        PrevSearchName: Code[250];
        MapPoint: Record 800;
        MapMgt: Codeunit 802;
        Res: Record 5200;
        EmployeeResUpdate: Codeunit 5200;
        SalespersonPurchaser: Record 13;
        EmployeeSalespersonUpdate: Codeunit 5201;
        AlternativeAddr: Record 5201;
        EmployeeQualification: Record 5203;
        Relative: Record 5205;
        EmployeeAbsence: Record 5207;
        MiscArticleInformation: Record 5214;
        ConfidentialInformation: Record 5216;
        HumanResComment: Record 5208;

        Text000: Label 'Avant de pouvoir utiliser Online Map, vous devez compléter la fenêtre Configuration Online Map.\Consultez la section Configuration d''Online Map dans l''Aide.';
        Text01: Label 'Confirmez-vous l''application du modèle de paie %1 ?';
        Text02: Label 'Les rubriques salarié actuelles de l''employé %1 seront supprimées et de nouvelles rubriques seront créées depuis le modèle %2\Souhaitez-vous continuer ?';
        Text03: Label '%1 doit être positif !';
        Text04: Label '%1 ne peut pas dépasser %2 !';
        Text05: Label 'Utilisateur %1 non configuré !';
        Text06: Label 'Direction non paramétrée pour l''utilisateur %1 !';
        TreatmentSectionGrid: Record "Treatment Section Grid";
        PayrollSetup: Record 52182483;
        Structure: Record Structure;
        PostCode: Record 225;
        EmployeePayrollItem: Record "Employee Payroll Item";
        PayrollTemplateLine: Record "Payroll Template Line";
        Function2: Record Function;
        Wilaya: Record Wilaya;
        TreatmentHourlyIndexGrid: Record "Treatment Hourly Index Grid";
        Poste: Record Post;


    trigger OnInsert();
    begin
        "Last Modified Date Time" := CURRENTDATETIME;
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Employee Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Employee Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
        DimMgt.UpdateDefaultDim(
          DATABASE::Employee, "No.",
          "Global Dimension 1 Code", "Global Dimension 2 Code");
        UpdateSearchName;

        //---03---
        IF NOT ParamUtilisateur.GET(USERID) THEN
            ERROR(Text05);
        IF ParamUtilisateur."Company Business Unit" = '' THEN
            ERROR(Text06);
        Direction.GET(ParamUtilisateur."Company Business Unit");
        "Company Business Unit Code" := ParamUtilisateur."Company Business Unit";
    end;

    trigger OnModify();
    begin
        "Last Modified Date Time" := CURRENTDATETIME;
        "Last Date Modified" := TODAY;
        IF Res.READPERMISSION THEN
            EmployeeResUpdate.HumanResToRes(xRec, Rec);
        IF SalespersonPurchaser.READPERMISSION THEN
            EmployeeSalespersonUpdate.HumanResToSalesPerson(xRec, Rec);
        UpdateSearchName;
    end;

    trigger OnDelete();
    begin
        AlternativeAddr.SETRANGE("Employee No.", "No.");
        AlternativeAddr.DELETEALL;

        EmployeeQualification.SETRANGE("Employee No.", "No.");
        EmployeeQualification.DELETEALL;

        Relative.SETRANGE("Employee No.", "No.");
        Relative.DELETEALL;

        EmployeeAbsence.SETRANGE("Employee No.", "No.");
        EmployeeAbsence.DELETEALL;

        MiscArticleInformation.SETRANGE("Employee No.", "No.");
        MiscArticleInformation.DELETEALL;

        ConfidentialInformation.SETRANGE("Employee No.", "No.");
        ConfidentialInformation.DELETEALL;

        HumanResComment.SETRANGE("No.", "No.");
        HumanResComment.DELETEALL;

        DimMgt.DeleteDefaultDim(DATABASE::Employee, "No.");
    end;

    trigger OnRename()
    begin
        "Last Modified Date Time" := CURRENTDATETIME;
        "Last Date Modified" := TODAY;
        UpdateSearchName;
    end;


    /// <summary>
    /// UpdateSearchName.
    /// </summary>
    procedure UpdateSearchName()
    begin
        PrevSearchName := xRec.FullName + ' ' + xRec.Initials;
        IF ((("First Name" <> xRec."First Name") OR ("Middle Name" <> xRec."Middle Name") OR ("Last Name" <> xRec."Last Name") OR
             (Initials <> xRec.Initials)) AND ("Search Name" = PrevSearchName))
        THEN
            "Search Name" := SetSearchNameToFullnameAndInitials;

    end;

    /// <summary>
    /// SetSearchNameToFullnameAndInitials.
    /// </summary>
    /// <returns>Return value of type Code[250].</returns>
    procedure SetSearchNameToFullnameAndInitials(): Code[250]
    begin
        EXIT(FullName + ' ' + Initials);
    end;



}