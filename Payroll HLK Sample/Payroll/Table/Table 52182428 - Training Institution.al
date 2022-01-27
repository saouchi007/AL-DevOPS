/// <summary>
/// Table Training Institution (ID 52182428).
/// </summary>
table 52182428 "Training Institution"
//table 39108399 "Training Institution"
{

    // version HALRHPAIE.6.1.01

    CaptionML = ENU = 'Training Institution',
                FRA = 'Etablissement de formation ';
    //DrillDownPageID = 39108400;
    //LookupPageID = 39108400;
    fields
    {

        field(1; "No."; Code[20])
        {
            CaptionML = ENU = 'Code',
                        FRA = 'N°';
            NotBlank = true;
        }

        field(2; Name; Text[50])
        {
            CaptionML = ENU = 'Description',
                        FRA = 'Nom';
        }
        field(3; Address; Text[50])
        {
            CaptionML = ENU = 'Adress',
                        FRA = 'Adresse';
        }
        field(4; "Address 2"; Text[50])
        {
            CaptionML = ENU = 'Adress 2',
                        FRA = 'Adresse (2ème ligne)';
        }
        field(5; City; Text[30])
        {
            CaptionML = ENU = 'City',
                        FRA = 'Ville';
            TableRelation = "Post Code".City;

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
        field(6; "Post Code"; Code[20])
        {
            CaptionML = ENU = 'Post Code',
                        FRA = 'Code postal';
            TableRelation = "Post Code";

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
        field(7; "Country/Region Code"; Code[10])
        {
            CaptionML = ENU = 'Country/Region Code',
                        FRA = 'Code pays/région';
            TableRelation = "Country/Region".Code;
        }
        field(8; Contact; Text[50])
        {
            CaptionML = ENU = 'Contact',
                        FRA = 'Contact';
        }
        field(9; "Phone No."; Text[30])
        {
            CaptionML = ENU = 'Phone No.',
                        FRA = 'N° Téléphone';
        }
        field(10; "Fax No."; Text[20])
        {
            CaptionML = ENU = 'Fax No.',
                        FRA = 'N° Télécopie';
        }
       /* field(11; Comment; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(14), "No." = FIELD("No.")));
            CaptionML = ENU = 'Comment',
                        FRA = 'Commentaires';

        }*/
        field(12; Blocked; Boolean)
        {
            CaptionML = ENU = 'Blocked',
                        FRA = 'Bloqué';
        }
        field(13; "E-Mail"; Text[80])
        {
            CaptionML = ENU = 'E-Mail',
                        FRA = 'E-mail';
        }
        field(14; "Home Page"; Text[80])
        {
            CaptionML = ENU = 'Home Page',
                        FRA = 'Page d''accueil';
        }
        field(15; "No. Series"; Code[10])
        {
            CaptionML = ENU = 'No. Series',
                        FRA = 'Souches de n°';
            TableRelation = "No. Series";
        }
        field(16; "Last Date Modified"; Date)
        {
            CaptionML = ENU = 'Last Date Modified',
                        FRA = 'Date dern. modification';
            Editable = false;
        }
        field(17; "Institution Class Code"; Code[10])
        {
            CaptionML = ENU = 'Institution Class Code',
                        FRA = 'Code classe établissement';
            TableRelation = "Training Institution Class";
        }
        field(18; "Institution Subclass Code"; Code[10])
        {
            CaptionML = ENU = 'Institution Subclass Code',
                        FRA = 'Code sous-classe établissement';
            TableRelation = "Training Institution Subclass";
        }
        field(19; Picture; BLOB)
        {
            CaptionML = ENU = 'Picture',
                        FRA = 'Image';
            SubType = Bitmap;
        }
        field(20; "No. of Trainings"; Integer)
        {
            CalcFormula = Count("Training Institution Catalog" WHERE("Training Institution No." = FIELD("No.")));
            CaptionML = ENU = 'No. of Trainings',
                        FRA = 'Nbre de formations';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify();
    begin
        "Last Date Modified" := TODAY;
    end;

    trigger OnRename();
    begin
        "Last Date Modified" := TODAY;
    end;

    var
        PostCode: Record 225;
        Institution: Record 52182428;
}

