codeunit 81641 "MICA Transient Top Management"
{
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]
    local procedure OnAfterValidateEventSalesLineFieldLineNo(var Rec: Record "Sales Line"; CurrFieldNo: Integer; var xRec: Record "Sales Line")
    var
        SalesAgreementOfOrder: Code[20];
        SalesAgreementOfCurrentLine: Code[20];
        SalesAgreementErrLbl: label 'You can only have 1 sales agreement per %1. Sales agreement for %1 %2 is %3 and not %4.';
        ErrorText: Text;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckSalesAgreement(Rec, IsHandled);
        if IsHandled then
            exit;

        if Rec.Type = Rec.Type::" " then
            exit;

        SalesAgreementOfOrder := GetFirstLineSalesAgreementNo(Rec);
        SalesAgreementOfCurrentLine := GetSalesAgreementNo(Rec, SalesAgreementOfOrder);
        case true of
            (SalesAgreementOfOrder = ''):
                begin
                    CheckSalesAgreementSetupFromSOLine(Rec);
                    Rec.Validate("MICA Sales Agreement No.", SalesAgreementOfCurrentLine);
                    UpdateHeaderSalesAgreementsFromLine(Rec, false);
                end;
            (SalesAgreementOfOrder = SalesAgreementOfCurrentLine):
                begin
                    Rec.Validate("MICA Sales Agreement No.", SalesAgreementOfCurrentLine);
                    UpdateHeaderSalesAgreementsFromLine(Rec, false);
                end;
            (SalesAgreementOfOrder <> SalesAgreementOfCurrentLine):
                begin
                    ErrorText := StrSubstNo(SalesAgreementErrLbl, Rec."Document Type", Rec."Document No.", SalesAgreementOfOrder, SalesAgreementOfCurrentLine);
                    error(ErrorText);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'MICA Sales Agreement No.', false, false)]
    local procedure OnAfterValidateEventSalesLineFieldSalesAgreementNo(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        if Rec.Type = Rec.Type::" " then
            exit;

        if (xRec."MICA Sales Agreement No." <> '') and (xRec."MICA Sales Agreement No." <> Rec."MICA Sales Agreement No.") then
            CheckIfSalesAgreementChangeOnSalesLineIsAllowed(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'MICA Sales Agreement No.', false, false)]
    local procedure SalesLineOnAfterValidateSalesAgreementNo(var xRec: Record "Sales Line"; var Rec: Record "Sales Line")
    begin
        if xRec."MICA Sales Agreement No." <> Rec."MICA Sales Agreement No." then
            UpdateHeaderSalesAgreementsFromLine(Rec, false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure OnBeforeDeleteSalesLine(var Rec: Record "Sales Line");
    var
        MICASalesSingleInstance: Codeunit "MICA Sales Single Instance";
    begin
        if not MICASalesSingleInstance.HeaderIsBeingDeleted(Rec) then
            UpdateHeaderSalesAgreementsFromLine(Rec, true);
    end;

    local procedure CheckIfSalesAgreementChangeOnSalesLineIsAllowed(FromSalesLine: record "Sales Line")
    var
        SalesLine: Record "Sales Line";
        SalesAgreementChangeErrorLbl: label 'You cannot change the %1 for %2 no. %3 on line %4 when there is more than one line.';
        ErrorText: Text;
    begin
        SalesLine.SetRange("Document Type", FromSalesLine."Document Type");
        SalesLine.SetRange("Document No.", FromSalesLine."Document No.");
        SalesLine.SetFilter("MICA Sales Agreement No.", '<>%1', '');
        SalesLine.SetFilter("Line No.", '<>%1', FromSalesLine."Line No.");
        if SalesLine.FindFirst() and (SalesLine."Line No." <> FromSalesLine."Line No.") then begin
            ErrorText := StrSubstNo(SalesAgreementChangeErrorLbl, SalesLine.FieldCaption("MICA Sales Agreement No."), FromSalesLine."Document Type", FromSalesLine."Document No.", FromSalesLine."Line No.");
            error(ErrorText);
        end;
    end;

    procedure UpdateHeaderSalesAgreementsFromLine(SourceSalesLine: record "Sales Line"; DeleteEvent: Boolean)
    var
        SalesHeader: record "Sales Header";
        SalesLine: Record "Sales Line";
        UpdateHeader: Boolean;
    begin
        if not SalesHeader.Get(SourceSalesLine."Document Type", SourceSalesLine."Document No.") then
            exit;
        case DeleteEvent of
            false:
                begin
                    if SalesHeader."Payment Method Code" <> SourceSalesLine."MICA Payment Method Code" then begin
                        SalesHeader.Validate("Payment Method Code", SourceSalesLine."MICA Payment Method Code");
                        UpdateHeader := true;
                    end;

                    if SalesHeader."Payment Terms Code" <> SourceSalesLine."MICA Payment Terms Code" then begin
                        SalesHeader.Validate("Payment Terms Code", SourceSalesLine."MICA Payment Terms Code");
                        UpdateHeader := true;
                    end;

                    if SalesHeader."MICA Sales Agreement" <> SourceSalesLine."MICA Sales Agreement No." then begin
                        SalesHeader."MICA Sales Agreement" := SourceSalesLine."MICA Sales Agreement No.";
                        UpdateHeader := true;
                    end;
                end;
            true:
                begin
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    SalesLine.SetFilter("Line No.", '<>%1', SourceSalesLine."Line No.");
                    SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
                    if SalesLine.IsEmpty() then
                        if SalesHeader.Get(SourceSalesLine."Document Type", SourceSalesLine."Document No.") then begin
                            SalesHeader.validate("MICA Sales Agreement", '');
                            UpdateHeader := true;
                        end;
                end;
        end;
        if UpdateHeader then begin
            SalesHeader.SuspendStatusCheck(true);
            SalesHeader.modify(true);
        end;
    end;

    local procedure CheckSalesAgreementSetupFromSOLine(var FromSalesLine: Record "Sales Line")
    var
        MICASalesAgreement: Record "MICA Sales Agreement";
        SalesLine: record "Sales Line";
        SalesAgrmtErr: Label 'You must set up at least one Sales Agreement for the customer no. %1.';
        ErrorText: Text;
    begin
        SalesLine.SetRange("Document Type", FromSalesLine."Document Type");
        SalesLine.SetRange("Document No.", FromSalesLine."Document No.");
        if SalesLine.FindFirst() and (SalesLine."Line No." = FromSalesLine."Line No.") then begin
            // SalesLine.SetFilter("Line No.", '>%1', 0);
            // line is the first line of sales order
            MICASalesAgreement.SetCurrentKey("Customer No.", "Item Category Code", Default, DefaultLP);
            MICASalesAgreement.SetRange("Customer No.", FromSalesLine."Sell-to Customer No.");
            MICASalesAgreement.SetRange("Item Category Code", FromSalesLine."Item Category Code");
            MICASalesAgreement.SetRange(DefaultLP, true);
            if not MICASalesAgreement.IsEmpty() then
                exit;
            MICASalesAgreement.SetRange("Item Category Code");
            MICASalesAgreement.SetRange(DefaultLP);
            MICASalesAgreement.SetRange(Default, true);
            if MICASalesAgreement.IsEmpty() then begin
                ErrorText := StrSubstNo(SalesAgrmtErr, FromSalesLine."Sell-to Customer No.");
                error(ErrorText);
            end;
        end;
    end;

    local procedure GetFirstLineSalesAgreementNo(FromSalesLine: Record "Sales Line"): Code[20]
    var
        SalesLine: record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", FromSalesLine."Document Type");
        SalesLine.SetRange("Document No.", FromSalesLine."Document No.");
        SalesLine.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        if SalesLine.FindFirst() then
            exit(SalesLine."MICA Sales Agreement No.")
        else
            exit('');
    end;

    local procedure GetSalesAgreementNo(RecSalesLine: Record "Sales Line"; OrderSalesAgreement: Code[20]): Code[20]
    var
        SalesLine: record "Sales Line";
        MICASalesAgreement: Record "MICA Sales Agreement";
        SalesAgreement2: Record "MICA Sales Agreement";
        SalesHeader: Record "Sales Header";
    begin
        with RecSalesLine DO begin
            MICASalesAgreement.SetCurrentKey("Customer No.", "Item Category Code", Default, DefaultLP);
            if "Item Category Code" <> '' THEN begin
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "Document No.");
                SalesLine.SetRange("Item Category Code", "Item Category Code");
                SalesLine.SetFilter("MICA Sales Agreement No.", '<> %1', '');
                if SalesLine.findfirst() then
                    exit(SalesLine."MICA Sales Agreement No.");
                SalesLine.SetRange("MICA Sales Agreement No.");
                MICASalesAgreement.SetRange("Customer No.", "Sell-to Customer No.");
                MICASalesAgreement.SetRange("Item Category Code", "Item Category Code");
                MICASalesAgreement.SetRange("No.", OrderSalesAgreement);
                if MICASalesAgreement.FindFirst() then
                    exit(MICASalesAgreement."No.");
                MICASalesAgreement.SetRange("No.");
                MICASalesAgreement.SetRange(DefaultLP, true);
                if MICASalesAgreement.findfirst() then begin
                    Clear(SalesAgreement2);
                    SalesAgreement2.CopyFilters(MICASalesAgreement);
                    SalesAgreement2.FindSet();
                    repeat
                        if SalesHeader.get("Document Type", "Document No.") then
                            if (SalesHeader."Order Date" >= SalesAgreement2."Start Date") AND (SalesHeader."Order Date" <= SalesAgreement2."End Date") then
                                exit(SalesAgreement2."No.");
                    until SalesAgreement2.Next() = 0;
                end;
                MICASalesAgreement.SetRange("Item Category Code");
                MICASalesAgreement.SetRange(DefaultLP);
                MICASalesAgreement.SetRange(Default, true);
                if MICASalesAgreement.findfirst() then begin
                    Clear(SalesAgreement2);
                    SalesAgreement2.CopyFilters(MICASalesAgreement);
                    SalesAgreement2.FindSet();
                    repeat
                        if SalesHeader.get("Document Type", "Document No.") then
                            if (SalesHeader."Order Date" >= SalesAgreement2."Start Date") AND (SalesHeader."Order Date" <= SalesAgreement2."End Date") then
                                exit(SalesAgreement2."No.");
                    until SalesAgreement2.Next() = 0;
                end;

            end else begin
                MICASalesAgreement.SetRange("Customer No.", "Sell-to Customer No.");
                MICASalesAgreement.SetRange(Default, true);
                if MICASalesAgreement.findfirst() then begin
                    Clear(SalesAgreement2);
                    SalesAgreement2.CopyFilters(MICASalesAgreement);
                    SalesAgreement2.FindSet();
                    repeat
                        if SalesHeader.get("Document Type", "Document No.") then
                            if (SalesHeader."Order Date" >= SalesAgreement2."Start Date") AND (SalesHeader."Order Date" <= SalesAgreement2."End Date") then
                                exit(SalesAgreement2."No.");
                    until SalesAgreement2.Next() = 0;
                end;

            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckSalesAgreement(SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;
}