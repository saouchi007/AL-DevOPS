/// <summary>
/// PageExtension Human Resources Setup Ext (ID 52182428) extends Record 5233.
/// </summary>
pageextension 52182428 "Human Resources Setup Ext" extends 5233
{

    // version NAVW14.00,HALRHPAIE


    layout
    {
        modify(Numbering)
        {
            CaptionML = ENU = 'Administration',
                                     FRA = 'Administration';
        }
        addafter("Employee Nos.")
        {
            field("Social Lending Nos."; "Social Lending Nos.")
            {

            }
            field("Show Only Active Employees"; "Show Only Active Employees")
            {
            }
        }

        addlast(content)
        {
            group(Control1902676001)
            {
                CaptionML = ENU = 'Training',
                            FRA = 'Formation';
                field("Training Nos."; "Training Nos.")
                {
                }
                field("Training Request Nos."; "Training Request Nos.")
                {
                }
                field("Training Registration Nos."; "Training Registration Nos.")
                {
                }
                field("Exercice Formation"; "Exercice Formation")
                {
                }
                field("Do not show archived training"; "Do not show archived training")
                {
                }
            }
            group(Career)
            {
                CaptionML = ENU = 'Career',
                            FRA = 'Carrière';
                field("Employer Nos."; "Employer Nos.")
                {
                }
                field("Post Nos."; "Post Nos.")
                {
                }
                field("Open Post Nos."; "Open Post Nos.")
                {
                }
                field("Candidate Nos."; "Candidate Nos.")
                {
                }
                field("Candidature Nos."; "Candidature Nos.")
                {
                }
            }
            group("Badge Reader")
            {
                CaptionML = ENU = 'Badge Reader',
                            FRA = 'Pointeuse';
                field("Badge Reader File"; "Badge Reader File")
                {
                }
                field("Cause of Absence Code"; "Cause of Absence Code")
                {
                }
                field("Overtime Category"; "Overtime Category")
                {
                }
                field("Cause of Overtime Code"; "Cause of Overtime Code")
                {
                }
            }
        }

    }


}

