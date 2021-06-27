report 81190 "MICA Transfer AppliedDisc DATA"
{
    Caption = 'Transfer Applied Sales Line Discount DATA';
    UseRequestPage = false;
    ProcessingOnly = true;
    UsageCategory = None;
    Permissions = tabledata "MICA New Applied SL Discount" = rmid, tabledata "MICA Posted Applied SL Disc." = rmid, tabledata "MICA Applied Sales Line Disc." = r;


    dataset
    {

        dataitem(OldAppliedSLDisc; "MICA Applied Sales Line Disc.")
        {
            RequestFilterFields = "Document No.";


            trigger OnAfterGetRecord()
            begin

                //////////////
                //Process designed for Vietnam and Colombian Databases
                // This process has been disabled in order to prevent this process from being launching
                //in new Michelin DATABASES
                // case true of
                //     "Posted Document No." = '':
                //         InsertFromOldAppliedSLDiscount(OldAppliedSLDisc);


                //     "Posted Document No." = 'ON POSTING':
                //         if SalesLine.get("Document Type", "Document No.", "Document Line No.") then
                //             InsertFromOldAppliedSLDiscount(OldAppliedSLDisc);


                //     else begin
                //             SalesInvLine.SetCurrentKey("Order No.", "Order Line No.", "Posting Date");
                //             SalesInvLine.SetRange("Order No.", "Document No.");
                //             SalesInvLine.SetRange("Order Line No.", "Document Line No.");
                //             SalesInvLine.SetFilter(Quantity, '<>0');
                //             if SalesInvLine.FindLast() then
                //                 InsertFromPosteddAppliedSLDiscount(OldAppliedSLDisc, SalesInvLine);

                //         end;
                //end;
            end;
        }
    }


    procedure InsertFromOldAppliedSLDiscount(OldMICAAppliedSalesLineDisc: Record "MICA Applied Sales Line Disc.")
    var
        MICANewAppliedSLDiscount: Record "MICA New Applied SL Discount";
    begin
        //NewAppliedSLDisc.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);

        MICANewAppliedSLDiscount.Init();
        MICANewAppliedSLDiscount."Document Type" := OldAppliedSLDisc."Document Type";
        MICANewAppliedSLDiscount."Document No." := OldAppliedSLDisc."Document No.";
        MICANewAppliedSLDiscount."Document Line No." := OldAppliedSLDisc."Document Line No.";
        MICANewAppliedSLDiscount.Code := OldAppliedSLDisc.Code;
        MICANewAppliedSLDiscount.Brand := OldAppliedSLDisc.Brand;
        MICANewAppliedSLDiscount."Item No." := OldAppliedSLDisc."Item No.";
        MICANewAppliedSLDiscount."Starting Date" := OldAppliedSLDisc."Starting Date";
        MICANewAppliedSLDiscount."Ending Date" := OldAppliedSLDisc."Ending Date";
        MICANewAppliedSLDiscount."Sales Type" := OldAppliedSLDisc."Sales Type";
        MICANewAppliedSLDiscount."Sales Code" := OldAppliedSLDisc."Sales Code";
        MICANewAppliedSLDiscount."Sales Discount %" := OldAppliedSLDisc."Sales Discount %";
        MICANewAppliedSLDiscount."Rebates Type" := OldAppliedSLDisc."Rebates Type";
        MICANewAppliedSLDiscount."Product Line" := OldAppliedSLDisc."Product Line";
        MICANewAppliedSLDiscount.Type := OldAppliedSLDisc.Type;
        MICANewAppliedSLDiscount."Unit of Measure Code" := OldAppliedSLDisc."Unit of Measure Code";
        MICANewAppliedSLDiscount.Insert();
    end;

    procedure InsertFromPosteddAppliedSLDiscount(OldMICAAppliedSalesLineDisc: Record "MICA Applied Sales Line Disc."; SalesInvoiceLine: Record "Sales Invoice Line")
    var
        MICAPostedAppliedSLDisc: Record "MICA Posted Applied SL Disc.";
    begin
        //NewAppliedSLDisc.SetCurrentKey("Document Type", "Document No.", "Document Line No.", "Rebates Type", Code);

        MICAPostedAppliedSLDisc.Init();
        MICAPostedAppliedSLDisc."Document Type" := OldAppliedSLDisc."Document Type";
        MICAPostedAppliedSLDisc."Document No." := OldAppliedSLDisc."Document No.";
        MICAPostedAppliedSLDisc."Document Line No." := OldAppliedSLDisc."Document Line No.";
        MICAPostedAppliedSLDisc."Posted Document No." := SalesInvoiceLine."Document No.";
        MICAPostedAppliedSLDisc."Posted Document Line No." := SalesInvoiceLine."Line No.";
        MICAPostedAppliedSLDisc.Code := OldAppliedSLDisc.Code;
        MICAPostedAppliedSLDisc.Brand := OldAppliedSLDisc.Brand;
        MICAPostedAppliedSLDisc."Item No." := OldAppliedSLDisc."Item No.";
        MICAPostedAppliedSLDisc."Starting Date" := OldAppliedSLDisc."Starting Date";
        MICAPostedAppliedSLDisc."Ending Date" := OldAppliedSLDisc."Ending Date";
        MICAPostedAppliedSLDisc."Sales Type" := OldAppliedSLDisc."Sales Type";
        MICAPostedAppliedSLDisc."Sales Code" := OldAppliedSLDisc."Sales Code";
        MICAPostedAppliedSLDisc."Sales Discount %" := OldAppliedSLDisc."Sales Discount %";
        MICAPostedAppliedSLDisc."Rebates Type" := OldAppliedSLDisc."Rebates Type";
        MICAPostedAppliedSLDisc."Product Line" := OldAppliedSLDisc."Product Line";
        MICAPostedAppliedSLDisc.Type := OldAppliedSLDisc.Type;
        MICAPostedAppliedSLDisc."Unit of Measure Code" := OldAppliedSLDisc."Unit of Measure Code";
        MICAPostedAppliedSLDisc."MICA Status" := MICAPostedAppliedSLDisc."MICA Status"::Closed;
        MICAPostedAppliedSLDisc.Insert();
    end;

    trigger OnPostReport()
    begin
        //if GuiAllowed then
        //  Message('update terminé');
    end;

}