/// <summary>
/// TableExtension HumanResourcesSetupExt (ID 52182440) extends Record Human Resources Setup.
/// </summary>
tableextension 52182440 HumanResourcesSetupExt extends "Human Resources Setup"
{
    fields
    {
        field(90001; "Training Nos."; Code[10])
        {
            CaptionML = ENU = 'Training Nos.',
                        FRA = 'N° Formations';
            TableRelation = "No. Series";
        }
        field(90002; "Training Request Nos."; Code[10])
        {
            CaptionML = ENU = 'Training Request Nos.',
                        FRA = 'N° Demandes de formation';
            TableRelation = "No. Series";
        }
        field(90003; "Training Session Nos."; Code[10])
        {
            CaptionML = ENU = 'Training Session Nos.',
                        FRA = 'N° Sessions de formation';
            TableRelation = "No. Series";
        }
        field(90004; "Training Institution Nos."; Code[10])
        {
            CaptionML = ENU = 'Training Institution Nos.',
                        FRA = 'N° Etablissements de formation';
            TableRelation = "No. Series";
        }
        field(90005; "Training Registration Nos."; Code[10])
        {
            CaptionML = ENU = 'Training Registration Nos.',
                        FRA = 'N° Inscriptions de formation';
            TableRelation = "No. Series";
        }
        field(90006; "Employer Nos."; Code[10])
        {
            CaptionML = ENU = 'Employer Nos.',
                        FRA = 'N° Employeurs';
            TableRelation = "No. Series";
        }
        field(90007; "Medical Reimboursement No."; Code[10])
        {
            CaptionML = ENU = 'Medical Reimboursement No.',
                        FRA = 'N° Remboursements médicaux';
            TableRelation = "No. Series";
        }
        field(90008; "Post Nos."; Code[10])
        {
            CaptionML = ENU = 'Post No.',
                        FRA = 'N° Postes';
            TableRelation = "No. Series";
        }
        field(90009; "Open Post Nos."; Code[10])
        {
            CaptionML = ENU = 'Open Post No.',
                        FRA = 'N° Postes ouverts';
            TableRelation = "No. Series";
        }
        field(90010; "Candidate Nos."; Code[10])
        {
            CaptionML = ENU = 'Candidate Nos.',
                        FRA = 'N° Candidats';
            TableRelation = "No. Series";
        }
        field(90011; "Candidature Nos."; Code[10])
        {
            CaptionML = ENU = 'Candidature Nos.',
                        FRA = 'N° Candidatures';
            TableRelation = "No. Series";
        }
        field(90012; "Show Only Active Employees"; Boolean)
        {
            CaptionML = ENU = 'Show Only Active Employees',
                        FRA = 'Afficher uniquement les salariés actifs';
        }
        field(90013; "Social Lending Nos."; Code[10])
        {
            CaptionML = ENU = 'Candidate Nos.',
                        FRA = 'N° Prêts sociaux';
            TableRelation = "No. Series";
        }
        field(90014; "Badge Reader File"; Text[250])
        {
            Caption = 'Chemin fichier pointeuse';
        }
        field(90015; "Overtime Category"; Code[10])
        {
            CaptionML = ENU = 'Category',
                        FRA = 'Catégorie heure supp.';
            TableRelation = "No. Series";
        }
        field(90016; "Cause of Overtime Code"; Code[10])
        {
            CaptionML = ENU = 'Cause of Overtime Code',
                        FRA = 'Code motif heure supp.';
            TableRelation = "No. Series";
        }
        field(90017; "Cause of Absence Code"; Code[10])
        {
            CaptionML = ENU = 'Cause of Absence Code',
                        FRA = 'Code motif absence';
            TableRelation = "Cause of Absence";
        }
        field(90018; "Exercice Formation"; Integer)
        {
        }
        field(90019; "Do not show archived training"; Boolean)
        {
            Caption = 'Ne pas afficher formations archivées';
        }
    }

    var
        myInt: Integer;
}