page 51501 "Payroll--Setup"
{
    // version HALRHPAIE.6.2.01

    UsageCategory = Lists;
    //AccessByPermission = page SimpleItemList = X
    CaptionML = ENU = 'Payroll Setup',
                FRA = 'Paramètres de paie';
    //PageType = Card;
    Editable = true;
    SourceTable = Payroll_Setup;

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                field("No. of Worked Days"; "No. of Worked Days")
                {
                }
                field("No. of Worked Hours"; "No. of Worked Hours")
                {
                }
                field("No. of Hours By Day"; "No. of Hours By Day")
                {
                }
                field("Overtime Base Unit of Measure"; "Overtime Base Unit of Measure")
                {
                }
                field("Union Rate"; "Union Rate")
                {
                }
                field("Absence Unit of Measure"; "Absence Unit of Measure")
                {
                }
                field("Maximal IEP"; "Maximal IEP")
                {
                }
            }
            group("Rubriques de base")
            {
                Caption = 'Rubriques de base';
                field("Base Salary"; "Base Salary")
                {
                }
                field("Show Post Salary Basis"; "Show Post Salary Basis")
                {
                }
                field("Base Salary Without Indemnity"; "Base Salary Without Indemnity")
                {
                }
                field("Post Salary"; "Post Salary")
                {
                }
                field("Taxable Salary"; "Taxable Salary")
                {
                }
                field("Brut Salary"; "Brut Salary")
                {
                }
                field("Net Salary"; "Net Salary")
                {
                }
                field("Advance Deduction"; "Advance Deduction")
                {
                }
                field("Union Subscription Deduction"; "Union Subscription Deduction")
                {
                }
                field("Medical Refund"; "Medical Refund")
                {
                }
                field("Professional Expances Refund"; "Professional Expances Refund")
                {
                }
                field(IEP; IEP)
                {
                }
                field("No. of Hours (Hourly Vacatary)"; "No. of Hours (Hourly Vacatary)")
                {
                }
                field("No. of Days (Daily Vacatary)"; "No. of Days (Daily Vacatary)")
                {
                }
                field("Overtime Filter"; "Overtime Filter")
                {
                }
                field("DAIP Taxable Salary"; "DAIP Taxable Salary")
                {
                }
                field("Family Allowance Filter"; "Family Allowance Filter")
                {
                }
                field("Indemnité de transport"; "Indemnité de transport")
                {
                }
                field("Prime de Panier"; "Prime de Panier")
                {
                }
            }
            group("Sécurité sociale")
            {
                Caption = 'Sécurité sociale';
                field("SS Basis"; "SS Basis")
                {
                }
                field("Employee SS Deduction"; "Employee SS Deduction")
                {
                }
                field("Employee SS %"; "Employee SS %")
                {
                }
                field("Employer Cotisation"; "Employer Cotisation")
                {
                }
                field("Employer Cotisation %"; "Employer Cotisation %")
                {
                }
            }
            group(IRG)
            {
                Caption = 'IRG';
                field("TIT Basis"; "TIT Basis")
                {
                }
                field("TIT Deduction"; "TIT Deduction")
                {
                }
                field("TIT merged"; "TIT merged")
                {
                }
                field("Do Not Generate Blank TIT"; "Do Not Generate Blank TIT")
                {
                }
                field("TIT Out of Grid"; "TIT Out of Grid")
                {
                }
                field("TIT Out of Grid %"; "TIT Out of Grid %")
                {
                }
                field("TIT Filter"; "TIT Filter")
                {
                }
            }
            group(Calcul)
            {
                Caption = 'Calcul';
                field(Absences; Absences)
                {
                }
                field(Advances; Advances)
                {
                }
                field(Overtime; Overtime)
                {
                }
                field("Union/Insurance"; "Union/Insurance")
                {
                }
                field("Medical Refunds"; "Medical Refunds")
                {
                }
                field("Deduct Lending From Payroll"; "Deduct Lending From Payroll")
                {
                }
                field("Allow TIT Manual Modif."; "Allow TIT Manual Modif.")
                {
                }
                field("Allow SS Manual Modif."; "Allow SS Manual Modif.")
                {
                }
                field("Allow Absence Free Entrance"; "Allow Absence Free Entrance")
                {
                }
                field("Allow Payroll Manual Adjust."; "Allow Payroll Manual Adjust.")
                {
                }
                field("Taxable Deduction Filter"; "Taxable Deduction Filter")
                {
                    Editable = true;
                }
            }
            group(Comptabilisation)
            {
                Caption = 'Comptabilisation';
                field("Payroll Journal Template Name"; "Payroll Journal Template Name")
                {
                }
                field("Payroll Journal Batch Name"; "Payroll Journal Batch Name")
                {
                }
                field("Payroll Bank Account"; "Payroll Bank Account")
                {
                }
                field("Delete Existing Entries"; "Delete Existing Entries")
                {
                }
                field("Compta. les charges patronales"; "Compta. les charges patronales")
                {
                }
                group("Charges patronales :")
                {
                    Caption = 'Charges patronales :';
                    field("Base oeuvres sociales"; "Base oeuvres sociales")
                    {
                        //Editable = Edit;
                    }
                    field("Taux oeuvres sociales"; "Taux oeuvres sociales")
                    {
                        //Editable = Edit;
                    }
                    field("Cpte oeuvres sociales (débit)"; "Cpte oeuvres sociales (débit)")
                    {
                        //Editable = Edit;
                    }
                    field("Cpte oeuvres sociales (crédit)"; "Cpte oeuvres sociales (crédit)")
                    {
                        //Editable = Edit;
                    }
                    field("Base taxe formation"; "Base taxe formation")
                    {
                        //Editable = Edit;
                    }
                    field("Taux taxe formation"; "Taux taxe formation")
                    {
                        //Editable = Edit;
                    }
                    field("Cpte taxe form. appr. (débit)"; "Cpte taxe form. appr. (débit)")
                    {
                        //Editable = Edit;
                    }
                    field("Cpte taxe form. appr. (crédit)"; "Cpte taxe form. appr. (crédit)")
                    {
                        //Editable = Edit;
                    }
                    field("Taux cotisation patronale"; "Taux cotisation patronale")
                    {
                        //Editable = Edit;
                    }
                    field("Cpte 1 cotis. patron. (débit)"; "Cpte 1 cotis. patron. (débit)")
                    {
                        //Editable = Edit;
                    }
                    field("Cpte 2 cotis. patron. (débit)"; "Cpte 2 cotis. patron. (débit)")
                    {
                        //Editable = Edit;
                    }
                    field("Cpte cotis.patronales (crédit)"; "Cpte cotis.patronales (crédit)")
                    {
                        //Editable = Edit;
                    }
                }
                field("Reminder Journal Template Name"; "Reminder Journal Template Name")
                {
                }
                field("Reminder Journal Batch Name"; "Reminder Journal Batch Name")
                {
                }
                field("Base cotisation patronale"; "Base cotisation patronale")
                {
                    //Editable = Edit;
                }
            }
            group(Cacobatph)
            {
                Caption = 'Cacobatph';
                field("Inclure Cacobatph"; "Inclure Cacobatph")
                {
                }
                field("Cotisation employeur cacobatph"; "Cotisation employeur cacobatph")
                {
                    Caption = 'Cotisation cacobatph %';
                }
                field("<Cotisation employeur oprebatph>"; "Cotisation employeur pretbath")
                {
                    Caption = 'Cotisation oprebatph %';
                }
                field("Employer Cotisation Cacobaptph"; "Employer Cotisation Cacobaptph")
                {
                }
                field("<Employer Cotisation oprebatph>"; "Employer Cotisation pretbath")
                {
                    Caption = 'Employer Cotisation oprebatph';
                }
            }
            group("Congé")
            {
                Caption = 'Congé';
                field("Leave Nbre of Days by Month"; "Leave Nbre of Days by Month")
                {
                }
                field("Leave days by year"; "Leave days by year")
                {
                }
                field("Leave TIT"; "Leave TIT")
                {
                }
                field("Leave Cause of Absence"; "Leave Cause of Absence")
                {
                }
                field("Accident cause of absence"; "Accident cause of absence")
                {
                }
                field("Include leave days"; "Include leave days")
                {
                    Caption = 'Inclure jours absence congé dans DAS';
                }
                field("Professional Expances"; "Professional Expances")
                {
                    Caption = 'Remb. frais de mission';
                }
                field("Year Separated Leave Indemnity"; "Year Separated Leave Indemnity")
                {
                }
            }
            group("Numérotation")
            {
                Caption = 'Numérotation';
                field("Medical Reimbursement No."; "Medical Reimbursement No.")
                {
                }
                field("Payroll Template No."; "Payroll Template No.")
                {
                }
                field("Reminder Nos."; "Reminder Nos.")
                {
                }
            }
            group(Grilles)
            {
                Caption = 'Grilles';
                field("Treatment Grid Type"; "Treatment Grid Type")
                {
                }
                field("Apply Index Point Value"; "Apply Index Point Value")
                {
                }
                group("Section grid : ")
                {
                    CaptionML = ENU = 'Section grid : ',
                                FRA = 'Grille par sections : ';
                    field("Include Minimal Index"; "Include Minimal Index")
                    {
                    }
                }
                field("Index Point Value"; "Index Point Value")
                {
                    Editable = indexPointValuEdit;
                }
                field("No. of Levels"; "No. of Levels")
                {
                    Caption = 'Nbre d''échelons';
                }
                group("Hourly Index Grid")
                {
                    CaptionML = ENU = 'Hourly Index Grid',
                                FRA = 'Grille par indices horaires : ';
                    field("No. of Index"; "No. of Index")
                    {
                    }
                }
            }
            group(Editions)
            {
                Caption = 'Editions';
                group("Etat des oeuvres sociales :")
                {
                    Caption = 'Etat des oeuvres sociales :';
                    field("Intitule oeuvres sociales 1"; "Intitule oeuvres sociales 1")
                    {
                    }
                    field("Intitule oeuvres sociales 2"; "Intitule oeuvres sociales 2")
                    {
                    }
                }
                field("Report Payment Method"; "Report Payment Method")
                {
                    Caption = 'Mode de paiement';
                }
                field("Limite page état de virement"; "Limite page état de virement")
                {
                    Caption = 'Limite de la page';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        Edit := "Compta. les charges patronales";
        indexPointValuEdit := "Apply Index Point Value";
    end;

    trigger OnInit();
    begin
        Edit := FALSE;
        indexPointValuEdit := FALSE;
    end;

    var
        Edit: Boolean;
        indexPointValuEdit: Boolean;


    local procedure Cpteoeuvressocialesd233bitOnBe();
    begin
        //CurrPage."Cpte oeuvres sociales (débit)".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure Cpteoeuvressocialescr233ditOnB();
    begin
        //CurrPage."Cpte oeuvres sociales (crédit)".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure Cpte1cotispatrond233bitOnBefor();
    begin
        //CurrPage."Cpte 1 cotis. patron. (débit)".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure Cpte2cotispatrond233bitOnBefor();
    begin
        //CurrPage."Cpte 2 cotis. patron. (débit)".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure Cptecotispatronalescr233ditOnB();
    begin
        //CurrPage."Cpte cotis.patronales (crédit)".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure Cptetaxeformapprd233bitOnBefor();
    begin
        //CurrPage."Cpte taxe form. appr. (débit)".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure Cptetaxeformapprcr233ditOnBefo();
    begin
        //CurrPage."Cpte taxe form. appr. (crédit)".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure TauxoeuvressocialesOnBeforeInp();
    begin
        //CurrPage."Taux oeuvres sociales".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure TauxcotisationpatronaleOnBefor();
    begin
        //CurrPage."Taux cotisation patronale".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure BaseoeuvressocialesOnBeforeInp();
    begin
        //CurrPage."Base oeuvres sociales".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure TauxtaxeformationOnBeforeInput();
    begin
        //CurrPage."Taux taxe formation".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure BasetaxeformationOnBeforeInput();
    begin
        //CurrPage."Base taxe formation".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure BasecotisationpatronaleOnBefor();
    begin
        //CurrPage."Base cotisation patronale".UPDATEEDITABLE("Compta. les charges patronales");
    end;

    local procedure IndexPointValueOnBeforeInput();
    begin
        //CurrPage."Index Point Value".UPDATEEDITABLE("Apply Index Point Value");
    end;
}

