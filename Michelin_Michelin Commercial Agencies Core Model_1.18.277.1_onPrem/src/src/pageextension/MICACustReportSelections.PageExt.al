pageextension 80700 "MICA Cust Report Selections" extends "Customer Report Selections"
{
    layout
    {
        modify(Usage2)
        {
            Visible = false;
            Enabled = false;
            Editable = false;
        }

        addafter(Usage2)
        {
            field("MICA Usage2_Copy"; Usage2_Copy)
            {
                ApplicationArea = All;
                Caption = 'Usage';
                ToolTip = 'Specifies which type of document the report is used for.';
                OptionCaption = 'Quote,Confirmation Order,Invoice,Credit Memo,Customer Statement,Job Quote,Reminder';

                trigger OnValidate()
                begin
                    case Usage2_Copy of
                        Usage2_Copy::Quote:
                            Rec.Usage := Rec.Usage::"S.Quote";
                        Usage2_Copy::"Confirmation Order":
                            Rec.Usage := Rec.Usage::"S.Order";
                        Usage2_Copy::Invoice:
                            Rec.Usage := Rec.Usage::"S.Invoice";
                        Usage2_Copy::"Credit Memo":
                            Rec.Usage := Rec.Usage::"S.Cr.Memo";
                        Usage2_Copy::"Customer Statement":
                            Rec.Usage := Rec.Usage::"C.Statement";
                        Usage2_Copy::"Job Quote":
                            Rec.Usage := Rec.Usage::JQ;
                        Usage2_Copy::Reminder:
                            Rec.Usage := Rec.Usage::Reminder;
                    end;
                end;
            }
        }
    }

    var
        Usage2_Copy: Option Quote,"Confirmation Order",Invoice,"Credit Memo","Customer Statement","Job Quote",Reminder;

    trigger OnAfterGetRecord()

    begin
        MapTableUsageValueToPageValue();
    end;

    trigger OnNewRecord(BellowRec: Boolean)
    begin
        MapTableUsageValueToPageValue();
    end;

    local procedure MapTableUsageValueToPageValue()
    var
        CustomReportSelection: Record "Custom Report Selection";
    begin
        CASE Rec.Usage OF
            CustomReportSelection.Usage::"S.Quote":
                Usage2_Copy := Rec.Usage::"S.Quote".AsInteger();
            CustomReportSelection.Usage::"S.Order":
                Usage2_Copy := Rec.Usage::"S.Order".AsInteger();
            CustomReportSelection.Usage::"S.Invoice":
                Usage2_Copy := Rec.Usage::"S.Invoice".AsInteger();
            CustomReportSelection.Usage::"S.Cr.Memo":
                Usage2_Copy := Rec.Usage::"S.Cr.Memo".AsInteger();
            CustomReportSelection.Usage::"C.Statement":
                Usage2_Copy := Usage2_Copy::"Customer Statement";
            CustomReportSelection.Usage::JQ:
                Usage2_Copy := Usage2_Copy::"Job Quote";
            CustomReportSelection.Usage::Reminder:
                Usage2_Copy := Usage2_Copy::Reminder;
        END;
    end;

}