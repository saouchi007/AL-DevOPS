/// <summary>
/// Table Candidate (ID 51427).
/// </summary>
table 52182456 Candidate
//table 39108427 Candidate
{
    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Candidate',
                FRA = 'Candidat';
    DataCaptionFields = "No.", "First Name", "Middle Name", "Last Name";
    //DrillDownPageID = 39108444;
    //LookupPageID = 39108444;

    fields
    {
        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'No.',
                        FRA = 'N°';

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    HumanResSetup.GET;
                    NoSeriesMgt.TestManual(HumanResSetup."Candidate Nos.");
                    "No. Series" := '';
                END;
            end;
        }
        field(2; "First Name"; Text[30])
        {
            CaptionML = ENU = 'First Name',
                        FRA = 'Prénom';
        }
        field(3; "Middle Name"; Text[30])
        {
            CaptionML = ENU = 'Middle Name',
                        FRA = 'Nom de jeune fille';
        }
        field(4; "Last Name"; Text[30])
        {
            CaptionML = ENU = 'Last Name',
                        FRA = 'Nom';

            trigger OnValidate();
            begin
                IF "Search Name" = '' THEN
                    "Search Name" := "Last Name";
            end;
        }
        field(5; "Father First Name"; Text[30])
        {
            CaptionML = ENU = 'Father First Name',
                        FRA = 'Prénom du père';
        }
        field(7; "Search Name"; Code[30])
        {
            CaptionML = ENU = 'Search Name',
                        FRA = 'Nom de recherche';
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

            trigger OnLookup();
            begin
                PostCode.LookUpCity(City, "Post Code", TRUE);
            end;

            trigger OnValidate();
            begin
                //PostCode.ValidatePostCode_old(City,"Post Code");
                PostCode.ValidateCity_old(City, "Post Code");
            end;
        }
        field(11; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code',
                        FRA = 'Code postal';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup();
            begin
                //PostCode.UpdateFromSalesHeader(City,"Post Code",TRUE);
                PostCode.LookUpPostCode(City, "Post Code", TRUE);
            end;

            trigger OnValidate();
            begin
                //PostCode.LookUpPostCode(City,"Post Code");
                PostCode.ValidatePostCode_old(City, "Post Code");
            end;
        }
        field(12; County; Text[30])
        {
            CaptionML = ENU = 'County',
                        FRA = 'Région';
        }
        field(13; "Phone No."; Text[30])
        {
            CaptionML = ENU = 'Phone No.',
                        FRA = 'N° téléphone';
        }
        field(14; "Mobile Phone No."; Text[30])
        {
            CaptionML = ENU = 'Mobile Phone No.',
                        FRA = 'N° téléphone mobile';
        }
        field(15; "E-Mail"; Text[80])
        {
            CaptionML = ENU = 'E-Mail',
                        FRA = 'E-mail';
        }
        field(16; "Mother Last Name"; Text[30])
        {
            CaptionML = ENU = 'Mother Last Name',
                        FRA = 'Nom de la mère';
        }
        field(17; "Mother First Name"; Text[30])
        {
            CaptionML = ENU = 'Mother First Name',
                        FRA = 'Prénom de la mère';
        }
        field(19; Picture; BLOB)
        {
            CaptionML = ENU = 'Picture',
                        FRA = 'Image';
            SubType = Bitmap;
        }
        field(20; "Birth Date"; Date)
        {
            CaptionML = ENU = 'Birth Date',
                        FRA = 'Date de naissance';
        }
        field(21; "Joint First Name"; Text[30])
        {
            CaptionML = ENU = 'Joint First Name',
                        FRA = 'Prénom du conjoint';
        }
        field(22; "Joint Last Name"; Text[30])
        {
            CaptionML = ENU = 'Joint Last Name',
                        FRA = 'Nom du conjoint';
        }
        field(23; "Joint Birth Date"; Date)
        {
            CaptionML = ENU = 'Joint Birth Date',
                        FRA = 'Date de naissance du conjoint';
        }
        field(24; Sex; Option)
        {
            CaptionML = ENU = 'Sex',
                        FRA = 'Sexe';
            OptionCaptionML = ENU = ' ,Female,Male',
                              FRA = ' ,Féminin,Masculin';
            OptionMembers = " ",Female,Male;
        }
        field(25; "Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Country/Region Code',
                        FRA = 'Code pays/région';
            TableRelation = "Country/Region";
        }
        field(26; "Joint Birthplace City"; Text[30])
        {

            trigger OnLookup();
            begin
                PostCode.LookUpCity("Joint Birthplace City", "Joint Birthplace Post Code", TRUE);
            end;

            trigger OnValidate();
            begin
                //PostCode.ValidatePostCode_old("Joint Birthplace City","Joint Birthplace Post Code");
                PostCode.ValidateCity_old("Joint Birthplace City", "Joint Birthplace Post Code");
            end;
        }
        field(27; "Joint Birthplace Post Code"; Code[10])
        {
            TableRelation = "Post Code";

            trigger OnLookup();
            begin
                //PostCode.UpdateFromSalesHeader("Joint Birthplace City","Birthplace Post Code",TRUE);
                PostCode.LookUpPostCode("Joint Birthplace City", "Birthplace Post Code", TRUE);
            end;

            trigger OnValidate();
            begin
                //PostCode.LookUpPostCode("Joint Birthplace City","Birthplace Post Code");
                PostCode.ValidatePostCode_old("Joint Birthplace City", "Birthplace Post Code");
            end;
        }
        field(28; "Joint Job Title"; Text[30])
        {
            CaptionML = ENU = 'Joint Job Title',
                        FRA = 'Fonction du conjoint';
        }
        field(39; Comment; Boolean)
        {
            CalcFormula = Exist("Human Resource Comment Line" WHERE("Table Name" = CONST(0),//CONST(12)
                                                                     "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Last Date Modified"; Date)
        {
            CaptionML = ENU = 'Last Date Modified',
                        FRA = 'Date dern. modification';
            Editable = false;
        }
        field(41; "Date Filter"; Date)
        {
            CaptionML = ENU = 'Date Filter',
                        FRA = 'Filtre date';
            FieldClass = FlowFilter;
        }
        field(53; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'Souches de n°';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(54; "Marriage Date"; Date)
        {
            CaptionML = ENU = 'Marriage Date',
                        FRA = 'Date de mariage';
        }
        field(10800; "Marital Status"; Option)
        {
            CaptionML = ENU = 'Marital Status',
                        FRA = 'Situation de famille';
            OptionCaptionML = ENU = ' ,Single,Married,Divorced,Widowed',
                              FRA = ' ,Célibataire,Marié,Divorcé,Veuf';
            OptionMembers = " ",Single,Married,Divorced,Widowed;
        }
        field(95013; "Nationality Code"; Text[30])
        {
            CaptionML = ENU = 'Nationality Code',
                        FRA = 'Code nationalité';
            TableRelation = Nationality;
        }
        field(95014; "Birthplace Post Code"; Code[10])
        {
            CaptionML = ENU = 'Birthplace Post Code',
                        FRA = 'Code postal lieu de naissance';
            TableRelation = "Post Code";

            trigger OnLookup();
            begin
                //PostCode.UpdateFromSalesHeader("Birthplace City","Birthplace Post Code",TRUE);
                PostCode.LookUpPostCode("Birthplace City", "Birthplace Post Code", TRUE);
            end;

            trigger OnValidate();
            begin
                //PostCode.LookUpPostCode("Birthplace City","Birthplace Post Code");
                PostCode.ValidatePostCode_old("Birthplace City", "Birthplace Post Code");
            end;
        }
        field(95015; "Military Situation"; Option)
        {
            CaptionML = ENU = 'Military Situation',
                        FRA = 'Situation militaire';
            OptionCaptionML = ENU = 'Exempt,Deffered,Completed,Not Completed',
                              FRA = 'Dispensé,Sursitaire,Acompli,Non Accompli';
            OptionMembers = Exempt,Deffered,Completed,"Not Completed";
        }
        field(95016; "Birthplace City"; Text[30])
        {
            CaptionML = ENU = 'Birthplace City',
                        FRA = 'Ville lieu de naissance';

            trigger OnLookup();
            begin
                PostCode.LookUpCity("Birthplace City", "Birthplace Post Code", TRUE);
            end;

            trigger OnValidate();
            begin
                //PostCode.ValidatePostCode_old("Birthplace City","Birthplace Post Code");
                PostCode.ValidateCity_old("Birthplace City", "Birthplace Post Code");
            end;
        }
        field(95017; "fiche créée"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Search Name")
        {
        }
        key(Key3; "Last Name", "First Name", "Middle Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        CandidateQualification.SETRANGE("Candidate No.", "No.");
        CandidateQualification.DELETEALL;

        HumanResComment.SETRANGE("No.", "No.");
        HumanResComment.DELETEALL;
    end;

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Candidate Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Candidate Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;
    end;

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := TODAY;
    end;

    var
        HumanResSetup: Record 5218;
        Candidate: Record 52182456;
        PostCode: Record 225;
        CandidateQualification: Record 52182461;
        HumanResComment: Record 5208;
        NoSeriesMgt: Codeunit 396;
        DimMgt: Codeunit 408;

    /// <summary>
    /// AssistEdit.
    /// </summary>
    /// <param name="OldCandidate">Record 51427.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure AssistEdit(OldCandidate: Record Candidate): Boolean;
    begin
        WITH Candidate DO BEGIN
            Candidate := Rec;
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD("Candidate Nos.");
            IF NoSeriesMgt.SelectSeries(HumanResSetup."Candidate Nos.", OldCandidate."No. Series", "No. Series") THEN BEGIN
                HumanResSetup.GET;
                HumanResSetup.TESTFIELD("Candidate Nos.");
                NoSeriesMgt.SetSeries("No.");
                Rec := Candidate;
                EXIT(TRUE);
            END;
        END;
    end;

    /// <summary>
    /// FullName.
    /// </summary>
    /// <returns>Return value of type Text[100].</returns>
    procedure FullName(): Text[100];
    begin
        IF "Middle Name" = '' THEN
            EXIT("First Name" + ' ' + "Last Name")
        ELSE
            EXIT("First Name" + ' ' + "Middle Name" + ' ' + "Last Name");
    end;

    /// <summary>
    /// DisplayMap.
    /// </summary>
    procedure DisplayMap();
    var
        MapPoint: Record 800;
        MapMgt: Codeunit 802;
    begin
        IF MapPoint.FIND('-') THEN
            MapMgt.MakeSelection(DATABASE::Candidate, GETPOSITION);
    end;
}

