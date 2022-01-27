/// <summary>
/// Report Quitus de départ (ID 52182430).
/// </summary>
report 52182430 "Quitus de départ"
{
    // version HALRHPAIE.6.1.01

    DefaultLayout = RDLC;
    RDLCLayout = './Report rdlc/Quitus de départ.rdl';

    dataset
    {
        dataitem(DataItem7528; 5200)
        {
            RequestFilterFields = "No.";
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
                AutoCalcField = true;
            }
            column(Texte1; Texte1)
            {
            }
            column(Texte2; Texte2)
            {
            }
            column(OptObjetsConfies; OptObjetsConfies)
            {
            }
            column(Texte3; Texte3)
            {
            }
            column(QUITUS_DE_DEPARTCaption; QUITUS_DE_DEPARTCaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }
            column(TexteDate; TexteDate)
            {
            }
            dataitem(DataItem4668; 5214)
            {
                DataItemLink = "Employee No." = FIELD("No.");
                DataItemTableView = SORTING("Employee No.", "Misc. Article Code", "Line No.");
                column(Misc__Article_Information_Description; Description)
                {
                }
                column(Misc__Article_Information__From_Date_; "From Date")
                {
                }
                column(Misc__Article_Information__To_Date_; "To Date")
                {
                }
                column(Misc__Article_Information__Serial_No__; "Serial No.")
                {
                }
                column(Misc__Article_Information__Structure_Description_; "Structure Description")
                {
                }
                column("Liste_des_objets_confiés__Caption"; Liste_des_objets_confiés__CaptionLbl)
                {
                }
                column(Misc__Article_Information__Serial_No__Caption; FIELDCAPTION("Serial No."))
                {
                }
                column(Misc__Article_Information_DescriptionCaption; FIELDCAPTION(Description))
                {
                }
                column(Misc__Article_Information__From_Date_Caption; FIELDCAPTION("From Date"))
                {
                }
                column(Misc__Article_Information__To_Date_Caption; FIELDCAPTION("To Date"))
                {
                }
                column(StructureCaption; StructureCaptionLbl)
                {
                }
                column(EmargementCaption; EmargementCaptionLbl)
                {
                }
                column(SignatureCaption; SignatureCaptionLbl)
                {
                }
                column(Misc__Article_Information_Employee_No_; "Employee No.")
                {
                }
                column(Misc__Article_Information_Misc__Article_Code; "Misc. Article Code")
                {
                }
                column(Misc__Article_Information_Line_No_; "Line No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    TexteDate := 'Fait à ' + Lieu + ', le ' + FORMAT(ImpDate);
                end;
            }

            trigger OnAfterGetRecord();
            begin

                //Employee.Get;
                EmployeeAssignment.RESET;
                EmployeeAssignment.SETRANGE(EmployeeAssignment."Employee No.", Employee."No.");
                IF EmployeeAssignment.FINDSET THEN
                    EmployeeAssignment.FINDLAST;
                Employee.Get("No.");
                Texte1 := '    Nous soussignés, ' + CompanyInfo.Name + ' sise à ' + CompanyInfo.Address + ' ' + CompanyInfo."Address 2"
                + ', attestons que ' + Employee."First Name" + ' ' + Employee."Last Name" + ' né';
                IF Gender = Gender::Female THEN
                    Texte1 := Texte1 + 'e';
                Texte1 := Texte1 + ' le ' + FORMAT(Employee."Birth Date") + ' à ' + Employee."Birthplace City" + ','
                + 'qui faisait partie de notre institution en qualité de : ';

                Texte2 := '-' + ' ' + Employee."Job Title"
                + ' ' + 'Du' + ' ' + FORMAT(Employee."Employment Date") + ' ' + 'Au';
                IF "Termination Date" = 0D then
                    Texte2 := Texte2 + ' Ajourd''hui';

                Texte2 := Texte2 + ' ' + FORMAT(Employee."Termination Date") + ' inclus.';


                Texte3 := 'est autorisé';
                IF Gender = Gender::Female THEN
                    Texte3 := Texte3 + 'e';
                Texte3 := Texte3 + ' à quitter son poste de travail ayant remis tous les objets qui lui ont été confiés.'
                + ' En foi de quoi, le présent quitus est délivré à l''intéressé';
                IF Gender = Gender::Female THEN
                    Texte3 := Texte3 + 'e';
                Texte3 := Texte3 + ' pour servir et valoir ce que de droit.';



                //TexteDate:='Fait à Alger, le '+FORMAT(TODAY);
                TexteDate := 'Fait à ' + Lieu + ', le ' + FORMAT(ImpDate);
            end;

            trigger OnPreDataItem();
            begin
                NomEntreprise := CompanyInfo.Name;
                NumRef := 'REF : N°     /SP/' + FORMAT(DATE2DMY(TODAY, 3));


                CompanyInfo.GET;
                //Employee.Get;
                TexteDate := 'Fait à ' + Lieu + ', le ' + FORMAT(ImpDate);


                CompanyInfo.GET;
                CompanyInfo.CALCFIELDS(Picture);
                Lieu := CompanyInfo.City;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Option)
                {
                    field(OptObjetsConfies; OptObjetsConfies)
                    {
                        Caption = 'Objets confiés';
                    }
                    field(ImpDate; ImpDate)
                    {
                        Caption = 'Date d''établissement';
                    }
                    field(Lieu; Lieu)
                    {
                        Caption = 'Lieu d''établissement';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin

        OptObjetsConfies := TRUE;
    end;

    trigger OnPreReport();
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        Text01: Label '"Fait à Alger, le "';
        Employee: Record 5200;
        CompanyInfo: Record 79;
        Text02: Label 'Nous soussignés, %1 sise à %2, attestons que %3 %4 né(e) le %5 à %6 est employé au sein de notre institution depuis le %7 à ce jour.';
        Texte1: Text[250];
        Texte2: Text[250];
        Texte3: Text[250];
        Texte4: Text[250];
        TexteDate: Text[50];
        EmployeeAssignment: Record "Employee Assignment";
        OptObjetsConfies: Boolean;
        ImpDate: Date;
        Lieu: Text[30];
        QUITUS_DE_DEPARTCaptionLbl: Label 'QUITUS DE DEPART';
        "Liste_des_objets_confiés__CaptionLbl": Label 'Liste des objets confiés :';
        StructureCaptionLbl: Label 'Structure';
        EmargementCaptionLbl: Label 'Emargement';
        SignatureCaptionLbl: Label 'Signature';
        NomEntreprise: Text[50];
        NumRef: Text[50];

}

