pageextension 50100 AlegrianCustomerCard extends "Customer Card"
{
    layout
    {
        addafter("Address & Contact")
        {
            group("Customer Identification")
            {

                field("Commerce Registration"; "Commerce Registration")
                {
                    ApplicationArea = all;
                    ToolTip = 'To insert customer registration for the customer';

                    trigger OnValidate()
                    begin
                        checkCR();
                    end;
                }
                field("Statistical Identification"; Rec."Statistical Identification")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        checkSI();
                    end;
                }
                field("Taxing Identification"; Rec."Taxing Identification")
                {
                    ApplicationArea = All;
                }
                field("Fiscal Identification"; "Fiscal Identification")
                {
                    ApplicationArea = all;
                    ToolTip = 'To insert fiscal indentification for the customer';
                }
            }
        }
    }

    local procedure checkCR()
    begin
        Rec.SetRange("Commerce Registration", Rec."Commerce Registration");
        if Rec.Count > 1 then begin
            Error('This CR %1 already exists !', Rec."Commerce Registration");
        end;
    end;

    local procedure checkSI()
    begin
        Rec.SetRange("Statistical Identification", Rec."Statistical Identification");
        if Rec.Count > 1 then begin
            Error('This SI %1 already exists !', Rec."Statistical Identification");
        end;
    end;
}