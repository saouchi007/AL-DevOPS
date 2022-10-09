/// <summary>
/// PageExtension ISA_SalesReceivable (ID 50231) extends Record MyTargetPage.
/// </summary>
pageextension 50101 ISA_SalesReceivable extends "Sales & Receivables Setup"
{
    layout
    {
        addafter(General)
        {
            group(AltrApp)
            {
                CaptionML = ENU = 'AltrApp Extension Setup', FRA = 'Paramétrage de l''extension AltrApp';
                Visible = true;
                field(ISA_StampDuty_GLA; Rec.ISA_StampDuty_GLA)
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Sepcifies the G/L Account to be used to post ''Stamp Duty'' entries on Sales documents',
                            FRA = 'Représente le compte général utilisé par le ''Droit de timbre'' ';
                    trigger OnValidate()
                    begin
                        Rec.Modify();
                    end;
                }
                field(ISA_StampDutyPymtMethodsCode; Rec.ISA_StampDutyPymtMethodsCode)
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Sepcifies the payment term to be used to trigger the stamp duty processing',
                            FRA = 'Représente le mode de règlement utiliser pour le calcul du droit de timbre';
                    trigger OnValidate()
                    begin
                        Rec.Modify();
                    end;
                }
                field(ISA_TransactionType; Rec.ISA_TransactionType)
                {
                    ApplicationArea = All;
                    ToolTipML = ENU = 'Specifies the Gen. Business posting group for internal use',
                    FRA = 'Représente le groupe compta marché pour les consommations internes';
                    trigger OnValidate()
                    begin
                        Rec.Modify();
                    end;
                }
            }
        }
    }
}