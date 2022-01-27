/// <summary>
/// Page Resource Manag Activities_EXT (ID 52182429).
/// </summary>
page 52182587 "Resource Manag Activities_EXT"
{
    // version NAVW111.00,RHPAIEKarim

    CaptionML = ENU = 'Activities',
                FRA = 'Activités';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = 9057;

    layout
    {
        area(content)
        {
            cuegroup(Allocation)
            {
                CaptionML = ENU = 'Allocation',
                            FRA = 'Ventilation';
                field("Salaries Actifs"; "Salaries Actifs")
                {
                }
                field("Fin de contrat"; "Fin de contrat")
                {
                    ApplicationArea = Basic, Suite;
                    DrillDownPageID = "Employee List";
                }
                field("Fin de Période d'essai"; "Fin de Période d'essai")
                {
                    ApplicationArea = Suite;
                    DrillDownPageID = "Employee List";
                }
                field("Absences journee"; "Absences journee")
                {
                    DrillDownPageID = "Absence Registration";
                }
                field("Available Resources"; "Available Resources")
                {
                    ApplicationArea = Jobs;
                    DrillDownPageID = "Resource List";
                    ToolTipML = ENU = 'Specifies the number of available resources that are displayed in the Job Cue on the Role Center. The documents are filtered by today''s date.',
                                FRA = 'Spécifie le nombre de ressources disponibles qui sont affichées dans la pile Travail du tableau de bord. Les documents sont filtrés à la date du jour.';
                    Visible = false;
                }
                field("Jobs w/o Resource"; "Jobs w/o Resource")
                {
                    ApplicationArea = Jobs;
                    DrillDownPageID = "Job List";
                    ToolTipML = ENU = 'Specifies the number of jobs without an assigned resource that are displayed in the Job Cue on the Role Center. The documents are filtered by today''s date.',
                                FRA = 'Spécifie le nombre de projets auxquels aucune ressource n''est affectée qui sont affichés dans la pile Travail du tableau de bord. Les documents sont filtrés à la date du jour.';
                    Visible = false;
                }
                field("Unassigned Resource Groups"; "Unassigned Resource Groups")
                {
                    ApplicationArea = Jobs;
                    DrillDownPageID = "Resource Groups";
                    ToolTipML = ENU = 'Specifies the number of unassigned resource groups that are displayed in the Job Cue on the Role Center. The documents are filtered by today''s date.',
                                FRA = 'Spécifie le nombre de groupes ressources non affectés qui sont affichés dans la pile Travail du tableau de bord. Les documents sont filtrés à la date du jour.';
                    Visible = false;
                }

                actions
                {
                    action("Resource Capacity")
                    {
                        ApplicationArea = Jobs;
                        CaptionML = ENU = 'Resource Capacity',
                                    FRA = 'Capacité ressource';
                        Image = Capacity;
                        RunObject = Page 213;
                        ToolTipML = ENU = 'View the capacity of the resource.',
                                    FRA = 'Affichez la capacité de la ressource.';
                    }
                    action("Resource Group Capacity")
                    {
                        ApplicationArea = Jobs;
                        CaptionML = ENU = 'Resource Group Capacity',
                                    FRA = 'Capacité groupe ressources';
                        RunObject = Page 214;
                        ToolTipML = ENU = 'View the capacity of resource groups.',
                                    FRA = 'Affichez la capacité des groupes de ressources.';
                    }
                }
            }
            /*cuegroup("My User Tasks")
            {
                CaptionML = ENU='My User Tasks',
                            FRA='Mes tâches utilisateur';
                field("Pending Tasks";"Pending Tasks")
                {
                    ApplicationArea = Basic,Suite;
                    CaptionML = ENU='Pending User Tasks',
                                FRA='Tâches utilisateur en attente';
                    DrillDownPageID = "User Task List";
                    Image = Checklist;
                    ToolTipML = ENU='Specifies the number of pending tasks that are assigned to you.',
                                FRA='Spécifie le nombre de tâches en attente qui vous sont affectées.';
                    Visible = true;
                }
            }*/
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        RESET;
        IF NOT GET THEN BEGIN
            INIT;
            INSERT;
        END;
        SETRANGE("Date Filter", WORKDATE, WORKDATE);
        SETFILTER("User ID Filter", USERID);

        //"Next Date Fin de contrat":=CALCDATE('<+10D>',WORKDATE);
        SETRANGE("Next Date Fin de contrat", CALCDATE('<-10D>', WORKDATE), CALCDATE('<+10D>', WORKDATE));
    end;

    var
        LocalFilter: Date;
        Employee: Record 5200;
}

