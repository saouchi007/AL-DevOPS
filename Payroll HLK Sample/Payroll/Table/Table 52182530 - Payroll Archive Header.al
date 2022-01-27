/// <summary>
/// Table Payroll Archive Header (ID 52182530).
/// </summary>
table 52182530 "Payroll Archive Header"
//table 39108615 "Payroll Archive Header"
{
    // version HALRHPAIE.6.2.00

    CaptionML = ENU = 'Payroll Archive Header',
                FRA = 'Entête archive de paie';
    // DrillDownPageID = 39108499;
    // LookupPageID = 39108499;

    fields
    {
        field(1; "Payroll Code"; Code[20])
        {
            CaptionML = FRA = 'Code de paie',
                        FRS = 'Code de paie';
            TableRelation = Payroll;
        }
        field(2; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';
        }
        field(3; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
        }
        field(4; "Middle Name"; Text[30])
        {
            CaptionML = ENU = 'Middle Name',
                        FRA = 'Nom de jeune fille';
        }
        field(5; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';
        }
        field(6; Initials; Text[30])
        {
            CaptionML = ENU = 'Initials',
                        FRA = 'Initiales';
        }
        field(7; "Function Description"; Text[80])
        {
            CaptionML = ENU = 'Function Description',
                        FRA = 'Désignation fonction';
        }
        field(8; Address; Text[50])
        {
            CaptionML = ENU = 'Address',
                        FRA = 'Adresse';
        }
        field(9; "Address 2"; Text[50])
        {
            CaptionML = ENU = 'Address 2',
                        FRA = 'Adresse (2ème ligne)';
        }
        field(10; City; Text[30])
        {
            CaptionML = ENU = 'City',
                        FRA = 'Ville';
        }
        field(11; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code',
                        FRA = 'Code postal';
            //This property is currently not supported
            //TestTableRelation = false;

            // ValidateTableRelation = false; commented by AK
        }
        field(12; County; Text[30])
        {
            CaptionML = ENU = 'County',
                        FRA = 'Région';
        }
        field(21; "Social Security No."; Text[30])
        {
            CaptionML = ENU = 'Social Security No.',
                        FRA = 'N° sécurité sociale';
        }
        field(22; "Union Code"; Code[10])
        {
            CaptionML = ENU = 'Union Code',
                        FRA = 'Code mutuelle';
        }
        field(23; "Union Membership No."; Text[30])
        {
            CaptionML = ENU = 'Union Membership No.',
                        FRA = 'N° adhérent mutuelle';
        }
        field(25; "Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Country/Region Code',
                        FRA = 'Code pays/région';
        }
        field(27; "Emplymt. Contract Type Code"; Code[10])
        {
            CaptionML = ENU = 'Emplymt. Contract Type Code',
                        FRA = 'Code type contrat de travail';
        }
        field(28; "Statistics Group Code"; Code[10])
        {
            CaptionML = ENU = 'Statistics Group Code',
                        FRA = 'Code groupe statistiques';
        }
        field(29; "Employment Date"; Date)
        {
            CaptionML = ENU = 'Employment Date',
                        FRA = 'Date de recrutement';
        }
        field(31; Status; Option)
        {
            CaptionML = ENU = 'Status',
                        FRA = 'Statut';
            OptionCaptionML = ENU = 'Active,Inactive',
                              FRA = 'Actif,Inactif';
            OptionMembers = Active,Inactive;
        }
        field(36; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            CaptionML = ENU = 'Global Dimension 1 Code',
                        FRA = 'Code axe principal 1';
        }
        field(37; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            CaptionML = ENU = 'Global Dimension 2 Code',
                        FRA = 'Code axe principal 2';
        }
        field(39; Comment; Boolean)
        {
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = Normal;
        }
        field(10800; "Marital Status"; Option)
        {
            CaptionML = ENU = 'Marital Status',
                        FRA = 'Situation de famille';
            OptionCaptionML = ENU = ' ,Single,Married,Divorced,Widowed',
                              FRA = ' ,Célibataire,Marié(e),Divorcé(e),Veuf(ve)';
            OptionMembers = " ",Single,Married,Divorced,Widowed;
        }
        field(50000; "N ° CCP"; Text[20])
        {
            Caption = 'N ° CCP';
        }
        field(95000; "Company Business Unit Code"; Code[10])
        {
            CaptionML = ENU = 'Company Business Unit Code',
                        FRA = 'Code unité';
        }
        field(95001; "Section Grid Class"; Code[10])
        {
            CaptionML = ENU = 'Class',
                        FRA = 'Classe';

            trigger OnValidate();
            begin
                IF ("Section Grid Class" <> xRec."Section Grid Class") OR ("Section Grid Class" = '') THEN BEGIN
                    VALIDATE("Section Grid Section", 0);
                    VALIDATE("Section Grid Level", 0);
                END;
            end;
        }
        field(95002; "Section Grid Section"; Integer)
        {
            CaptionML = ENU = 'Section',
                        FRA = 'Section';
        }
        field(95003; "Section Grid Level"; Integer)
        {
            CaptionML = ENU = 'Level',
                        FRA = 'Echelon';
        }
        field(95004; "Payroll Bank Account"; Code[10])
        {
            CaptionML = ENU = 'Payroll Bank Account',
                        FRA = 'Compte bancaire de paie';
        }
        field(95005; "RIB Key"; Text[2])
        {
            CaptionML = ENU = 'RIB Key',
                        FRA = 'Clé RIB';
        }
        field(95006; "Structure Code"; Code[20])
        {
            CaptionML = ENU = 'Structure Code',
                        FRA = 'Code de structure';
        }
        field(95008; "Total Advance"; Decimal)
        {
            CaptionML = ENU = 'Total Advance',
                        FRA = 'Total avance';
            Editable = false;
        }
        field(95009; "Payroll Bank Account No."; Text[20])
        {
            CaptionML = ENU = 'Payroll Bank Account No.',
                        FRA = 'N° compte bancaire de paie';
        }
        field(95010; Sanctioned; Boolean)
        {
            CaptionML = ENU = 'Sanctioned',
                        FRA = 'Sanctionné';
            Editable = false;
        }
        field(95012; "Total Overtime (Base)"; Decimal)
        {
            CaptionML = ENU = 'Total Overtime',
                        FRA = 'Total heures supp.';
            Editable = false;
        }
        field(95015; "Military Situation"; Option)
        {
            CaptionML = ENU = 'Military Situation',
                        FRA = 'Situation militaire';
            OptionCaptionML = ENU = 'Not Concerned,Inapte,Exempt,Deffered,Completed,Not Completed',
                              FRA = 'Non concernée,Inapt,Dispensé,Sursitaire,Acompli,Non Accompli';
            OptionMembers = "Not Concerned",Inapte,Exempt,Deffered,Completed,"Not Completed";
        }
        field(95017; "Payroll Template No."; Code[20])
        {
            CaptionML = ENU = 'Payroll Template No.',
                        FRA = 'N° modèle de paie';
        }
        field(95018; "Total Recovery (Base)"; Decimal)
        {
            CaptionML = ENU = 'Total Recovery (Base)',
                        FRA = 'Total récupération (Base)';
            Editable = false;
        }
        field(95021; "Function Code"; Code[20])
        {
            CaptionML = ENU = 'Function Code',
                        FRA = 'Code fonction';
        }
        field(95022; "Structure Description"; Text[35])
        {
            CaptionML = ENU = 'Structure Description',
                        FRA = 'Désignation structure';
            Editable = false;
        }
        field(95023; "Total Medical Refund"; Decimal)
        {
            CaptionML = ENU = 'Total Medical Refund',
                        FRA = 'Total remboursement frais médicaux';
            Editable = false;
        }
        field(95024; Confirmed; Boolean)
        {
            CaptionML = ENU = 'Confirmed',
                        FRA = 'Confirmé';
        }
        field(95025; "Total Leave (Base)"; Decimal)
        {
            CaptionML = ENU = 'Total Leave (Base)',
                        FRA = 'Total congé (base)';
            Editable = false;
        }
        field(95026; "Socio-Professional Category"; Code[10])
        {
            CaptionML = ENU = 'Socio-Professional Category',
                        FRA = 'Catégorie socio-professionnelle';
        }
        field(95027; "Confirmation Date"; Date)
        {
            CaptionML = ENU = 'Confirmation Date',
                        FRA = 'Date de confirmation';
        }
        field(95030; "No. of Children"; Integer)
        {
            CaptionML = ENU = 'No. of Children',
                        FRA = 'Nombre d''enfants';
            Editable = false;
        }
        field(95031; "Authorised Days Absence"; Decimal)
        {
            CaptionML = ENU = 'Authorised Days Absence',
                        FRA = 'Jours absence autorisés';
            Editable = false;
        }
        field(95032; "Unauthorised Days Absence"; Decimal)
        {
            CaptionML = ENU = 'Unauthorised Days Absence',
                        FRA = 'Jours absence non autorisés';
            Editable = false;
        }
        field(95033; "Authorised Hours Absence"; Decimal)
        {
            CaptionML = ENU = 'Authorised Hours Absence',
                        FRA = 'Heures absence autorisées';
            Editable = false;
        }
        field(95034; "Unauthorised Hours Absence"; Decimal)
        {
            CaptionML = ENU = 'Unauthorised Hours Absence',
                        FRA = 'Heures absence non autorisées';
            Editable = false;
        }
        field(95035; "Total Family Allowance Contr."; Decimal)
        {
            CaptionML = ENU = 'Total Family Allowance Contr.',
                        FRA = 'Total cotisations AF';
            Editable = false;
        }
        field(95036; "Total Union Contr."; Decimal)
        {
            CaptionML = ENU = 'Total Union Contr.',
                        FRA = 'Total cotisations mutuelle';
            Editable = false;
        }
        field(95037; "Hourly Index Grid Function No."; Integer)
        {
            Caption = 'N° fonction';
        }
        field(95038; "Hourly Index Grid Function"; Text[50])
        {
            Caption = 'Fonction';
        }
        field(95039; "Hourly Index Grid CH"; Text[30])
        {
            Caption = 'CH';
        }
        field(95040; "Hourly Index Grid Index"; Integer)
        {
            Caption = 'Indice';
        }
        field(95041; "Payroll Type Code"; Code[10])
        {
            Caption = 'Type de paie';
        }
        field(95058; "Payment Method Code"; Code[10])
        {
            Caption = 'Code mode de règlement';
            TableRelation = "Payment Method";
        }
        field(95059; "Leave Indemnity Amount"; Decimal)
        {
            Caption = 'Indemnité de congé (montant)';
        }
        field(95060; "Leave Indemnity No."; Decimal)
        {
            Caption = 'Indemnité de congé (nbre)';
        }
        field(95061; "Leave Indemnity TIT"; Decimal)
        {
            Caption = 'IRG de congé';
        }
        field(95067; Regime; Option)
        {
            Caption = 'Régime';
            OptionCaption = 'Mensuel,Vacataire journalier,Vacataire horaire';
            OptionMembers = Mensuel,"Vacataire journalier","Vacataire horaire";
        }
        field(95071; Observation; Text[250])
        {
            Caption = 'Observation';
        }
        field(95072; "Total Absences Days"; Decimal)
        {
            CaptionML = ENU = 'Unauthorised Days Absence',
                        FRA = 'Total absences (jours)';
            Editable = false;
            FieldClass = Normal;
        }
        field(95073; "Total Absences Hours"; Decimal)
        {
            CaptionML = ENU = 'Unauthorised Days Absence',
                        FRA = 'Total absences (heures)';
            Editable = false;
            FieldClass = Normal;
        }
        field(95077; "STC Payroll"; Boolean)
        {
            Caption = 'Paie STC';
            Editable = false;
        }
        field(95078; "Consumed leave days"; Decimal)
        {
            Caption = 'Nombre de jours congé consommés';
        }
        field(95079; "Payroll filter"; Code[20])
        {
            Caption = 'Filtre Paie';
            FieldClass = FlowFilter;
        }
        field(95080; "Total Mise en dispo"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Payroll Code", "No.")
        {
        }
        key(Key2; "Union Code")
        {
        }
        key(Key3; "No.")
        {
            SumIndexFields = "Leave Indemnity Amount", "Leave Indemnity No.";
        }
        key(Key4; "Payroll Bank Account", "No.", "Payment Method Code", "Company Business Unit Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        //ERROR(Text01,Rec.TABLECAPTION);
    end;

    var
        Text01: Label 'Suppression impossible de %1';
}

